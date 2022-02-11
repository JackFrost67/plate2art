from threading import local
from Updater import Updater
import os, sys, platform, subprocess

def fileparts(fn):
    (dirName, fileName) = os.path.split(fn)
    (fileBaseName, fileExtension) = os.path.splitext(fileName)
    return dirName, fileBaseName, fileExtension


def imageHandler(bot, message, chat_id, local_filename):
	print(local_filename)
	# send message to user
	bot.sendMessage(chat_id, "Hi, please wait until the image is ready")

	# check if image contains food
	food_found = yolo_food_detection.load_image_food(local_filename)
	if (food_found == True):
		dirName, fileBaseName, fileExtension = fileparts(local_filename)
		fn = os.path.join(dirName, fileBaseName  + '.jpg')	
		bot.sendImage(chat_id, fn, "Food found, using bbox to process the image")
	else:
		bot.sendMessage(chat_id, "Food not found, using whole image")

	# set matlab command
	if 'Linux' in platform.system():
		matlab_cmd = 'matlab'
	else:
		matlab_cmd = '"C:\\Program Files\\MATLAB\\R2016a\\bin\\matlab.exe"'
	# set command to start matlab script "edges.m"
	cur_dir = os.path.dirname(os.path.realpath(__file__))
	quality_dir = cur_dir + "/../image_quality"
	cmd = matlab_cmd + " -nodesktop -nosplash -nodisplay -wait -r \"addpath(\'" + quality_dir + "\'); estimate_image_quality(\'" + local_filename + "\'); quit\""
	# lunch command
	subprocess.call(cmd,shell=True)
	# send back the quality scores
	dirName, fileBaseName, fileExtension = fileparts(local_filename)
	quality_txt_file = os.path.join(dirName, fileBaseName + '_quality' + '.txt')

	with open(quality_txt_file) as f:
		quality_txt = f.read()

	bot.sendMessage(chat_id, quality_txt)

	#TODO similarity
	#bot.sendImage(chat_id, new_fn, "")


if __name__ == "__main__":
	bot_id = '5170348617:AAG9_rEg8xFXHhHew-cXcUS2vN94TuuRaTE'
	sys.path.append('../segmentation')
	import yolo_food_detection

	updater = Updater(bot_id)
	updater.setPhotoHandler(imageHandler)
	updater.start()
