function [k,kg,m]=beam(E,I,leng,mass)

%-------------------------------------------------------------------
%  Purpose:
%     Stiffness, Goemetric stiffness and mass matrices for Hermitian beam element
%    
%
%  Synopsis:
%     [k,m]=beam(E,I,leng,mass) 
%
%  Variable Description:
%     k - element stiffness matrix (size of 4x4)   
%     m - element mass matrix (size of 4x4)
%     E - elastic modulus 
%     I - second moment of inertia of cross-section
%     leng - element length
%     mass - mass density (mass per unit volume)

%-------------------------------------------------------------------

% stiffness matrix

 c=E*I/(leng^3);
 k=c*[12      6*leng   -12       6*leng;...
      6*leng  4*leng^2 -6*leng   2*leng^2;...
     -12     -6*leng    12      -6*leng;...
      6*leng  2*leng^2 -6*leng   4*leng^2];
  
  
% geometric stiffness matrix

 c1=1/(30*leng);
 kg=c1*[36    3*leng   -36       3*leng;...
      3*leng  4*leng^2 -3*leng  -leng^2;...
     -36     -3*leng    36      -3*leng;...
      3*leng -leng^2   -3*leng   4*leng^2];
  
   
% consistent mass matrix

    mm1=mass*leng/630;
    m=mm1*[234      33*leng   81       -19.5*leng;...
          33*leng  6*leng^2  19.5*leng  -4.5*leng^2;...
          81       19.5*leng   234      -33*leng;...
         -19.5*leng -4.5*leng^2 -33*leng   6*leng^2];
  



 

