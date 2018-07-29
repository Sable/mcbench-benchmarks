% scriptfile to calculate and save some trajectories

%
% Copyright 2004, Paul Lambrechts, The MathWorks, Inc.
%

pbar=0.1;
vbar=0.3;
abar=4;
Ts=0.001;
Tsettle=1;

close all
%[t,ad,aa,tx,a,v,p,tt] = make2(pbar,vbar,abar,Ts,1);

[t,dd] = make4(pbar,vbar,abar,100,5000,Ts);
[dj,tx,d,j,a,v,p,tt]=profile4(t,dd(1),Ts);

q=round(Tsettle/Ts);

a2=[a' zeros(1,q) -a' zeros(1,q)]';

t2=[0:Ts:max(size(a2))*Ts-Ts]' ;

v2=[v' zeros(1,q) -v' zeros(1,q)]';
p2=[p' 0.1*ones(1,q) -p'+pbar zeros(1,q)]';

figure
plot(t2,[a2  v2  p2])
grid

save acc.txt a2 -ascii -double
save vel.txt v2 -ascii -double
save pos.txt p2 -ascii -double 

% alternative (more control on formatting)
var=['a2';'v2';'p2'];
for i=1:3
   h=fopen([var(i,:),'.txt'],'w');
   eval(['fprintf(h,''%20.16f \n'',',var(i,:),');'])
   fclose(h);
end