function handle = arrowhead(x,y,clr,Asize,head)

%  arrowhead   Draw an arrowhead 

%      This program was written to place arrowheads on trajectories 
%      calculated using one of MATLAB's ode solvers.  However, the program
%      does not require the solvers, it only requires two points as shown
%      in the figures below.  

%                (x2,y2)                    (x2,y2)            
%      head=1       o               head=2     o                             
%                  /|\                        /|\                                     
%                 / | \                      / | \                             
%                /  |  \                    /  o  \              
%               /   |   \                  / / . \ \               
%              o----o----o                o/   .   \o          
%                   .                          .                                
%                   .                          .          
%           (x1,y1) o                  (x1,y1) o           

%                (x2,y2)                    (x2,y2)             
%      head=3       o               head=4     o                               
%                  /|\                        /|\                               
%                 / | \                      / | \                          
%                /  |  \                    /  |  \                    
%               / _-o-_ \                  /   |   \                    
%              o    .    o                o_   |   _o                 
%                   .                         -o-                      
%                   .                          .       
%           (x1,y1) o                  (x1,y1) o    

%      The program draws the arrowhead, and does not draw the shaft.  Also, 
%      the point (x1,y1) is only used to determine the direction of the 
%      arrowhead, and has no affect on the size of the arrowhead.   
     
%      arrowhead(x,y,color,Asize,head)  

%      required arguments:  the values of x=[x1 x2] and y=[y1 y2]
%      optional arguments:  
%         color: a string, using the same format as for the plot command
%         Asize = [Asize(1) Asize(2)]: this rescales the arrowhead
%             Asize(1) = the length in changed by this factor (default=1)
%             Asize(2) = the width in changed by this factor (default=1)
%         head: an integer, this specifies the shape of the arrow head
%             head = 1 straight back (the default)
%             head = 2 slanted back
%             head = 3 curved back
%             head = 4 bowed-out back

%        EXAMPLES: The figures produced by the following commands are 
%        on the MATLAB web-site (where you downloaded this program)

%	 Examples involving an ODE solver:
%	 [t,y] = ode45(@rhs,[0 100],[0 1]);
%	 hold on
%	 plot(y(:,1),y(:,2))
%	 i=3; ii=i+2; arrowhead([y(i,1) y(ii,1)],[y(i,2) y(ii,2)]);
%	 i=16; ii=i+1; arrowhead([y(i,1) y(ii,1)],[y(i,2) y(ii,2)],'r');
%	 i=65; ii=i+1; arrowhead([y(i,1) y(ii,1)],[y(i,2) y(ii,2)],'m',[1.3 1.1],2);
%	 i=72; ii=i+2; arrowhead([y(i,1) y(ii,1)],[y(i,2) y(ii,2)],[],[1.1 1],3);
%	 i=80; ii=i+1; arrowhead([y(i,1) y(ii,1)],[y(i,2) y(ii,2)],'k',[],3);
%	 i=100; ii=i+1; arrowhead([y(i,1) y(ii,1)],[y(i,2) y(ii,2)],'g',[],4);

%	 Examples involving an ODE solver and log coordinates
%	 [t,y] = ode45(@rhs,[0 100],[0 1]);
%	 loglog(y(:,1),y(:,2))
%	 hold on
%	 i=3; ii=i+2; arrowhead([y(i,1) y(ii,1)],[y(i,2) y(ii,2)]);
%	 i=16; ii=i+1; arrowhead([y(i,1) y(ii,1)],[y(i,2) y(ii,2)],'r');
%	 i=65; ii=i+1; arrowhead([y(i,1) y(ii,1)],[y(i,2) y(ii,2)],'m',[1.3 1.1],2);
%	 i=72; ii=i+2; arrowhead([y(i,1) y(ii,1)],[y(i,2) y(ii,2)],[],[1.1 1],3);
%	 i=80; ii=i+2; arrowhead([y(i,1) y(ii,1)],[y(i,2) y(ii,2)],'k',[],3);
%	 i=100; ii=i+1; arrowhead([y(i,1) y(ii,1)],[y(i,2) y(ii,2)],'g',[],4);

%	 Examples not involving an ODE solver:
%	 axis([-6 6 0 0.4]);
%	 arrowhead([-6 -3.3],[0.3 0.3],[],[3 3]);
%	 arrowhead([-6 -0.7],[0.3 0.3],'r',[3 3],3);
%	 arrowhead([-6 1.8],[0.3 0.3],'k',[3 3],2);
%	 arrowhead([-6 5.3],[0.3 0.3],'m',[3 3],4);
%	 arrowhead([6 -5.8],[0.1 0.1],'m',[3 3]);
%	 arrowhead([6 -3],[0.1 0.1],'y',[3 3],3);
%	 arrowhead([6 -0.5],[0.1 0.1],'c',[3 3],2);
%	 arrowhead([6 2.5],[0.1 0.1],'g',[3 3],4);

