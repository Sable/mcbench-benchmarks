function set1001d(m)

% sets parameters of DT3157 according to
% http://cmp.felk.cvut.cz/cmp/hardware/pulnix.html#TM-1001digital
% for single camera directly connected to frame grabber

% m=openfg('DT3157');
   setfg(m,'FrameType','NonInterlaced')
   setfg(m,'CameraType',4);				% 8 bit mode
   setfg(m,'ClockSource','External')	%(switch camera to NSP) 
   setfg(m,'SyncSentinel','Off')
      
   
   setfg(m,'ExtOnLoToHi',0)   % pixel clock sampling edge
   setfg(m,'LineOnLoToHi',0)  % line data valid after edge
   setfg(m,'FieldOnLoToHi',0) % frame data valid after edge
   
   setfg(m,'TotalPixPerLine',1280)
   setfg(m,'FirstActivePixel',142)
   setfg(m,'ActivePixelCount',1008)

   setfg(m,'TotalLinesperFld',1100)
   setfg(m,'FirstActiveLine',24)
   setfg(m,'ActiveLineCount',1017)
   
   setfg(m,'FrameLeft',0)
   setfg(m,'HorFrameInc',1)
   setfg(m,'FrameWidth',1008)
   setfg(m,'FrameTop',0)
   setfg(m,'VerFrameInc',1)
   setfg(m,'FrameHeight',1017)
   
   setfg(m,'digioconfig',255);
   setfg(m,'digitalio',255)

   