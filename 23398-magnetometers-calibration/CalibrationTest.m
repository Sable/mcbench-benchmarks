function CalibrationTest(n,noiselevel)
% main routine : calls MgnCalibration
%                        and an auxilliary function 
%                        which performs 3D rotations
%
% n                    : nomber of simulated data (default 1000)
% noiselevel     : level of noise (default 0.05)
%
%   Author Alain Barraud  2008
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;%close previously open figures
if nargin <2,noiselevel=0.05;end
if nargin<1,n=2000;end
b0=[ 0.5;0;sqrt(3)/2];% b0 reference of magnetic field
% the measurements are obtained from random rotations
% of b0. These rotations are defined here by quaternions
U=zeros(n,3);halftheta=zeros(n,1);qref=zeros(n,4);
for k=1:n
    a(k,:)=3*(rand(1,3)-.5);
    u=2*rand(3,1)-1;U(k,:)=u/norm(u);halftheta(k)=pi*(rand-.5);
    qref(k,:)=[cos(halftheta(k)),sin(halftheta(k))*U(k,:)];%random unit quternion
    M=Mqv(qref(k,:));%compute rotation matrix from quaternion
    truedata(:,k)=M*b0;%
end
%truedata are perfect normalized measurements
figure;plot3(truedata(1,:),truedata(2,:),truedata(3,:),'*');axis equal
%computes rough data with ellipsoid parameters Ath (shape) 
% and Offth (center)
Ath=triu(rand(3));Offth=[0.5;-.3;1]+0.1*randn(3,1);
data=Ath\truedata+repmat(Offth,1,n);
%now add noise
noise=(rand(3,n)-0.5)*2*noiselevel;
data=data+noise;
figure;plot3(data(1,:),data(2,:),data(3,:),'*');
% performs calibration
[A,c] = MgnCalibration(data);
Caldata=A*(data-repmat(c,1,n));% calibrated data
figure;plot3(Caldata(1,:),Caldata(2,:),Caldata(3,:),'*');axis equal
set(gca,'xlim',[-1 1],'ylim',[-1 1],'zlim',[-1 1])
disp('     estimated shape                                    theoretical shape')
disp([num2str(A,'%15.3e'),['   ';'   ';'   '],num2str(Ath,'%15.3e')])
disp('estimated      theoretical center')
disp([num2str(c,'%15.3e'),['   ';'   ';'   '],num2str(Offth,'%15.3e')])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function M=Mqv(v)
x=v(1);y=v(2);z=v(3);t=v(4);
M=[(x^2+y^2-z^2-t^2) , (2*y*z+2*x*t)       , (-2*x*z+2*y*t);
      (-2*x*t+2*y*z)       , (z^2-y^2+x^2-t^2), (2*x*y+2*z*t) ;
       (2*x*z+2*y*t)       , (-2*x*y+2*z*t)      , (-y^2+x^2-z^2+t^2)];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%