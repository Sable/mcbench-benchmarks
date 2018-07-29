function [dj,tx,d,j,a,v,p,tt]=profile4(t,d,acc,plt)

% function [dj,tx,d,j,a,v,p,tt]=profile4(t,d,acc)
%
% Calculate symmetrical fourth order profiles from times: 
%
%  Inputs:
%
%      t(1) = constant djerk phase duration
%      t(2) = constant jerk phase duration (default 0)
%      t(3) = constant acceleration phase duration (default 0)
%      t(4) = constant velocity phase duration (default 0)
% 
%      d    = bound on djerk
%      acc  = continuous time: accuracy for profiles: t(1)*acc = minimal timestep
%             discrete time:   sample time
%
%  Outputs:
%
%      dj  = derivative of jerk profile suitable for simulink 
%
%      tx  = time sequence for plotting profiles
%      d   = derivative of jerk profile
%      j   = jerk profile
%      a   = acceleration profile
%      v   = velocity profile
%      p   = position profile
%
%      tt  = 16 switching times for profile:
%
%       0 1              6 7             10 11  12 13
%       .-.              .-.              .-.    .-.
%       | |              | |              | |    | |
%       | |  2 3    4 5  | |         8 9  | |    | |  14 15
%       '-'--.-.----.-.--' '---------.-.--'-'----'-'--.-.--
%            | |    | |              | |              | |
%            | |    | |              | |              | |
%            '-'    '-'              '-'              '-'
%
%  Note: coinciding switching times are not removed 

%
% Copyright 2004, Paul Lambrechts, The MathWorks, Inc.
%

if nargin~=3 && nargin~=4
    help profile4
    return
end
if nargin==3
    plt=1;
end


if length(t)==1  % min distance with max djerk
    tt=   [0 1 1 2 2 3 3 4 4 5 5 6 6 7 7 8]*t;
%    tt=   [0 1 1 2 2 3 4 4 4 4 4 5 5 6 6 7]*t;
    
elseif length(t)==2 % constant jerk phase
    tt=   [0 1 1 2 2 3 3 4 4 5 5 6 6 7 7 8]*t(1) ...
        + [0 0 1 1 1 1 2 2 2 2 3 3 3 3 4 4]*t(2);
    
elseif length(t)==3 % constant acceleration phase
    tt=   [0 1 1 2 2 3 3 4 4 5 5 6 6 7 7 8]*t(1) ...
        + [0 0 1 1 1 1 2 2 2 2 3 3 3 3 4 4]*t(2) ...
        + [0 0 0 0 1 1 1 1 1 1 1 1 2 2 2 2]*t(3) ;

elseif length(t)==4 % constant velocity phase
    tt=   [0 1 1 2 2 3 3 4 4 5 5 6 6 7 7 8]*t(1) ...
        + [0 0 1 1 1 1 2 2 2 2 3 3 3 3 4 4]*t(2) ...
        + [0 0 0 0 1 1 1 1 1 1 1 1 2 2 2 2]*t(3) ...
        + [0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1]*t(4) ;
    
else
    return
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate Simulink look-up table
dt=[];
for i=1:16
    dt =  [dt   [1 1]*tt(i) ];
end
dt  = [dt 1.5*tt(16)];

dd = [0 d d 0];
dd = [ dd -dd -dd dd -dd dd dd -dd 0];

dj = [dt ; dd] ;

if plt==0  % no plot required
    tx=[];d=[];j=[];a=[];v=[];p=[];    % dummy outputs
    return
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate profiles for plotting

% Determine continuous or discrete
if max(abs( round(t/acc)-t/acc )) > 1e-12 % continuous
   disp('Calculating continuous time profiles')
   step = t(1)*acc;
   tx=(0:step:1.2*tt(16))';
   x=[];
   for i=0:step:1.2*tt(16)
       j=find(i<=dj(1,:));
       x=[x ; dj(2,j(1))];
   end
   d=x;
   j=cumsum(d)*step;
   a=cumsum(j)*step; 
   v=cumsum(a)*step;
   p=cumsum(v)*step;

