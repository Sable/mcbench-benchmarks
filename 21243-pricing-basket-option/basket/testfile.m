   a= [1.0000   -0.3566    0.1929   
   -0.3566    1.0000   -0.1429    
    0.1929   -0.1429    1.0000];
basketstruct = basketset([100 20 80],[0.2, 0.02, 0.09],a,[1 2 4]);
 Price = asianbasket(basketstruct,'Call',{'01-Oct-2003'; '01-Jan-2004'},'01-Jan-2003',30,800,0.09,460,...
    1,'Arithmetic');

