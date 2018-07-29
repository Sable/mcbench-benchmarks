function [p,stats]=quantreg(x,y,tau,order,Nboot);
% Quantile Regression
% 
% USAGE: [p,stats]=quantreg(x,y,tau[,order,nboot]);
% 
% INPUTS: 
%   x,y: data that is fitted. (x and y should be columns)
%        Note: that if x is a matrix with several columns then multiple
%        linear regression is used and the "order" argument is not used.
%   tau: quantile used in regression. 
%   order: polynomial order. (default=1)
%          (negative orders are interpreted as zero intercept)
%   nboot: number of bootstrap surrogates used in statistical inference.(default=200)
%
% stats is a structure with the following fields:
%      .pse:    standard error on p. (not independent)
%      .pboot:  the bootstrapped polynomial coefficients.
%      .yfitci: 95% confidence interval on "polyval(p,x)" or "x*p"
%
% [If no output arguments are specified then the code will attempt to make a default test figure
% for convenience, which may not be appropriate for your data (especially if x is not sorted).]
%
% Note: uses bootstrap on residuals for statistical inference. (see help bootstrp)
% check also: http://www.econ.uiuc.edu/~roger/research/intro/rq.pdf
%
% EXAMPLE:
% x=(1:1000)';
% y=randn(size(x)).*(1+x/300)+(x/300).^2;
% [p,stats]=quantreg(x,y,.9,2);
% plot(x,y,x,polyval(p,x),x,stats.yfitci,'k:')
% legend('data','2nd order 90th percentile fit','95% confidence interval','location','best')
% 
% For references on the method check e.g. and refs therein:
% http://www.econ.uiuc.edu/~roger/research/rq/QRJEP.pdf
%
%  Copyright (C) 2008, Aslak Grinsted

%   This software may be used, copied, or redistributed as long as it is not
%   sold and this copyright notice is reproduced on each copy made.  This
%   routine is provided as is without any express or implied warranties
%   whatsoever.


if nargin<3
    error('Not enough input arguments.');
end
if nargin<4, order=[]; end
if nargin<5, Nboot=200; end

if (tau<=0)|(tau>=1),
    error('the percentile (tau) must be between 0 and 1.')
end

if size(x,1)~=size(y,1)
    error('length of x and y must be the same.');
end

if numel(y)~=size(y,1)
    error('y must be a column vector.')
end

if size(x,2)==1
    if isempty(order)
        order=1;
    end
    %Construct Vandermonde matrix.
    if order>0
        x(:,order+1)=1;
    else
        order=abs(order);
    end
    x(:,order)=x(:,1); %flipped LR instead of 
    for ii=order-1:-1:1
        x(:,ii)=x(:,order).*x(:,ii+1);
    end
elseif isempty(order)
    order=1; %used for default plotting
else
    error('Can not use multi-column x and specify an order argument.');
end


pmean=x\y; %Start with an OLS regression

rho=@(r)sum(abs(r-(r<0).*r/tau));

p=fminsearch(@(p)rho(y-x*p),pmean);

if nargout==0
    [xx,six]=sortrows(x(:,order));
    plot(xx,y(six),'.',x(six,order),x(six,:)*p,'r.-')
    legend('data',sprintf('quantreg-fit ptile=%.0f%%',tau*100),'location','best')
    clear p
    return
end 

if nargout>1
    %calculate confidence intervals using bootstrap on residuals
    
    yfit=x*p;
    resid=y-yfit;
    
    stats.pboot=bootstrp(Nboot,@(bootr)fminsearch(@(p)rho(yfit+bootr-x*p),p)', resid);
    stats.pse=std(stats.pboot);
    
    qq=zeros(size(x,1),Nboot);
    for ii=1:Nboot
        qq(:,ii)=x*stats.pboot(ii,:)';
    end
    stats.yfitci=prctile(qq',[2.5 97.5])';
    
end


% 
% 
% 
% function ps=invtranspoly(p,kx)
%
% ps=p;
% order=length(p);
% fact=cumprod(1:order);
% kx=cumprod(repmat(kx,1,order));
% for ii=2:order
%     for jj=1:ii-1
%         N=order-jj+1;
%         k=ii-jj;
%         k=min(k,N-k);
%         ps(ii)=ps(ii)+p(jj)*kk(k)*fact(N)/(fact(k)*fact(N-k));
%     end
% end




