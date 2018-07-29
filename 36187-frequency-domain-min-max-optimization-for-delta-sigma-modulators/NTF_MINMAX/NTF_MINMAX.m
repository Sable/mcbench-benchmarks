function [ntf, Rf, gopt, diagn] = NTF_MINMAX(order, OSR, H_inf, f0, zf)
% [ntf, Rf, gopt, diagn] = NTF_MINMAX(order, OSR, H_inf, f0, zf)
%Synthesize a noise transfer function (NTF) for a lowpass or bandpass delta-sigma modulator
%by min-max optimization.
% Arguments:
%	order:  The order of NTF which is an FIR filter. 
%		The default value is order=32.
%	osr:    The over sampling ratio. 
%		The default value is OSR=32.
%	H_inf:  The maximum out-of-band gain of NTF. 
%		The default value is Hinf=1.5.
%	f0:     The normalized center frequency of the modulator. 
%		f0 must be in [0,1/2). 
%		The center frequency will be 2*pi*f0 (rad/sec). 
%		The default value is f0=0.
% 	zf:     The flag for assigning NTF zeros. 
%		If zf is 0, then the design is executed without zero assignment. 
%		Otherwise, zeros of the NTF to be optimized is assigned at the center frequency. 
%		The default value is zf=0.
%
% OUTPUTS:
%	ntf:	The optimized NTF given as a zpk object. See zpk.m
%	Rf:	FIR filter coefficients of the optimized loop filter R(z)
% NOTICE:
%	This function uses free toolboxes YALMIP and SeDuMi.
%	For YALMIP, see the following web page:
%		http://users.isy.liu.se/johanl/yalmip/
%	For SeDuMi, see
%		http://sedumi.ie.lehigh.edu/
%

switch nargin
    case 0
        order = 32;
        OSR = 32;
        H_inf = 1.5;
        f0 = 0;
        zf = 0;
    case 1
        OSR = 32;
        H_inf = 1.5;
        f0 = 0;
        zf = 0;
    case 2
        H_inf = 1.5;
        f0 = 0;
        zf = 0;
    case 3
        f0 = 0;
        zf = 0;
    case 4
        zf = 0;
end

% Maximum signal frequency
Omega = 1/OSR*pi;

% State space representation of R
A = [zeros(order-1,1) , eye(order-1) ; zeros(1,order)];
B = [zeros(order-1,1) ; 1];
D = [1];

% Definition of LMI's and LME's
if f0==0 %Lowpass delta-sigma modulator
    % LMI for gain optimization
    c = sdpvar(1,order);
    P = sdpvar(order, order, 'symmetric');
    Q = sdpvar(order, order, 'symmetric');
    g = sdpvar(1,1);
    M1 = A'*P*A+Q*A+A'*Q-P-2*Q*cos(Omega);
    M2 = A'*P*B + Q*B;
    M3 = B'*P*B-g;
    M = [M1,M2,c';M2',M3,1;c,1,-1];
    F = set([]);
    F = F + set(Q>0) + set(M<0);
    if zf==1 %Placing a zero at z=1
        F = F + set(sum(c)==-1);
    end
    if H_inf<inf %H-infinity norm condition of NTF for stability
        R = sdpvar(order,order,'symmetric');
        F = F + set(R>0) + set([A'*R*A-R, A'*R*B, c';B'*R*A, -H_inf^2+B'*R*B,1;c,1,-1]<=0);
    end
else %Bandpass delta-sigma modulator
    % LMI for gain optimization
    c = sdpvar(1,order);
    P = sdpvar(order, order, 'symmetric');
    Q = sdpvar(order, order, 'symmetric');
    g = sdpvar(1,1);
    M1r = A'*P*A+Q*A*cos(2*f0*pi)+A'*Q*cos(2*f0*pi)-P-2*Q*cos(Omega);
    M2r = A'*P*B + Q*B*cos(2*f0*pi);
    M3r = B'*P*B-g;
    M1i = A'*Q*sin(2*f0*pi)-Q*A*sin(2*f0*pi);
    M21i = -Q*B*sin(2*f0*pi);
    M22i = B'*Q*sin(2*f0*pi);
    Mr = [M1r,M2r,c';M2r',M3r,1;c,1,-1];
    Mi = [M1i, M21i, zeros(order,1);M22i, 0, 0; zeros(1,order),0,0];
    M = [Mr, Mi; -Mi, Mr];
    F = set([]);
    F = F + set(Q>0) + set(M<0);
    if zf==1 % Placing a zero at z=exp(j*2pi*f0)
        nn = (0:order-1)';
        vr = cos(2*pi*f0*nn);
        vi = sin(2*pi*f0*nn);
        vn = [-cos(2*pi*f0*order),-sin(2*pi*f0*order)];
        F = F + set(c*[vr,vi]==vn);
    end
    if H_inf<inf %H-infinity norm condition of NTF for stability
        R = sdpvar(order,order,'symmetric');
        F = F + set(R>0) + set([A'*R*A-R, A'*R*B, c';B'*R*A, -H_inf^2+B'*R*B,1;c,1,-1]<=0);
    end
end

% Solve LMI's and LME's
diagn=solvesdp(F+set(g>0),g,sdpsettings('solver','sedumi'));
Rf = [0,fliplr(double(c))];
NTFss = ss(A,B,double(c),D,1);
ntf = zpk(NTFss);
gopt = sqrt(double(g));
return;