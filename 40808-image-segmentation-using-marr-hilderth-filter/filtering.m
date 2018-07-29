function [Izerosmooth]= filtering(I1)
mask= [0 0 1 0 0;
       0 1 2 1 0;
       1 2 -16 2 1;
       0 1 2 1 0;
       0 0 1 0 0];
   
   Izerosmooth= conv2(I1,mask);
  
    