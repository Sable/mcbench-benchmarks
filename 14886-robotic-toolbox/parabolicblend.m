

function [pos,vel,acc]=parabolicblend(t,tb,omega,thetai,thetaf)

toffset=t(1);
t=t-toffset;

tbefore=find(t<tb);
tparbegin=t(1:tbefore(end));

%%the parabolic starting blend
pos=thetai+(omega/(2*tb)).*tparbegin.^2;
vel=omega/tb.*tparbegin;
acc=omega/tb;
tparend=t(length(t)-tbefore(end)+1:end);
tlinear=t(tbefore(end)+1:end-length(tparend));
%%the linear zone
pos=[pos, pos(end)+omega/tb.*tlinear ];

%%the parabolic ending blend
k=omega/(2*tb);

pos=[pos, thetaf-k.*(t(end)-tparend).^2];
end