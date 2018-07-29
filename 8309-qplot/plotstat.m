function plot3d (type)
global A cds opt holdon leg label figmain smmethod subpl


% Check if there IS data to plot
if isempty(A) errordlg ('No data present. Sure you read a file yet?','Error'); return; end

% Add or substitute plot
figure (figmain);
subplot(subpl(1),subpl(2),subpl(3),'Parent',figmain);
if holdon hold on; else 	hold off; end

% Columns
X= A(:,opt.xc(1));
Y= A(:,opt.yc(1));
M= A(:,opt.zc);

switch type
	case 'histo'
		hist(Y,10);
	case 'histo3'
		hist3([X,Y],[10,10]);
	case 'corrxy'
		[rho,pval]= corr(X,Y);
		plot(X,Y,'o');
		L= ['rho= ',num2str(rho),' p< ',num2str(pval)];
		legend(L);
	case 'corrall'
		fprintf('Col Row  Rho  Pval \n')
		output= mcorr(A,'sig');
		fprintf('  %d   %d %4.2f  %4.2f \n',output)
	case 'qqplot'
		qqplot(X,Y);
	case 'normplot'
		normplot(X);

end