%	 As indicated in the above four figures, the arrowhead is centered on the 
%	 line through (x1,y1), (x2,y2), with the front of the arrowhead at (x2,y2).  
%	 In the above ODE examples these points are from the computed solution.  
%	 In this context, (x1,y1) is the solution at time t1, while (x2,y2) is the 
%	 solution at time t2, where t1 < t2.  Depending on how picky you are about 
%	 the arrowhead being centered on the solution curve, you can adjust t1 to 
%	 rotate the arrowhead's direction.

%	 The default length and width of the arrowhead are determined by the height 
%	 and width of the currently active plot, or subplot, window.  By default 
%        the width of the arrowhead is 1/50 of the figure's smallest dimension 
%        (width/length), and the length of the arrowhead is 2.8 times the width. These  
%	 values can be adjusted using the Asize argument.  If this is done, it is likely 
%        that values between 0.2 and 4.0 will suffice, but any positive value can be 
%        used. Also, the code calculates the arrowhead placement using figure (screen) 
%        coordinates, and then converts this to axis coordinates. This means that it  
%        should not be necessary to use the pbaspect or daspect commands.

%   Copyright(c) 2009 Version 1.1
%   Mark H. Holmes

%   Revision History:
%
%     01/31/09 - Major rewrite of the code (v 1.1)
%                Now works with log and semilog coordinates; 
%		 Added another arrowhead type;
%		 Fixed a couple of errors.
%     10/02/08 - First release (v 1.0)

handle = [];

% errors
if nargin < 2
	error('You need to specify two points');
end
if (length(x) ~= 2) || (length(y) ~= 2),
	error('x and y vectors must each have two components');
end
if (x(1) == x(2)) && (y(1) == y(2)),
	error('The two points are equal - cannot determine direction!');
end

% set the defaults
if nargin <= 2
	clr = 'b';
end
if nargin <= 3
	Asize = [1 1];
end
if nargin <= 4
	head = 1;
end

% check if variables left empty
if isempty(clr)
	clr = 'b'; 
end;
if isempty(Asize)
	Asize = [1 1];
end;
if isempty(head)
	head = 1;
end

% determine and remember the hold status, toggle if necessary
if ishold,
	WasHold = 1;
else
	WasHold = 0;
	hold on;
end

x1 = x(1); x2 = x(2); y1 = y(1); y2 = y(2);

% get the axis dimensions
Scales = get(gca,'Position');

xlog=strcmp(get(gca,'Xscale'), 'log');
ylog=strcmp(get(gca,'Yscale'), 'log');

% get ranges for axis 
Size =  axis;
a = Size(1); b= Size(2); c= Size(3); d=Size(4);

% 2*Whead = width of arrow head
Whead = min(Scales(3),Scales(4))/50;

% Lhead = length of arrow head
Lhead = 2.8*Whead;

% user adjustment
Whead = Asize(2)*Whead;
Lhead = Asize(1)*Lhead;

% estimate the figure to axis scaling
v1 = 0.08*Scales(3);  v2 = 0.08*Scales(4);
v3 = 0.84*Scales(3);  v4 = 0.84*Scales(4);

% calculate the midpoint for the back of arrowhead
if xlog==1
	la=log10(a); lab=log10(b)-la;
	xv=[log10(x1)-la   log10(x2)-la]/lab;
else
	xv = [x1-a x2-a]/(b-a);
end;
XX = [v1 v1] + v3*xv;
% XX = [X1 X2] 
if ylog==1
	lc=log10(c); lcd=log10(d)-lc;
	yv=[log10(y1)-lc   log10(y2)-lc]/lcd;
else
	yv = [y1-c y2-c]/(d-c);
end;
YY = [v2 v2] + v4*yv;
% YY = [Y1 Y2]
Z3 = [XX(2) YY(2)] - Lhead * [XX(2)-XX(1)  YY(2)-YY(1)]/norm([XX(2)-XX(1)  YY(2)-YY(1)]);
% Z3 = [X3 Y3];

%  calculate the back two tips of the arrowhead
if x1==x2
	q = [ 1 0 ];
else
	q = [-(YY(2)-YY(1)) / (XX(2)-XX(1))  1]/norm([-(YY(2)-YY(1)) / (XX(2)-XX(1))  1]);
end;
ZA = Z3 + Whead * q;
% ZA = [XA YA] 
ZB = Z3 - Whead * q;
% ZB = [XB YB]
if xlog==1
	xx(1) = 10^(la + lab*(ZA(1)-v1)/v3);
	xx(2) = 10^(la + lab*(ZB(1)-v1)/v3);
