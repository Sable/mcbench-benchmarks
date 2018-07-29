% STARTUP FOR ENGINE COOLING EXAMPLE

if((exist('+EngineCoolingComponents')==7) && ~exist('EngineCoolingComponents_Lib.mdl'))
    ssc_build EngineCoolingComponents
end

ssc_engine_cooling_system

% Copyright 2011-2012 The MathWorks, Inc.