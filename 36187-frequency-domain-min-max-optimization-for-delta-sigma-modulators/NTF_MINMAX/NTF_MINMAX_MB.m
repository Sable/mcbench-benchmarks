function [ntf, Rf, gopt, diagn] = NTF_MINMAX_MB(order, OSR, H_inf, f, zf)
% [ntf, Rf, gopt, diagn] = NTF_MINMAX_MB(order, OSR, H_inf, f, zf)
%Synthesize a noise transfer function (NTF) for a lowpass or bandpass delta-sigma modulator
%by min-max optimization.
% Arguments:
%	order:  The order of NTF which is an FIR filter.
%		The default value is order=32.
%	osr:    The over sampling ratio.
%		The default value is OSR=32.
%	H_inf:  The maximum out-of-band gain of NTF.
%		The default value is Hinf=1.5.
%	f:     The vecotr of normalized center frequencies of the modulator.
%		f=[f1,f2,...,f4] (the max size of f is limited to 4)
%       The element fi must be in [0,1/2).
%		The center frequency will be 2*pi*fi (rad/sec).
%		The default value is f=[0,1/4].
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
        f = [0,1/4];
        zf = 0;
    case 1
        OSR = 32;
        H_inf = 1.5;
        f = [0,1/4];
        zf = 0;
    case 2
        H_inf = 1.5;
        f = [0,1/4];
        zf = 0;
    case 3
        f = [0,1/4];
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
% LMI for gain optimization
F = set([]);
c = sdpvar(1,order);
g = [];

NN = length(f);

if NN>=1
    f0=f(1);
    if f0==0; %Lowpass delta-sigma modulator
        P1 = sdpvar(order, order, 'symmetric');
        Q1 = sdpvar(order, order, 'symmetric');
        g1 = sdpvar(1,1);
        M11 = A'*P1*A+Q1*A+A'*Q1-P1-2*Q1*cos(Omega);
        M12 = A'*P1*B + Q1*B;
        M13 = B'*P1*B-g1;
        M1 = [M11,M12,c';M12',M13,1;c,1,-1];
        F = F + set(Q1>0) + set(M1<0);
        if zf==1 %Placing a zero at z=1
            F = F + set(sum(c)==-1);
        end
    else %Bandpass delta-sigma modulator
        P1 = sdpvar(order, order, 'symmetric');
        Q1 = sdpvar(order, order, 'symmetric');
        g1 = sdpvar(1,1);
        M1r = A'*P1*A+Q1*A*cos(2*f0*pi)+A'*Q1*cos(2*f0*pi)-P1-2*Q1*cos(Omega);
        M2r = A'*P1*B + Q1*B*cos(2*f0*pi);
        M3r = B'*P1*B-g1;
        M1i = A'*Q1*sin(2*f0*pi)-Q1*A*sin(2*f0*pi);
        M21i = -Q1*B*sin(2*f0*pi);
        M22i = B'*Q1*sin(2*f0*pi);
        Mr = [M1r,M2r,c';M2r',M3r,1;c,1,-1];
        Mi = [M1i, M21i, zeros(order,1);M22i, 0, 0; zeros(1,order),0,0];
        M1 = [Mr, Mi; -Mi, Mr];
        F = F + set(Q1>0) + set(M1<0);
        if zf==1 % Placing a zero at z=exp(j*2pi*f0)
            nn = (0:order-1)';
            vr = cos(2*pi*f0*nn);
            vi = sin(2*pi*f0*nn);
            vn = [-cos(2*pi*f0*order),-sin(2*pi*f0*order)];
            F = F + set(c*[vr,vi]==vn);
        end
    end
    g=[g,g1];
end
if NN>=2
    f0=f(2);
    if f0==0; %Lowpass delta-sigma modulator
        P2 = sdpvar(order, order, 'symmetric');
        Q2 = sdpvar(order, order, 'symmetric');
        g2 = sdpvar(1,1);
        M11 = A'*P2*A+Q2*A+A'*Q2-P2-2*Q2*cos(Omega);
        M12 = A'*P2*B + Q2*B;
        M13 = B'*P2*B-g2;
        M1 = [M11,M12,c';M12',M13,1;c,1,-1];
        F = F + set(Q2>0) + set(M2<0);
        if zf==1 %Placing a zero at z=1
            F = F + set(sum(c)==-1);
        end
    else %Bandpass delta-sigma modulator
        P2 = sdpvar(order, order, 'symmetric');
        Q2 = sdpvar(order, order, 'symmetric');
        g2 = sdpvar(1,1);
        M1r = A'*P2*A+Q2*A*cos(2*f0*pi)+A'*Q2*cos(2*f0*pi)-P2-2*Q2*cos(Omega);
        M2r = A'*P2*B + Q2*B*cos(2*f0*pi);
        M3r = B'*P2*B-g2;
        M1i = A'*Q2*sin(2*f0*pi)-Q2*A*sin(2*f0*pi);
        M21i = -Q2*B*sin(2*f0*pi);
        M22i = B'*Q2*sin(2*f0*pi);
        Mr = [M1r,M2r,c';M2r',M3r,1;c,1,-1];
        Mi = [M1i, M21i, zeros(order,1);M22i, 0, 0; zeros(1,order),0,0];
        M2 = [Mr, Mi; -Mi, Mr];
        F = F + set(Q2>0) + set(M2<0);
        if zf==1 % Placing a zero at z=exp(j*2pi*f0)
            nn = (0:order-1)';
            vr = cos(2*pi*f0*nn);
            vi = sin(2*pi*f0*nn);
            vn = [-cos(2*pi*f0*order),-sin(2*pi*f0*order)];
            F = F + set(c*[vr,vi]==vn);
        end
    end
    g=[g,g2];
