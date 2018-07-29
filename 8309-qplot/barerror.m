function barerror (X,Y,E,width,color)

if mean([size(X,1),size(Y,1),size(E,1)]) ~= length(X)	error ('Imput vectors are of different lengths'); return; end
if size(Y,2) ~= size(E,2) error ('Data and Error vectors have different number of columns'); return; end

colors= ['k';'w';'r';'g';'b';'c';'m';'y'];
hold on
ncol= size(Y,2);
off= [fix(-ncol/2):fix(ncol/2)];
realwidth= min(diff(X))/(ncol);
if ~mod(ncol,2) off= [off(1:ceil(length(off)/2)-1), off(1+ ceil(length(off)/2):length(off))]; end
for h= 1:ncol
	Xtmp= X(:,1)+ off(h)*(realwidth/2)- sign(off(h))*(~mod(ncol,2)*realwidth/4);
	bar(Xtmp,Y(:,h),width/(2*ncol),colors(mod(h,1+length(colors))));
	errorbar(Xtmp,Y(:,h),E(:,h),'LineStyle','none','Color',color);
end
hold off
return
