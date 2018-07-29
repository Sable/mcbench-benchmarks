function s = fsa(x,interval,output,fopen_opt)
%FSA   Fourier Spectral Analysis
%   Uses FFT and returns amplitudes and phases of the Fourier
%   components.
%
%   Syntax:
%      S = FSA(X,INTERVAL,OUTPUT,OPT)
%
%   Inputs:
%      X   Series
%      INTERVAL   Data sampling interval (hour)
%      OUTPUT     Print(fid or filename)/show results
%                 [ {1} 0 <filename> ]
%      OPT        Permissions of fopen [ 'w' ]
%
%   Output:
%      S   Structure with result: .f .T .amp .pha (frequency, period,
%          amplitude and phase)
%
%   Example:
%      interval=.1;
%      t=0:interval:24*100;
%      A1 = 1;    Phi1 = 30; T1 = 12;
%      A2 = 2;    Phi2 = 80; T2 = 24;
%
%      y1 = A1*cos(2*pi*t/T1 - Phi1*pi/180);
%      y2 = A2*cos(2*pi*t/T2 - Phi2*pi/180);
%      y  = y1+y2;
%
%      s=fsa(y,interval);
%      figure
%      plot(s.T,s.amp), xlim([0 30]); grid
%
%   MMA 8-12-2002, martinho@fis.ua.pt
%
%   See also LSF, MAX_MIN

%   Department of Physics
%   University of Aveiro, Portugal

if nargin < 4
  fopen_opt='w';
end
if nargin < 3
  output=1;
end
if nargin < 2
  error('## x and interval are needed...')
end

%=====================================================================
% fft:
%=====================================================================
N=length(x);Ni=N;
N=N-mod(N,2);
n=N/2;
x=x(1:N);
y=fft(x);
a0 = y(1)/N;
a = 2*real(y)/N;
b = -2*imag(y)/N;
amp=sqrt(a.^2+b.^2);
pha=atan3(b,a);
f=(0:N-1)/(N*interval);

%=====================================================================

% data:
f=f(2:n+1);       %  FREQUENCY
T=1./f;           %  PERIOD
amp=amp(2:n+1)';  %  AMPLITUDE
pha=pha(2:n+1)';  %  PHASE

%=====================================================================

s.f   = reshape(f,length(f),1);
s.T   = reshape(T,length(T),1);
s.amp = reshape(amp,length(amp),1);
s.pha = reshape(pha,length(pha),1);
s.N   = Ni;
s.n   = n;
s.a0  = a0;

if output ~=0
%=====================================================================
% show results:
%=====================================================================
  % choose main components:
  [Max, Min]=max_min(s.amp,0);
  [I,J]=sort(Max.val);
  Mamp=Max.val(J);
  MT=s.T(Max.i(J));
  Mpha=s.pha(Max.i(J));
  disp_max=10;
  warn=0;

  if isstr(output)
    fid=fopen(output,fopen_opt);
  else
    fid=1;
  end

  fprintf(fid,'\n');
  fprintf(fid,'*******************************************\n');
  fprintf(fid,' Fourier Spectral Analysis\n');
  fprintf(fid,' Date: %s\n',datestr(now));
  fprintf(fid,' Serie Length: %d\n',N);
  fprintf(fid,' Interval: %2.2f h\n',interval);
  fprintf(fid,' Days: %2.2f\n',(N-1)*interval/24);
  fprintf(fid,' a0: %4.4f\n',s.a0);
  fprintf(fid,' Main signs\n');
  fprintf(fid,'-------------------------------------------\n');
  fprintf(fid,'    Period     Amp      Pha\n');

  for j=1:min(length(Max.i),disp_max)
    fprintf(fid,'%10.4f  %8.4f %10.4f\n', MT(end-j+1), Mamp(end-j+1), Mpha(end-j+1) );
  end

  fprintf(fid,'*******************************************\n');
  if isstr(output)
    fclose(fid);
  end

end

function teta = atan3(y,x)
%ATAN3   Inverse tangent [0:360[
%   Is the same as atan2(x,y)*180/pi, but with positive output.
%
%   Syntax:
%      TETA = ATAN3(Y,X)
%
%   Inputs:
%      Y, X   Same as in atan2
%
%   Output:
%      TETA   Angle (deg)
%
%   MMA 13-1-2003, martinho@fis.ua.pt

%   Department of Physics
%   University of Aveiro, Portugal

teta=atan2(y,x)*180/pi;
I=find(teta<0);
teta(I)=teta(I)+360;

function [Max, Min] = max_min(x,disp)
%MAX_MIN   Get extremes of series
%
%   Syntax:
%      [MAX,MIN] = MAX_MIN(X,DISP)
%
%   Inputs:
%      X      Vector to analyse
%      DISP   Show result in a plot (new figure) [ {0} | 1 ]
%
%   output:
%      MAX   Maximums structure with fields .i .val .iabs .abs
%            (indices, values, indice of absolute maximum, absolute
%            maximum)
%      MIN   Minimums structure with fields .i .val .iabs .abs
%            (indices, values, indice of absolute minimum, absolute
%            minimum)
%
%   Example:
%      x=[2 2 1 1 1 2 3 1 .5 1 1 1 .5 .5 .5 .7 .1 1 1 1 ];
%      [Max, Min]=max_min(x,1);
%      legend('x','max','min','abs max','abs min')
%
%   MMA 11-12-2002, martinho@fis.ua.pt

%   Department of Physics
%   University of Aveiro, Portugal

%   15-07-2003 - Works with nan (i=1)

if nargin == 1
  disp=0;
end

iMax=1; % to deal with NaNs
iMin=1;

n=length(x);
if  ~(n > 1)
  return
end
cmax=0;
cmin=0;

% at start:
if x(1) >= x(2)
  cmax=cmax+1;
  iMax(cmax)=1;
end
if x(1) <= x(2)
  cmin=cmin+1;
  iMin(cmin)=1;
end
% internal:
for i=2:n-1
  if x(i-1) <= x(i) & x(i+1) <= x(i)
    cmax=cmax+1;
    iMax(cmax)=i;
  end
  if x(i-1) >= x(i) & x(i+1) >= x(i)
    cmin=cmin+1;
    iMin(cmin)=i;
  end
end
% at end:
if x(end) >= x(end-1)
  cmax=cmax+1;
  iMax(cmax)=n;
end
if x(end) <= x(end-1)
  cmin=cmin+1;
  iMin(cmin)=n;
end
%»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
[a,b]=max(x);
iabs_max=find(x==a);
abs_max=x(iabs_max);

[a,b]=min(x);
iabs_min=find(x==a);
abs_min=x(iabs_min);

%»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
% build output:

Max.i    = iMax;
Max.val  = x(iMax);
Max.iabs = iabs_max;
Max.abs  = x(iabs_max);

Min.i    = iMin;
Min.val  = x(iMin);
Min.iabs = iabs_min;
Min.abs = x(iabs_min);

%»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
% graphics:
if disp
  figure
  plot(x,'-+')
  hold on
  plot(Max.i,Max.val,'r*')    % maximums
  plot(Min.i,Min.val,'bo')    % minimums
  plot(Max.iabs,Max.abs,'r^') % absolute maximum
  plot(Min.iabs,Min.abs,'b^') % absolute minimum
end
