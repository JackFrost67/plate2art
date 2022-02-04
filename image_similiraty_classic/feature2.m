function [pleasure, arousal, dominance] = feature2(sMean, lMean)
%FEAUTER2 Approx. emotional coordinates based on brightness and saturation
    pleasure = 0.69 * lMean + 0.22 * sMean;
    arousal = -0.31 * lMean + 0.60 * sMean;
    dominance = 0.76 * lMean + 0.32 * sMean;
end

