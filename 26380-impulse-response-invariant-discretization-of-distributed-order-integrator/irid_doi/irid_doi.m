% Impulse response invariant discretization of distributed order integrator
% 
% irid_doi function is prepared to compute a discrete-time finite 
% dimensional (z) transfer function to approximate a distributed order 
% integrator  int(1/s^r,r,a,b), where "s" is the Laplace transform
% variable. Where 'a' and 'b' are arbitrary real numbers in the range of 
% (0.5,1), and a<b. 'p' and 'q' are integer and p>=q.
%
% The proposed approximation keeps the impulse response "invariant"
%
% IN: 
%       Ts: The sampling period
%       a : Lower limit of integral
%       b : Upper limit of integral
%       p : Denominator order of the approximate z-transfer function
%       q : Numerator order of the approximate z-transfer function
%
% OUT: 
%       sr: returns the LTI object that approximates the int(1/s^r,r,a,b)
%           in the sense of invariant impulse response. 
% TEST CODE
% doi=irid_doi(0.001,0.75,1,5,5);
%
% Reference: (1) Yan Li, Hu Sheng and YangQuan Chen. 
%               "On the Distributed Order Integrator".
%            (2) YangQuan Chen. 
%               "Impulse-invariant discretization of fractional order low-pass filters".
%                Sept. 2008. CSOIS AFC (Applied Fractional Calculus) Seminar.
%                http://fractionalcalculus.googlepages.com/
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
%       The code integrand.m was writen by Dr. Yan Li,
%       The code irid_doi.m was writen by Hu Sheng,
%
% See also irid_fod.m 
%          at http://www.mathworks.com/matlabcentral/files/21342/irid_fod.m
% See also srid_fod.m 
%          (See how the nonminimum phase zeros are handled)


function [sr]=irid_doi(Ts,a,b,p,q)

if nargin<4; p=5,q=5; end
if p<3 | q<3, sprintf('%s','The order of the approximate transfer function should be greater than 2'), return,end
if p<q, sprintf('%s','The denominator order of the approximate z-transfer function should be greater than or equal to the Numerator'), return, end
if Ts <= 0 , sprintf('%s','Sampling period has to be positive'), return, end
if a<=0.5 | a>1 | b<=0.5 | b>1, sprintf('%s','The fractional order should be in (0.5,1)'), return, end
if a>=b, sprintf('%s','The Upper limit of integral should be greater than the Lower limit of integral'), return, end

close all;
wmax0=2*pi/Ts/2;           % rad./sec. Nyquist frequency
L=1/Ts;                    % decides the number of points of the impulse response function h(n)
t=[0:L-1]*Ts;
ht=[];
for k=1:length(t)          % impulse response
    ht(k)=quadgk(@(x)integrand(a,b,t(k),x),0,inf);
end
h=[ht(2:end).*Ts];         % approcimation
[B,A]=stmcb((h),q,p);
sprintf('Impulse response invariant Discrete approximated transfer function:')
sr = tf(B,A,Ts)
hht=impulse(sr,t);         % approcimated impulse response

wmax=floor(log10(wmax0))+1; wmin=wmax-5; 
w=logspace(wmin,wmax,1000);                  
j=sqrt(-1);
                           % frequency response of distributed order
srfr=((j.*w).^(-a)-(j.*w).^(-b))./log(j.*w); 
srfr1=freqresp(sr,w);      % approcimated frequency response

figure;
subplot(3,1,1)             % comparision of impulse response
plot(t,ht,'b');         
hold on
plot(t,hht./Ts,'r-.')  
axis([Ts,Ts.*L,0,1]);
xlabel('Time');ylabel('Impulse response');
grid on;
legend('impulse response of \int_a^b{s^{-\alpha}}d\alpha','approximated impulse response');

subplot(3,1,2)            % comparision of magnitude 
semilogx(w,20*log10(abs(srfr)),'b');hold on;                     
semilogx(w,20*log10(abs(reshape(srfr1, 1000, 1))),'r-.');   
legend('mag. Bode of \int_a^b{s^{-\alpha}}d\alpha','approximated mag. Bode');
xlabel('Frequency (Hz)');ylabel('Magnitude (dB)');grid on;

subplot(3,1,3)            % comparision of phase
semilogx(w,(180/pi) * (angle(srfr)),'b');hold on;
semilogx(w,(180/pi) * (angle(reshape(srfr1, 1000, 1))),'r-.');
grid on  
xlabel('Frequency (Hz)');ylabel('Phase (degrees)');
legend('phase Bode of \int_a^b{s^{-\alpha}}d\alpha','approximated phase Bode')

end





