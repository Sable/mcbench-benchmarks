function varargout...
    =copula111gGarch111VaR(r,parameters,sigmaone,sigmatwo,RHOHAT,s,cl)
%% Gaussian Copula - AR(1)-GARCH(1,1)-n
%%
% The copula111guGarch111VaR function calculates value at risk of portfolio
% composed of two stocks return, The model for marginal is  
% AR(1)-GARCH(1,1)-n which n means residuals have standard normal
% distribution.The copula function is Gaussian.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Inputs
% This function has seven input arguments, The first argument is the series
% of returns of two stocks, therefore is the n by 2 matrix; the second 
% argument is the estimated parameters of marginal models that estimated
% with fitparp(fitparpf)  function; The third argument is the standard 
% deviation of first return series; The fourth argument is the standard
% deviation of second return series; The fifth argument is the estimated
% parameter of Gaussian copula which extracted by 'fitparcopulag' function, 
% The sixth argument is the size of sample in data, The seventh argument is
% the confidence levels which is the 1 by 2 matrix with two values. 
%%  Outputs
%   [out VaR pmin violation]=...
%       copula111gGarch111VaR(r,parameters,sigmaone,sigmatwo,RHOHAT,s,cl)
% This function produced 4 outputs arguments. The first output is the
% 'out' contain all of values that is calculated by double integrate in the
% body of function, this arguments used for control purpose; The second
% output argument is the estimated value at risk; The third output argument
% is the probability related to estimated value at risk and used for
% controlling purpose; the fourth is the numbers of violations.
%
%
%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  %   Written By Ali Najjar, Monday, June 06, 2011, 9:34:21 AM         %
%%  %   Revised By Ali Najjar, Friday, October 05, 2012, 10:50:50 AM     %
%%  %   Email: Najjar.Ali@Gmail.com                                      %
%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic;
%% 
n1=s;
n=size(r,1);
[row_cl,col_cl]=size(cl);
xmax=cell(1,n1);
ni=n-s;
out=cell(ni,1);
pmin=cell(ni,1);
mu1=ones(ni,1);
mu2=ones(ni,1);
sigma1=ones(ni,1);
sigma2=ones(ni,1);
VaR=ones(ni,2);
rp=(0.5.*r(:,1))+(0.5.*r(:,2));
%% for loop 1
for i=1:ni
%%  marginal distribution
    mu1(i)=parameters{i}(1,1)+parameters{i}(2,1)*r(s+i-1,1);
    mu2(i)=parameters{i}(1,2)+parameters{i}(2,2)*r(s+i-1,2);
    sigma1(i)=sigmaone{i};
    sigma2(i)=sigmatwo{i};
    rho=RHOHAT{i}(1,2);
%%  the Gaussian copula density function
    normalcpdf=@(x,y,rho)(1-rho.^2).^(-0.5).*exp(-0.5*(1-rho.^2).^(-1).*...
        (x.^2+y.^2-2*rho.*x.*y)).*exp(0.5*(x.^2+y.^2));
    normalcpdfp=@(x,y,rho)normalcpdf(norminv(x,0,1),norminv(y,0,1),rho);
%%  Integrand function
    f=@(x,y)normalcpdfp(normcdf(x,mu1(i),sigma1(i)),...
        normcdf(y,mu2(i),sigma2(i)),rho)...
            .* normpdf(x,mu1(i),sigma1(i)).* normpdf(y,mu2(i),sigma2(i));
%%  for loop 2
    I=linspace(rp(s+i)-(sigma1(i)*4.00),rp(s+i)+(sigma1(i)*4.0),n1);
    for j=1:n1
       display([i,j]);
        xmax{j}=@(y)(2. * I(j))-y;
        out{i}(j)=quad2d(f,(-sigma2(i)*4),(sigma2(i)*4),(-sigma1(i)*4),xmax{j});
        if out{i}(j)<((1-cl(2))-.005) || out{i}(j)>((1-cl(1))+.005)
            out{i}(j)=2;
        end
    end
%%
    [min1 ii1]=min(abs(out{i}-(1-cl(1))));
    [min2 ii2]=min(abs(out{i}-(1-cl(2))));
    VaR(i,1)=I(ii1); VaR(i,2)= I(ii2);
    pmin{i}=[min1+(1-cl(1)) min2+(1-cl(2))];
end
%% Violations
    violation=zeros(row_cl,col_cl);
    for j=1:col_cl
        for i=1:ni        
            if VaR(i,j) >rp(s+i);
                violation(j)=violation(j)+1;
            end
        end
    end
%% Plotting
    figure(1);
    plot(1:(n-s),rp(s+1:n),'g.');
    hold on;
    plot(1:ni,VaR(1:ni,1),'r:');
    legend('Portfolio Return','Gaussian Copula with AR(1)-GARCH(1,1)-n VaR');
    xlabel('Trading days','horizontal','center','Fontweight','bold');
    ylabel('Portfolio Return','rotation',90,'horizontal',...
        'center','Fontweight','bold');
    title(['Gaussian Copula with AR(1)-GARCH(1,1)-n VaR at ',...
        num2str(cl(1)*100),'%'],'FontSize',12,'Fontweight','bold');
    hold off;
    figure(2);
    plot(1:(n-s),rp(s+1:n),'b.');
    hold on;
    plot(1:ni,VaR(1:ni,2),'m:');
    legend('Portfolio Return','Gaussian Copula with AR(1)-GARCH(1,1)-n VaR');
    xlabel('Trading days','horizontal','center','Fontweight','bold');
    ylabel('Portfolio Return','rotation',90,'horizontal',...
        'center','Fontweight','bold');
    title(['Gaussian Copula with AR(1)-GARCH(1,1)-n VaR at ',...
        num2str(cl(2)*100),'%'],'FontSize',12,'Fontweight','bold');
    hold off;
%% Output
    varargout{1}=out;
    varargout{2}=VaR;
    varargout{3}=pmin;
    varargout{4}=violation;
%%
    elapsed_time=toc;
    display([elapsed_time]);
end
