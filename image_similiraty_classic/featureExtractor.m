%%
featureVector = [];

paintImageDir = "/home/jackfrost67/Desktop/plate2art/img";

imagefiles = dir(paintImageDir + "/*.jpg");
nfiles = length(imagefiles);

%%
for i = 1 : nfiles
    strcat(imagefiles(i).folder, "/", imagefiles(i).name);
    paintImage = imread(strcat(imagefiles(i).folder, "/", imagefiles(i).name));
    [H, S, L] = rgb2ihsl(paintImage);
    
    % Feature 1: mean of brightness and saturation
    [sMean, lMean] = feature1(S, L);
    
    % Feature 2: Pleasure, Arousal, Dominance
    [pleasure, arousal, dominance] = feature2(sMean, lMean);
    
    % Feature 3: Hue circular statistics
    [hMean, hAngularDispersion, hMeanW, hAngularDispersionW] = feature3(H, S);
    
    % Feature 4: Colorfulness (EMD)
    EMD = feature4(paintImage);
    
    % Feature 5: Color names
    
    % Feature 6: Itten
    Itten = feature6(paintImage);
end