%%
paintImageDir = "/home/jackfrost67/Desktop/plate2art/img";

imagefiles = dir(paintImageDir + "/*.jpg");
nfiles = length(imagefiles);

featuresVector = [];
%%
for i = 1 : nfiles
    tic
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
    Itten = featureItten(paintImage);
    
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
    
    %% Feature 11: Level of Detail (waterfall segmentation is needed)
    [levelOfDetail, ~] = watershedSegmentation(paintImage);
    levelOfDetail = double(levelOfDetail);
    %% Feature 12: Low Depth of Field (DOF)
    DOF = featuresDOF(H, S, L, waveletTextures);
    
    %% Feature 13: Dynamics absolute
    dynamics = featureDynamics(paintImage);
    
    %% Feature 14: Rule of Thirds
    [hMeanRoT, sMeanRoT, lMeanRoT] = featureRuleOfThirds(paintImage);
    
    %% 
    featuresVector = [featuresVector;
                      sMean lMean pleasure arousal dominance hMean ...
                      hAngularDispersion hMeanW hAngularDispersionW EMD ...
                      colorNames Itten Wang' coarseness contrast directionality ...
                      waveletTextures statsH.Contrast statsH.Correlation ...
                      statsH.Energy statsH.Homogeneity statsS.Contrast ...
                      statsS.Correlation statsS.Energy statsS.Homogeneity ...
                      statsL.Contrast statsL.Correlation statsL.Energy ...
                      statsL.Homogeneity levelOfDetail DOF dynamics hMeanRoT ...
                      sMeanRoT lMeanRoT];
     toc
end