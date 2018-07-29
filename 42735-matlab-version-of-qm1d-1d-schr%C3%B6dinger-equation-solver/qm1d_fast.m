% This routine do:
% 1. Discretize schrodinger equation over the specified set of points:
%     v(x)=2m*V(x)/hbar^2; ee=2m*E/hbar^2.
%     [    d^2       2m        ]           2m*E
%     [ - -----  + ------ V(x) ] phi(x) = ------  phi(x)
%     [   d x^2    hbar^2      ]          hbar^2
%
% 2. Find eigen values and eigen vectors.
% 3. Plot the found eigen values and eigen vectors.
%
% Usage:
% [ee,ev] = qm1d_fast(NPTS,NSTM,a,b,f_pot_handle)
% NPTS - number of points for discretization of schrodinger equation
% NSTM - number of eigen values and eigen vector to find
% a - the start point of te interval for x
% b - the end point of the interval for y
% f_pot_handle - handle to function which defines the potential
%
% Examples:
%
% 1. Harmonic oscillator - symetric at x=L/2
% NPTS=1000;
% NSTM=5;
% L=10d0;
% f_pot = @(x) {4d0*(x-L/2).^2}; 
% qm1d_fast(NPTS,NSTM,0,L,f_pot);
% 
% 2. Harmonic oscillator - symetric at x=0
% NPTS=1000;
% NSTM=5;
% L=10d0;
% f_pot = @(x) {4d0*x.^2}; 
% qm1d_fast(NPTS,NSTM,-L/2,L/2,f_pot);
%
% 3. Barrier - defined with heaviside function
% NPTS=1000;
% NSTM=5;
% L=100d0;
% bb=3d0;
% aa=1d0;
% f_pot = @(x) {heaviside(x-aa)-heaviside(x-bb)};
% qm1d_fast(NPTS,NSTM,0,L,f_pot);
%
% If you don't have heaviside defined in your Matlab version define this function as:
% function [y]=heaviside(x)
% y=zeros(1,length(x))
% ipos = find(x>0);
% y(ipos)=1;
%
% 4.Barrier
% NPTS=1000;
% NSTM=5;
% L=100d0;
% bb=3d0;
% aa=1d0;
% pot_dat = [zeros(1,int16(aa/L*NPTS)), ones(1,int16((bb-aa)/L*NPTS)),  zeros(1,int16((L-bb)/L*NPTS))];
% f_pot = @(x) {pot_dat(int16(x/L*(NPTS-1)))};
% qm1d_fast(NPTS,NSTM,0,L,f_pot);
% 
% 5. Harmonic oscillator - with potential defined in file
% Define the potential in file: 
% NPTS=1000;
% L=10d0;
% dx=L/(NPTS-1);
% pot_dat=[[0:NPTS-1]*dx; 4d0*([0:NPTS-1]-((NPTS-1)/2)).^2*dx^2]';
% save('pot.dat','-ascii','pot_dat');
% clear
%
% pot_dat=load('pot.dat');
% f_pot = @(x) {spline(pot_dat(:,1),pot_dat(:,2),x)};
% %It is not obligatory the NPTS to be the same as the number of points for the potential
% NPTS=10000; 
% NSTM=5;
% L=10d0;
% qm1d_fast(NPTS,NSTM,0,L,f_pot);
%
%
% See also: http://iffwww.iff.kfa-juelich.de/~ekoch/DFT/qm1d.html
function [ee,ev] = qm1d_fast(NPTS,NSTM,a,b,f_pot_handle)
%pot_dat=load(pot_filename);
j=1:NPTS; % indexes for main diagonal
L=b-a;
h=L/(NPTS-1); % space step
x=j*h+a;
V=cell2mat(f_pot_handle(x));

main_diag=2/h^2+V(j);
sub_diag=-1/h^2*ones(1,NPTS-1);

[ee,ev] = trideigs(main_diag,sub_diag,'I',1,NSTM);

% average spacing of energy levels (for adjusting scale of ev)
de0=(ee(NSTM)-ee(1))/(NSTM-1);

% plot potential
plot(x,V(j),'r'); hold on;

% plot eign vectors
de=0.15*sqrt(NPTS)*de0;
for n=1:NSTM
    plot(x,ee(n)+de*ev(:,n)); hold on;
    plot(x,ones(length(j),1)*ee(n)); hold on;
end

% set up plotting options
xlim([0 NPTS]*h+a); ylim([min(V) ee(NSTM)+de0]);
