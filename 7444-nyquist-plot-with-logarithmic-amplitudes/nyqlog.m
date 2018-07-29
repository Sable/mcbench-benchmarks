function nyqlog(sys)

% Nyqlog makes a polar plot of the open 
% loop transfer function h0(s) with
% |h0(s)| on a dB scale. It supports
% only continuous and monovariable systems.

% Trondheim, June 2009
% Trond Andresen <Trond.Andresen@itk.ntnu.no>
% Department of Engineering Cybernetics, 
% The Norwegian University of Science and Technology, 
% N-7034 Trondheim, NORWAY. 

% May be distributed freely for non-commercial use, 
% but please leave the above info unchanged, for
% credit and feedback purposes.
%
% ***********************************************
% System examples for copying and pasting on the
% MATLAB command line:
% -------------------
%sys=tf(1, conv([1 0 0], [1 1]));
%sys=tf(conv([5 1],[1 1]), [1 0 0 0],'ioDelay',1);
%sys=tf(1,conv([1 -0.01 0 1 3 -0.1 7],[1 -0.05 0.6]));
%sys=tf(1,[1 0.00000001 1+0.00000001^2]);
%sys=tf(1,[1 0]);
%w0=10; zeta=0.1; sys=tf([1 1],[1/w0^2 2*zeta/w0 1]);
%w0=5; zeta=0.1; sys=tf(1,[1/w0^2 2*zeta/w0 1]);
%sys=0.1*tf([10 1], [5 6 1 0 0]);
%sys=1*tf([1],conv([1 -0.1],[1 0]));
%sys=tf([1 0 25],conv([1 0 1 0 0],[1 0 4]));
%sys=tf([1 0 25],[1 0 1 ]);
%sys=tf([1 0 1], [1 0 0 0]);

%Table 9.6 - 3:
%sys=10*tf(1,conv(conv([1000 1],[10 1]),[1 1]))
%Table 9.6 - 9:
%sys=tf(0.001,[50 1 0 0])
%Table 9.6 - 12:
% sys=0.05*tf([5 1], [1 0 0 0])
%Table 9.6 - 13:
% sys=tf(conv([5 1],[1 1]), [1 0 0 0]);
%Table 9.6 - 14:
%sys=200*tf(conv([3 1],[2 1]),conv(conv([50 1 0],[10 1]),conv([0.5 2],[0.1 1])))
%Table 9.6 - 15:
%sys=10*tf([25 1],conv([1 2 0 0],[1 1]))

% Ex. 8.15 in REGULERINGSTEKNIKK (in Norwegian) by Balchen, Andresen, Foss:
% a=0.2; T =1; Kp= 1; sys=tf(Kp,conv([1 -a],[T 1]));
% *************************************************

% Checking system order:
[hlp,den]=tfdata(sys,'v');
k=1;
while (hlp(k) == 0) k=k+1; end
num=(hlp(k:end));
hlp=size(size(den));
if (hlp(2)> 2)
   error('Only monovariable systems allowed in Nyqlog');
end

% Checking for delay:
dly=get(sys,'ioDelay');

% Checking that the system is not discrete:
sorz=get(sys,'variable');
if (sorz ~= 's')
   error('Only continuous systems allowed in Nyqlog');
end

% Charting poles and zeroes, system dimension;
% Sorting poles by Im-value in ascending order:
sysdim=size(den); sysdim=sysdim(2)-1;
if (sysdim == 0)
   error('Denominator order of zero not allowed in Nyqlog');
end%
numdim=size(num); numdim = numdim(2)-1;
if (numdim > sysdim)
   error('Denominator order must be >= nominator order');
end
poles=roots(den);
    re_poles=real(poles);
% This is used below to check stability of the closed-loop system:
    openloop_rhp_poles=sum(re_poles > 0);
impoles=imag(poles);
[vhlp,im_ndx]=sort(impoles);
poles(:)=poles(im_ndx(:));
abpoles=abs(poles);
repoles=real(poles);
impoles=imag(poles);
% No. of poles in the origin and on the imaginary axis, if any;
Np_origin=0;
Np_imag=0;
for k=1:sysdim
   if (repoles(k) == 0)
      if (impoles(k) > 0) 
      	 Np_imag = Np_imag+1;
   	  elseif (impoles(k) == 0)
          Np_origin = Np_origin+1;
      else
      end
   end
