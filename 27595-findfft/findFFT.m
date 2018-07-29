function [amp freq] = findFFT(data,varargin)
%findFFT returns fft amplitude and frequency vectors from input data
%
%IN
%   data - vector containing information to perform fft on
%   '-sampFreq',## - inputs sampling frequency of ##, if ## is not supplied
%                    default is 1
%   '-zeropad',##  - option to zeropad data to ## times original size, if
%                    ## is not supplied default is 10
%   '-window'      - Option to apply a windowing function to data
%   'windowtype'   - string containing which windowing function to apply to
%                    data, must follow option '-window', if not supplied
%                    default is 'hann'
%OUT
%   amp  - vector containing amplitude values (y-axis)
%   freq - vector containing frequency values (x-axis)
%
%Examples:
%   [amp freq] = findFFT(data)
%   [amp freq] = findFFT(data,'-sampFreq',10)
%   [amp freq] = findFFT(data,'-zeropad',5)
%   [amp freq] = findFFT(data,'-window','hamming')
%   [amp freq] = findFFT(data,'-sampFreq',10,'-zeropad',5,'-window',...
%                        'blackman')
%   
%
%Use plotFFTdifs.m script to see examples of how this function works and
%what all the different outputs look like.
%
%References
%   For an excellent introduction to FFTs, zeropadding, and windowing
%   http://blinkdagger.com/category/control-systems/
%
%   For an excellent article on windowing
%   http://www.ee.iitm.ac.in/~nitin/_media/ee462/fftwindows.pdf?id=jan07%3A
%   ee462%3Arefs&cache=cache
%
%
%Written by:
%   Bryant Svedin
%   10 May, 2010

if nargin == 0;
    amp = [];
    freq = [];
    return
end

datasize = size(data);
if datasize(1) == 1
    data = data'; %data must be a column vector
end


if nargin > 1;
    options = parse_args(varargin{:});
else
    options.wantWindow = false;
    options.windowtype = 'hann';
    options.zeropad = false;
    options.zeronum = 10;
    options.sampFreq = 1;
end

%Windowing the data introduces an error in the amplutude values which is
%corrected by multiplying by the coherance factor corresponding the the
%window type
if strcmp(options.windowtype,'hann')
    cohfac = 1/.5;
elseif strcmp(options.windowtype,'hamming')
    cohfac = 1/.54;
elseif strcmp(options.windowtype,'flattopwin')
    cohfac = 1/.22;
elseif strcmp(options.windowtype,'blackman')
    cohfac = 1/.43;
elseif strcmp(options.windowtype,'kaiser')
    cohfac = 1/.4;
elseif strcmp(options.windowtype,'bohmanwin')
    cohfac = 1/.5;
elseif strcmp(options.windowtype,'gausswin')
    cohfac = 1/.43;
end

%just normal FFT
if ~options.zeropad && ~options.wantWindow 
    N = 2^(nextpow2(length(data)));
    N2 = length(data);
    amp = abs(fft(data,N)) * 2/N2;
    NumUniquePts = ceil((N+1)/2);
    amp = amp(1:NumUniquePts);
    freq=(0:NumUniquePts-1)'/(NumUniquePts)*(options.sampFreq/2);
    
%zeropaded FFT
elseif options.zeropad && ~options.wantWindow 
    N = 2^(nextpow2(length(data)*options.zeronum));
    N2 = length(data);
    amp = abs(fft(data,N)) * 2/N2;
    NumUniquePts = ceil((N+1)/2);
    amp = amp(1:NumUniquePts);
    freq=(0:NumUniquePts-1)'/(NumUniquePts)*(options.sampFreq/2);
    
%windowed FFT
elseif ~options.zeropad && options.wantWindow 
    N = 2^(nextpow2(length(data)));
    N2 = length(data);
    wind = window(eval(['@' options.windowtype]),N2);
    windowedSignal = wind.*data;
    amp = abs(fft(windowedSignal,N)) * 2/N2;
    amp = amp * cohfac; %multiply by the coherance factor to get the correct amplitude
    NumUniquePts = ceil((N+1)/2);
    amp = amp(1:NumUniquePts);
    freq=(0:NumUniquePts-1)'/(NumUniquePts)*(options.sampFreq/2);

%windowed zeropaded FFT
elseif options.zeropad && options.wantWindow 
    N = 2^(nextpow2(length(data)*options.zeronum));
    N2 = length(data);
    wind = window(eval(['@' options.windowtype]),N2);
    windowedSignal = wind.*data;
    amp = abs(fft(windowedSignal,N)) * 2/N2;
    amp = amp * cohfac; %multiply by the coherance factor to get the correct amplitude
    NumUniquePts = ceil((N+1)/2);
    amp = amp(1:NumUniquePts);
    freq=(0:NumUniquePts-1)'/(NumUniquePts)*(options.sampFreq/2);
end



function options = parse_args(varargin)
for a = 1:nargin
    if ischar(varargin{a}) && ~isempty(varargin{a})
        if varargin{a}(1) == '-'
            switch lower(varargin{a}(2:end))
                case 'window'
                    options.wantWindow = true;
                    if a+1 <= nargin
                        if varargin{a+1}(1) ~= '-'
                            options.windowtype = varargin{a+1};
                        else
                            options.windowtype = 'hann';
                        end
                    else
                        options.windowtype = 'hann';
                    end
                case 'zeropad'
                    options.zeropad = true;
                    if a+1 <= nargin
                        if ~ischar(varargin{a+1})
                            options.zeronum = varargin{a+1};
                        else
                            options.zeronum = 30;
                        end
                    else
                        options.zeronum = 30;
                    end
                case 'sampfreq'
                    if a+1 <= nargin
                        if ~ischar(varargin{a+1})
                            options.sampFreq = varargin{a+1};
                        else
                            options.sampFreq = 1;
                        end
                    else
                        options.sampFreq = 1;
                    end
                otherwise
            end
        end
    end
end
if ~isfield(options,'wantWindow')
    options.wantWindow = false;
end
if ~isfield(options,'windowtype')
    options.windowtype = 'hann';
end
if ~isfield(options,'zeropad')
    options.zeropad = false;
end
if ~isfield(options,'zeronum')
    options.zeronum = 30;
end
if ~isfield(options,'sampFreq')
    options.sampFreq = 1;
end
return

























