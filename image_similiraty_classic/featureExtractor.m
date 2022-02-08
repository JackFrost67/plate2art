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
    
    %% Feature 1: mean of brightness and saturation
    [sMean, lMean] = featureSaturationBrightness(S, L);
    
    %% Feature 2: Pleasure, Arousal, Dominance
    [pleasure, arousal, dominance] = featurePleasureArousalDominance(sMean, lMean);
    
    %% Feature 3: Hue circular statistics
    [hMean, hAngularDispersion, hMeanW, hAngularDispersionW] = featureHue(H, S);
    
    %% Feature 4: Colorfulness (EMD)
    EMD = featureColorfulness(paintImage);
    
    %% Feature 5: Color names
    colorNames = featuresColorNames(paintImage);
    
    %% Feature 6: Itten
    Itten = featureItten(paintImage, H, S, L);
    
    %% Feature 7: Wang
    Wang = featuresWang(paintImage);
    
    %% Feature 8: Tamura
    [coarseness, contrast, directionality] = featuresTamura(paintImage);
    
    %% Feature 9: Wavelet textures
    waveletTextures = featureWavelet(H, S, L);
    
    %% Feature 10: GLCM features
    statsH = graycoprops(graycomatrix(H));
    statsS = graycoprops(graycomatrix(S));
    statsL = graycoprops(graycomatrix(L));
    
    %% Feature 11: Level of Detail
    
    %% Feature 12: Low Depth of Field (DOF)
    
    %% Feature 13: Dynamics
    
    %% Feature 14: Rule of Thirds
end