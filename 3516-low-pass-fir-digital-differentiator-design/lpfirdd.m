%---------------------------------------------------------
% Low-pass FIR digital differentiator (LPFIRDD) design   -
% via constrained quadratic programming (QP)             -
% [Copt,c]=lpfirdd(N,alpha,beta,r,idraw)                 - 
% By Dr Yangquan Chen		019-07-1999                   -
% Email=<yqchen@ieee.org>; URL=http://www.crosswinds.net/~yqchen/
% -------------------------------------------------------- 
% LPFIRDD: only 1st order derivative estimate
% total taps=2N. c(i)=-c(i+N+1); c(N+1)=0 (central point)
%
%          -N      -N+1            -1                    N
% FIR=c(1)z   +c(2)z    +...+ c(N)z  + 0 + ... + c(2N+1)z
%
%       N
%     ------
%     \                    j   -j
%      >       Copt(j) * (z - z  )
%     /
%     ------
%      j=1
% N: Taps  (N=2, similar to sgfilter(2,2,1,1)
% alpha ~ beta: transit band of frequency 
%				    (in percentage of Nyquest freq)
% r: the polynomial order. r<=N Normally, set it to 1.
%---------------------------------------------------------------
function [Copt,bd]=lpfirdd(N,alpha,beta,r,idraw)
% testing parameters
% alpha=1./pi;beta=1.5/pi;N=10;r=1;idraw=1;
if (alpha>beta)
   disp('Error in alpha (alpha<=beta)');return;
end
if ((beta>1) | (beta <0)) 
   disp('Error in Beta! (beta in [0,1]');return;
end
if ((alpha>1) | (alpha <0)) 
   disp('Error in Alpha! (Alpha in [0,1]');return;
end
% default r=1
if (r<1); r=1; end 
% matrix W
W=zeros(r,N);
for ix=1:N;for jx=1:r;
      W(jx,ix)=ix^(2*jx-1);
end;end
%matrix L
L=zeros(N,1);
if (beta>alpha)
	for ix=1:N
	   L(ix)=(alpha*sin(ix*beta*pi)-beta*sin(ix*alpha*pi))/ix/ix/(beta-alpha);
	end
elseif (beta==alpha)
	for ix=1:N
	   L(ix)=(ix*alpha*pi*cos(ix*alpha*pi)-sin(ix*alpha*pi))/ix/ix;
	end
end   
% matrix e
ex=zeros(r,1);ex(1)=1;
% optimal solution
Copt=W'*inv(W*W')*(ex + 2.*W*L/pi)-2.*L/pi
Copt=Copt/2;
% fr plots
if (idraw==1)
   bd=[-fliplr(Copt'),0,Copt']';
	%ad=1;sys_sg=tf(bd',ad,1./Fs);bode(sys_sg)
	Fs=12790;nL=N;nR=N;npts=1000;%w=logspace(0,4,npts);
	w=((1:npts)-1)*pi/npts;
	j=sqrt(-1);ejw=zeros(nL+nR+1,npts);
	for ix=(-nL:nR)
		ejw(ix+nL+1,:)=exp(j*ix*w); 
	end
	freq=bd'*ejw;
	figure;subplot(2,1,1)
	plot(w/pi*Fs/2,(abs(freq)));grid on;
	hold on; ax=axis;ax(2)=Fs/2;axis(ax);
	xlabel('freq. (Hz)');ylabel('amplitude (dB)');
	subplot(2,1,2)
	plot(w/pi*Fs/2,180*(angle(freq))/pi );grid on;
	hold on; ax=axis;ax(2)=Fs/2;axis(ax);
   xlabel('freq. (Hz)');ylabel('phase anlge (deg.)');
   
	figure;subplot(2,1,1);Fs=12600; % Hz for U8
	semilogx(w*Fs/pi/2,20*log10(abs(freq)));grid on;
	hold on; ax=axis;ax(2)=Fs/2;axis(ax);
	semilogx([Fs/2,Fs/2],[ax(3),ax(4)],'o-r');grid on;
	xlabel('freq. (Hz)');ylabel('amplitude (dB)');
	subplot(2,1,2)
	semilogx(w*Fs/pi/2,180*(angle(freq))/pi );grid on;
	hold on; ax=axis;ax(2)=Fs/2;axis(ax);
	semilogx([Fs/2,Fs/2],[ax(3),ax(4)],'o-r');grid on;
	xlabel('freq. (Hz)');ylabel('phase anlge (deg.)');
end
return
 
