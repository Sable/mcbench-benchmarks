function plot2d (type)
global A opt cds holdon leg label figmain subpl

if isempty(A) errordlg ('No data present. Sure you read a file yet?','Error'); return; end
if size(A,2) < 2 errordlg ('Seems to be only 1 column of data. Need at least 2','Error'); return; end
figure (figmain);
subplot(subpl(1),subpl(2),subpl(3),'Parent',figmain);
if (holdon)	hold on; else 	hold off; end

X= A(:,opt.xc);
Y= A(:,opt.yc);

switch type
	case 'xyscatter' 
		plot(X,Y,'o');
	case 'xyline'
		plot(X,Y,'-o');
	case 'hist'
		hist(A(:,opt.yc(1)),10);
	case 'stem'
		stem(X,Y);
	case 'stairs'
		stairs(X,Y);
	case 'vbarg'
		bar(X,Y,'group');
	case 'vbars'
		bar(X,Y,'stack');
	case 'barerror'
		if size(Y,2) ~= size(A(:,opt.ec),2) 
			msg= errordlg ('Y Data and Error Data have different number of columns','Error'); 
			waitfor (msg);
			return; 
		end
		barerror(X,Y,A(:,opt.ec),0.8,'k');
	case 'hbars'
		barh(X,Y,'stack');
	case 'hbarg'
		barh(X,Y,'group');
	case 'rose'	
		rose(X);
	case 'pie'
		pie(X);
	case 'polar'
		polar(X,A(:,opt.yc(1)));
	case 'compass'
		compass(X,A(:,opt.yc(1)));
	case 'error'
		if size(Y,2) ~= size(A(:,opt.ec),2) 
			msg= errordlg ('Y Data and Error Data have different number of columns','Error'); 
			waitfor (msg);
			return; 
		end
		multX= [];
		for j= 0:opt.yc(2)-opt.yc(1) multX= [multX,X]; end
		errorbar(multX,Y,A(:,opt.ec));
end

title(label.t); xlabel(label.x); ylabel(label.y);
% legend(leg(opt.yc));
return
