function [t,ad,aa,tx,a,v,p,tt]=make2(varargin)

% [t,ad,aa,tx,a,v,p,tt] = make2(p,v,a,Ts,plt)
%
% Calculate timing for symmetrical second order profiles ....
%
% inputs:
%      p    = desired path (specify positive)              [m]
%      v    = velocity bound (specify positive)            [m/s]
%      a    = acceleration bound (specify positive)        [m/s2]
%      Ts   = sampling time (optional, if not specified or 0: continuous time)
%      plt  = optional: if plt=0 no profile plot is generated, default: plt=1
%
% outputs:
%      t(1) = constant acceleration phase duration
%      t(2) = constant velocity phase duration (default 0)
%      
%         t1          
%    a  .-----.         
%       |     |         
%       |     |   t2      
%      -'-----'--------.-----.--
%                      |     |  
%                      |     |  
%    -a                '-----'  
%                        t1   
%
% In case of discrete time, acceleration bound a is reduced to ad
%
% .... and calculate profiles: 
%
%      aa  = acceleration profile suitable for simulink 
%
%      tx  = time sequence for plotting profiles
%      a   = acceleration profile
%      v   = velocity profile
%      p   = position profile
%
%      tt  = 4 switching times for profile:
%
%      t0     t1          
%    a  .-----.         
%       |     |         
%       |     |       t2     t3
%      -'-----'--------.-----.--
%                      |     |  
%                      |     |  
%    -a                '-----'  
%                           
%
%  Note: coinciding switching times are not removed 

%
% Copyright 2004, Paul Lambrechts, The MathWorks, Inc.
%

if nargin < 3 || nargin > 5
   help make2
   return
else
   p=abs(varargin{1});
   v=abs(varargin{2});
   a=abs(varargin{3});
   plt=1;
   if nargin < 4
       Ts=0;
   else
       Ts=abs(varargin{4});
       if nargin == 5
           plt=varargin{5};
       end
   end
end
   
ad = a;  % required for discrete time calculations

% Calculation t1
t1 = (p/a)^(1/2) ; % largest t1 with bound on acceleration
if Ts>0  
   t1 = ceil(t1/Ts)*Ts; 
   ad = p/(t1^2); 
end
% velocity test
if v < ad*t1   % v bound violated ?
   t1 = v/a ;  % t1 with bound on velocity not violated
   if Ts>0  
       t1 = ceil(t1/Ts)*Ts; 
       ad = v/t1; 
   end
end
a = ad;  % as t1 is now fixed, ad is the new bound on acceleration

% Calculation t2
t2 = (p-a*t1^2)/v ;  % largest t2 with bound on velocity
if Ts>0  
   t2 = ceil(t2/Ts)*Ts; 
   ad = p/( t1^2 + t1*t2 );
end
if abs(t2)<1e-12, t2=0; end % for continuous time case

% All time intervals are now calculated
t=[ t1 t2 ] ;

% This error should never occur !!
if min(t)<0
    disp('ERROR: negative values found')
end

% Finished.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate profiles

a = ad;

tt=   [0 1 1 2]*t(1) ...
    + [0 0 1 1]*t(2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate Simulink look-up table
at=[];
for i=1:4
    at =  [at   [1 1] * tt(i) ]  ;
end
at  = [at 1.5*tt(4)];

aa  = [at ; [ 0 a a 0 0 -a -a 0 0 ] ];

if plt==0  % no plot required
    tx=[];a=[];v=[];p=[];    % dummy outputs
    return
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate profiles for plotting

% Determine time grid for plotting
if Ts==0
    Ts=t1/99.5;  % continuous time accuracy for profile calculations
    while tt(4)/Ts > 5000 && Ts*2 < tt(2)
        Ts=Ts*2;          % to prevent plot of more than 5000 points
    end
else
   % Ts=Ts/10;   % discrete time accuracy for profile calculations
end

% Determine continuous or discrete
if max(abs( round(t/Ts)-t/Ts )) > 1e-12 % continuous

   disp('Calculating continuous time profiles')
   step = Ts;
   tx=(0:step:1.2*tt(4));
   x=[];
   for i=0:step:1.2*tt(4)
       j=find(i<=aa(1,:));
       x=[x ; aa(2,j(1))];
   end
   a=x;
   v=cumsum(a)*step;
   p=cumsum(v)*step;

else % discrete
    
   disp('Calculating discrete time profiles')
   ttest=[tt 1.5*tt(4)];
   len = round(1.2*tt(4)/Ts + 1); % length of profiles
   if len<100                     % to make sure there are sufficient points to make a smooth plot 
       Ts  = Ts/round(100/len); 
       len = round(1.2*tt(4)/Ts + 1); 
   end
   xa = zeros(len,1);
   xv = xa;
   xp = xa;
   xa(1) = a;
   tx=(0:Ts:1.2*tt(4)+Ts/2);
   for time=Ts:Ts:(1.2*tt(4)+Ts/2)
      i = find( (time + Ts/2) <= ttest ); i = i(1)-1;
      k = round(time/Ts);
      if i==1 
          xa(k+1) =  a;
      elseif i==3 
          xa(k+1) = -a;
      else
          xa(k+1) =  0;
      end
      xv(k+1) = xv(k) + xa(k)*Ts;
      xp(k+1) = xp(k) + xv(k)*Ts;
   end
   a=xa;v=xv;p=xp;

end

%close all
%figure
subplot(311);plot(tx,a,'k','LineWidth',1.5);hold on;plot([0 0],[-1 1]*max(a),'k--',[1 1]*max(tt),[-1 1]*max(a),'k--','LineWidth',1.5);grid on; axis([ [-0.01 1]*max(tx) [-1.1 1.1]*max(a)]);
title('Second order trajectory profiles');ylabel('a [m/s2]');
subplot(312);plot(tx,v,'k','LineWidth',1.5);hold on;plot([0 0],[0 1]*max(v),'k--',[1 1]*max(tt),[0 1]*max(v),'k--','LineWidth',1.5);grid on; axis([ [-0.01 1]*max(tx) [-0.1 1.1]*max(v)]);
ylabel('v [m/s]');
subplot(313);plot(tx,p,'k','LineWidth',1.5);hold on;plot([0 0],[0 1]*max(p),'k--',[1 1]*max(tt),[0 1]*max(p),'k--','LineWidth',1.5);grid on; axis([ [-0.01 1]*max(tx) [-0.1 1.1]*max(p)]);
xlabel('time [s]');ylabel('x [m]');
%set(1,'position',[700 400 500 500])
set(1,'paperposition',[0 0 5 5])

return
subplot(311);
text(tt(1)+tt(4)/200,max(a)/5,'t_0');
text(tt(2)+tt(4)/200,max(a)/5,'t_1');
text(tt(3)+tt(4)/200,max(a)/5,'t_2');
text(tt(4)+tt(4)/200,max(a)/5,'t_3');
