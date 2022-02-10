import os.path
from enum import Enum
from os import path
from os.path import join
import os, sys, platform, subprocess

import telepot
import time
import cv2

class Step(Enum):
    RECEIVE_IMAGE = 0
    FOOD_NOT_FOUND = 1
    IMG_QUALITY = 2
    QUALITY_BAD = 3

def fileparts(fn):
    (dirName, fileName) = os.path.split(fn)
    (fileBaseName, fileExtension) = os.path.splitext(fileName)
    return dirName, fileBaseName, fileExtension

class TelegramBot:

    TOKEN = '5170348617:AAG9_rEg8xFXHhHew-cXcUS2vN94TuuRaTE'

    def __init__(self):
        # Bot
        self.bot = TelegramBot.init_bot()
        self.step = Step.RECEIVE_IMAGE

    def start_main_loop(self):
        # Start mainloop
        print('Listening ...')
        self.bot.message_loop(self.on_chat_message)
    
    def calculate_image_quality(self, img_path):
        cur_dir = os.path.dirname(os.path.realpath(__file__))
        quality_dir = cur_dir + "/../image_quality"
        matlab_cmd = 'matlab'
        cmd = matlab_cmd + " -nodesktop -nosplash -nodisplay -wait -r \"addpath(\'" + quality_dir + "\'); estimate_image_quality(\'" + img_path + "\'); quit\""
        subprocess.call(cmd,shell=True)
        # send back the quality scores
        dirName, fileBaseName, fileExtension = fileparts('tmp/received_image.png')
        quality_txt_file = os.path.join(dirName, fileBaseName + '_quality' + '.txt')
        with open(quality_txt_file) as f:
            quality_txt = f.read()
        return quality_txt
    
    def get_similar_images(self, img_path, chat_id):
        cur_dir = os.path.dirname(os.path.realpath(__file__))
        dir_mat = cur_dir + "/../image_similarity_nn/"
        matlab_cmd = 'matlab'
        cmd = matlab_cmd + " -nodesktop -nosplash -nodisplay -wait -r \"addpath(\'" + dir_mat + "\'); find_similar_with_NN(\'" + img_path + "\'); quit\""
        subprocess.call(cmd,shell=True)
        self.bot.sendMessage(chat_id, "Migliori quadri trovati con la rete neurale:")
        self.bot.sendPhoto(chat_id, photo=open('tmp/received_image_sim_nn_1.jpg', 'rb'))
        self.bot.sendPhoto(chat_id, photo=open('tmp/received_image_sim_nn_2.jpg', 'rb'))
        self.bot.sendPhoto(chat_id, photo=open('tmp/received_image_sim_nn_3.jpg', 'rb'))
        #TODO aggiungere similarity classica


    def on_chat_message(self, msg):
        content_type, chat_type, chat_id = telepot.glance(msg)  # get dei parametri della conversazione e del tipo di messaggio

        if self.step == Step.RECEIVE_IMAGE:
            if content_type == 'text':
                name = msg["from"]["first_name"]
                txt = msg['text']

                self.bot.sendMessage(chat_id, 'Ciao %s, benvenuto!\nInserisci la foto di un piatto per iniziare' % name)

            if content_type == 'photo':
                self.bot.download_file(msg['photo'][-1]['file_id'], 'tmp/received_image.jpg')
                img = cv2.imread('tmp/received_image.png')

                self.bot.sendMessage(chat_id, 'Sto cercando il cibo...')
                sys.path.append('../segmentation')
                import yolo_food_detection
                food_found = yolo_food_detection.load_image_food('tmp/received_image.jpg')
                
                if food_found:
                    self.bot.sendMessage(chat_id,"Cibo trovato!")
                    self.bot.sendMessage(chat_id,"Analizzo la qualità dell'immagine...")
                    self.bot.sendPhoto(chat_id, photo=open('tmp/received_image.jpg', 'rb'))
                    txt_quality = self.calculate_image_quality('tmp/received_image.jpg')
                    self.bot.sendMessage(chat_id, txt_quality)
                    if ("too bright" in txt_quality or "too dark" in txt_quality
                        or "Poor" in txt_quality or "Bad" in txt_quality):
                        self.bot.sendMessage(chat_id, "Rilevata scarsa qualità, continuare?\n/Si\n/No")
                        self.step = Step.QUALITY_BAD
                    else:
                        self.bot.sendMessage(chat_id, "Ok, cerco i quadri migliori...")
                        self.get_similar_images('tmp/received_image.jpg', chat_id)
                else:
                    self.bot.sendMessage(chat_id, "Cibo non trovato, continuare?\n/Si\n/No")
                    self.step = Step.FOOD_NOT_FOUND

        if self.step == Step.FOOD_NOT_FOUND:
            if content_type == 'text':
                name = msg["from"]["first_name"]
                txt = msg['text']

                if txt == '/Si':
                    self.bot.sendMessage(chat_id,"Analizzo la qualità dell'immagine...")
                    self.bot.sendPhoto(chat_id, photo=open('tmp/received_image.jpg', 'rb'))
                    txt_quality = self.calculate_image_quality('tmp/received_image.jpg')
                    self.bot.sendMessage(chat_id, txt_quality)
                    if ("too bright" in txt_quality or "too dark" in txt_quality
                        or "Poor" in txt_quality or "Bad" in txt_quality):
                        self.bot.sendMessage(chat_id, "Rilevata scarsa qualità, continuare?\n/Si\n/No")
                        self.step = Step.QUALITY_BAD
                    else:
                        self.bot.sendMessage(chat_id, "Ok, cerco i quadri migliori...")
                        self.get_similar_images('tmp/received_image.jpg', chat_id)
                        self.step = Step.RECEIVE_IMAGE

                elif txt == '/No':
                    self.bot.sendMessage(chat_id, 'Mi dispiace, riprova con un\'altra foto')
                    self.step = Step.RECEIVE_IMAGE
                else:
                    self.bot.sendMessage(chat_id, 'Input non valido, riprovare.\n/Si\n/No')
        if self.step == Step.QUALITY_BAD:
            if content_type == 'text':
                name = msg["from"]["first_name"]
                txt = msg['text']

                if txt == '/Si':
                    self.bot.sendMessage(chat_id, "Ok, cerco i quadri migliori...")
                    self.get_similar_images('tmp/received_image.jpg', chat_id)
                    self.step = Step.RECEIVE_IMAGE
                elif txt == '/No':
                    self.bot.sendMessage(chat_id, 'Mi dispiace, riprova con un\'altra foto')
                    self.step = Step.RECEIVE_IMAGE
                else:
                    self.bot.sendMessage(chat_id, 'Input non valido, riprovare.\n/Si\n/No')

    @staticmethod
    def init_bot():
        bot = telepot.Bot(TelegramBot.TOKEN)
        bot.setWebhook()  # unset webhook by supplying no parameter
        return bot

bot = TelegramBot()
bot.start_main_loop()

while 1:
    time.sleep(10)

