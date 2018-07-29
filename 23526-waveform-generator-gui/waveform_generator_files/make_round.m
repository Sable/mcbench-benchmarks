function make_round(hfl,ha)

global r xys

ar=get(ha,'DataAspectRatio');

no=get(hfl,'Userdata');
x=xys(1,no);
y=xys(2,no);


% draw marker as circle:
al=0:pi/12:2*pi;
if ar(1)>ar(2)
    xa=x+ar(1)*r/ar(2)*cos(al);
    ya=y+r*sin(al);
else
    xa=x+r*cos(al);
    ya=y+ar(2)*r/ar(1)*sin(al);
end

set(hfl,'XData',xa);
set(hfl,'YData',ya);
