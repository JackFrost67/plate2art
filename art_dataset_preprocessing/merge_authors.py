'''
This program reads two csv files and merges them based on a common key column.
'''
# import the pandas library
# you can install using the following command: pip install pandas

import pandas as pd

# Read the files into two dataframes.
df1 = pd.read_csv('train_info.csv')
df1 = df1[['filename', 'title','style','genre','date']]

df2 = pd.read_csv('all_data_info.csv')
df2 = df2[['new_filename', 'artist']]

# Merge the two dataframes, using _ID column as key
df3 = pd.merge(df1, df2, how='left', left_on='filename', right_on='new_filename')
df3 = df3[['filename', 'artist', 'title','style','genre','date']]
df3.set_index('filename', inplace = True)

# Write it to a new CSV file
df3.to_csv('full_info.csv')
