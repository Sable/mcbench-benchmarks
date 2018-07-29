function stringmo
% Example:  stringmo  from Article 2.7
% ~~~~~~~~~~~~~~~~~~
% This is a driver program to illustrate motion
% of a string having one end subjected to 
% harmonic oscillation.
%
% User m functions required: 
%    shkstrng, ploteasy

fprintf('\nFORCED MOTION OF A VIBRATING ');
fprintf('STRING\n'); close
wf=2.98*pi; tmax=(2*pi)*.8; 
[y,t,x]=shkstrng(wf,80,0,tmax,75,0,1,51); 

while 0 % Skip redundant code
   
surf(x,t,y); ylabel('time') 
view([30,30]); xlabel('x axis');
zlabel('deflection'); % colormap([1 1 1]);
title(['Motion of a String with the Right', ...
       ' End Shaken Harmonically']);
fprintf('\nPress [Enter] for the\n');
fprintf('deflection when t=0.5\n');
figure(gcf); % genprint('strngsrf'); pause
[yp5,tp5,xp5]=shkstrng(wf,80,.5,.5,1,0,1,51); 
ploteasy(xp5,yp5,'horizontal direction', ...
         'transverse deflection', ...
         'String Deflection When t=0.5'); 
fprintf('Press [Enter] for the deflection\n');
fprintf('history at x=0.25\n');
%genprint('dflatep5'); 
pause
[yxc,txc,xc]= ...
  shkstrng(wf,80,0,tmax,151,.25,.25,1);
ploteasy(txc,yxc,'dimensionless time', ...
        'transverse deflection', ...
        'Motion at x=0.25 in the String');
     %genprint('motnqrtp');
     
end  % End of skipped code
  
fprintf('Press [Enter] for animation')
fprintf('\nof the string motion\n'); 
dumy=input('','s'); motion(x,y);
disp(' '); return; disp('All Done');

%==============================================

function [y,t,x]= ...
         shkstrng(w,nsum,t1,t2,nt,x1,x2,nx)
%
% [y,t,x]=shkstrng(w,nsum,t1,t2,nt,x1,x2,nx)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Simulation of the motion of a string having 
% one end fixed and the other end shaken 
% harmonically.    
%
% w     - forcing frequency
% t1,t2 - minimum and maximum times
% nt    - number of time values
% x1,x2 - minimum and maximum x values 
%         lying between zero and one
% nx    - number of x values
%
% t,x   - vectors of time and position values
% y     - matrix of transverse deflection 
%         values having nt rows and nx 
%         columns
%
% User m functions called:  none
%----------------------------------------------

t=linspace(t1,t2,nt)'; x=linspace(x1,x2,nx);
np=pi*(1:nsum); y=sin(w*t)/sin(w)*sin(w*x);
a=2*w*ones(nt,1)*(cos(np)./(np.^2-w^2));
y=y+a.*sin(t*np)*sin(np'*x);

%==============================================

function motion(x,y,inct,trac)
%
% motion(x,y,inct,trac) 
% ~~~~~~~~~~~~~~~~~~~~~
% This function animates the motion history 
% of the string.
%
% x    - horizontal position coordinates 
%        corresponding to various columns 
%        of matrix y
% y    - matrix with row j specifying the 
%        string position at the j'th time 
%        value
% inct - the number of row increments used 
%        to select positions for plotting. 
%        Using inct=2 would plot every other 
%        row of y. inct=1 is the default value. 
% trac - if this parameter is present, 
%        successive plot images are left on 
%        the screen. Otherwise, each 
%        configuration is shown and removed 
%        before the next image is shown. The 
%        default choice is to remove 
%        successive images.
%
% User m functions called:  none
%----------------------------------------------

if nargin ==2, inct=1; trac=0; end
if nargin ==3, trac=0; end
if inct > 1
  [nt,nx]=size(y); y=y(1:inct:nx,:); 
end
xmin=min(x); xmax=max(x); 
yend=y(:,end); yemx=max(yend); yemn=min(yend);
ymin=min(y(:)); ymax=max(y(:)); clf;
axis([xmin,xmax,2*ymin,2*ymax]); 
[nt,nx]=size(y); axis off; hold on
titl='STRING SHAKEN AT THE RIGHT END';
for j=1:nt-1
   yj=y(j,:); yje=yj(end); 
   plot(x,yj,'k',[0],[0],'ko',xmax,yje,'bo',...
      [xmax,xmax],[yemn,yemx],'k')
   title(titl), drawnow; figure(gcf); pause(.2)
  if trac ==0, cla; end
end
plot(x,yj,'k',[0],[0],'ko',xmax,yje,'bo',...
   [xmax,xmax],[yemn,yemx],'k')
figure(gcf); hold off;

%==============================================

function ploteasy(x,y,xlabl,ylabl,titl)
%
% ploteasy(x,y,xlabl,ylabl,titl)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Easy plot function with a simple 
% argument list
%
% x,y   - data to be plotted   
% xlabl - horizontal axis label for the graph
% ylabl - vertical axis label for the graph
% titl  - title for the graph
%
% User m functions called:  none
%----------------------------------------------

plot(x,y);
if nargin==2, figure(gcf); return, end
if nargin>2, xlabel(xlabl); end
if nargin>3, ylabel(ylabl); end
if nargin>4, title(titl); end
figure(gcf); 