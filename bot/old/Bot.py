import logging
import time
import json, os, sys
import urllib
import tempfile
import requests
#import re, hashlib

class Bot:
    def __init__(self, bot_id, download_folder=tempfile.gettempdir()+os.sep):
        self.bot_id = bot_id
        self.base_url = "https://api.telegram.org/bot" + bot_id + "/"
        self.file_url = "https://api.telegram.org/file/bot" + bot_id + "/"
        self.max_update_id = 0
        self.encoding  = 'utf-8'
        self.download_folder = download_folder

    def query(self, page, params):
        response = urllib.request.urlopen( self.base_url + page, urllib.parse.urlencode(params).encode(self.encoding) )
        return json.loads(response.read().decode(self.encoding))

    def getMessageType(self, message):
        if 'photo' in message:
            return 'photo'
        if 'voice' in message:
            return 'voice'
        if 'document' in message:
            return 'document'
        if 'text' in message:
            return 'text'

    def sendMessage(self, chat_id, text):
        return self.query("sendMessage", { "chat_id": chat_id, "text": text} )
    
    def sendImage(self, chat_id, image_path, caption):
        #http://docs.python-requests.org/en/latest/user/quickstart/
        if os.path.isfile(image_path):
            print("sto inviando l'immagine: " + image_path)
            url = self.base_url + 'sendPhoto'
            files = {'photo': open(image_path, 'rb')}
            data  = {'caption':caption, "chat_id": chat_id}
            r = requests.post(url, files=files, data=data)
        else:
            print("Immagine non trovata: " + image_path)

    def sendDocument(self, chat_id, doc_path):
        #http://docs.python-requests.org/en/latest/user/quickstart/
        if os.path.isfile(doc_path):
            print("sto inviando il documento: " + doc_path)
            url = self.base_url + 'sendDocument'
            files = {'document': open(doc_path, 'rb')}
            data  = {"chat_id": chat_id}
            r = requests.post(url, files=files, data=data)
            #print(r.text)
        else:
            print("Documento non trovato: " + doc_path)



    def getFileDetails(self, file_id):
        file_details = self.query('getFile', { "file_id": file_id})
        #print(file_details)
        #file_path, filename, ext
        file_url   = self.file_url + file_details['result']['file_path']
        file_name  = os.path.basename(file_details['result']['file_path'])
        file_ext   = os.path.splitext(file_name)[1]
        return file_url, file_name, file_ext

    def getFile(self, file_id, download_folder=None):
        if download_folder is None:
            download_folder = self.download_folder
        file_url, file_name, file_ext = self.getFileDetails(file_id)
        local_filename = download_folder + file_name
        urllib.request.urlretrieve(file_url, local_filename)
        return local_filename


    def getUpdates(self, update_id=-1):
        # define which updates to fetch
        if update_id < 0:
            update_id = self.max_update_id + 1
        # get updates
        data = self.query("getUpdates", { "offset": update_id})
        # update max_update_id
        for r in data['result']:
            if r['update_id'] > self.max_update_id:
                self.max_update_id = r['update_id']
        # return updates
        return data['result']


if __name__ == "__main__":
    bot = Bot('128366843:AAHovviK9AQDbcWJkM9JkqDAt8B5oLUUCQI')
    while True:
        #print(bot.getUpdates())
        for u in bot.getUpdates():
            print(u['message'])
            messageType = bot.getMessageType(u['message'])
            print(messageType)
            if 'photo' in u['message']:
                local_filename = bot.getFile(u['message']['photo'][-1]['file_id'])
                print(local_filename)
            if 'voice' in u['message']:
                local_filename = bot.getFile(u['message']['voice']['file_id'])
                print(local_filename)
            if 'document' in u['message']:
                local_filename = bot.getFile(u['message']['document']['file_id'])
                print(local_filename)
        time.sleep(2)
    
