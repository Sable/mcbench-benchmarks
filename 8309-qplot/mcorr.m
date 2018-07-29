function varargout= mcorr(varargin)
%MCORR Multi-plot of all correlations between columns of a matrix
% MCORR (X) plots correlations between all possible combinations of the
% columns of array X, in a single figure. If the first argument is the 
% name of a file present in the current directory, mcorr reads 
% it (including variable names in the first row) as X. Otherwise, MCORR assumes 
% its first argument is the array to plot, in which case consecutive 
% numbers will be used as variable names. If there is a second (numeric) 
% argument, mcorr will plot only the columns indicated in the second argument.
% mcorr does not plot self-correlations (each variable with itself). It 
% is unpractical to try to plot more than, say, 8 variables, since each
% individual plot becomes too small.
%
% OUTPUT= MCORR (X,'sig') calculates the Pearson correlation coefficient between
% each pair of columns and, if the correlation is sgnificant at the 95%
% level, points are plotted in red and the column numbers, Pearson coefficient
% and p-value are returned in the OUTPUT array. Requires Statistical Toolbox
%
% EXAMPLES:
% mcorr ('myfile')
% mcorr ('myfile',[1:5])
% mcorr (X,[3:6])
% output= mcorr (X,'sig')
%
% Last modified: Feb. 2008


if nargin == 0 error ('mcorr needs at least 1 argument: name of file or array'); end
pearson= 0;
color= 'b';
output= [];

%Its a file => Read. Else is matrix
if ischar(varargin{1}) & ~isempty(dir(varargin{1})) 
	[A,varnames] = tblread(varargin{1});
else
	A= varargin{1};
 	varnames= num2cell([1:size(A,2)]);
end

%Select columns
if nargin > 1 & isnumeric(varargin{2})
	A= A(:,varargin{2});
	varnames= varnames(varargin{2});
end
ncol= size(A,2);

%Pearson corr. coef.
for j= 1:length(varargin)
	if ischar(varargin{j}) & ~isempty(findstr(lower(varargin{j}),'sig'))
		pearson= 1;
	end
end

%Function
for j= 2:ncol
for k= 1:j-1
	subplot(ncol-1,ncol-1,(j-2)*(ncol-1)+k);
	if pearson [rho,pval]= corr(A(:,k),A(:,j));
		if pval < 0.05 
			color= 'r';
			output= [output;k,j,rho,pval];
		else
			color= 'b'; 
		end
	end
	plot(A(:,k),A(:,j),'.','MarkerSize',5,'MarkerEdgeColor',color);
	set (gca,'FontSize',6);
	if k == 1 ylabel(varnames(j),'FontSize',7); end
	if j == ncol xlabel(varnames(k),'FontSize',7); end
end
end

varargout{1}= output;
