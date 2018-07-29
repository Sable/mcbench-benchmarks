% Generalized Mittag-Leffler function
% Reference:
% A. A. KILBAS, M. SAIGOb, and R. K. SAXENA, Generalized Mittag-Leffler function and 
% generalized fractional calculus operators, Integral Transforms and Special Functions, 
% vol. 15, No. 1, 2004, pp. 3149.
% Prepared by YangQuan Chen. 07/23/2008
% Based on the ml_fun code in Dingyu Xue, YangQuan Chen* and Derek Atherton.
% Linear Feedback Control  Analysis and Design with Matlab. SIAM Press, 2007, 
% ISBN: 978-0-898716-38-2. (348 pages)
% a: \rho
% b: \mu
% c: \gamma
% x: the variable
% eps0: specified accuracy

 function f=gml_fun(a,b,c,x,eps0)
 gamma_c=1.0/gamma(c);
 if nargin<5, eps0=eps; end
 f=0; fa=1; j=0;
 while norm(fa,1)>=eps0
    fa=(gamma(c+j)*gamma_c)/gamma(j+1)/gamma(a*j+b) *x.^j;
    f=f+fa; j=j+1; 
 end

% ===
% % GML test code
% % exp(x)
% deltat=0.01;
% x=[-1:deltat:1]; 
% y1=gml_fun(1,1,1,x);
% figure;plot(x,y1,'r',x,exp(x),'k')
% figure;plot(x,y1-exp(x),'k')
% % ok, now try MLF when c=1
% y2=gml_fun(0.5,0.5,1,x);
% y3=MLF_M(0.5,0.5,x); % Igor Podlubny's code
% figure;plot(x,y1,'b',x,y2,'r',x,y3,'k')
% %figure;plot(x, y2-y3','k')
% legend('e^x=E_{1,1}^{(1)}', 'E_{0.5,0.5}^{(1)} - this code', 'E_{0.5,0.5}^{(1)} - Podlubny code')
% % okay, let us now try GML
% y5=gml_fun(0.5,0.5,0.5,x);
% y6=gml_fun(0.5,0.5,1.5,x);
% figure;plot(x,y2,'r',x,y5,'k',x,y6,'b')
% legend('GML \gamma=1','GML \gamma=.5','GML \gamma=1.5')
% title('E_{0.5,0.5}^\gamma(x)')
% 
% 
% 
% 
% 
