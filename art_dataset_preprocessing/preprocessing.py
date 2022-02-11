# Preprocessing for dataset
# Run once or you will mess up everything
# Dataset used: https://www.kaggle.com/c/painter-by-numbers zipfile: train.zip

import csv
import os
import pandas as pd
import matplotlib.pyplot as plt
import argparse
import cv2

def preprocessing():
    lines = csv.reader(file, delimiter = ',')
    lines_list = list(lines)
    lines_list = [line for line in lines_list[1:] if os.path.exists(os.path.join(path, line[0]))]
    
    # getting unclassified data filename
    unknown_file = [row[0] for row in lines_list[1:] if not len(row[3])]
    
    # deleting unclassified data
    for img in unknown_file:
        filename = os.path.join(path, img)
        if os.path.exists(filename):
            os.remove(filename)

    # get genre for each filename 
    labels_list = [row[3].split(',', 1)[0] for row in lines_list[1:] if len(row[3])]
    series = pd.Series(list(labels_list), dtype = "category")

    # array for info about the distribution of data in the dataset
    categories = list(series.cat.categories)
    counter = list()

    # rename each file labeling the filename with the map of the category
    category_counter = 0   
    category_list = []
    
    
    dest_folder = current_directory + "/" + args.destination
    print(dest_folder)
    if not(os.path.exists(dest_folder)):
        os.mkdir(dest_folder)

    if os.path.exists("img_db.csv"):
            os.remove("img_db.csv")    
           
    with open("info.txt", "w") as info_file:
        with open("img_db.csv", "w") as img_db_csv:
            img_db_writer = csv.writer(img_db_csv)
            info_file.write("Code & Category\n")
            for category in series.cat.categories:
                filenames = [row[0] for row in lines_list[1:] if row[3] == category and os.path.exists(os.path.join(path, row[0]))]
                titles = [row[2] for row in lines_list[1:] if row[3] == category and os.path.exists(os.path.join(path, row[0]))]
                if (len(filenames) >= args.number):
                    category_counter += 1
                    category_list.append(category)
                    info_file.write(str(category_counter) + "\t" + category + "\n")
                    fix_index = 0 # add 1 if im.read throw an exception so we can remove it from the counted images
                    for index, filename in enumerate(filenames):
                        if os.path.exists(os.path.join(path, filename)) and index - fix_index < args.number:
                            with open(os.path.join(path, filename), 'rb') as f:
                                check_chars = f.read()[-2:]
                                if (check_chars == b'\xff\xd9'):
                                    im = cv2.imread(os.path.join(path, filename))
                                    if im.shape[1] > 500 and im.shape[0] > 500:
                                        width = int(args.scaleratio * im.shape[1])
                                        height = int(args.scaleratio * im.shape[0])
                                    elif im.shape[1] < 300 or im.shape[0] < 300:
                                        width = int(im.shape[1]*1.5)
                                        height = int(im.shape[0]*1.5)
                                    else: 
                                        width = im.shape[1]
                                        height = im.shape[0]
                                        
                                    dim = (width, height)
                                    renamed_path = current_directory + "/" + args.destination + "/" + str(category_counter) + "_" + str(index - fix_index) + ".jpg"
                                    index_img = filenames.index(filename)
                                    row = [renamed_path, titles[index_img]]
                                    img_db_writer.writerow(row)
                                    cv2.imwrite(renamed_path, cv2.resize(im, dim, interpolation=cv2.INTER_AREA))
                                else:
                                    fix_index += 1
                        else:
                            break

                    counter.append(len(filenames))
    
    if(args.plot_flag):
        fig, axs = plt.subplots()
        axs.barh(category_list, counter)
        axs.invert_yaxis() 
        plt.yticks(fontsize = 6) # TODO: make the font dynamic
        axs.set_xlabel('Number of occurencies')
        axs.set_title('Is dataset balanced?')
        plt.show()

    print("Number of class: ", category_counter)

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("-p", "--plot", dest="plot_flag", action='store_true', help="Show plot for data distribution")
    parser.add_argument("-d", "--directory", dest="directory", default=os.path.dirname(os.path.realpath(__file__)), help="Directory where dataset is putted", type=str)
    parser.add_argument("-c", "--csvname", dest="csvname", default="train_info.csv", help="Name of the csv filena", type=str)
    parser.add_argument("-i", "--imgfolder", dest="imgfolder", default="train", help="Folder where images is putted", type=str)
    parser.add_argument("-n", "--number", dest="number", default=500, help="How many elements for class to take", type=int)
    parser.add_argument("-r", "--ratio", dest="scaleratio", default=0.5, help="Scale ratio to reduce the dimension of the dataset", type=float)
    parser.add_argument("-f", "--folderdest", dest="destination", default="img", help="Destination directory for the images", type=str)

    args = parser.parse_args()

    current_directory = args.directory  
    print(current_directory)
    csv_file_path = os.path.join(current_directory, args.csvname)
    path = os.path.join(current_directory, args.imgfolder)

    with open(csv_file_path, 'r') as file:
        preprocessing()
