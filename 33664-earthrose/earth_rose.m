function earth_rose(E, nbins)
%EARTH_ROSE   direction rose from earth coordinate angles.
% 
%   Syntax:
%      EARTH_ROSE(E, nbins)
%
%   Inputs:
%      E:  Angular current direction in degrees, earth coordinates.
%      OPTIONAL:
%        nbins: number of bins to plot histogram
%
%    Example:
%      theta = [110 110 110 90 288 290 292];
%      nbins = 20;
%      ocean_rose(theta, nbins);
%

% Cameron Sparr
% cameronsparr@gmail.com
%
% This was inspired by wind_rose.m
%
% The code to change the axis labels from a mathematical system to
% N,S,E,W were written by Jordan Rosenthal in a forum post:
%      http://www.mathworks.com/matlabcentral/newsreader/author/4601
%

D = mod(90 - E, 360);
D = D*pi/180;

if nargin > 1
    rose(D, nbins);
else
    rose(D);
end

hHiddenText = findall(gca,'type','text');
Angles = 0 : 30 : 330;
hObjToDelete = zeros( length(Angles)-4, 1 );
k = 0;
for ang = Angles
   hObj = findall(hHiddenText,'string',num2str(ang));
   switch ang
   case 0
      set(hObj,'string','East','HorizontalAlignment','Left');
   case 90
      set(hObj,'string','North','VerticalAlignment','Bottom');
   case 180
      set(hObj,'string','West','HorizontalAlignment','Right');
   case 270
      set(hObj,'string','South','VerticalAlignment','Top');
   otherwise
      k = k + 1;
      hObjToDelete(k) = hObj;
   end
end
delete( hObjToDelete(hObjToDelete~=0) );


end