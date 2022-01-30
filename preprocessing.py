# Preprocessing for dataset
# Run once or you will mess up everything
# Dataset used: https://www.kaggle.com/c/painter-by-numbers zipfile: train2.zip

import numpy as np
import csv
import os
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.ticker import PercentFormatter

current_directory =  os.path.dirname(__file__)
csv_file_path = os.path.join(current_directory, 'train_info.csv')
path = current_directory + "/img/"

with open(csv_file_path, 'r') as file:
    lines = csv.reader(file, delimiter = ',')
    lines_list = list(lines)
    lines_list = [line for line in lines_list[1:] if os.path.exists(path + line[0])]

    # getting unclassified data filename
    unknown_file = [row[0] for row in lines_list[1:] if not len(row[3])]
    
    # deleting unclassified data
    for img in unknown_file:
        filename = current_directory + "/img/" + img
        if os.path.exists(filename):
            os.remove(filename)

    # get genre for each filename 
    labels_list = [row[3] for row in lines_list[1:] if len(row[3])]
    series = pd.Series(list(labels_list), dtype = "category")

    # array for info about the distribution of data in the dataset
    categories = list(series.cat.categories)
    counter = list()

    # rename each file labeling the filename with the map of the category
    for code, category in enumerate(series.cat.categories):
        filenames = [row[0] for row in lines_list[1:] if row[3] == category and os.path.exists(path + row[0])]
        
        print("Code: ", code)
        print("Category: ", category)
    
        for index, filename in enumerate(filenames):
            if os.path.exists(path + filename):
                os.rename(path + filename, path + str(code) + str(index) + ".jpg")

        counter.append(len(filenames))
    
    fig, axs = plt.subplots()
    axs.barh(categories, counter)
    axs.invert_yaxis() 
    plt.yticks(fontsize = 6)
    axs.set_xlabel('Number of occurencies')
    axs.set_title('Is dataset balanced?')
    plt.show()

    print("\nNumber of class: ", len(series.cat.categories))