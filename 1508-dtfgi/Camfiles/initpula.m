function initpula(ma);

for i=0:3
   setfg(ma,'InputChannel',i)
   setfg(ma,'BlackLevel',0)
   setfg(ma,'WhiteLevel',700000)
   setfg(ma,'InputFilter','AcNone')
   setfg(ma,'FrameType','Noninterlaced')

   setfg(ma,'FrameTop',0)
   setfg(ma,'FrameLeft',0)
   setfg(ma,'FrameWidth',760)
   setfg(ma,'FrameHeight',484)
   setfg(ma,'HorFrameInc',1)
   setfg(ma,'VerFrameInc',1)

   setfg(ma,'TotalPixPerLine',909)
   setfg(ma,'BackPorchStart',60)
   setfg(ma,'ClampStart',95)
   setfg(ma,'ClampEnd',100)
   setfg(ma,'FirstActivePixel',126)
   setfg(ma,'ActivePixelCount',760)
   setfg(ma,'FirstActiveLine',33)
   setfg(ma,'TotalLinesPerFld',524)
   setfg(ma,'ActiveLineCount',484)

   setfg(ma,'ClockSource','Internal')
   setfg(ma,'ClockFreq',14312500)
%   setfg(ma,'ExtOnLoToHi',-1)
   setfg(ma,'VideoType','Composite')
   setfg(ma,'CSyncTresh',125)
%   setfg(ma,'CSyncSource',0)
   setfg(ma,'LineOnLoToHi',0)
   setfg(ma,'FieldOnLoToHi',0)
   setfg(ma,'SyncSentinel','Off')
   setfg(ma,'SyncMaster','Off')

end
