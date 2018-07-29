function so = scaleStream(si,factor)
% SCALESTREAM  Scale a stream (of numerics)
so = {head(si)*factor,delayEval(@scaleStream,{tail(si),factor})};