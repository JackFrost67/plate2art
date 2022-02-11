import pandas as pd

# Read the files into two dataframes.
df = pd.read_csv('img_db.csv')
#df.set_index('filename', inplace = True)
test = (df.loc[df['filename'] == "/home/fdila/repos/uni/plate2art/art_dataset_preprocessing/img/1_2.jpg"])
print(test['artist'].values[0])
print(test['title'].values[0])


