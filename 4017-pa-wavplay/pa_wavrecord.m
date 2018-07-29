function y = pa_wavrecord(varargin)
%    pa_wavrecord: record from multichannel sound hardware
%
%    Usage:          pa_wavrecord([devicetype])
%      inputbuffer = pa_wavrecord(firstchannel, lastchannel, nsamples, [samplerate],
%                                 [deviceid], [devicetype])
%
%    pa_wavrecord is a tool for recording multi-channel audio through your 
%    ASIO device. Arguments in [] are optional
%
%    - firstchannel	the first input channel to record from
%    - lastchannel  the last input channel to record from
%    - nsamples 	the number of samples to record from each channel
%    - samplerate	the sampling frequency. Default: 44100
%    - deviceid 	the device id to use for INPUT. Default: 0
%    - informat     the desired data type of inputbuffer. Valid types
%                   and the number of bits per sample are as follows:
%    - devicetype   determines which sound driver to use
%        'win'      Windows Multimedia Device
%        'dx'       DirectX DirectSound driver
%        'asio'     ASIO Driver (default)
%    - inputbuffer 	is a variable that will hold the recorded audio, 
%                   running along rows, with a seperate column for 
%                   each channel
%
%    SEE ALSO: pa_wavplay, pa_wavplayrecord

% check right num of args
error(nargchk(0,6,nargin));

% defaults
device_opt = 1;
device = 0;
fs = 44100;
%in_opt = 2;

% no args, print devices for asio
if (nargin==0)
    pawavplaya;
    return;
end

% if devtype specified
if ischar(varargin{end})
   s=varargin{end};
   varargin(end)=[];
   
   device_opt = strmatch(s,{'asio','win', 'dx'});
   if isempty(device_opt),
       error(['Unrecognized DEVICETYPE: ' s]);
   end

   if (nargin==1)
       if device_opt==1, % asio
           pawavplaya;
       end
       if device_opt==2, % win
           pawavplayw;
       end     
       if device_opt==3, % dx
           pawavplayx;
       end
       return;
    end
end

%{
% if informat specified
if ischar(varargin{end})
   s=varargin{end};
   varargin(end)=[];
   
   in_opt = strmatch(s,{'int16','double'});
   if isempty(in_opt),
       error(['Unrecognized informat: ' s]);
   end
end
%}

% channels
firstchannel = varargin{1};
lastchannel =  varargin{2};

% samples
nsamples = varargin{3};

% sample rate
if length(varargin)>=4,
    fs=varargin{4};
end

% device id
if length(varargin) >= 5,
    device = varargin{5};
end

if device_opt==1, % asio
    fprintf('Using ASIO driver\n');
    y = pawavplaya(0, -1, fs, firstchannel, lastchannel, nsamples, device);

elseif device_opt==2, % win
    fprintf('Using WMME driver\n');
    y = pawavplayw(0, -1, fs, firstchannel, lastchannel, nsamples, device);

elseif device_opt==3, % dx
    fprintf('Using DirectX driver\n');
    y = pawavplayx(0, -1, fs, firstchannel, lastchannel, nsamples, device);
end

fprintf('Converting result to doubles\n');
y = double(y);

% [EOF] pa_wavrecord.m