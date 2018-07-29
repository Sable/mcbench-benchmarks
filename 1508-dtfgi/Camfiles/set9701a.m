function set9701a(m)
% sets parameters of DT3152 according to
% http://cmp.felk.cvut.cz/cmp/hardware/pulnix.html#TM-9701analog
% where m is a initialized handle to a framegrabber 

% input parameters check
if nargin < 1, 
	error('Not enough input arguments!');
end

if nargin > 1, 
	error('Too many input arguments!');
end

for i=0:3
   setfg(m,'InputChannel',i)
   setfg(m,'FrameType','NonInterlaced')
   setfg(m,'VideoType','Composite')
   setfg(m,'ClockSource','internal')
   setfg(m,'ClockFreq',14318180)
   setfg(m,'TotalPixPerLine',909)
   
   setfg(m,'backporchstart',60)
   setfg(m,'clampstart',95)
   setfg(m,'clampend',100)
   
   
   setfg(m,'FirstActivePixel',126)
   setfg(m,'ActivePixelCount',760)

   setfg(m,'TotalLinesperFld',524)
   setfg(m,'FirstActiveLine',33)
   setfg(m,'ActiveLineCount',484)
   
   setfg(m,'FrameLeft',0)
   setfg(m,'HorFrameInc',1)
   setfg(m,'FrameWidth',760)
   setfg(m,'FrameTop',0)
   setfg(m,'VerFrameInc',1)
   setfg(m,'FrameHeight',484)
end   

setfg(m,'InputChannel',0)
