# plate2art
Dal piatto all'arte

Progetto relativo al corso di Visual Information Processing and Management anno 2021/2022.

## Struttura

- art_classification: codice e modelli neurali per la classificazione dei quadri
- art_dataset_preprocessing: codice per il preprocessing del dataset di quadri
- bot: codice per il bot
- image_quality: codice per la stima di brightness e rumore
- image_similarity_nn: codice per trovare quadri simili all'input sfruttando reti neurali
- image_similarity_classic: codice per trovare quadri simili all'input sfruttando metriche handcrafted
- segmentation: codice per la rete YOLO per food detection

## TODO: 
  - Bot:
    - [x] Image quality
    - [ ] Similarity
  - Riconoscimento immagini di bassa qualità:
    - [x] immagini sfocate/rumorose -> PIQE
    - [x] immagini sovraesposte/sottoesposte -> media luminanza
  - Segmentazione:
    - [x] Trovare piatto / riconoscere se non è presente il piatto -> YOLO
  - Classificazione:
	  - [ ] Fine tuning Neural Net di quadri
    - [ ] Valutazione usando metriche classiche
  - Similarity:
    - [ ] Feature extraction dalla NN e confronto con feature immagine piatto - approccio NN
    - [ ] Feature extraction e confronto con feature immagine piatto - approccio classico HOG - histogram colore
    - [ ] Valutazione usando metriche qualitative 


