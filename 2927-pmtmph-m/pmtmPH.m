%function [P,s,ci] = pmtmPH(x,dt,nw,qplot,nfft);
%
%Computes the power spectrum using the multi-taper method with adaptive weighting.
%
% Inputs:
%   x      - Input data vector.
%   dt     - Sampling interval, default is 1.
%   nw     - Time bandwidth product, acceptable values are
%            0:.5:length(x)/2-1, default is 3.  2*nw-1 dpss tapers
%            are applied except if nw=0 a boxcar window is applied 
%            and if nw=.5 (or 1) a single dpss taper is applied.
%   qplot  - Generate a plot: 1 for yes, else no.  
%   nfft   - Number of frequencies to evaluate P at, default is
%            length(x) for the two-sided transform. 
%
% Outputs:
%   P      - Power spectrum computed via the multi-taper method.
%   s      - Frequency vector.
%   ci     - 95% confidence intervals. Note that both the degrees of freedom
%            calculated by pmtm.m and chi2conf.m, which pmtm.m calls, are
%            incorrect.  Here a quick approximation method is used to
%            determine the chi-squared 95% confidence limits for v degrees
%            of freedom.  The degrees of freedom are close to but no larger
%            than (2*nw-1)*2; if the degrees of freedom are greater than
%            roughly 30, the chi-squared distribution is close to Gaussian.
%
%            The vertical ticks at the top of the plot indicate the size of
%            the full band-width.  The distance between ticks would remain
%            fixed in a linear plot.  For an accurate spectral estimate,
%            the true spectra should not vary abruptly on scales less than
%            the full-bandwidth.
%
%Other toolbox functions called: dpps.m; and if nfft does not equal length(x), czt.m
%
%Peter Huybers
%MIT, 2003
%phuybers@mit.edu


function [P,s,ci] = pmtmPH(x,dt,nw,qplot,nfft);

if nargin<1, %make red-noise with a periodic component.
  x=0; 
  for ct=2:500,
      x(ct)=.8*x(ct-1)+randn; 
  end;
  x=x/std(x)+sqrt(.5)*sin(2*pi*[1:500]/41+rand*2*pi)+sin(2*pi*[1:500]/100+rand*2*pi); 
end;

if nargin<2, dt=1; end;
if nargin<3, nw=3; end;
if nargin<4, qplot=1; end;
if nargin<5, nfft=length(x); end;
if nargin<6, cl=.95; end;

x   = x(:);
nx  = length(x);
k   = min(round(2*nw),nx); 
k   = max(k-1,1);
s   = 0:1/(nfft*dt):1/dt-1/(nfft*dt);
s   = s(:);
w   = nw/(dt*nx);       % half-bandwidth of the dpss

%Compute the discrete prolate spheroidal sequences
[E,V]=dpss(nx,nw,k);

%Compute the windowed DFTs.
if nx<=nfft
   Pk=abs(fft(E(:,1:k).*x(:,ones(1,k)),nfft)).^2;
else  %compute DFT on nfft evenly spaced samples around unit circle:
   Pk=abs(czt(E(:,1:k).*x(:,ones(1,k)),nfft)).^2; 
end

%Iteration to determine adaptive weights:    
   if k>1,
   sig2 = x'*x/nx;             % power
   P    = (Pk(:,1)+Pk(:,2))/2;   % initial spectrum estimate
   Ptemp= zeros(nfft,1);
   P1   = zeros(nfft,1);
   tol  = .0005*sig2/nfft;     % usually within 'tol'erance in about three iterations, see equations from [2] (P&W pp 368-370).   
   a    = sig2*(1-V);
   while sum(abs(P-P1)/nfft)>tol            
      b=(P*ones(1,k))./(P*V'+ones(nfft,1)*a'); % weights
      wk=(b.^2).*(ones(nfft,1)*V');            % new spectral estimate
      P1=(sum(wk'.*Pk')./ sum(wk'))';
      Ptemp=P1; P1=P; P=Ptemp;                 % swap P and P1
   end
   %Determine equivalent degrees of freedom, see p.  of Percival and Walden 1993.
   v=(2*sum((b.^2).*(ones(nfft,1)*V'),2).^2)./sum((b.^4).*(ones(nfft,1)*V.^2'),2);
   else, %simply the periodogram;
     P=Pk;
     v=2*ones(nfft,1);
   end;

%cut records
select=1:(nfft+1)/2+1;
P=P(select); 
s=s(select);
v=v(select);

%Chi-squared 95% confidence interval
%approximation from Chamber's et al 1983; also see Percival and Walden p.256, 1993
ci(:,1)=1./(1-2./(9*v)-1.96*sqrt(2./(9*v))).^3;
ci(:,2)=1./(1-2./(9*v)+1.96*sqrt(2./(9*v))).^3;

if qplot==1,
figure(1); clf; hold on;
cu=P(2:end).*ci(2:end,1);
cl=P(2:end).*ci(2:end,2);
%confidence interval
c=[.92 .92 .92];
h=fill([s(2); s(2:end); flipud([s(2:end); s(end)])],[cu(1); cl; flipud([cu; cl(end)])],c);
set(h,'edgecolor',c);
h=plot(s,P); set(h,'linewidth',2);
%bandwidth indicators
axis tight; h=axis; 
plot([s(2) h(2)],[h(4) h(4)],'k');
for ds=min(s):2*w:max(s);
  plot([ds ds],[h(4)/1.3 h(4)],'k');
end;
set(gca,'xscale','log'); set(gca,'yscale','log');
xlabel('frequency (cycles/deltat)')
ylabel('power density (units^2/cycle/deltat)');
end;

%-------------------------------------------------------Other Possibilities
%Can use stats toolbox chi2inv for a more accurate approx.
%if exist('chi2inv')>0,  % need the stats toolbox for chi2inv
%ci=2*k./[chi2inv((1-cl)/2,2*k) chi2inv(1-(1-cl)/2,2*k)]; % confidence intervals

%Code for non-adaptive weightings based on the eigen-value of each dpss 
%P = Pk*V/k;

%plot confidence interval for eigen-weighting
%axis tight; h=axis;
%x=(50*h(1)+h(2))/51;
%y=(100*h(3)+h(4))/101;
%plot([x x],y.*ci,'k');
%plot([x-w x+w],[y y],'k');
%plot(x,y,'k.');
%axis tight;