function [ X Y ] = selPts
%[ X Y ] = selPts
%	manually select several points in current figure
%   selection is stopped when ESC is pressed

X = []; Y = [];
ctrlLen = 0;
while 1
	[X1 Y1] = ginput(1);
	if isempty(X1), break; end
	X = [X;X1];
	Y = [Y;Y1];
	plot(X1,Y1,'bo');
	ctrlLen = ctrlLen+1;
% 	text(X1+3,Y1,num2str(ctrlLen));
end

end

