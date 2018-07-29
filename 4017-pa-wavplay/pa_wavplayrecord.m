function y = pa_wavplayrecord(varargin)
% pa_wavplayrecord: simultaneous playback & record of multichannel sound
%
%    Usage:
%      inputbuffer = pa_wavplayrecord(playbuffer,[playdevice],[samplerate],
%                       [recnsamples], [recfirstchannel], [reclastchannel],
%                       [recdevice], [devicetype])
% 
%    pa_wavplayrecord is a tool for playing and recording multi-channel
%    audio through your ASIO device. Arguments in [] are optional
%
%    pa_wavplayrecord([devicetype]) will list all your audio devices for 
%    that device type then exit.
%
%    - playbuffer   the matrix to play
%    - playdevice   the device to play it on. Default: 0
%    - samplerate	the sampling frequency. Default: 44100
%    - recnsamples  the number of samples to record. Default: 0
%                   if 0 then we'll record for the duration of playbuffer
%    - recfirstchannel the first channel to record from Default: 1
%    - reclastchannel the last channel to record from Default: 1
%    - recdevice    the device to record from. Default: 0
%    - devicetype   determines which sound driver to use
%        'win'      Windows Multimedia Device
%        'dx'       DirectX DirectSound driver
%        'asio'     ASIO Driver (default)
% 
%    See the help for pa_wavplay for a list of some of these arguments,
%    and the formatting of them.
%
%    SEE ALSO: pa_wavrecord, pa_wavplayrecord

% check right num of args
error(nargchk(1,8,nargin));

% defaults
device_opt = 1;
playdevice = 0;
fs = 44100;
recnsamples = 0;
recfirstchannel = 1;
reclastchannel = 1;
recdevice = 0;

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
playbuffer = varargin{1};

% play device
if length(varargin)>=2,
    playdevice=varargin{2};
end

% sample rate
if length(varargin)>=3,
    fs=varargin{3};
end

% recnsamples
if length(varargin)>=4,
    recnsamples=varargin{4};
end

% recfirstchannel
if length(varargin)>=5,
    recfirstchannel=varargin{5};
end

% reclastchannel
if length(varargin)>=6,
    reclastchannel=varargin{6};
end

% recdevice
if length(varargin)>=7,
    recdevice=varargin{7};
end

if device_opt==1, % asio
    fprintf('Using ASIO driver\n');
    y = pawavplaya(playbuffer, playdevice, fs, recfirstchannel, reclastchannel, recnsamples, recdevice);
elseif device_opt==2, % win
    fprintf('Using WMME driver\n');
    y = pawavplayw(playbuffer, playdevice, fs, recfirstchannel, reclastchannel, recnsamples, recdevice);
elseif device_opt==3, % dx
    fprintf('Using DirectX driver\n');
    y = pawavplayx(playbuffer, playdevice, fs, recfirstchannel, reclastchannel, recnsamples, recdevice);
end

fprintf('Converting result to doubles\n');
y = double(y);

% [EOF] pa_wavplayrecord.m