end
if Np_imag impoles=impoles(end+1-Np_imag:end); end
% Sorting zeroes by Im-value in ascending order:
abzeroes=0;
if (numdim) 
    zeroes=roots(num);
    imzeroes=imag(zeroes);
    [vhlp,im_ndx]=sort(imzeroes);
    zeroes(:)=zeroes(im_ndx(:));
    abzeroes=abs(zeroes);
    rezeroes=real(zeroes);
    imzeroes=imag(zeroes);   
 end
 
% Finding smallest distance > 0 to pole or zero
% to decide
% radius for half circles around imaginary poles;
eps=1e-3;
R=eps;
if Np_origin  R = eps^(1/Np_origin); end
R0=inf;
if (Np_origin && Np_imag)
    R=mindist(0,poles,R0);
    if (numdim) R = mindist(0,zeroes,R0); end
end
R0=R;
if Np_imag
    for k=1:length(impoles)
        R=mindist(impoles(k),poles,R0);
    end
end
R0=R;
if (numdim) 
    for k=1:length(impoles)
        R=mindist(impoles(k),zeroes,R0);
    end
end
frac=0.01;
if Np_origin frac = (0.01)^(1/Np_origin); end
R=frac*R;

% Calculating a tentative vector s to be used in h0(s):
% Ns = number of points on s. Special measures are
% taken if there is a time delay in sys.
Ns=1000+150*(dly > 0);
wmin= R;
wmax= 1e6*max(cat(1,abpoles,abzeroes));
if (wmax == 0) wmax= R*1e11; end
if (dly) wmax = min(wmax,4*pi/dly); end
w=log(wmin):(log(wmax)-log(wmin))/Ns:log(wmax);
w=exp(w');
s=j.*w;

% Splicing in possible imaginary zeroes > 0 in s:
n=0;
for k=1:numdim
   if (abs(rezeroes(k)) < 1e-12 && imzeroes(k) > R)
      n=n+1;
      imonlyzeroes(n) = imzeroes(k);
   end
end
if (exist('imonlyzeroes'))
   w1=cat(1,w,imonlyzeroes');
   [w1,im_ndx]=sort(w1,1);
   s=j.*w1;
end

% Plotting main graph and its mirror image:

s1=s;
spiralfactor=1.5;
spiralfactor=1/spiralfactor;
set(gcf,'Color',[1 1 1]);
s = scurve(s1,R,spiralfactor, Np_origin, Np_imag,impoles);
 %plot(s); hold on; 
 %break;
 %plot([0 1],[R 1]);
s=conj(s);
[zmirr,ncount] = nygraph(sys,s,0);
hold on;
spiralfactor=1/spiralfactor;
s = scurve(s1,R,spiralfactor, Np_origin, Np_imag,impoles);
[zmain,ncount] = nygraph(sys,s,1);

fprintf(1,'Number of poles in RHP of open-loop system: %i\n',openloop_rhp_poles);

% Count net encirclements around the point -1.
% An encirclement is counted as positive if the direction
% is clockwise.
[ncirc,npoles_on_im_axis] = countencirc(zmirr,zmain); 
if npoles_on_im_axis > 0
    fprintf(1,'%d closed-loop pole(s) on the im-axis.\n',npoles_on_im_axis);
    fprintf(1,'Graph goes through the -1 point, so\n');
    fprintf(1,'encirclement counting cannot be done.\n');
else
    fprintf(1,'Number of net encirclements around the -1 point:   %i\n',ncirc);
    closedloop_rhp_poles=ncirc+openloop_rhp_poles;
    fprintf(1,'=> Number of poles in RHP of closed-loop system:   %i\n',...
        closedloop_rhp_poles);
    if closedloop_rhp_poles > 0
        fprintf(1,'=> Closed-loop-system is unstable\n');
    else
        fprintf(1,'and no closed-loop poles on Im-axis\n=> Closed-loop-system is asymptotically stable\n');
    end
end

% Plotting background diagram;
circle(0,0.5,'r-');
circle(0,0.6666666667,'r-.');
circle(0,0.833333333,'r-.');
circle(0,1,'r-');
circle(0,1.16666667,'r-.');
circle(0,1.33333333,'r-.');
circle(0,1.5,'r-');
phase_lines(24,0.5,1.5,'r-.');
phase_lines(8,0.5,1.5,'r-');
plot(-1,0,'ko','LineWidth',2.5);
plot([-1.5 1.5],[0 0]); plot([0 0],[-1.5 1.5]);
text(0.03,-0.05,'-120','FontSize',7); 
text(0.4141, -0.3331,'-60','FontSize',9); 
text(0.8, -0.64,'0 dB','FontSize',8);
text(1.1924, -0.9575,'+60','FontSize',9);

% Plotting directional arrows:
% for xh = [0.8 0.65 0.45 0.25]
for xh = [0.8 0.15]
   nmid=round(xh*ncount);
   arrow(zmain(nmid+1),zmain(nmid),'b-');
end
% for xh = [0.75 0.6 0.4 0.2]
for xh = [0.7 0.1]
   nmid=round(xh*ncount);
   arrow(zmirr(nmid),zmirr(nmid+1),'k-');
end

% % Contours for |N|= const. may be plotted: 
% % for instance [6 3 1 0.5 0.25 0 -0.5 -1 -3 -6]

% nlgrid([6 3]);

scalexy=axis; scalexy(3:4)= 1.01*scalexy(3:4);
axis(scalexy); 
axis equal; axis off; axis tight; hold off;

%******************************************
%****** SUB-FUNCTIONS: ********************

function arrow(z2,z1,col)
% dz=0.12*exp(j*angle(z2-z1));
dz=0.11*exp(j*angle(z2-z1));
z_arrow_end1=z2-dz*exp(j*pi/4);
z_arrow_end2=z2-dz*exp(-j*pi/4);
plot([real(z2) real(z_arrow_end1)],...
   [imag(z2) imag(z_arrow_end1)],col,'LineWidth',1.5);
plot([real(z2) real(z_arrow_end2)],...
   [imag(z2) imag(z_arrow_end2)],col,'LineWidth',1.5);

%***********************************************
function circle(zcentre,radius,plotdata)
angles=0:pi/72:2*pi;
circ=zcentre+radius.*(cos(angles)+j.*sin(angles));
plot(circ,plotdata);

%***********************************************
function phase_lines(n,rstart,rend,plotdata)
hold on;
angles=0:2*pi/n:2*pi;
lines=ones(n,2);
for k=1:n
    zh = cos(angles(k))+j*sin(angles(k));
    lines(k,1)= rstart*zh;
    lines(k,2)= rend*zh;
    plot(real(lines(k,:)),imag(lines(k,:)),plotdata);
 end

%***********************************************

function [s]= scurve(s1,R,spiralfactor, Np_origin, Np_imag,impoles)
a=log(spiralfactor)*2/pi;
%R=R/spiralfactor;
% Calculating first arc if pole(s) in the origin:
% If there are one or more pure integrators s is 
% made to do a small arc of a log spiral 
% into the upper right quadrant from 0 to pi/2.
s=s1;
if Np_origin
   fi=0:0.02/Np_origin:1; fi=0.5*pi*fi;
   sarc=R*exp((a+j)*fi);
   % merging sarc with s:
   x1=imag(sarc(end));
   k=1;
   while (imag(s1(k)) < x1) k=k+1; end
	s1=cat(1,sarc.',s(k:end));
   s=s1;
end

% Calculating arcs for possible pole(s) on the im-axis:
% For each such possible pole we generate a vector 
% sarc describing a log spiral around the pole
% from -pi/2 to pi/2 into the right half plane.
fi=-1:0.02:1; fi=0.5*pi*fi;
s1=s;
for m = 1:Np_imag
   R=R/spiralfactor;
   sarc=R*exp((a+j)*fi);
   x1=impoles(m)+imag(sarc(1));
   k=1;
   while (imag(s1(k)) < x1) k=k+1; end
   sarc(:)=sarc(:)+ j*impoles(m);
   s1=cat(1,s1(1:k-1),sarc.');
   x1=impoles(m)+imag(sarc(end));
   k=1;
   while (imag(s(k)) < x1) k=k+1; end
   s1=cat(1,s1,s(k:end));
end
s=s1;

%***********************************************

function [zplot,ncount] = nygraph(sys,s,plotdata)
% Preparing logarithmic polar plot data:
kmax=size(s); kmax=kmax(1);
for k=1:kmax zh(k)=evalfr(sys,s(k)); end
z=zh.';
absz = abs(z)+1e-14;
logabs = 20.*log10(absz);

%Avoiding plot continuing for |h0| < -120dB:
% the vector s is then truncated. 
for k=1:kmax
   if (logabs(k) <= -120) logabs(k) = -120; end
end
ncount=length(logabs);
while (logabs(ncount) <= -120) ncount=ncount-1; end
%From now on all vectors are ncount long; ncount <= size(s).

%Plotting the two conjugate halves of the polar curve;
logabsplot=logabs(1:ncount)./120.+1;
zplot=z(1:ncount).*logabsplot./absz(1:ncount);
if (plotdata)
   plot(zplot,'LineWidth',2.2);
else
   plot(zplot,'k--','LineWidth',1.7);
end

% ************************

function [ncirc,npoles_on_im_axis] = countencirc(zmirr,zmain)

% Counts net encirclements around the point -1.
% An encirclement is counted as positive if the direction
% is clockwise. This follows Belanger (1995):
% "Control Engeering", Saunders College Publishing,
% pp 206 - 208.
% 
% Bugs fixed and improvements made in Feb. 09:
% The function now also counts poles on the im-axis for the
% closed-loop system, if any. If such poles exist, this
% corresponds to the graph going through -1. 
% Encirclement counting is then impossible and is
% disabled.
% Another (small) bug fixed and improvements made in June 09

eps=1e-6;
zmirr(1:end)=zmirr(end:-1:1);
zmirr=zmirr(2:end-1);
zall=[zmirr;zmain;zmirr(1)];
if abs(imag(zall(1))) < eps 
    zall=[zall;zall(2)];
end
ncirc=0;
npoles_on_im_axis=0;
z3=zall(end);
for k=3:length(zall)
    z4=z3;
    z1=zall(k);z2=zall(k-1); z3=zall(k-2);
    abz1=abs(z1+1);abz2=abs(z2+1); abz3=abs(z3+1);
    zre1=real(z1); zre2=real(z2);
%   Checking if graph is too close to -1:
    dl1= fromline2minusone(z1,z2);
    dl2= fromline2minusone(z2,z3);
    dl3= fromline2minusone(z3,z4);
    closest_now = abz1 > abz2 && abz3 > abz2;
    if closest_now && min([dl1 dl2 dl3]) < 1e-5 ...
    && min([abz1 abz2 abz3])< 0.001
        npoles_on_im_axis=npoles_on_im_axis+1;
    end
%   end checking if graph is too close to -1.

% Only checking for Re axis crossings to the left 
% of minus 0.9 to avoid unnecessary work:
    if zre1 < -0.9
        zim1=imag(z1); zim2=imag(z2); zim3=imag(z3);
        if zim1*zim2 < 0
            % Interpolation to find real z value at crossing:
            delta12=(real(z1)-real(z2))*abs(imag(z2))/(abs(imag(z1))+abs(imag(z2)));
            realcross=real(z2)+delta12;
        end
        if zim1 > eps && zim2 < -eps
            if realcross < -1 
                ncirc=ncirc+1;% ncirc,z1, z2, z3
            end
        elseif zim1 < -eps && zim2 > eps
            if realcross < -1 
                ncirc=ncirc-1;% ncirc,z1, z2, z3
            end
        elseif abs(zim2) < eps && zim1 > 0 && zim3 < 0
            if real(z2) < -1 
                ncirc=ncirc+1;% ncirc,z1, z2, z3
            end
        elseif abs(zim2) < eps && zim3 > 0 && zim1 < 0
            if real(z2) < -1 
                ncirc=ncirc-1;% % ncirc,z1, z2, z3
            end
        else
        end
    end % real(z1) < -0.99
end

% ************************

function [dist] = mindist(point,vector,initdist)
% Calculates the minimum distance from a given complex number
% to a set of other complex numbers:
mdist = initdist;
kmax=length(vector);
for k=1:kmax
    d0=abs(vector(k)-point);
    if (d0 ~= 0) mdist = min(d0, mdist); end
end
dist=mdist;

% ************************

function nlgrid(absNdB)
% absNdB = [6 3 1 0.5 0.25 0 -0.5 -1 -3 -6]
absNdB = absNdB';
n=length(absNdB);
absN=10.^(absNdB/20);
radii=1./absN;
nangles=200;
angles=0:pi/nangles:2*pi;
angles=angles'; 
for k=1:n
   circ=-1.+radii(k).*(cos(angles)+j.*sin(angles));
   absc = abs(circ)+1e-14;
	logabs = 20.*log10(absc);
   for p=1:nangles
      if (logabs(p) <= -120) logabs(p) = -120; end
   end
   logabsplot=logabs./120.+1;
   cplot=circ.*logabsplot./absc;
   plot(cplot,'k-','LineWidth',0.5);
end

% ********************************

function [distline_to_minus1] = fromline2minusone(z1,z2)
% Calcucates the min. distance from the point -1 to the line z1,z2 
v=z2-z1;
v=imag(v)-i*real(v);
v=v/abs(z2-z1);
r=z1+1;
d=dot([real(v) imag(v)],[real(r) imag(r)]');
distline_to_minus1=abs(d);
% pointonline=-1-distline_to_minus1*v;

% ********************************