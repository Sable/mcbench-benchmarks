function PicardChebyshevDemo()
% Purpose: 
% Demo function used to demonstrate how to use the Picard-Chebyshev method
% This will propagate an orbit a total of one period and compare the
% solution to the analytical solution using kepler universal variable
% propagation.
%
%
% Programmed by Darin Koblick 05-30-2012
%--------------------------------------------------------------------------
%% Begin Code
mu = 398600.4415;
%Initialize State Vector
r0 = [7000,0,0];
v0 = [0,sqrt(mu./sqrt(sum(r0.^2))),0];
a = sqrt(sum(r0.^2));
vMag = sqrt(sum(v0.^2));
P = 2*pi*sqrt((a^3)/mu);    %period in seconds
tSpan = [0 P*2];
%Set up the inputs needed to run the Picard-Chebyshev Method
N = 50;
NoisePrct = 0.25;
tau = fliplr(cos((0:N).*pi./N));
omega1 = (tSpan(end)+tSpan(1))/2;
omega2 = (tSpan(end)-tSpan(1))/2;
t = omega2.*tau + omega1;
errTol = 1e-6;
%Run the analytic orbit propagator routine
[rA,vA] = keplerUniversal(repmat(r0',[1 length(t)]),repmat(v0',[1 length(t)]),t,mu);
%Noise up the position and velocity estimates
r_guess = rA + rand(size(rA)).*(a.*NoisePrct*2) - (a.*NoisePrct);
v_guess = vA + rand(size(vA)).*(vMag.*NoisePrct*2) - (vMag.*NoisePrct);
x_guess = [r_guess',v_guess'];
x_guess(1,:) = [rA(:,1)',vA(:,1)'];
%Run the Picard-Chebyshev Method
rvPCM  = VMPCM(@TwoBodyForceModel,tau',x_guess,omega1,omega2,errTol,mu);

%Compare Error to analytical solution
PCMPosMag = sqrt(sum(rvPCM(:,1:3).^2,2));
  APosMag = sqrt(sum(rA'.^2,2));
PCMVelMag = sqrt(sum(rvPCM(:,4:end).^2,2));
  AVelMag = sqrt(sum(vA'.^2,2));
PosErr = abs(PCMPosMag-APosMag);
VelErr = abs(PCMVelMag-AVelMag);
PlotPostionAndVelocity(rvPCM,rA,vA,vMag,a,t,x_guess);
PlotMagnitudeErrors(t,PosErr,VelErr);
end

function eta = TwoBodyForceModel(t,posvel,mu)
eta = NaN(size(posvel));
rMag = sqrt(sum(posvel(:,1:3).^2,2));
nuR3 = -mu./rMag.^3;
eta(:,1) = posvel(:,4);
eta(:,2) = posvel(:,5);
eta(:,3) = posvel(:,6);
eta(:,4) = nuR3.*posvel(:,1);
eta(:,5) = nuR3.*posvel(:,2);
eta(:,6) = nuR3.*posvel(:,3);
end

function PlotPostionAndVelocity(rvPCM,rA,vA,vMag,a,t,xg)
figure('color',[1 1 1],'position',[0 0 1200 800]);
subplot(3,2,1);
plot(t./60,rvPCM(:,1),'ok'); hold on;
plot(t./60,rA(1,:),'+r');
plot(t./60,xg(:,1),'b');
ylim([-a-1,a+1]); 
xlabel('Time (min)');
ylabel('Position (km)');
legend('VPCM','Kepler','Initial Guess');
subplot(3,2,2);
plot(t./60,rvPCM(:,4),'ok'); hold on;
plot(t./60,vA(1,:),'+r');
plot(t./60,xg(:,4),'b');
ylim([-vMag-1 vMag+1]);
xlabel('Time (min)');
ylabel('Velocity (km/s)');
legend('VPCM','Kepler','Initial Guess');
subplot(3,2,3);
plot(t./60,rvPCM(:,2),'ok'); hold on;
plot(t./60,rA(2,:),'+r');
plot(t./60,xg(:,2),'b');
ylim([-a-1,a+1]);
xlabel('Time (min)');
ylabel('Position (km)');
legend('VPCM','Kepler','Initial Guess');
subplot(3,2,4);
plot(t./60,rvPCM(:,5),'ok'); hold on;
plot(t./60,vA(2,:),'+r');
plot(t./60,xg(:,5),'b');
ylim([-vMag-1 vMag+1]);
xlabel('Time (min)');
ylabel('Velocity (km/s)');
legend('VPCM','Kepler','Initial Guess');
subplot(3,2,5);
plot(t./60,rvPCM(:,3),'ok'); hold on;
plot(t./60,rA(3,:),'+r');
plot(t./60,xg(:,3),'b');
ylim([-a-1,a+1]);
xlabel('Time (min)');
ylabel('Position (km)');
legend('VPCM','Kepler','Initial Guess');
subplot(3,2,6);
plot(t./60,rvPCM(:,6),'ok'); hold on;
plot(t./60,vA(3,:),'+r');
ylim([-vMag-1 vMag+1]);
plot(t./60,xg(:,6),'b');
xlabel('Time (min)');
ylabel('Velocity (km/s)');
legend('VPCM','Kepler','Initial Guess');
end

function PlotMagnitudeErrors(t,PosErr,VelErr)
figure('color',[1 1 1]);
subplot(2,1,1);
plot(t./60,PosErr.*1e6,'k');
xlabel('Time (min)');
ylabel('Position Error (mm)');
subplot(2,1,2);
plot(t./60,VelErr.*1e6,'k');
xlabel('Time (min)');
ylabel('Velocity Error (mm/s)');
end