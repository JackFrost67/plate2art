function featuresVector = extract_features_classic(image)
%FEATUREEXTRACTOR Feature extraction using handcrafted feature based on
%sentiment and color analysis
    %addpath("utils");
    
    [rows, cols, ~]=size(image);
    maxRowCol = max(rows, cols);
    if(maxRowCol > 4000)
        image = imresize(image, 1/ceil(maxRowCol/1000));
    end
    
    %% transform the image from RGB to Hue Saturation Luminance
    [H, S, L] = rgb2hsl(image);
    
    %% Feature 1: mean of brightness and saturation
    sMean = mean2(S);
    lMean = mean2(L);
    
    %% Feature 2: Pleasure, Arousal, Dominance
    [pleasure, arousal, dominance] = featurePleasureArousalDominance(sMean, lMean);
    
    %% Feature 3: Hue circular statistics
    [hMean, hAngularDispersion, hMeanW, hAngularDispersionW] = featureHue(H, S);
    
    %% Feature 4: Colorfulness (EMD)
    EMD = featureColorfulness(image);
    
    %% Feature 5: Color names
    colorNames = featuresColorNames(image);
    
    %% Feature 6: Itten
    Itten = featureItten(image);
    
    %% Feature 7: Wang
    Wang = featuresWang(image);
    
    %% Feature 8: Tamura
    [coarseness, contrast, directionality] = featuresTamura(image);
    
    %% Feature 9: Wavelet textures
    waveletTextures = featureWavelet(H, S, L);
    
    %% Feature 10: GLCM features
    statsH = graycoprops(graycomatrix(H));
    statsS = graycoprops(graycomatrix(S));
    statsL = graycoprops(graycomatrix(L));
    
    if isnan(statsH.Correlation)
        statsH.Correlation = 0;
    end
    if isnan(statsS.Correlation)
        statsS.Correlation = 0;
    end
    
    if isnan(statsL.Correlation)
        statsL.Correlation = 0;
    end
    
    %% Feature 11: Level of Detail (waterfall segmentation is needed)
    [levelOfDetail, ~] = watershedSegmentation(image);
    levelOfDetail = double(levelOfDetail);
    %% Feature 12: Low Depth of Field (DOF)
    DOF = featuresDOF(H, S, L, waveletTextures);
    
    %% Feature 13: Dynamics absolute
    dynamics = featureDynamics(image);
    
    %% Feature 14: Rule of Thirds
    [hMeanRoT, sMeanRoT, lMeanRoT] = featureRuleOfThirds(image);
    
    %% Returning the whole vector of features
    featuresVector = [sMean lMean pleasure arousal dominance hMean ...
                      hAngularDispersion hMeanW hAngularDispersionW EMD ...
                      colorNames Itten Wang' coarseness contrast directionality ...
                      waveletTextures statsH.Contrast statsH.Correlation ...
                      statsH.Energy statsH.Homogeneity statsS.Contrast ...
                      statsS.Correlation statsS.Energy statsS.Homogeneity ...
                      statsL.Contrast statsL.Correlation statsL.Energy ...
                      statsL.Homogeneity levelOfDetail DOF dynamics hMeanRoT ...
                      sMeanRoT lMeanRoT];
end
