function pa_wavplay(varargin)
%    pa_wavplay: playback a matrix to multichannel sound hardware
%
%    Usage: pa_wavplay([devicetype])
%           pa_wavplay(buffer, [samplerate], [deviceid], [devicetype])
% 
%    pa_wavplay is a tool for playing multi-channel audio through your ASIO
%    device. Arguments in [] are optional
%
%    pa_wavplay([devicetype]) will list all your audio devices for that
%    device type then exit.
%
%    - buffer       is the matrix to play
%    - samplerate	is the sampling frequency. Default: 44100
%    - deviceid 	is the device id to use for output. Default: 0
%    - devicetype   determines which sound driver to use
%        'win'      Windows Multimedia Device
%        'dx'       DirectX DirectSound driver
%        'asio'     ASIO Driver (default)
% 
%    For stereo playback, buffer should be an N-by-2 matrix. The number of
%    audio channels supported is hardware dependent.
% 
%    samplerate should be a valid integer sample rate, eg. 22050 44100 etc.
%  
%    As of pa_wavplay 0.2, buffer should be either of type double or
%    single. pa_wavplay uses 32-bit floats (single) internally.
%
%    SEE ALSO: pa_wavrecord, pa_wavplayrecord

% check right num of args
error(nargchk(0,4,nargin));

% defaults
device_opt = 1;
device = 0;
fs = 44100;

% no args, print devices for asio
if (nargin==0)
    pawavplaya;
    return;
end

% if devtype specified
if ischar(varargin{end}),
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

% data buffer
y = varargin{1};

% sample rate
if length(varargin)>=2,
   fs=varargin{2};
end

% device id
if length(varargin) >= 3,
    if (~(ischar(varargin{3})))
        device = varargin{3};
    end
end

if device_opt==1, % asio
    fprintf('Using ASIO driver\n');
    pawavplaya(y, device, fs, 0, 0, 0, -1);

elseif device_opt==2, % win
    fprintf('Using WMME driver\n');
    pawavplayw(y, device, fs, 0, 0, 0, -1);
     
elseif device_opt==3, % dx
    fprintf('Using DirectX driver\n');
    pawavplayx(y, device, fs, 0, 0, 0, -1);
end

% [EOF] pa_wavplay.m