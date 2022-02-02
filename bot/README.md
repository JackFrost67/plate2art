# python-bot #

## Setup ##
1. Download Telegram on your mobile phone
2. Create a new bot
  1. Open a chat with @BotFather
  2. Send command /newbot
  3. When asked, insert a name and a username for your new bot
  4. BotFather sends you the token to access to your bot. Copy it on computer
2. Download this code on your computer
3. Open the file py2matlab.py and change the bot_id variable by assigning the token previously taken
4. Launch the script that will become the server of your telegram bot (requires python 3)
  1. on Windows: python py2matlab.py
  2. on Ubuntu: python3 py2matlab.py
5. Test it by opening a chat with your just-created bot and send him a picture.

## Classes ##

### Bot ###
This class is used to make the basic operations such as receiving and sending text messages and images, as well as documents and audio messages

Example:
```python
  from Bot import Bot
  
  bot = Bot(bot_id)
  bot.sendMessage(chat_id, "This is a message")
```

### Updater ###
The updater checks for updates and dispatches the type of message received to the specified function (if specified).
It's possible to bind a function to a message type by using these setter functions:
```python
  setTextHandler(f)
  setPhotoHandler(f)
  setVoiceHandler(f)
```

Here there is an example:
```python
from Updater import Updater

# create your function to handle a message type, in this case plain text
def myTextHandler(bot, message, chat_id, text):
  # this function sends back the received message
  bot.sendMessage(chat_id, 'Received this text: ' + text)

# instantiate the updater
updater = Updater(bot_id)
# bind the textHandler of the updater with your custom textHandler
updater.setTextHandler(myTextHandler)
# lunch the updater
updater.start()
```