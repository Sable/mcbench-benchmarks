function [hdl, inf] = dxAviOpen(fname);
	hdl = [];
	inf = [];
	if ~exist(fname,'file')
		fprintf(2,'dxAviOpen error, cannot find file %s\n', fname);
		return;
	end
	[hdl, t] = dxAviOpenMex(fname);
	if length(hdl) == 0;
		error(['Error opening video file ', fname]);
		return;
	end
	inf.Width = t(1);
	inf.Height = t(2);
	inf.NumFrames = t(3);
	inf.FrameRate = t(4);
	inf.TotalDuration = t(5);
