% Impulse response invariant discretization of fractional second
% order filter.
% 
% irid_fsof function is prepared to compute a discrete-time finite 
% dimensional (z) transfer function to approximate a continuous-time 
% fractional second order low-pass filter (LPF) [1/(s^2 + a*s + b)]^r, where "s" is 
% the Laplace transform variable; "r" is a real number in the range of 
% (0,1); a and b are the time constant of LPF [1/(s^2 + a*s + b)]^r, where a, b >= 0. 
%
% The proposed approximation keeps the impulse response "invariant"
%
% IN: 
%       a, b: the time constant of (the first order) LPF 
%             (a and b are arbitrary positive real numbers)
%       r: the fractional order in (0,1)
%       Ts: the sampling period
%       norder: the finite order of the approximate z-transfer function 
%       (the orders of denominator and numerator z-polynomial are the same)
% OUT: 
%       sr: returns the LTI object that approximates the [1/(s^2 + a*s + b)]^r
%           in the sense of invariant impulse response. 
% TEST CODE
% [sr]=irid_fsof(0.01,3,2,.8,5);
%
% Reference:  
%       (1) Yan Li, Hu Sheng and YangQuan Chen.
%           "Analytical Impulse Response of A Fractional Second Order Filter
%           and Its Impulse Response Invariant Discretization".
%       (2) YangQuan Chen. 
%           "Impulse-invariant discretization of fractional order low-pass filters".
%           Sept. 2008. CSOIS AFC (Applied Fractional Calculus) Seminar.
%           http://fractionalcalculus.googlepages.com/
% --------------------------------------------------------------------
% Yan Li, Ph.D, 
% School of Control Science and Engineering,
% Shandong University, Jinan, Shandong 250061, P. R. China.
% --------------------------------------------------------------------
%
% --------------------------------------------------------------------
% YangQuan Chen, Ph.D, Associate Professor and Graduate Coordinator
% Department of Electrical and Computer Engineering,
% Director, Center for Self-Organizing and Intelligent Systems (CSOIS)
% Utah State University, 4120 Old Main Hill, Logan, UT 84322-4120, USA
% E: yqchen@ece.usu.edu or yqchen@ieee.org, T/F: 1(435)797-0148/3054; 
% W: http://www.csois.usu.edu or http://yangquan.chen.googlepages.com 
% --------------------------------------------------------------------
%
%--------------------------------------------------------------------
% Hu Sheng, Ph.D, 
% Department of Electrical and Computer Engineering,
% Center for Self-Organizing and Intelligent Systems (CSOIS)
% Utah State University, 4120 Old Main Hill, Logan, UT 84322-4120, USA
% --------------------------------------------------------------------
% Note: All the codes were finished under the direction of Dr. YangQuan Chen.
%       The codes were writen by Dr. Yan Li and Hu Sheng,
%
% See also irid_fod.m 
%          at http://www.mathworks.com/matlabcentral/files/21342/irid_fod.m
%          irid_doi.m
%          at
%          http://www.mathworks.com/matlabcentral/fileexchange/
%          26380-impulse-response-invariant-discretization-of-distributed-order-integrator

%*************************************************************************
function [sr]=irid_fsof(Ts,a,b,r,norder)

if nargin<5; norder=5; end
if a < 0 | b < 0 , sprintf('%s','a and b constant has to be positive'), return, end
if Ts < 0 , sprintf('%s','Sampling period has to be positive'), return, end
if r>=1 | r<= 0, sprintf('%s','The fractional order should be in (0,1)'), return, end
if norder<2, sprintf('%s','The order of the approximate transfer function has to be greater than 1'), return, end
 
close all;
wmax0=2*pi/Ts/2;          % rad./sec. Nyquist frequency
wmax=floor(1+ log10(wmax0) ); 
wmin=wmax-5;  
w=logspace(wmin,wmax,1000);                 
j=sqrt(-1);
L=10/Ts;                  % decides the number of points of the impulse response function h(n)
t=[1:L]*Ts; y=[]; ht=[]; y1=[]; y2=[];

if a^2-4*b<0              % Case 1: a^2-4*b<0 
    for k=1:length(t)
        y1(k)=quad(@(tau)realconvolution((-a)/2,sqrt(-a^2+4*b)/2,r,tau,t(k)),0,t(k));
        y2(k)=quad(@(tau)imconvolution((-a)/2,sqrt(-a^2+4*b)/2,r,tau,t(k)),0,t(k));
    end
    ht=y1+y2;
elseif a^2-4*b==0         % Case2: a^2-4*b==0 
       ht = exp(-sqrt(b).*t).*t.^(2*r-1)/gamma(2*r);
else                      % Case 3: a^2-4*b>0
    for k=1:length(t)
       ht(k)=quadgk(@(x)integration2(x,a,b,r,t(k)),0,t(k));
    end
    s=(-a+sqrt(abs(a^2-4*b)))/2;
    ht= (exp(s.*t)/gamma(r)/gamma(r)).*ht;
end
h = [ht.*Ts];              % approcimation
q=norder;p=norder; 
[B,A]=stmcb((h),q,p); 
sprintf('Impulse response invariant Discrete approximated transfer function:')
sr=tf(B,A,Ts)        
hht=impulse(sr,t);         % approcimated impulse response
                           % frequency response 
srfr=(1./((j*w).^2 +a*j*w+b)).^(r);   
srfr1=freqresp(sr,w);      % approcimated frequency response

figure;
subplot(3,1,1)             % comparision of impulse response
plot(t,ht,'b');         
hold on;
plot(t,hht./Ts,'r-.')  
axis([Ts,Ts.*L,-0.5,1]);
xlabel('Time');ylabel('Impulse response');
grid on;
legend(['impulse response of 1/(s^2 + ',num2str(a), '* s +',num2str(b),' )^{',num2str(abs(r)),'}'],'approximated impulse response');

subplot(3,1,2)            % comparision of magnitude 
semilogx(w,20*log10(abs(srfr)),'b');hold on;                     
semilogx(w,20*log10(abs(reshape(srfr1, 1000, 1))),'r-.');   
legend(['mag. Bode of 1/(s^2 + ',num2str(a), '* s +',num2str(b),' )^{',num2str(abs(r)),'}'],'approximated mag. Bode');
xlabel('Frequency (Hz)');ylabel('Magnitude (dB)');grid on;

subplot(3,1,3)            % comparision of phase
semilogx(w,(180/pi) * (angle(srfr)),'b');hold on;
semilogx(w,(180/pi) * (angle(reshape(srfr1, 1000, 1))),'r-.');
grid on  
xlabel('Frequency (Hz)');ylabel('Phase (degrees)');
legend(['phase Bode of 1/(s^2 + ',num2str(a), '* s +',num2str(b),' )^{',num2str(abs(r)),'}'],'approximated phase Bode')

end

