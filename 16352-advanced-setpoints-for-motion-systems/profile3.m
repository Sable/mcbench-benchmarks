function [jj,tx,j,a,v,p,tt]=profile3(t,j,acc,plt)

% function [jj,tx,j,a,v,p,tt]=profile3(t,j,acc)
%
% Calculate symmetrical third order profiles from times: 
%
%  Inputs:
%
%      t(1) = constant jerk phase duration
%      t(2) = constant acceleration phase duration (default 0)
%      t(3) = constant velocity phase duration (default 0)
% 
%      j    = bound on jerk
%      acc  = continuous time: accuracy for profiles: t(1)*acc = minimal timestep
%             discrete time:   sample time
%
%  Outputs:
%
%      jj  = derivative of jerk profile suitable for simulink 
%
%      tx  = time sequence for plotting profiles
%      j   = jerk profile
%      a   = acceleration profile
%      v   = velocity profile
%      p   = position profile
%
%      tt  = 8 switching times for profile:
%
%       0 1              6 7  
%       .-.              .-.  
%       | |              | |  
%       | |  2 3    4 5  | |  
%       '-'--.-.----.-.--' '--
%            | |    | |       
%            | |    | |       
%            '-'    '-'       
%
%  Note: coinciding switching times are not removed 

%
% Copyright 2004, Paul Lambrechts, The MathWorks, Inc.
%

if nargin < 3 || nargin > 4
    help profile3
    return
end
if nargin==3
    plt=1;
end

if length(t)==1  % min distance with max jerk
    tt=   [0 1 1 2 2 3 3 4 ]*t;
    
elseif length(t)==2 % constant acceleration phase
    tt=   [0 1 1 2 2 3 3 4 ]*t(1) ...
        + [0 0 1 1 1 1 2 2 ]*t(2);
    
elseif length(t)==3 % constant velocity phase
    tt=   [0 1 1 2 2 3 3 4 ]*t(1) ...
        + [0 0 1 1 1 1 2 2 ]*t(2) ...
        + [0 0 0 0 1 1 1 1 ]*t(3) ;
else
    return
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate Simulink look-up table
jt=[];
for i=1:8
    jt =  [jt   [1 1] * tt(i) ]  ;
end
jt  = [jt 1.5*tt(8)];

jj  = [jt ; [ 0 j j 0 0 -j -j 0 0 -j -j 0 0 j j 0 0 ] ];

if plt==0  % no plot required
    tx=[];j=[];a=[];v=[];p=[];    % dummy outputs
    return
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate profiles for plotting

% Determine continuous or discrete
if max(abs( round(t/acc)-t/acc )) > 1e-12 % continuous

   disp('Calculating continuous time profiles')
   step = t(1)*acc;
   tx=0:step:1.2*tt(8);
   x=[];
   for i=0:step:1.2*tt(8)
       j=find(i<=jj(1,:));
       x=[x ; jj(2,j(1))];
   end
   j=x;
   a=cumsum(j)*step; 
   v=cumsum(a)*step;
   p=cumsum(v)*step;

else % discrete
    
   disp('Calculating discrete time profiles')
   Ts=acc;
   ttest=[tt 1.5*tt(8)];
   len = round(1.2*tt(8)/Ts + 1); % length of profiles
   xj = zeros(len,1);
   xa = xj;
   xv = xj;
   xp = xj;
   xj(1) = j;
   tx=0:Ts:1.2*tt(8)+Ts/2;
   for time=Ts:Ts:(1.2*tt(8)+Ts/2)
      i = find( (time + Ts/2) <= ttest ); i = i(1)-1;
      k = round(time/Ts);
      if i==1 || i==7 
          xj(k+1) =  j;
      elseif i==3 || i==5 
          xj(k+1) = -j;
      else
          xj(k+1) =  0;
      end
      xa(k+1) = xa(k) + xj(k)*Ts;
      xv(k+1) = xv(k) + xa(k)*Ts;
      xp(k+1) = xp(k) + xv(k)*Ts;
   end
   j=xj;a=xa;v=xv;p=xp;

end

%close all
%figure
subplot(411);plot(tx,j,'k','LineWidth',1.5);hold on;plot([0 0],[-1 1]*max(j),'k--',[1 1]*max(tt),[-1 1]*max(j),'k--','LineWidth',1.5);grid on; axis([ [-0.01 1]*max(tx) [-1.1 1.1]*max(j)]);
title('Third order trajectory profiles');ylabel('j [m/s3]');
subplot(412);plot(tx,a,'k','LineWidth',1.5);hold on;plot([0 0],[-1 1]*max(a),'k--',[1 1]*max(tt),[-1 1]*max(a),'k--','LineWidth',1.5);grid on; axis([ [-0.01 1]*max(tx) [-1.1 1.1]*max(a)]);
ylabel('a [m/s2]');
subplot(413);plot(tx,v,'k','LineWidth',1.5);hold on;plot([0 0],[0 1]*max(v),'k--',[1 1]*max(tt),[0 1]*max(v),'k--','LineWidth',1.5);grid on; axis([ [-0.01 1]*max(tx) [-0.1 1.1]*max(v)]);
ylabel('v [m/s]');
subplot(414);plot(tx,p,'k','LineWidth',1.5);hold on;plot([0 0],[0 1]*max(p),'k--',[1 1]*max(tt),[0 1]*max(p),'k--','LineWidth',1.5);grid on; axis([ [-0.01 1]*max(tx) [-0.1 1.1]*max(p)]);
xlabel('time [s]');ylabel('x [m]');
set(1,'position',[700 200 500 680])
set(1,'paperposition',[0 0 5 6.8])

subplot(411);
text(tt(1)+tt(8)/200,max(j)/5,'t_0');
text(tt(2)+tt(8)/200,max(j)/5,'t_1');
text(tt(3)          ,max(j)/5,'t_2');
text(tt(4)          ,max(j)/5,'t_3');
text(tt(5)          ,max(j)/5,'t_4');
text(tt(6)          ,max(j)/5,'t_5');
text(tt(7)+tt(8)/200,max(j)/5,'t_6');
text(tt(8)+tt(8)/200,max(j)/5,'t_7');
