% Function graph
 
% Graphs a 3 dimensional logarithmic function named F(Theta,Phi), 
% theta the elevation angle and phi the rotational angle. Converts to 
% Cartesian coordinates and plots a surface plot with color pattern 
% radiating from the origin.


function graph
Phi= 0:pi/50:2*pi; %0 to 2pi angle from x axis
Theta= -pi:pi/50:pi; %0 to pi elevation angle from y axis
[PHI,THETA]=meshgrid(Phi,Theta); % create a matrix of X and Y angles
R = 10*log10(F(THETA,PHI).^2); % evaluate angles for all theta and phi, note reversed input order.
l=size(R);
clear r;        %Clears the variables incase this is run more then once
clear the;      %in the same session
clear ph;
r = zeros(size(R));
the = zeros(size(R));
ph = zeros(size(R));
for i=1:l(1)
  for j=1:l(2)
      if R(i,j) > 1
         r(i,j) = R(i,j);
         the(i,j) = THETA(i,j);
         ph(i,j) = PHI(i,j);
      end       % Any value skipped in the matrices is automatically 
  end           % initialized to 0 as the matrix is allocated dynamically.
end             
[X,Y,Z]=sph2cart(ph,the,r); %convert to cartesian
surf(X,Y,Z,r) %plot with Color scale set to r values

%Plot tidying up
title({'Rectangular Planar Array' 'Antenna Pattern'});
%set all axis to same scale to prevent skewing the image
axis([min(min(Z)) max(max(Z)) min(min(Z)) max(max(Z)) min(min(Z)) max(max(Z))])
axis off
box off
%Relabling the colorbar scale giving a title and forcing the # of indices and spacing
h = colorbar('YTickLabel',...
{-round(max(max(r))*5/6),-round(max(max(r))*4/6),-round(max(max(r))*3/6),...
-round(max(max(r))*2/6),-round(max(max(r))*1/6)});
Title(h, 'Color Scale(dB) - 0');
deltar = max(max(r))-min(min(r));
set(h, 'YTick', [round(max(max(r))-deltar*5/6) round(max(max(r))-deltar*4/6)...
    round(max(max(r))-deltar*3/6) round(max(max(r))-deltar*2/6)...
    round(max(max(r))-deltar*1/6)]);