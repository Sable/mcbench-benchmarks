function err = myTestFunction(p,x,y,plot_handle,text_handle)
%err = myTestFunction(p,x,y,plot_handle,text_handle)
%
%Calculates the sum of squared error between y and the predicted function,
%which is the sum of a sinusoid and a 2nd order polynomial.  
%
%The predicted function is defined by  the 2 parameters for the sinuosoid 
%('amp' and 'freq') and 3 parameters for the 2nd order polynomial 
%(poly(1),poly(2), and poly(3)).
%
%This is the required format for a function to be minimized by 'fit.m':
%
%1) All model parameters must be fields of the first input parameter (p)
%2) The first output parameter must be the error value to be minimized 
%
%Written by G.M Boynton, September 12,2005

predY = p.amp*sin(x*p.freq)+p.poly(1)*x.^2+p.poly(2)*x+p.poly(3);
err = sum( (y-predY).^2);

%fun graphics stuff
set(plot_handle,'YData',predY);
txt = sprintf('%5.2f*sin(%5.2f*x)+%5.2f*x^2+%5.2f*x+%5.2f',...
    p.amp,p.freq,p.poly(1),p.poly(2),p.poly(3));
set(text_handle,'String',txt);
drawnow






