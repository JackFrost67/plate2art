# Segmentation

NOTA: per far funzionare la rete è necessario inserire nella cartella i file food100.names, yolov2-food100.cfg e yolov2-food100.weights dal repository https://github.com/bennycheung/Food100_YOLO_Tools 

yolo_food_detection: funzione che prende in input il path di un'immagine e ritorna True se l'immagine contiene un cibo o False se non lo contiene. Se viene trovato almeno un piatto, ritaglia la bounding box più grande e salva il ritaglio con lo stesso nome del file in input.

test_food_detection: script per testare la food detection

