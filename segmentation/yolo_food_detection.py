# YOLO object detection
import cv2 as cv
import numpy as np
import time

def load_image_food(path):
    
    WHITE = (255, 255, 255)
    img = None
    img0 = None
    outputs = None

    # Load names of classes and get random colors
    classes = open('food100.names').read().strip().split('\n')
    np.random.seed(42)
    colors = np.random.randint(0, 255, size=(len(classes), 3), dtype='uint8')

    # Give the configuration and weight files for the model and load the network.
    net = cv.dnn.readNetFromDarknet('yolov2-food100.cfg', 'yolov2-food100.weights')
    net.setPreferableBackend(cv.dnn.DNN_BACKEND_OPENCV)
    # net.setPreferableTarget(cv.dnn.DNN_TARGET_CPU)

    # determine the output layer
    ln = net.getLayerNames()
    ln = [ln[i - 1] for i in net.getUnconnectedOutLayers()]

    img0 = cv.imread(path)
    img = img0.copy()
    
    blob = cv.dnn.blobFromImage(img, 1/255.0, (416, 416), swapRB=True, crop=False)

    net.setInput(blob)
    t0 = time.time()
    outputs = net.forward(ln)
    t = time.time() - t0

    # combine the 3 output groups into 1 (10647, 85)
    # large objects (507, 85)
    # medium objects (2028, 85)
    # small objects (8112, 85)
    outputs = np.vstack(outputs)
    post_process(img, outputs, 0.2, path)

def post_process(img, outputs, conf, path):
    H, W = img.shape[:2]

    boxes = []
    confidences = []
    classIDs = []

    for output in outputs:
        scores = output[5:]
        classID = np.argmax(scores)
        confidence = scores[classID]
        if confidence > conf:
            x, y, w, h = output[:4] * np.array([W, H, W, H])
            p0 = int(x - w//2), int(y - h//2)
            p1 = int(x + w//2), int(y + h//2)
            boxes.append([*p0, int(w), int(h)])
            confidences.append(float(confidence))
            classIDs.append(classID)

    indices = cv.dnn.NMSBoxes(boxes, confidences, conf, conf-0.1)
    if len(indices) > 0:
        print("Food Found")
        max_box_area = 0;
        max_box_index = 0;
        for i in indices.flatten():
            (w, h) = (boxes[i][2], boxes[i][3])
            area = w*h
            if (area > max_box_area):
                max_box_index = i
        
        (x, y) = (boxes[max_box_index][0], boxes[max_box_index][1])
        (w, h) = (boxes[max_box_index][2], boxes[max_box_index][3])
        cibo = img[y:y+h, x:x+w]
        cv.imwrite('test.jpg', cibo)
