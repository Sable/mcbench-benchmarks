function plot3d (type,smoothf)
global A cds opt holdon leg label figmain smmethod subpl


% Check if there IS data to plot
if isempty(A) errordlg ('No data present. Sure you read a file yet?','Error'); return; end
if size(A,2) < 3 
	errordlg (['Seems to be only ',num2str(size(A,2)),' columns of data. Need at least 3'],'Error'); 
	return; 
end

% Add or substitute plot
figure (figmain)
subplot(subpl(1),subpl(2),subpl(3),'Parent',figmain);
if holdon hold on; else hold off; end

% Columns
X= A(:,opt.xc(1));
Y= A(:,opt.yc(1));
M= A(:,opt.zc);

% Checking the size of data region
if size(M,2) > 1 & size(M,2) < length(X)
	warn= msgbox('More than 1 Z column, but less than X rows. Only the 1st Z column displayed','Warning');
	waitfor(warn);
	M= A(:,opt.zc(1));
end

% If we have only 1 Z column => assume XYZ triplets and interpolate.
if size(M,2) == 1
   [XI,YI]= meshgrid(min(X):range(X)/(2*length(X)-1):max(X),min(Y):range(Y)/(2*length(Y)-1):max(Y));
	Mitp= griddata(X,Y,M,XI,YI,smmethod{max(1,smoothf)});
end

% If smooth > 0 interpolate anyway (finer mesh). Smoothing method 4 ('v4')
% is not available here, so don't use it
if smoothf > 0 & size(M,2) > 1
	[XI,YI]= meshgrid(min(X):range(X)/(2*length(X)-1):max(X),min(Y):range(Y)/(2*length(Y)-1):max(Y));
	Mitp= interp2(X,Y,M,XI,YI,smmethod{min(4,smoothf)});
end


switch type
	case 'waterfall'
		if size(M,2) ~= 1 && smoothf ==0 waterfall(X,Y,M); 
		else waterfall(XI,YI,Mitp); end
	case 'ribbon'
		ribbon(X,M);
	case 'grid'
		if size(M,2) ~= 1 && smoothf ==0 mesh(X,Y,M); 
		else mesh(XI,YI,Mitp); end
	case 'bar3'
		if size(M,2) ~= 1 && smoothf ==0 bar3(X,M,'detached'); 
		else bar3(X,Mitp,'detached'); end
	case 'plot3'
		plot3(X,Y,M,'o');
	case 'stem3'
		stem3(X,Y,M(:,1));
	case 'surface'
		if size(M,2)~= 1 && smoothf ==0 surf(X,Y,M);
		else surf(XI,YI,Mitp); end
	case 'smoothfed'
		if size(M,2) ~= 1 && smoothf ==0 surfl(X,Y,M); 
		else surfl(XI,YI,Mitp); end
		shading interp;
		colormap(pink);
	case 'contour'
		if size(M,2) ~= 1 && smoothf ==0 contour(X,Y,M,10); 
		else
			[C,h]= contour(XI,YI,Mitp,10); 
			clabel(C,h,'FontSize',10);
		end
end
title(label.t); xlabel(label.x); ylabel(label.y); zlabel(label.z);
grid on;
return