end
if NN>=3
    f0=f(3);
    if f0==0; %Lowpass delta-sigma modulator
        P3 = sdpvar(order, order, 'symmetric');
        Q3 = sdpvar(order, order, 'symmetric');
        g3 = sdpvar(1,1);
        M11 = A'*P3*A+Q3*A+A'*Q3-P3-2*Q3*cos(Omega);
        M12 = A'*P3*B + Q3*B;
        M13 = B'*P3*B-g3;
        M3 = [M11,M12,c';M12',M13,1;c,1,-1];
        F = F + set(Q3>0) + set(M3<0);
        if zf==1 %Placing a zero at z=1
            F = F + set(sum(c)==-1);
        end
    else %Bandpass delta-sigma modulator
        P3 = sdpvar(order, order, 'symmetric');
        Q3 = sdpvar(order, order, 'symmetric');
        g3 = sdpvar(1,1);
        M1r = A'*P3*A+Q3*A*cos(2*f0*pi)+A'*Q3*cos(2*f0*pi)-P3-2*Q3*cos(Omega);
        M2r = A'*P3*B + Q3*B*cos(2*f0*pi);
        M3r = B'*P3*B-g3;
        M1i = A'*Q3*sin(2*f0*pi)-Q3*A*sin(2*f0*pi);
        M21i = -Q3*B*sin(2*f0*pi);
        M22i = B'*Q3*sin(2*f0*pi);
        Mr = [M1r,M2r,c';M2r',M3r,1;c,1,-1];
        Mi = [M1i, M21i, zeros(order,1);M22i, 0, 0; zeros(1,order),0,0];
        M3 = [Mr, Mi; -Mi, Mr];
        F = F + set(Q3>0) + set(M3<0);
        if zf==1 % Placing a zero at z=exp(j*2pi*f0)
            nn = (0:order-1)';
            vr = cos(2*pi*f0*nn);
            vi = sin(2*pi*f0*nn);
            vn = [-cos(2*pi*f0*order),-sin(2*pi*f0*order)];
            F = F + set(c*[vr,vi]==vn);
        end
    end
    g=[g,g3];
end
if NN>=4
    f0=f(4);
    if f0==0; %Lowpass delta-sigma modulator
        P4 = sdpvar(order, order, 'symmetric');
        Q4 = sdpvar(order, order, 'symmetric');
        g4 = sdpvar(1,1);
        M11 = A'*P4*A+Q4*A+A'*Q4-P4-2*Q4*cos(Omega);
        M12 = A'*P4*B + Q4*B;
        M13 = B'*P4*B-g4;
        M4 = [M11,M12,c';M12',M13,1;c,1,-1];
        F = F + set(Q4>0) + set(M4<0);
        if zf==1 %Placing a zero at z=1
            F = F + set(sum(c)==-1);
        end
    else %Bandpass delta-sigma modulator
        P4 = sdpvar(order, order, 'symmetric');
        Q4 = sdpvar(order, order, 'symmetric');
        g4 = sdpvar(1,1);
        M1r = A'*P4*A+Q4*A*cos(2*f0*pi)+A'*Q4*cos(2*f0*pi)-P4-2*Q4*cos(Omega);
        M2r = A'*P4*B + Q4*B*cos(2*f0*pi);
        M3r = B'*P4*B-g4;
        M1i = A'*Q4*sin(2*f0*pi)-Q4*A*sin(2*f0*pi);
        M21i = -Q4*B*sin(2*f0*pi);
        M22i = B'*Q4*sin(2*f0*pi);
        Mr = [M1r,M2r,c';M2r',M3r,1;c,1,-1];
        Mi = [M1i, M21i, zeros(order,1);M22i, 0, 0; zeros(1,order),0,0];
        M4 = [Mr, Mi; -Mi, Mr];
        F = F + set(Q4>0) + set(M4<0);
        if zf==1 % Placing a zero at z=exp(j*2pi*f0)
            nn = (0:order-1)';
            vr = cos(2*pi*f0*nn);
            vi = sin(2*pi*f0*nn);
            vn = [-cos(2*pi*f0*order),-sin(2*pi*f0*order)];
            F = F + set(c*[vr,vi]==vn);
        end
    end
    g=[g,g4];
end

if H_inf<inf %H-infinity norm condition of NTF for stability
    R = sdpvar(order,order,'symmetric');
    F = F + set(R>0) + set([A'*R*A-R, A'*R*B, c';B'*R*A, -H_inf^2+B'*R*B,1;c,1,-1]<=0);
end

% Solve LMI's and LME's
diagn=solvesdp(F+set(g>0),g*g',sdpsettings('solver','sedumi'));
%diagn
Rf = [0,fliplr(double(c))];
NTFss = ss(A,B,double(c),D,1);
ntf = zpk(NTFss);
gopt = sqrt(double(g));
return;