function set1001a(m)
% sets parameters of DT3152 according to
% http://cmp.felk.cvut.cz/cmp/hardware/pulnix.html#TM-1001analog

% m=openfg('DT3152');
% setfg(m,'digioconfig',255);
%   setfg(m,'PCMode',1)
%   setfg(m,'PCValue',1)
%   setfg(m,'exposure',0)
   setfg(m,'InputChannel',0)
   setfg(m,'FrameType','NonInterlaced')
   setfg(m,'VideoType','Composite')
   setfg(m,'ClockSource','internal')
   setfg(m,'ClockFreq',20000000)
   setfg(m,'TotalPixPerLine',1272)
   
   setfg(m,'backporchstart',90)
   setfg(m,'clampstart',165)
   setfg(m,'clampend',170)
   
   
   setfg(m,'FirstActivePixel',235)
   setfg(m,'ActivePixelCount',988)

   setfg(m,'TotalLinesperFld',1050)
   setfg(m,'FirstActiveLine',30)
   setfg(m,'ActiveLineCount',1015)
   
   setfg(m,'FrameLeft',0)
   setfg(m,'HorFrameInc',1)
   setfg(m,'FrameWidth',988)
   setfg(m,'FrameTop',0)
   setfg(m,'VerFrameInc',1)
   setfg(m,'FrameHeight',1015)
   


%   setfg(m,'ExtOnLoToHi',0)
%   expozice=128+64+32;		% nejdelsi
%   mod16 = 5;
%   mod81 = 0;
%   mod82 = 4;
%   mod83 = 2;
%   mod84 = 6;
%   mod8  = 1;
%   integracestart=0;
%   integracestop=8;
%   integracepovolena =0;
%   integracenepovolena=16; 
%   integracezakazana=integracestop+integracenepovolena;
%   setfg(m,'digitalio',mod16+integracezakazana+expozice)

setfg(m, 'SyncMaster', 'Off')
setfg(m, 'SyncValue','VerFreq', 30)		%TM9701
%setfg(m, 'SyncValue','VerFreq', 15)		%TM1001
setfg(m, 'SyncMaster', 'On')