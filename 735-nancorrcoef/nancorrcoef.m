function r = nancorrcoef(x,y)
%NANCORRCOEF - Compute Pearson's correlation for input vectors that contain NaN values 
%
%Syntax:  r = nancorrcoef(x,y);
%
%Inputs: X -  First input vector
%        Y - Second input vector
%
%Output: R - Correlation coefficient
%           (Note: R is a scalar, not a 2 x 2
%                  matrix as in CORRCOEF)
%
%Example:  x = randn(20,1);  y = randn(20,1);
%          r = nancorrcoef(x,y); 
%
%Other m-files required: none
%Subfunctions:  none
%mat-files required: none
%
%See also: CORRCOEF

%Author: Denis Gilbert, Ph.D., physical oceanography
%Maurice Lamontagne Institute, Dept. of Fisheries and Oceans Canada
%email: gilbertd@dfo-mpo.gc.ca  Web: http://www.qc.dfo-mpo.gc.ca/iml/
%September 2001; Last revision: 13-Sep-2001 by D. Gilbert

%Check number of input vectors
if nargin ~= 2
    error('Two input vectors are required');
end

%Conditions that must be satisfied to continue the calculations
if size(x) ~= size(y) 
    error('Dimensions of input vectors must be the same !!!');
elseif (sum(isnan(x))/length(x)) > 0.20 | (sum(isnan(y))/length(y)) > 0.20
    disp('Input vectors have more than 20% NaN values...')
    disp('Verify if you could eliminate a few NaNs')
    disp('by interpolation or some other method')
    error('Too many NaNs,  processing stopped !!!');
elseif (sum(isnan(x))/length(x)) > 0.05 | (sum(isnan(y))/length(y)) > 0.05
    warning('Vectors have more than 5% NaN values, results may be inaccurate !!!')
end

%Only keep the common valid values in both input vectors
tf = ~isnan(x) & ~isnan(y);  %Logical flag
x = x(tf);   y = y(tf);

meanx = mean(x);	%Compute mean value of X
meany = mean(y);	%Compute mean value of Y

%Compute the arguments that go into the mathematical formula of R
sx2   = sum((x-meanx).^2);  
sy2   = sum((y-meany).^2);  
sxy   = sum((x-meanx).*(y-meany));

% Mathematical definition of Pearson's product moment correlation coefficient
r = sxy./sqrt(sx2*sy2);  
