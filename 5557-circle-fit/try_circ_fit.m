%try_circ_fit
%
% IB 
%
% revival of a 13 years old code


  % Create data for a circle + noise
  
  th = linspace(0,2*pi,20)';
  R=1.1111111;
  sigma = R/10;
  x = R*cos(th)+randn(size(th))*sigma;
  y = R*sin(th)+randn(size(th))*sigma;
  
   plot(x,y,'o'), title(' measured points')
   pause(1)
   
   % reconstruct circle from data
   [xc,yc,Re,a] = circfit(x,y);
      xe = Re*cos(th)+xc; ye = Re*sin(th)+yc;
    
     plot(x,y,'o',[xe;xe(1)],[ye;ye(1)],'-.',R*cos(th),R*sin(th)),
     title(' measured fitted and true circles')
      legend('measured','fitted','true')
      text(xc-R*0.9,yc,sprintf('center (%g , %g );  R=%g',xc,yc,Re))
     xlabel x, ylabel y 
     axis equal
     

   
  


