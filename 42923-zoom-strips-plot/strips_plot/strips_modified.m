function strips_modified(x,sd,vstart,Fs,scale,color)
%STRIPS  Strip plot.
%   STRIPS(X) plots vector X in horizontal strips of length 250.
%   If X is a matrix, STRIPS(X) plots each column of X in horizontal
%   strips.  The left-most column (column 1) is the top horizontal strip.
%
%   STRIPS(X,N) plots vector X in strips that are each N samples long.
%
%   STRIPS(X,SD,vstart,Fs) plots vector X in horizontal strips of duration SD
%   seconds beginning at sample vstart given sampling frequency of Fs samples per second.
%
%   STRIPS(X,SD,vstart,Fs,SCALE) scales the vertical axes.
%
%   If X is a matrix, STRIPS(X,N), STRIPS(X,SD,vstart,Fs), and STRIPS(X,SD,vstart,Fs,SCALE)
%   plot the different columns of X on the same strip plot.
%
%   STRIPS ignores the imaginary part of X if it is complex.
%
%   See also PLOT, STEM.

%   Use the syntax strips(X(:),size(X,1),1,SCALE) to get the effect of
%   STRIPS(X) (where X is a matrix) with a SCALE paratmeter.

%   Mark W. Reichelt and Thomas P. Krauss  7-23-93
%   Copyright 1988-2002 The MathWorks, Inc.
%   $Revision: 1.7 $  $Date: 2002/03/28 17:31:01 $

error(nargchk(1,6,nargin))
if nargin == 1
  if isempty(x), return, end
  vstart=1;
  Fs = 1;
  scale = 1;
  color='k';
  [sd,c] = size(x);
  if min(sd,c) == 1
      sd = 250;
  end
  x = x(:);
else
  if nargin<3
      vstart=1;
      Fs = 1;
      scale=1;
      color='k';
  end
  if nargin<4
      Fs=1;
      scale = 1;
      color='k';
  end
  if nargin < 5
      scale = 1;
      color='k';
  end
  if (nargin < 6)
      color='k';
  end
  if isempty(x), return, end
  if min(size(x))==1, x = x(:); end   % turn vectors into columns
end

if any(imag(x)~=0), 
  disp('Warning: X vector complex.  I''m ignoring the imaginary part.')
  x = real(x);
end

perstrip = ceil(sd * Fs);	% strip duration * number of samples per second
len = size(x,1);                % number of rows
num_sigs = size(x,2);          % number of columns
if rem(len,perstrip) == 1	% leave off last point if it's a singleton
  len = len - 1;
  x = x(1:len,:);
end
num_strips = ceil(len/perstrip);

xmax = max(max( x(find(~isnan(x))) ));
xmin = min(min( x(find(~isnan(x))) ));
x0 = 0.5 * (xmin + xmax);
x0=0;

x = scale * x;

% add NaN's to the vector x
NaNind = len+1:perstrip*num_strips;
if ~isempty(NaNind)
    x(NaNind,:)=NaN*ones(length(NaNind),num_sigs);
end

% compute vertical deviation to add to x
del = 0.25 * (xmax-xmin);
sep = (xmax-xmin) + del;
if sep == 0, sep = 1; end
deviation = (num_strips-1:-1:0)*sep;

Y = zeros((perstrip+1)*num_strips,num_sigs);
for l = 1:num_sigs
    y = [reshape(x(:,l),perstrip,num_strips); NaN*ones(1,num_strips)];

    % add vertical deviation to x
    y = y - x0 + deviation(ones(perstrip+1,1),:);
    Y(:,l) = y(:);
end

% compute horizontal (time) axis
t = (0:perstrip-1)'/Fs;
t = t(:,ones(1,num_strips));
t(perstrip+1,:) = NaN + zeros(1,num_strips);
t = t(:);

% compute yticks and yticklabels
yt = (0:num_strips-1)*sep;   % ticks
width = 32;
s = setstr(ones(num_strips, width) * ' ');
col = width + 1;
for i = 1:num_strips
   str = num2str((i-1)*sd+vstart);
   s(i,width-length(str)+1:width) = str;
   col = min(col,width-length(str)+1);
end
s = flipud(s);
s = s(:,col:width);

% plot and set axes properties
newplot;
plot(t,Y,color,'LineWidth',2); 
set(gca,'xlim',[0 sd],'ylim',xmin-x0+[-del sep*num_strips],'ytick',yt,...
    'yticklabel',s,'ygrid','on')