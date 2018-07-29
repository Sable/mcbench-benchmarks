function [a,b,alpha,p,chiopt,Cab,Calphap]=...
    wtls_line(xin,yin,uxin,uyin,guck);
% function [a,b,alpha,p,chiopt,Cab,Calphap]=...
%   wtls_line(xin,yin,uxin,uyin,guck);
%
% weighted total least squares (wtls) fit of a straigth line 
% to a set of points with uncertainties in both coordinates
%
% input:        xin     abscissa vector
%               yin     ordinate vector
%               uxin    (standard) uncertainties of xin, same size as xin
%               uyin    (standard) uncertainties of yin, same size as yin
%               guck    flag, if >0, chisquare is plotted over whole
%                       alpha-interval, optimum alpha is shown as red +
%
% output:       a, b    usual straight line parameters
%                       y=a*x+b
%               alpha,p more stable parametrisation
%                       y*cos(alpha)-x*sin(alpha)-p=0
%                       alpha: slope angle in radians
%                       p: distance of straight line from (0,0)
%                       conversion: a=tan(alpha),b=p/cos(alpha)
%               chiopt  minimum chisquare found
%               Cab     covariances, [var(a),var(b),cov(a,b)]
%               Calphap covariances, [var(alpha),var(p),cov(alpha,p)]
%
% algorithm:    M. Krystek & M. Anton
%               Physikalisch-Technische Bundesanstalt Braunschweig, Germany
%               Meas. Sci. Tech. 18 (2007), pp3438-3442
%
% tested for Matlab 6 and Matlab 7
% testdata: script file pearson_york_testdata.m
%
% 2007-03-08

tol=1e-6; %"tolerance" parameter of fnimbnd, see there

global ux uy x y
% inputs
if nargin<5,guck=0;end
% force column vectors
x=xin(:);
y=yin(:);
ux=uxin(:);
uy=uyin(:);
% "initial guess": 
p0=polyfit(x,y,1);
alpha0=atan(p0(1));
% one-dimensional search, use p=p^
[alphaopt,chiopt,exitflag] = ...
    fminbnd(@chialpha,alpha0-pi/2,alpha0+pi/2,optimset('TolX',tol));
% get optimum p from alphaopt
alpha=alphaopt;
uk2=ux.^2*sin(alpha)^2+uy.^2*cos(alpha)^2;
u2=1./mean(1./uk2);
w=u2./uk2;
xbar=mean(w.*x);
ybar=mean(w.*y);
p=ybar*cos(alpha)-xbar*sin(alpha);
% convert to a, b parameters y=a*x+b
a=sin(alpha)/cos(alpha);
b=p/cos(alpha);
% --- uncertainty calculation, covariance matrix = 2*inv(Hessian(chi2)) ---
n=length(x);
vk=y.*cos(alpha)-x*sin(alpha)-p;
vka=-y*sin(alpha)-x*cos(alpha);
vkaa=-vk-p;
fk=vk.*vk;
fka=2*vk.*vka;
fkaa=2*(vka.^2+vk.*vkaa);
gk=uk2;
gka=2*sin(alpha)*cos(alpha)*(ux.^2-uy.^2);
gkaa=2*(ux.^2-uy.^2)*(cos(alpha)^2-sin(alpha)^2);
Hpp=2*n/u2;
Halphap=-2*sum((vka.*gk-gka.*vk)./gk.^2);
Halphaalpha=...
    sum(fkaa./gk-2*fka.*gka./gk.^2+2*gka.^2.*fk./gk.^3-gkaa.*fk./gk.^2);
NN=2/(Hpp*Halphaalpha-Halphap^2);
var_p=NN*Halphaalpha;
var_alpha=NN*Hpp;
cov_alphap=-NN*Halphap;
Calphap=[var_alpha,var_p,cov_alphap];
% ------ convert to a & b covariance matrix, following DIN 1319 (4)
var_a=var_alpha/cos(alpha)^4;
var_b=(var_alpha*p*p*sin(alpha)^2+var_p*cos(alpha)^2+...
    2*cov_alphap*p*sin(alpha)*cos(alpha))/cos(alpha)^4;
cov_ab=(var_alpha*p*sin(alpha)+cov_alphap*cos(alpha))/cos(alpha)^4;
Cab=[var_a,var_b,cov_ab];
% ------ end of uncertainty calculation -----------------------------------
%
%-------------------- plotting section ------------------------------------
if guck~=0
    alphatest=linspace(alpha-pi/2,alpha+pi/2,1000);
    for k=1:length(alphatest),chitest(k)=chialpha(alphatest(k));end
    plot(alphatest,chitest,alphaopt,chiopt,'+r')
    xlabel('alpha')
    ylabel('\chi^2')
    grid on
    disp([mfilename,' :: paused, hit any key to continue'])
    pause
end
% ------------------ end of plotting section ------------------------------
return
% ------------------ subfunction ------------------------------------------
function chi=chialpha(alpha)
    global ux uy x y
    uk2=ux.^2*sin(alpha)^2+uy.^2*cos(alpha)^2;
    u2=1./mean(1./uk2);
    w=u2./uk2;
    xbar=mean(w.*x);
    ybar=mean(w.*y);
    p=ybar*cos(alpha)-xbar*sin(alpha);
    chi=sum((y*cos(alpha)-x*sin(alpha)-p).^2./uk2);
return
% ----------- end of subfunction ------------------------------------------
