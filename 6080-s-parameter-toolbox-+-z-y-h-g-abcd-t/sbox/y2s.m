function s = y2s(y)
% S = y2s(Y)
%
% Admittance to Scattering transformation
% for square matrices at multiple frequencies
% 
% s = inv(I+y) * (I-y)
% ver 0.0 original	31.03.1998
% ver 0.1 +freq		27.09.2002
% ver 0.2 +octave supp.	01.06.2005 

  if size(size(y),2) > 2   
      nF = size(y,3);  
    else nF = 1;  
    end;
  
I = diag(ones(1, size(y,2)));


  for i=1:nF
    s(:,:,i) = inv(I+y(:,:,i)) * (I-y(:,:,i));  
  end;
