import logging
import time
import json, os, sys
import urllib
import tempfile
import requests
from Bot import Bot


def doNothing(*arg):
    pass

class Updater:
    def __init__(self, bot_id, waitingTime=0, download_folder=tempfile.gettempdir()+os.sep):
        self.bot = Bot(bot_id, download_folder)
        self.textHandler     = doNothing;
        self.photoHandler    = doNothing;
        self.voiceHandler    = doNothing;
        self.documentHandler = doNothing;
        self.waitingTime     = waitingTime;

    def setTextHandler(self, f):
        self.textHandler = f

    def setPhotoHandler(self, f):
        self.photoHandler = f

    def setVoiceHandler(self, f):
        self.voiceHandler = f

    def start(self):
        while True:
            for u in self.bot.getUpdates():
                # get info about the message
                messageType = self.bot.getMessageType(u['message'])
                message     = u['message']
                chat_id     = message['chat']['id']
                name        = message['chat']['first_name']
                message_id  = message['message_id']
                # call right functors
                if messageType == 'text':
                    # TODO: distinguish between command and plain text
                    text = message['text']
                    self.textHandler(self.bot, message, chat_id, text)
                if messageType == 'photo':
                    local_filename = self.bot.getFile(u['message']['photo'][-1]['file_id'])
                    self.photoHandler(self.bot, message, chat_id, local_filename)
                if messageType == 'voice':
                    local_filename = self.bot.getFile(u['message']['voice']['file_id'])
                    self.voiceHandler(self.bot, message, chat_id, local_filename)
                if messageType == 'document':
                    local_filename = self.bot.getFile(u['message']['document']['file_id'])
                    self.documentHandler(self.bot, message, chat_id, local_filename)
            if self.waitingTime > 0:
                time.sleep(self.waitingTime)

if __name__ == "__main__":
    updater = Updater('128366843:AAHovviK9AQDbcWJkM9JkqDAt8B5oLUUCQI')
    updater.start()
