clear;
beta1=[2 0.9];
beta0=[3 2   ];
% fitfunc=@(x,betav)(betav(1)*x.^2+betav(2)*x+betav(3));
fitfunc=@(x,betav) betav(1)*x.^3.*1./(exp(x./betav(2))-1);
% fitfunc=@(x,betav) (sin(betav(1).*x)+0.1*cos(betav(2).*x)+0.15*sin(betav(3).*x));
% fitfunc=@(x,betav) betav(1).*x+betav(2)+betav(3)*x.^2+betav(4).*x.^3;
% fitfunc=@(x,betav) betav(3)*sqrt(2*pi)*abs(betav(2)) *normpdf(x,betav(1),abs(betav(2)));
% fitfunc=@(x,betav) betav(1).*x+betav(2)+betav(3)*x.^2+betav(4).*x.^3+...
% betav(5).*x.^4+betav(6).*x.^5+betav(7).*x.^6+betav(8).*x.^7;

error=0.01 ;
x=[10*eps:0.5:10];
y=fitfunc(x,beta1);
y=y+(randn(size(y)))*error;
yerr=error.*ones(size(y));


errorbarm([x; y; yerr; ])
% pause
textposition=[];
plotbool=true;
axisin=[-10 15 0 12];
axisin=[];
headercell={'Nonlinear Fit'  '$f(x)=\frac{A_0}{\sqrt{2\pi\sigma^2}}\exp{\frac{-(x-\mu)^2}{2\sigma}}$' ''};
mylabel={'xaxis','yaxis [cm]','$\mu$','$\sigma$' '$A_0$'};


[beta betaerr chi prob chiminvec]=wnonlinfit(x,y,yerr,fitfunc,beta0...
    ,'chitol',5,'label',mylabel,'position',textposition,...
    'header',headercell,...
    'printchi','off','axis',axisin,'errprec',2);


 print -dpdf -cmyk test.pdf

 
% figure(2)
% print -dpdf -cmyk testres.pdf 