else % discrete
    
   disp('Calculating discrete time profiles')
   Ts=acc;
   ttest=[tt 1.5*tt(16)];
   len = round(1.2*tt(16)/Ts + 1); % length of profiles
   xd = zeros(len,1);
   xj = xd;
   xa = xd;
   xv = xd;
   xp = xd;
   xd(1) = d;
   tx=(0:Ts:1.2*tt(16)+Ts/2)';
   for time=Ts:Ts:1.2*tt(16)+Ts/2
      j = find( (time + Ts/2) <= ttest ); j = j(1)-1;
      k = round(time/Ts);
      if j==1 || j==7 || j==11 || j==13
          xd(k+1) =  d;
      elseif j==3 || j==5 || j==9 || j==15
          xd(k+1) = -d;
      else
          xd(k+1) =  0;
      end
      xj(k+1) = xj(k) + xd(k)*Ts;
      xa(k+1) = xa(k) + xj(k)*Ts;
      xv(k+1) = xv(k) + xa(k)*Ts;
      xp(k+1) = xp(k) + xv(k)*Ts;
   end
   d=xd;j=xj;a=xa;v=xv;p=xp;

   dj(1,:)=dj(1,:)+Ts/2 ; % add Ts/2 to avoid numerical problems
end
dj=dj'; % to be compatible with Simulink 'From Workspace' block

% figure
%close all
subplot(511);plot(tx,d,'k','LineWidth',1.5);hold on;plot([0 0],[-1 1]*max(d),'k--',[1 1]*max(tt),[-1 1]*max(d),'k--','LineWidth',1.5); grid on; axis([ [-0.01 1]*max(tx) [-1.1 1.1]*max(d)]);
title('Fourth order trajectory profiles');ylabel('d [m/s4]');
subplot(512);plot(tx,j,'k','LineWidth',1.5);hold on;plot([0 0],[-1 1]*max(j),'k--',[1 1]*max(tt),[-1 1]*max(j),'k--','LineWidth',1.5);grid on; axis([ [-0.01 1]*max(tx) [-1.1 1.1]*max(j)]);
ylabel('j [m/s3]');
subplot(513);plot(tx,a,'k','LineWidth',1.5);hold on;plot([0 0],[-1 1]*max(a),'k--',[1 1]*max(tt),[-1 1]*max(a),'k--','LineWidth',1.5);grid on; axis([ [-0.01 1]*max(tx) [-1.1 1.1]*max(a)]);
ylabel('a [m/s2]');
subplot(514);plot(tx,v,'k','LineWidth',1.5);hold on;plot([0 0],[0 1]*max(v),'k--',[1 1]*max(tt),[0 1]*max(v),'k--','LineWidth',1.5);grid on; axis([ [-0.01 1]*max(tx) [-0.1 1.1]*max(v)]);
ylabel('v [m/s]');
subplot(515);plot(tx,p,'k','LineWidth',1.5);hold on;plot([0 0],[0 1]*max(p),'k--',[1 1]*max(tt),[0 1]*max(p),'k--','LineWidth',1.5);grid on; axis([ [-0.01 1]*max(tx) [-0.1 1.1]*max(p)]);
xlabel('time [s]');ylabel('x [m]');
set(1,'position',[700 100 500 860])
set(1,'paperposition',[0 0 5 8.6])

return
subplot(511);
text(tt( 1)+tt(16)/200,-max(d)/5,'t_0');
text(tt( 2)-tt(16)/200,-max(d)/5,'t_1');
text(tt( 3)-tt(16)/200, max(d)/5,'t_2');
text(tt( 4)-tt(16)/200, max(d)/5,'t_3');
text(tt( 5)-tt(16)/200, max(d)/5,'t_4');
text(tt( 6)-tt(16)/200, max(d)/5,'t_5');
text(tt( 7)-tt(16)/200,-max(d)/5,'t_6');
text(tt( 8)-tt(16)/200,-max(d)/5,'t_7');
text(tt( 9)-tt(16)/200, max(d)/5,'t_8');
text(tt(10)-tt(16)/200, max(d)/5,'t_9');
text(tt(11)-tt(16)/100,-max(d)/5,'t_1_0');
text(tt(12)-tt(16)/200,-max(d)/5,'t_1_1');
text(tt(13)-tt(16)/100,-max(d)/5,'t_1_2');
text(tt(14)-tt(16)/200,-max(d)/5,'t_1_3');
text(tt(15)-tt(16)/100, max(d)/5,'t_1_4');
text(tt(16)-tt(16)/200, max(d)/5,'t_1_5');
