[filename, pathname] = uigetfile({'*.avi','AVI file'; '*.vid','Gary''s zlib vid file'; 
			'*.mov','quicktime file, needs 3ivx codec'; '*.*','Any file'},'Pick a video file');

%Open an handle to the AVI file
[avi_hdl, avi_inf] = dxAviOpen([pathname, filename]);

for frame_num = 1:30:avi_inf.NumFrames;
	
	%Reads frame_num from the AVI
	pixmap = dxAviReadMex(avi_hdl, frame_num);
	if 1;
		imshow(reshape(pixmap/255,[avi_inf.Height,avi_inf.Width,3]));
		title(sprintf('frame number %d',floor(frame_num)));
		fprintf('Press any key\n');
		pause;
	end
end

%Cleanup
dxAviCloseMex(avi_hdl);
