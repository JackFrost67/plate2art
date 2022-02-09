%% Test accuracy

net = load("trained_models/NASNet_resize.mat");
net = net.NN;
%% Top 1 accuracy
[YPred,scores] = classify(net,augImdsTest);
YTest = imdsTest.Labels; 
top1Accuracy = mean(YPred == YTest);

%% Top 5 accuracy
[n,m] = size(scores);  
idx = zeros(m,n); 
for i=1:n  
    [~,idx(:,i)] = sort(scores(i,:),'descend');  
end  
idx = idx(1:5,:);  
top5Classes = net.Layers(end).ClassNames(idx);  
top5count = 0;  
for i = 1:n  
    top5count = top5count + sum(YTest(i,1) == top5Classes(:,i));  
end  
top5Accuracy = top5count/n;

%% Plot confusion matrix
labels = ["Abstract Art"
"Abstract Expressionism"
"Academicism"
"Art Deco"
"Art Informel"
"Art Nouveau (Modern)"
"Baroque"
"Color Field Painting"
"Cubism"
"Early Renaissance"
"Expressionism"
"Fauvism"
"High Renaissance"
"Impressionism"
"Magic Realism"
"Mannerism (Late Renaissance)"
"Naïve Art (Primitivism)"
"Neoclassicism"
"Northern Renaissance"
"Pop Art"
"Post-Impressionism"
"Realism"
"Rococo"
"Romanticism"
"Surrealism"
"Symbolism"
"Ukiyo-e"];

m = confusionmat(YTest,YPred);
confusionchart(m, labels, 'RowSummary','row-normalized', 'Normalization','row-normalized');
