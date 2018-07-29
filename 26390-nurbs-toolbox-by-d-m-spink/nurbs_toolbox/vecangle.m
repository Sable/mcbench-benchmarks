function ang = vecangle(num,den) 
%  
% Function Name: 
%  
%   vecangle - An alternative to atan, returning an arctangent in the  
%              range 0 to 2*pi. 
%  
% Calling Sequence: 
%  
%   ang = vecmag2(num,dum) 
%  
% Parameters: 
%  
%   num		: Numerator, vector of size (1,nv). 
%   dem		: Denominator, vector of size (1,nv). 
%   ang		: Arctangents, row vector of angles. 
%  
% Description: 
%  
%   The components of the vector ang are the arctangent of the corresponding 
%   enties of num./dem. This function is an alternative for  
%   atan, returning an angle in the range 0 to 2*pi. 
%  
% Examples: 
%  
%   Find the atan(1.2,2.0) and atan(1.5,3.4) using vecangle 
%  
%   ang = vecangle([1.2 1.5], [2.0 3.4]); 
 
%  D.M. Spink 
%  Copyright (c) 2000. 
 
ang = atan2(num,den); 
index = find(ang < 0.0); 
ang(index) = 2*pi+ang(index); 
