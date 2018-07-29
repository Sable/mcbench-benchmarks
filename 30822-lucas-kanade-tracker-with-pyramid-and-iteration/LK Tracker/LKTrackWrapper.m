function [ X2 Y2 ] = LKTrackWrapper( imgseq,X1,Y1 )
% [ X2 Y2 ] = LKTrackWrapper( imgseq,X1,Y1 )
%	calls LKTrackPyr for each 2 neighboring frames in imgseq.
%	imgseq(M-by-N-by-F) are F grayscale images, it can be either from
%	a image sequence or a video(like from VideoReader).
%	if X1 and Y1 are not specified, function calls corner_ST to find
%	maxPtsNum corners. if X2 and Y2 are not required to output, function
%	will show these points in a figure. You should press a key to
%	start the show.


if nargin > 0 % image sequence or video
	[M N imgNum] = size(imgseq);
	maxPtsNum = 50;
	if ~exist('Y1','var')
		[Y1 X1] = corner_ST(imgseq(:,:,1),maxPtsNum);
		borderTh = 10;
		discard = Y1<borderTh | Y1>M-borderTh |...
			X1<borderTh | X1>N-borderTh; % discard points on the image border
		Y1 = Y1(~discard);
		X1 = X1(~discard);
	end

	X2 = zeros(length(X1),imgNum);
	Y2 = zeros(length(X1),imgNum);
	X2(:,1) = X1;
	Y2(:,1) = Y1;

	for p = 2:imgNum
		[X2(:,p) Y2(:,p)] = LKTrackPyr(imgseq(:,:,p-1),imgseq(:,:,p),...
			X2(:,p-1),Y2(:,p-1));
	end

	if nargout == 0
		figure,pause % show the points
		sc = min(M,N)/30; % scale of the line indicating the speed
		for p = 1:imgNum
			imshow(imgseq(:,:,p)),hold on
			X2p = X2(:,p); Y2p = Y2(:,p);
			plot(X2p,Y2p,'go');
			if p > 1 % draw speed lines
				plot([X2p,X2p+(X2p-X2pl)*sc]',...
					[Y2p,Y2p+(Y2p-Y2pl)*sc]','m-');
			end
			pause;
			X2pl = X2p; Y2pl = Y2p;
		end
	end
	
else % webcam, not finished
	
	vid = videoinput('winvideo',1); % specify your own name and index
	vid.TriggerRepeat = Inf;
	vid.FrameGrabInterval = 3;
	vid.ReturnedColorSpace='grayscale'; % 'rgb'
	figure
	while vid.FramesAcquired<=100
		data = getdata(vid,1);
		imshow(data);
		drawnow
	end
	stop(vid);
	delete(vid);

end

