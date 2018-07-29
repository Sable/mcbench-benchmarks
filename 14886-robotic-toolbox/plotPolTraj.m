%% Author: epokh
%% Website: www.epokh.org/drupy
%% This software is under GPL

%%input: time vector and C the matrix of pol coefficients

function plotPolTraj(tpoints,C)
[r,c]=size(C);
for k=1:r
t=linspace(tpoints(k),tpoints(k+1));
pos=C(k,1)+C(k,2).*t+C(k,3).*t.^2+C(k,4).*t.^3;
vel=C(k,2)+2*C(k,3).*t+3*C(k,4).*t.^2;
acc=2*C(k,3)+6*C(k,4).*t;
plot(t,pos,'b');
plot(t,vel,'g');
plot(t,acc,'k');
end

end