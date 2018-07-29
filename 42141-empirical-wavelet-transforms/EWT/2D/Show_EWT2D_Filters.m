function Show_EWT2D_Filters(fil)

%===========================================================
%
% function Show_EWT2D_Filters(fil)
%
% This function permits to plot the Fourier magnitude of all 
% 2D EWT Littlewood-Paley filters.
%
% Input:
%   - fil: cell containing all the filters
%
% Author: J.Gilles
% Institution: UCLA - Department of Mathematics
% email: jegilles@math.ucla.edu
% Date: March, 1st, 2013
%
%===========================================================
p=ceil(length(fil)/2);

figure;
for n=1:length(fil)
    subplot(2,p,n);imshow(fftshift(abs(fil{n})),[]);
end
