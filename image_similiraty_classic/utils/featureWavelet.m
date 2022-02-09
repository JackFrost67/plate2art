function waveletTextures = featureWavelet(H, S, L)
%FEATUREWAVELET texture extraction based on Daubechies wavelet
    [cH, sH] = wavedec2(H, 3, 'db1');
    [cS, sS] = wavedec2(S, 3, 'db1');
    [cL, sL] = wavedec2(L, 3, 'db1');
    
    %% for each 3 level calculate f
    fH = [];
    for i = 1 : 3
        [hH, vH, dH] = detcoef2('all', cH, sH, i);
        fH_ = (sum(hH, 'all') + sum(vH, 'all') + sum(dH, 'all')) / (numel(hH) + numel(vH) + numel(dH));
        fH = [fH fH_];
    end
    fH = [fH sum(fH)];
    
    fS = [];
    for i = 1 : 3
        [hS, vS, dS] = detcoef2('all', cS, sS, i);
        fS_ = (sum(hS, 'all') + sum(vS, 'all') + sum(dS, 'all')) / (numel(hS) + numel(vS) + numel(dS));
        fS = [fS fS_];
    end
    fS = [fS sum(fS)];
    
    fL = [];
    for i = 1 : 3
        [hL, vL, dL] = detcoef2('all', cL, sL, i);
        fL_ = (sum(hL, 'all') + sum(vL, 'all') + sum(dL, 'all')) / (numel(hL) + numel(vL) + numel(dL));
        fL = [fL fL_];
    end
    fL = [fL sum(fL)];
    
    waveletTextures = [fH fS fL];
end

