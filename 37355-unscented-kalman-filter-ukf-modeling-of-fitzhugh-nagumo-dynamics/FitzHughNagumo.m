% 15.7.02
%
% Unscented Kalman Filter (UKF) applied to FitzHugh-Nagumo neuron dynamics. 
% Voltage observed, currents and inputs estimated.
% 
% FitzHughNagumo() is the main program and calls the other programs.
% 
% A detailed description is provided in
% H.U. Voss, J. Timmer & J. Kurths, Nonlinear dynamical system identification from uncertain and indirect measurements, Int. J. Bifurcation and Chaos 14, 1905-1933 (2004).
% I will be happy to email this paper on request. It contains a tutorial about the estimation of hidden states and unscented Kalman filtering.
%
% For commercial use and questions, please contact me.
% 
% ++++++++++++++++++++++++++++++++++++++++++++++
% Henning U. Voss, Ph.D.
% Associate Professor of Physics in Radiology
% Citigroup Biomedical Imaging Center
% Weill Medical College of Cornell University
% 516 E 72nd Street
% New York, NY 10021
% Tel. 001-212 746-5216, Fax. 001-212 746-6681
% Email: hev2006@med.cornell.edu
% ++++++++++++++++++++++++++++++++++++++++++++++

function FitzHughNagumo()

global dT

orient tall

% Dimensions: dq for param. vector, dx augmented state, dy observation
dq=1; dx=dq+2; dy=1; 

fct='FitzHughNagumo_fct'; % model function F(x)
obsfct='FitzHughNagumo_obsfct';   % observation function G(x)

ll=800; % number of data samples
dT=0.2; % sampling time step (global variable)

% Simulating data: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x0=zeros(2,ll); x0(:,1)=[0; 0]; % true trajectory
dt=.1*dT; nn=fix(dT/dt); % the integration time step is smaller than dT

% External input, estimated as parameter p later on:
z=[1:ll]/250*2*pi; z=-.4-1.01*abs(sin(z/2));

% 4th order Runge-Kutta integrator:

for n=1:ll-1;
  xx=x0(:,n);
  for i=1:nn
    k1=dt*FitzHughNagumo_int(xx,z(n));
    k2=dt*FitzHughNagumo_int(xx+k1/2,z(n));
    k3=dt*FitzHughNagumo_int(xx+k2/2,z(n));
    k4=dt*FitzHughNagumo_int(xx+k3,z(n));
    xx=xx+k1/6+k2/3+k3/3+k4/6;
  end;
  x0(:,n+1)=xx;
end;

x=[z; x0]; % augmented state vector (notation a bit different to paper)

R=.2^2*var(FitzHughNagumo_obsfct(x))*eye(dy,dy); % observation noise covariance matrix
randn('state',0); y=feval(obsfct,x)+sqrtm(R)*randn(dy,ll); % noisy data

% Initial conditions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xhat=zeros(dx,ll); 
xhat(:,2)=x(:,2); % first guess of x_1 set to observation 

Q=.015; % process noise covariance matrix

Pxx=zeros(dx,dx,ll); 
Pxx(:,:,1)=blkdiag(Q,R,R);

errors=zeros(dx,ll); % not so important
Ks=zeros(dx,dy,ll);  % Kalman gains

% Main loop for recursive estimation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for k=2:ll 

[xhat(:,k),Pxx(:,:,k),Ks(:,:,k)]=ut(xhat(:,k-1),Pxx(:,:,k-1),y(:,k),fct,obsfct,dq,dx,dy,R);

Pxx(1,1,k)=Q;

errors(:,k)=sqrt(diag(Pxx(:,:,k)));

end; % k

% Results %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

chisq=mean((x(1,:)-xhat(1,:)).^2+(x(2,:)-xhat(2,:)).^2+(x(3,:)-xhat(3,:)).^2)
est=xhat(1:dq,ll)'
error=errors(1:dq,ll)'

figure(1)

subplot(2,1,1)
plot(y,'bd','MarkerEdgeColor','blue', 'MarkerFaceColor','blue','MarkerSize',3);
hold on; 
plot(x(dq+1,:),'black','LineWidth',2);
%plot(xhat(dq+1,:),'r','LineWidth',2); 
xlabel(texlabel('t'));
ylabel(texlabel('x_1, y'));
hold off;
axis tight
title('(a)')
drawnow

subplot(2,1,2)
plot(x(dq+2,:),'black','LineWidth',2);
hold on
plot(xhat(dq+2,:),'r','LineWidth',2); 
plot(x(1,:),'black','LineWidth',2); 
for i=1:dq; plot(xhat(i,:),'m','LineWidth',2); end;
for i=1:dq; plot(xhat(i,:)+errors(i,:),'m'); end;
for i=1:dq; plot(xhat(i,:)-errors(i,:),'m'); end;
xlabel(texlabel('t'));
ylabel(texlabel('z, estimated z, x_2, estimated x_2'));
hold off
axis tight
title('(b)')

function r=FitzHughNagumo_int(x,z)
% Function for modeling data, not for UKF execution
a=.7; b=.8; c=3.;
r=[c*(x(2)+x(1)-x(1)^3/3+z); -(x(1)-a+b*x(2))/c];

function r=FitzHughNagumo_obsfct(x)
% Observation function
r=x(2,:);

function r=FitzHughNagumo_fct(dq,x)
% Runge-Kutta integrator for FitzHugh-Nagumo system with parameters

global dT
dt=.02; % local integration step
nn=fix(dT/dt);

p=x(1:dq,:);
xnl=x(dq+1:size(x(:,1)),:);
for n=1:nn
k1=dt*fc(xnl,p);
k2=dt*fc(xnl+k1/2,p);
k3=dt*fc(xnl+k2/2,p);
k4=dt*fc(xnl+k3,p);
xnl=xnl+k1/6+k2/3+k3/3+k4/6;
end
r=[x(1:dq,:); xnl];

function r=fc(x,p);
a=.7; b=.8; c=3.;
r=[c*(x(2,:)+x(1,:)-x(1,:).^3/3+p); -(x(1,:)-a+b*x(2,:))/c];

function [xhat,Pxx,K]=ut(xhat,Pxx,y,fct,obsfct,dq,dx,dy,R);
% Unscented transformation. Not specific to FitzHugh-Nagumo model

  N=2*dx;

  xsigma=chol( dx*Pxx )'; % Pxx=root*root', but Pxx=chol'*chol
  Xa=xhat*ones(1,N)+[xsigma, -xsigma];
  X=feval(fct,dq,Xa);

  xtilde=sum(X')'/N;

  Pxx=zeros(dx,dx);
  for i=1:N;
    Pxx=Pxx+(X(:,i)-xtilde)*(X(:,i)-xtilde)'/N;
  end;

  Y=feval(obsfct,X);

  ytilde=sum(Y')'/N;
  Pyy=R;
  for i=1:N;
    Pyy=Pyy+(Y(:,i)-ytilde)*(Y(:,i)-ytilde)'/N;
  end;
  Pxy=zeros(dx,dy); 
  for i=1:N;
    Pxy=Pxy+(X(:,i)-xtilde)*(Y(:,i)-ytilde)'/N;
  end;
  
  K=Pxy*inv(Pyy);
  xhat=xtilde+K*(y-ytilde);
  Pxx=Pxx-K*Pxy';
