function S=streakbar(X,Y,U,V,unit)

% H=streakbar(X,Y,U,V,unit) creates a colorbar for (but not exclusively)
% the function streakarrow.
% The arrays X and Y defines the coordinates for U and V.
% U and V are the same arrays used for streakarrow.
% The string variable unit is the unit of the vector magnitude
% Example:
%   streakbar(X,Y,U,V,'m/s')

Vmag=sqrt(U.^2+V.^2);
Vmin=min(Vmag(:)); Vmax=max(Vmag(:));

 P=get(gca,'position');
 %axes('position',[P(1)+P(3)+.02  P(2)+0.01  .01  P(4)-0.02]')
 axes('position',[P(1)+P(3)+.02  P(2)  .01  P(4)]')
 [X,Y]=meshgrid( [0 1], linspace(Vmin,Vmax,64));
 Q= [1:64; 1:64]; 
 S=pcolor(X', Y',Q); shading flat; set(gca,'XTickLabel',[],  'Yaxislocation', 'right')
 title(unit)