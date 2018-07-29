function [u,X,T,uf,t]=forcmove(a,v,tmax,nt)

% [u,X,T,uf,t]=forcmove(a,v,tmax,nt)
% See Article 9.4   
% This function computes the dynamic response  
% of a taut string subjected to a force moving
% along the string with constant speed. The
% string is fixed at x=0 and and x=+infinity.
% The system is initially at rest when the 
% force is imposed at the left end and moves
% to the right at constant speed. If the force
% speed is larger than the wave propagation 
% speed, then no disturbance occurs ahead of
% the force. If the force moves slower than the 
% wave propagation speed, then the deflection 
% propagates ahead of the force at the speed 
% of wave propagation. 
%  
% v     - speed of the moving load 
% a     - speed of wave propagation in the
%         string
% tmax  - maximum time for which the 
%         solution is computed
% u     - matrix of deflection values where
%         time and position vary row-wise and
%         column-wise, respectively
% T,X   - matrices of time and position values
%         corresponding to the deflection 
%         matrix U
% uf    - deflection values where the force acts
% t     - vector of times (same as colunms of T)

if nargin==0, a=.8; v=1; tmax=10; nt=15; end 

% Obtain solution values and plot results
[u,X,T,uf,t]=ustring(a,v,tmax,nt); 
if a>v, xf=X(:,2); uf=u(:,2); xw=X(:,3); 
else, xf=X(:,3); uf=u(:,3); end
close, subplot(211)
waterfall(X,T,-u), xlabel('x axis')
ylabel('time'), zlabel('deflection')
titl=['INVERTED MOTION SURFACE FOR  A = ',...
      num2str(a),'  AND  V = ',num2str(v)]; 
title(titl), grid on, hold on
plot3(xf,t,-uf,'.k',xf,t,-uf,'k')
colormap([0 0 0]), view([-10,30]), shg
umin=min(u(:)); umax=max(u(:)); xmax=X(1,4);
range=[0,xmax,2*umin,2*umax]; hold on 
Titl='T = %4.2f'; subplot(212) , axis off

% Use a dense set of points for animation 
nt=80; [uu,XX,TT,uuf,tt]=ustring(a,v,tmax,nt);
umax=max(abs(uu(:))); uu=uu/umax; uuf=uuf/umax;
XX=XX/xmax; range=[0,1,-1,0.5]; h=.4;
arx=h*[0,.02,-.02,0,0]; ary=h*[0,.25,.25,0,1];
for j=1:nt
   uj=uu(j,:); xj=XX(j,:);
   xfj=v/xmax*tt(j); ufj=uuf(j);
   plot(xj,uj,'k',xfj+arx,ufj+ary,'-k')
   axis off, time=(sprintf(Titl,tt(j))); 
   text(.45,.25,time), axis(range), drawnow
   pause(.05), figure(gcf), if j<nt, cla, end 
end
hold off;

%=============================================

function [u,X,T,uf,t]=ustring(a,v,tmax,nt)
% [u,X,T,uf,t]=ustring(a,v,tmax,nt)
% This function computes the deflection u(x,t)
% of a semi-infinite string subjected to a 
% moving force. The equation for the normalized
% deflection 
% u(x,t)=1/a/(a^2-v^2)*((v-a-v*abs(x-a*t)...
%                           +a*abs(x-v*t));
% a    - speed of wave propagation in the string
% v    - speed of the force moving to the right 
% tmax - maximum time for computing the solution
% nt   - number of time increments computed
% uu   - array of displacement values normalized
%        by dividing by a factor equal to the force 
%        magnitude over twice the density per unit
%        length. Position varies column-wise and
%        time varies row-wise in the array.
% X,T  - position and time arrays for the solution
% uf   - deflection vector under the force
% t    - time vector for the solution (same as the
%        columns of T)
%       
t=linspace(0,tmax,nt)'; xmax=1.05*tmax*max(a,v);
u=zeros(nt,4); nx=4; X=zeros(nt,nx); X(:,nx)=xmax;
c=1/a/(a^2-v^2); xw=a*t; xf=v*t; T=repmat(t,1,4);
uw=c*xw*(v-a+abs(v-a)); uf=c*xf*(v-a-abs(v-a));
if a>v
   X(:,2)=xf; X(:,3)=xw; u(:,2)=uf;
else
   X(:,2)=xw; X(:,3)=xf; u(:,2)=uw; 
end   