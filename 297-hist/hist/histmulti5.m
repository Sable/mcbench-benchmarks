function [n,x,nbins]=histmulti5(y,bins)
% For multidimensional histograms for Matlab 5.
%
% [n,x,nbins]=histmulti5(y,bins)
%
% Every row in y represent a different data point and the columns
% are the different coordinates.
%
% For one-dimensional data you should use a column-vectors.
%
% bins: a rowvector => This is the number of bins in that coordinate.
% bins: a matrix => The lower limits for the different bins as produced in x.
%   Pad at end of the columns with NaN if different number of bins
%   in different coordinates (and unequal bins). 
% The upper limits are the lower limit for the next bound and inf for
% the last one.
%
%
% The default is that bins=[10 ... 10];
%
% Result:
%  n - a multidimensional vector with counts.
%  x - Corresponds to the bins-matrix (with NaN-padding if necessary).
%
% The algorithms are constructed to be very fast, and can be superior
% to hist even for one-dimensional histograms.
%
% It uses a mex-file to get good performance, and the first time it
% automatically compiles the mex-file. If you have trouble compiling
% c-files please compile the c-file by hand or erase it.
%
% Rewritten for Matlab 5 by Hans Olsson, Hans.Olsson@dna.lth.se
% Original Matlab 4 routine written by Hans Olsson, Hans.Olsson@dna.lth.se.
% Inspired by hist2 written by Kirill K. Pankratov, kirill@plume.mit.edu
% Which in turn was based on routines written by Hans.Olsson@dna.lth.se

% Handling of arguments.
if (nargin<1)
  help histmulti
  return
end;
if (nargin<2)
  bins=10*ones(1,size(y,2));
end;
if (length(bins)==1)
  bins=bins*ones(1,size(y,2));
end;
if (size(bins,2)~=size(y,2))
  error('Wrong number of bins in histmul5');
end;

% Transform elements into bin numbers.
if (size(bins,1)==1)
  % All bins have equal size.
  nbins=bins;
  mincol=min(y);
  maxcol=max(y);
  % Construct bin-width:
  binwidth=(maxcol-mincol)./bins;
  x=nan*zeros(max(bins),size(nbins,2));
  prodold=1;
  for col=1:size(bins,2)
    % Construct the bins:
    x(1:nbins(col),col)=(mincol(col)+(0:nbins(col)-1)*binwidth(col))';
    % Transform data into bins in this dimension.
    add=floor((y(:,col)-mincol(col))/binwidth(col));
    % Ensure that it is valid bin, we subtract in order to simplify
    % the next line.
    add=min(add,nbins(col)-1);
    % Make one bin-number:
    if (col==1) S=add; else S=S+add*prodold; end;
    prodold=prodold*nbins(col);
  end;
else
  global binorder;
  x=bins;
  nbins=sum(~isnan(bins));
  % Index used by tobinh:
  I=1:size(y,1);
  prodold=1;
  for col=1:size(bins,2);
    x0=x(1,col);
    dx=diff(x(1:nbins(col)));
    if (abs(dx-dx(1))<=dx(1)*eps)
      % Same size in this bin, make it faster:
      % We must here handle data outside all bins:
      add=floor((y(:,col)-x0)/dx(1));
      Ind=find((add<0)|(add>=nbins(col)));
      add(Ind)=nan*ones(size(Ind));
      binorder=add;
    else
      % Initialize binorder
      binorder=nan*ones(size(y,1),1);
      % run tobinh which stores the bin in the global variable binorder
      tobinh(y(:,col),I,x(:,col),1:nbins(col),nbins(col));
    end;
    % Make one bin-number
    if (col==1), S=binorder; else,S=S+binorder*prodold; end;
    prodold=prodold*nbins(col);
  end;
  S=S(~isnan(S));
end;

% Transform bin numbers into histograms.
S=S+1;
% Compute one-dimensional histogram for integers S in the range
% 1..prod(nbins)
% This is the core of the routine and for large datasets this should
% be optimized.

% We have a special mex-file, but if that routine is not available
% we use a one-liner with sparse.
global DO_HAVEHELP
global HAVE_WARNED
if (isempty(DO_HAVEHELP)|(DO_HAVEHELP<3))
  DO_HAVEHELP=exist('hist5hel');
  if ((DO_HAVEHELP<3)&(isempty(HAVE_WARNED))&(exist('hist5hel.c')))
    warning(['Please compile ',which('hist5hel.c'),', and: clear mex']);
    HAVE_WARNED=1;
  end;
end;
if (DO_HAVEHELP>=3)
  n=hist5hel(S,prod(nbins));
else
 n=full(sparse(S,1,1,prod(nbins),1));
end;


% Finally make the output into the right form, do nothing if one
% dimension because reshape requires two dimensions.
if (length(nbins)>1)
  n=reshape(n,nbins);
end;



function tobinh(y,I,x,binnr,nbins)
% Helper to place elements into bins.
% Place the y in different bins.
% The result is in the global variable binorder.
%
% We use binary search for the bins.
% Number of operations should be length(x)*log(nbins)*nbins
global binorder;
if (isempty(y)|(nbins==0))
  % Do nothing.
elseif (nbins==1)
  if (binnr==1)
    sel=y>=x(1);
    I=I(sel);
  end;
  binorder(I)=(binnr-1)*ones(size(I));
else
  i=fix(nbins/2);
  middle=x(binnr(i+1));
  sel=y<middle;
  tobinh(y(sel),I(sel),x,binnr(1:i),i);
  sel=y>=middle;
  tobinh(y(sel),I(sel),x,binnr(i+1:nbins),nbins-i);
end;
