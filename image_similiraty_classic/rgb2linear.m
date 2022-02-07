function out = rgb2linear(inpict)
%   OUTPICT=RGB2LINEAR(INPICT)
%   Convert gamma-corrected sRGB to linear RGB
%
%   INPICT is an RGB image of a floating point class.
%   Output class is inherited from INPICT

mk = double(inpict <= 0.0404482362771076);
out = inpict/12.92.*mk + real(((inpict+0.055)/1.055).^2.4).*(1-mk);
end