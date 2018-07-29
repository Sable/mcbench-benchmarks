function hfl=create_marker(ha,x,y,r,c,uf,no)
% create movable with mouse marker
% ha - axes handler
% (x,y) - marker position
% r - marker radius
% c - marker color
% uf - update function


% rdraw marker as circle:
al=0:pi/12:2*pi;
xa=x+r*cos(al);
ya=y+r*sin(al);
hfl=fill(xa,ya,c,'parent',ha);

% what to do if ckicked:
set(hfl,'ButtonDownFcn',['bdf(' num2str(ha,'%20.20f') ',' num2str(hfl,'%20.20f') ',''' uf '''' ')']);

set(hfl,'Userdata',no); % memorize number