else
	xx = [a a] + (b-a)*[ZA(1)-v1 ZB(1)-v1]/v3;
end;
% xx = [xa xb] 
if ylog==1
	yy(1) = 10^(lc + lcd*(ZA(2)-v2)/v4);
	yy(2) = 10^(lc + lcd*(ZB(2)-v2)/v4);
	y3 = 10^(lc + lcd*(Z3(2)-v2)/v4);
else
	yy = [c c] + (d-c)*[ZA(2)-v2 ZB(2)-v2]/v4;
	y3 = c + (d-c)*(Z3(2)-v2)/v4;
end;
% yy = [ya yb] 
xa=xx(1); xb=xx(2);
ya=yy(1); yb=yy(2);

% the polygon forming the arrowhead
if head==1
	xd = [x2 xa xb];
	yd = [y2 ya yb];
elseif head==2
	LL=0.7*Lhead;
	Z4 = [XX(2) YY(2)] - LL * [XX(2)-XX(1)  YY(2)-YY(1)]/norm([XX(2)-XX(1)  YY(2)-YY(1)]);
	if xlog==1
		x4 = 10^(la + lab*(Z4(1)-v1)/v3);
	else
		x4 = a + (b-a)*(Z4(1)-v1)/v3;
	end;
	if ylog==1
		y4 = 10^(lc + lcd*(Z4(2)-v2)/v4);
	else
		y4 = c + (d-c)*(Z4(2)-v2)/v4;
	end;
	% Z4 = [X4 Y4]
	xd = [x2 xa x4 xb];
	yd = [y2 ya y4 yb];
elseif head==3
	beta = 2;
	gam = 0.25;
	Z2 = [XX(2)  YY(2)];
	Z23 = Z2 - Z3;
	nZB3 = norm(ZB-Z3);
	nn=6;
	for i=1:nn
		ZL = Z3 + (ZB-Z3)*(i-1)/(nn-1);
		fac = 1 - (norm(ZL-Z3)/nZB3)^beta;
		ZD = ZL + gam*fac*Z23;
		ZLL = Z3 - (ZB-Z3)*(i-1)/(nn-1);
		ZDD = ZLL + gam*fac*Z23;
		if xlog==1
			xm = 10^(la + lab*(ZD(1)-v1)/v3);
			xmm = 10^(la + lab*(ZDD(1)-v1)/v3);
		else
			xm = a + (b-a)*(ZD(1)-v1)/v3;
			xmm = a + (b-a)*(ZDD(1)-v1)/v3;
		end;
		if ylog==1
			ym = 10^(lc + lcd*(ZD(2)-v2)/v4);
			ymm = 10^(lc + lcd*(ZDD(2)-v2)/v4);
		else
			ym = c + (d-c)*(ZD(2)-v2)/v4;
			ymm = c + (d-c)*(ZDD(2)-v2)/v4;
		end;
		if i==1
			xd = [xm];  yd=[ym];
		else
			xd = [xmm xd xm];  yd=[ymm yd ym];
		end;
	end;
	xd = [x2 xd];
	yd = [y2 yd];
else
	beta = 2;
	gam = 0.2;
	Z2 = [XX(2)  YY(2)];
	Z23 = Z2 - Z3;
	nZB3 = norm(ZB-Z3);
	nn=6;
	for i=1:nn
		ZL = Z3 + (ZB-Z3)*(i-1)/(nn-1);
		fac = 1 - (norm(ZL-Z3)/nZB3)^beta;
		ZD = ZL - gam*fac*Z23;
		ZLL = Z3 - (ZB-Z3)*(i-1)/(nn-1);
		ZDD = ZLL - gam*fac*Z23;
		if xlog==1
			xm = 10^(la + lab*(ZD(1)-v1)/v3);
			xmm = 10^(la + lab*(ZDD(1)-v1)/v3);
		else
			xm = a + (b-a)*(ZD(1)-v1)/v3;
			xmm = a + (b-a)*(ZDD(1)-v1)/v3;
		end;
		if ylog==1
			ym = 10^(lc + lcd*(ZD(2)-v2)/v4);
			ymm = 10^(lc + lcd*(ZDD(2)-v2)/v4);
		else
			ym = c + (d-c)*(ZD(2)-v2)/v4;
			ymm = c + (d-c)*(ZDD(2)-v2)/v4;
		end;

		if i==1
			xd = [xm];  yd=[ym];
		else
			xd = [xmm xd xm];  yd=[ymm yd ym];
		end;
	end;
	xd = [x2 xd];
	yd = [y2 yd];
end

% draw the arrowhead
fill(xd,yd,clr,'EdgeColor',clr);

% restore original axe ranges and hold status
axis(Size);
if ~WasHold,
	hold off
end






