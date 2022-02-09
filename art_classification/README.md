# Art classification

load_dataset: crea oggetto ImageDataStore dalla cartella '../img' e associa le label secondo il filename delle immagini.

dataset_aug: a partire dall'imds creato crea 3 datastore agumented per train e test delle reti.

train_nn: traina una rete NASNetMobile a cui è stato sostituito l'ultimo layer fully connected.

test_accuracy: data una rete e l'augmented imds calcola top1accuracy, top5accuracy e stampa la matrice di confusione.