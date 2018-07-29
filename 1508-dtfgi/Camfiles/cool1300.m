function cool1300(m,bits,bin,iod,gain)
% function cool1300(m,bits,bin,iod,gain)
% sets parameters of DT3157 according to
% http://cmp.felk.cvut.cz/cmp/hardware/cool1300
% where m is a initialized handle to a framegrabber 
% bits is dynamic range in bits, valid 8 and 12
% bin is 1 for binning, 
% iod is 1 for image on demand
% gain is 1 for gain increased by factor of 2

%---------------------------------------------------------
%  setfg(m,'CameraType',type); 
% type is a type of a bus width described below
%			0 16BIT_INPUT,
%			1 14BIT_INPUT
%			2 12BIT_INPUT
%			3 10BIT_INPUT
%			4 8BIT_SINGLE_CHANNEL_INPUT
% 			5 8BIT_DUAL_CHANNEL_INPUT
%-----------------------------------------------------------

gainbit = 4; 	% 5
iodbit = 5;	% 4
binbit = 2;

% input parameters check
if nargin < 1, 
	error('Not enough input arguments!');
end

if nargin > 5, 
	error('Too many input arguments!');
end



setfg(m,'FrameType','NonInterlaced')
if bits==8
   setfg(m,'CameraType',4); % 8 bit
elseif bits==12
   setfg(m,'CameraType',2); % 12 bit
else   
   error('Number of bits per pixel unknown')
end   

if ~exist('bin','var') 
   bin=0;
end

if ~exist('iod','var')
   iod=0;
end

if ~exist('gain','var')
   gain=0;
end

   
   setfg(m,'ClockSource','External')


if bin % HW subsampled
   setfg(m,'ExtOnLoToHi',1)   
   setfg(m,'LineOnLoToHi',1); 
   setfg(m,'FieldOnLoToHi',0);
   
   setfg(m,'TotalPixPerLine',800)
   setfg(m,'ActivePixelCount',640)
   setfg(m,'FirstActivePixel',4) 
   
   setfg(m,'TotalLinesperFld',525)
   setfg(m,'ActiveLineCount',512)
   setfg(m,'FirstActiveLine',1) %11
   
   setfg(m,'FrameLeft',0)
   setfg(m,'HorFrameInc',1)
   setfg(m,'FrameWidth',640)
   setfg(m,'FrameTop',0)
   setfg(m,'VerFrameInc',1)
   setfg(m,'FrameHeight',512)
else % full resolution
   setfg(m,'ExtOnLoToHi',0)   
   setfg(m,'LineOnLoToHi',1); 
   setfg(m,'FieldOnLoToHi',0);      % prenastaveno z 0 po experimentech s dlouhou expozici

   setfg(m,'TotalPixPerLine',1600)
   setfg(m,'ActivePixelCount',1280)
   setfg(m,'FirstActivePixel',4) 
   
   setfg(m,'TotalLinesperFld',1050)
   setfg(m,'ActiveLineCount',1024)
   setfg(m,'FirstActiveLine',22)
   
   setfg(m,'FrameLeft',0)
   setfg(m,'HorFrameInc',1)
   setfg(m,'FrameWidth',1280)
   setfg(m,'FrameTop',0)
   setfg(m,'VerFrameInc',1)
   setfg(m,'FrameHeight',1024)
end   
   setfg(m,'SyncMaster','Off')
   setfg(m,'SyncSentinel','Off')
   
   setfg(m,'digioconfig',255);
   outputbits = 3+(1-bin)*2^binbit+(1-iod)*2^iodbit+(1-gain)*(2^gainbit);
   setfg(m,'digitalio',outputbits)
%   setfg(m,'digitalio',255)

   

