%% Test accuracy

%% Top 1 accuracy
[YPred,scores] = classify(trainedNetwork_1,augImdsTrain);
YTest = imdsTrain.Labels; 
top1Accuracy = mean(YPred == YTest);

%% Top 5 accuracy
[n,m] = size(scores);  
idx = zeros(m,n); 
for i=1:n  
    [~,idx(:,i)] = sort(scores(i,:),'descend');  
end  
idx = idx(1:5,:);  
top5Classes = trainedNetwork_1.Layers(end).ClassNames(idx);  
top5count = 0;  
for i = 1:n  
    top5count = top5count + sum(YTest(i,1) == top5Classes(:,i));  
end  
top5Accuracy = top5count/n;