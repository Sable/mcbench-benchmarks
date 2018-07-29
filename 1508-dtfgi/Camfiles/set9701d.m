function set9701d(m)
% sets parameters of DT3157 according to
% http://cmp.felk.cvut.cz/cmp/hardware/pulnix.html#TM-9701digital
% where m is a initialized handle to a framegrabber 

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

% input parameters check
if nargin < 1, 
	error('Not enough input arguments!');
end

if nargin > 1, 
	error('Too many input arguments!');
end



   setfg(m,'FrameType','NonInterlaced')
   setfg(m,'CameraType',4);
   setfg(m,'ClockSource','External')

   setfg(m,'ExtOnLoToHi',0)   
   setfg(m,'LineOnLoToHi',0); 
   setfg(m,'FieldOnLoToHi',0);

   setfg(m,'TotalPixPerLine',910)
   setfg(m,'FirstActivePixel',35) 
   setfg(m,'ActivePixelCount',760)
   
   setfg(m,'TotalLinesperFld',525)
   setfg(m,'FirstActiveLine',38)
   setfg(m,'ActiveLineCount',484)
   
   setfg(m,'FrameLeft',0)
   setfg(m,'HorFrameInc',1)
   setfg(m,'FrameWidth',760)
   setfg(m,'FrameTop',0)
   setfg(m,'VerFrameInc',1)
   setfg(m,'FrameHeight',484)
   
   setfg(m,'SyncMaster','Off')
   setfg(m,'SyncSentinel','Off')
   
   setfg(m,'digioconfig',255);
   setfg(m,'digitalio',255)

   

