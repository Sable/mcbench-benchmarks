function Show_EWT_Boundaries(magf,boundaries,R)

%===================================================================
% function Show_EWT_Boundaries(magf,boundaries,R)
% 
% This function plot the boundaries by superposition on the graph 
% of the magnitude of the Fourier spectrum on the frequency interval 
% [0,pi].
%
% Input:
%   - magf: magnitude of the Fourier spectrum
%   - boundaries: list of all boundaries
%   - R: ratio to plot only a portion of the spectrum (we plot the
%        interval [0,pi/R]. R must be >=1 
%
% Author: Jerome Gilles
% Institution: UCLA - Department of Mathematics
% Year: 2013
% Version: 1.0
%===================================================================

figure;
freq=2*pi*[0:length(magf)-1]/length(magf);

if R<1
    R=1;
end
R=round(length(magf)/(2*R));
plot(freq(1:R),magf(1:R));
NbBound=length(boundaries);

for i=1:NbBound
     line([boundaries(i) boundaries(i)],[0 max(magf)],'LineWidth',2,'LineStyle','--','Color',[1 0 0]);
end