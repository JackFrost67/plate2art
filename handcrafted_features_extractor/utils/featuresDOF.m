function DOF = featuresDOF(H, S, L,waveletFeatures)
%Calcolo Low Depth Of field
%waveletFeatures(3, 7, 11) contengono le wavelet livelli 3 su tutta 
%l'immagine, rispettivamente di H, S, V

[rows, cols] = size(H);

%definisco le righe iniziali e finali dei quattro blocchi centrali
rowOfBlock(1) = floor(rows/4);
rowOfBlock(2) = rowOfBlock(1)*2;
rowOfBlock(3) = rowOfBlock(1)*3;

%definisco le colonne iniziali e finali dei quattro blocchi centrali
colOfBlock(1) = floor(cols/4);
colOfBlock(2) = colOfBlock(1)*2;
colOfBlock(3) = colOfBlock(1)*3;

%calcolo le wavelet per ogni blocco e le sommo
fH_ = 0;
for x = 2:3
    for y = 2:3
        blockOfH = H(rowOfBlock(x-1):rowOfBlock(x), colOfBlock(y-1):colOfBlock(y));
        [cH, sH] = wavedec2(blockOfH, 3, 'db1');
        
        [hH, vH, dH] = detcoef2('all', cH, sH, 3);
        fH_ = fH_ + (sum(hH, 'all', 'omitnan') + sum(vH, 'all', 'omitnan') + sum(dH, 'all', 'omitnan'))...
            / (numel(hH) + numel(vH) + numel(dH));
    end
end
%wavelet of H is 0 if is a grayimage
if(waveletFeatures(3) == 0)
    DOF = [0];
else
    DOF = [fH_/waveletFeatures(3)];
end

fS_ = 0;
for x = 2:3
    for y = 2:3
        blockOfS = S(rowOfBlock(x-1):rowOfBlock(x), colOfBlock(y-1):colOfBlock(y));
        [cS, sS] = wavedec2(blockOfS, 3, 'db1');
        
        [hS, vS, dS] = detcoef2('all', cS, sS, 3);
        fS_ = fS_ + (sum(hS, 'all', 'omitnan') + sum(vS, 'all', 'omitnan') + sum(dS, 'all', 'omitnan'))...
            / (numel(hS) + numel(vS) + numel(dS));
    end
end
%wavelet of S is 0 if is a grayimage
if(waveletFeatures(7) == 0)
    DOF = [DOF 0];
else
    DOF = [DOF fS_/waveletFeatures(7)];
end


fL_ = 0;
for x = 2:3
    for y = 2:3
        blockOfL = L(rowOfBlock(x-1):rowOfBlock(x), colOfBlock(y-1):colOfBlock(y));
        [cL, sL] = wavedec2(blockOfL, 3, 'db1');
        
        [hL, vL, dL] = detcoef2('all', cL, sL, 3);
        fL_ = fL_+ (sum(hL, 'all', 'omitnan') + sum(vL, 'all', 'omitnan') + sum(dL, 'all', 'omitnan'))...
            / (numel(hL) + numel(vL) + numel(dL));
    end
end


%wavelet grayimage
if(waveletFeatures(11) == 0)
    DOF = [DOF 0];
else
    DOF = [DOF fL_/waveletFeatures(11)];
end

end

