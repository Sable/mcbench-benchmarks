%
% RITADELTA
%
% Ritar ut ett vackert delta förskjutet enligt x,y,z.
% Skalas om enligt size.

function ritadelta(x,y,z,size)
xv=[10.3 5.7 4.0 9.6;
    9.6 12.5 12.4 10.3;
    10.3 9.5 8.5 8;
    8 8 8.6 9.8;
    9.8 12.8 15.7 10.0;
    10.0 5.3 6.9 10.0;
    10 13.1 15 11.3;
    11.3 10.9 11.1 11.7;
    11.7 16.5 14.1 10.3];
xv=16-xv-6.5; xv=xv*size; xv=xv+x;
zv=[0 0.3 8.6 10.5;
    10.5 11.5 14.3 13.6;
    13.6 13.5 12.4 14.7;
    14.7 14.7 13.9 14.4;
    14.4 15.4 11.5 9.1;
    9.1 7.1 1.5 0.65;
    0.65 0 6.2 10.2;
    10.2 10.6 10.7 10.3;
    10.3 7.0 -0.3 0]-7.5;
zv=zv*size; zv=zv+z;

for i=1:9
   plotbz([xv(i,1) zv(i,1)],[xv(i,2) zv(i,2)],[xv(i,3) zv(i,3)],[xv(i,4) zv(i,4)],y,0.01,'m');
end	

