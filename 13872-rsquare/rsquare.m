function R2 = rsquare(y,yhat)
% PURPOSE:  calculate r square using data y and estimates yhat
% -------------------------------------------------------------------
% USAGE: R2 = rsquare(y,yhat)
% where: 
%        y are the original values as vector or 2D matrix and
%        yhat are the estimates calculated from y using a regression, given in
%        the same form (vector or raster) as y
% -------------------------------------------------------------------------
% OUTPUTS:
%        R2 is the r square value calculated using 1-SS_E/SS_T
% -------------------------------------------------------------------
% Note: NaNs in either y or yhat are deleted from both sets.
%
% Felix Hebeler, Geography Dept., University Zurich, Feb 2007

if nargin ~= 2
    error('This function needs some exactly 2 input arguments!');
end

% reshape if 2d matrix
yhat=reshape(yhat,1,size(yhat,1)*size(yhat,2)); 
y=reshape(y,1,size(y,1)*size(y,2));

% delete NaNs
while sum(isnan(y))~=0 || sum(isnan(yhat))~=0
    if sum(isnan(y)) >= sum(isnan(yhat)) 
        yhat(isnan(y))=[];
        y(isnan(y))=[];
    else
        y(isnan(yhat))=[]; 
        yhat(isnan(yhat))=[];
    end
end

% 1 - SSe/SSt
R2 = 1 - ( sum( (y-yhat).^2 ) / sum( (y-mean(y)).^2 ) );

% SSr/SSt
% R2 = sum((yhat-mean(y)).^2) / sum( (y-mean(y)).^2 ) ;

if R2<0 || R2>1
    error(['R^2 of ',num2str(R2),' : yhat does not appear to be the estimate of y from a regression.'])
end