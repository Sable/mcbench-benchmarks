function barerror (X,Y,E,width,ycolor,ecolor,varargin)

% Help:
% BarrError combines the functions 'bar' and 'errorbar' in a single function. 
% It can plot several bars (with their respective errors) per X value
% Lables for the x axis can be specified as a cell array of strings as last
% argument. They will be used recursively.
% Author: F. de Castro

% Sintax: barerror (X,Y,E,width,ycolor,ecolor,varargin)
% X: vector of x values
% Y: vector/array or matrix of y values
% E: vector/array or matrix of error values (plotted simmetrically)
% width: bar width
% YCOLOR: one-letter color code for the bar
% ECOLOR: one-letter color code for the error bar
% 
% Warnings:
% Vectors/arrays X, Y and E must be the same length
% Y and E must have the same number of columns if they are arrays
% The length of YCOLOR and ECOLOR must be the same as the number of columns
% of Y and E
% 
% Example:
% x= (1:5)';
% y= 20*rand(length(x),3);
% e= rand(length(x),3);
% ycolor= ['b','r','g'];
% ecolor= ['k','k','k'];
% labels= {'G1','G2','G3','G4','G5'};
% barerror(x,y,e,1,ycolor,ecolor,labels);


%-- Check vectors lengths & widths
if mean([size(X,1),size(Y,1),size(E,1)]) ~= length(X)	
	error ('Imput vectors are of different lengths. They must have the same length'); 
	return;
end
if size(Y,2) ~= size(E,2)
	error ('Y and Error vectors have different number of columns'); 
	return;
end
if size(Y,2) ~= length(ycolor)
	error ('The Y vector has more/less columns than number of elements in ycolor'); 
	return; 
end
if size(E,2) ~= length(ecolor)
	error ('The Error vector has more/less columns than number of elements in ecolor'); 
	return; 
end


%-- Function
hold on
ncol= size(Y,2);
off= fix(-ncol/2):fix(ncol/2);
realwidth= min(diff(X))/(ncol);
if ~mod(ncol,2)
	off= [off(1:ceil(length(off)/2)-1), off(1+ ceil(length(off)/2):length(off))]; 
end
for h= 1:ncol
	Xtmp= X(:,1)+ off(h)*(realwidth/2)- sign(off(h))*(~mod(ncol,2)*realwidth/4);
	bar(Xtmp,Y(:,h),width/(2*ncol),ycolor(mod(h,1+length(ycolor))));
	errorbar(Xtmp,Y(:,h),E(:,h),'LineStyle','none','Color',ecolor(mod(h,1+length(ycolor))));
end

set(gca,'XTick',X);
if ~isempty(varargin)
	set(gca,'XTickLabel',varargin{1:length(varargin)}(:));
end

hold off
