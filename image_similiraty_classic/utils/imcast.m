function [outpict inclass] = imcast(inpict,outclass)
%   [OUTPICT INCLASS]=IMCAST(INPICT,OUTCLASS)
%       Scale and recast image data and return class of input
%       This is more succinct than using getrangefromclass()
%       and im2double(), im2uint8(), etc.
%
%       This is a convenience not only because it is succinct
%       and parameterizes the class assignment, but it also 
%       increases portability and potential speed, using 
%       precompiled IPT tools when available.  If IPT is not
%       installed, m-code conversions are used instead.
%
%   INPICT may be of any supported class
%   OUTCLASS is a string describing any supported class
%   
%   Supported classes are:
%   'uint8','uint16','int16','double','single','logical'
inclass = class(inpict);
outclass = lower(outclass);
if strcmp(inclass,outclass)
	outpict = inpict;
	return;
end
% IF IPT IS INSTALLED
if license('test', 'image_toolbox')
	switch outclass
		case 'uint8'
			outpict = im2uint8(inpict);
		case 'double'
			outpict = im2double(inpict);
		case 'single'
			outpict = im2single(inpict);
		case 'uint16'
			outpict = im2uint16(inpict);
		case 'int16'
			outpict = im2int16(inpict);	
		case 'logical'
			switch inclass
				case 'uint8'
					outpict = inpict > 127;
				case 'uint16'
					outpict = inpict > 32768;
				case 'int16'
					outpict = inpict > 0;
				case {'double','single'}
					outpict = inpict > 0.5;
			end
		otherwise
			error('IMCAST: unsupported image class for output')
	end
	
	return;
end
% IF IPT IS NOT INSTALLED
% i'm not sure how to make this any faster in m-code
% logical thresholding might not be appropriate in all cases
switch inclass
	case 'uint8'
		switch outclass
			case 'uint16'
				outpict = uint16(inpict)*257;
			case 'int16'
				outpict = int16(int32(inpict)*257-32768);
			case {'double','single'}
				outpict = cast(inpict,outclass)/255;
			case 'logical'
				outpict = inpict > 127;
			otherwise
				error('IMCAST: unsupported image class for output')
		end
		
	case 'uint16'
		switch outclass
			case 'uint8'
				outpict = uint8(inpict/257);
			case 'int16'
				outpict = int16(int32(inpict)-32768);
			case {'double','single'}
				outpict = cast(inpict,outclass)/65535;
			case 'logical'
				outpict = inpict > 32767;
			otherwise
				error('IMCAST: unsupported image class for output')
		end
		
	case 'int16'
		switch outclass
			case 'uint8'
				outpict = uint8((int32(inpict)+32768)/257);
			case 'uint16'
				outpict = uint16(int32(inpict)+32768);
			case {'double','single'}
				outpict = (cast(inpict,outclass)+32768)/65535;
			case 'logical'
				outpict = inpict > 0;
			otherwise
				error('IMCAST: unsupported image class for output')
		end
		
	case {'double','single','logical'}
		switch outclass
			case 'uint8'
				outpict = uint8(inpict*255);
			case 'uint16'
				outpict = uint16(inpict*65535);
			case 'int16'
				outpict = int16(inpict*65535-32768);
			case {'double','single'}
				outpict = cast(inpict,outclass);
			case 'logical'
				outpict = inpict > 0.5;
			otherwise
				error('IMCAST: unsupported image class for output')
		end
	otherwise
		error('IMCAST: unsupported image class for input')
end
end


