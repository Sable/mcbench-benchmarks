function Show_EWT2D_Curvelet(ewtc)

%==========================================================================
% function Show_EWT2D_Curvelet(ewtc)
% 
% This function displays the curvelet coefficient obtained by the Empirical 
% Curvelet Transform (one figure per scale)
%
% Inputs:
%   -ewtc: output of the empirical curvelet transform
%
% Author: Jerome Gilles
% Institution: UCLA - Department of Mathematics
% Year: 2013
% Version: 1.0
%==========================================================================

Ns=length(ewtc);

% Show the low pass filter
figure;
imshow(ewtc{1},[]);

for s=2:Ns
   Nt=length(ewtc{s});
   figure;
   for t=1:Nt
      subplot(1,Nt,t);
      imshow(ewtc{s}{t},[]);
   end
end