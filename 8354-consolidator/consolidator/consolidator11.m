function [xcon,ycon] = consolidator13(x,y,aggregation_mode,tol,tolerance_style)
% consolidator: consolidate "replicates" in x, also aggregate corresponding y
% usage: [xcon,ycon] = consolidator13(x,y,aggregation_mode,tol,tolerance_style)
%
% arguments: (input)
%  x - rectangular array of data to be consolidated. If multiple (p)
%      columns, then each row of x is interpreted as a single point in a
%      p-dimensional space. (x may be character, in which case xcon will
%      be returned as a character array.)
%
%      x CANNOT be complex. If you do have complex data, split it into
%      real and imaginary components as columns of an array.
%
%      If x and y are both ROW vctors, they will be transposed and
%      treated as single columns.
%
%  y - outputs to be aggregated. If y is not supplied (is left empty)
%      then consolidator is similar to unique(x,'rows'), but with a
%      tolerance on which points are distinct. (y may be complex)
%
%      y MUST have the same number of rows as x.
%
%  aggregation_mode - (OPTIONAL) character flag, denotes the method
%      to be used in the aggregation of elements of y. If y was
%      left empty, then aggregation_mode is ignored. Contractions
%      are allowed and capitalization is ignored.
%
%      DEFAULT: 'mean'
%
%      'mean'  --> compute the average y for each consolidated x
%      'sum'   --> compute the sum of y for each consolidated x
%      'min'   --> compute the minimum y for each consolidated x
%      'max'   --> compute the maximum y for each consolidated x
%      'std'   --> compute the standard deviation of y for each x
%      'var'   --> compute the variance of y for each x
%      'prod'  --> compute the product of y for each consolidated x
%      'geom'  --> compute the geometric mean at each consolidated x
%      'harm'  --> compute the harmonic mean at each consolidated x
%      'median' --> compute the median at each consolidated x
%      'count' --> compute the # of consolidated elements 7at each x
%
%      Note: 'count' only returns 1 column, regardless
%      of the size of y. All other operations operate on
%      each column of y independently.
%
%  tol - (OPTIONAL) tolerance to identify replicate elements of x. If
%      x has multiple columns, then the same tolerance is applied to
%      all columns of x.
%
%      DEFAULT (if tolerance_style is 'absolute'): 0
%      DEFAULT (if tolerance_style is 'relative'): 1.e-12
%
%      Note: Tolerances are a complicated thing, especially in
%      higher dimensions and when trying to do it effficiently for
%      high numbers of data points. A complete interpoint distance
%      matrix would be the proper way to do t, but for many thousands
%      of points it would use too much memory. One also has the problem
%      of transitivity. If A is within tol of B, and B is within tol
%      of C, then is A near enough to C? If not, then how is the
%      consolidation to be done? So please view these tolerances
%      with some tolerance of your own.
%
%      Note: relative tolerances near 1 are not meaningful.
%
% tolerance_style - (OPTIONAL) character flag, denotes whether
%      the tolerance criterion is absolute over all columns or
%      a relative tolerance within a single column of x.
%
%      Note: DO NOT use a relative tolerance of 0, nor greater
%      than 1. Even a relative tolerance near 1 is not meaningful.
%
%      DEFAULT: 'absolute'
%
%      'relative' --> Tol is a relative tolerance between the
%         minimum and maximum of each column of x.
%
%      'absolute' --> look for differences of size tol in any
%         column of x.
%
%  
% arguments: (output)
%  xcon - consolidated x. Replicates wthin the tolerance are removed.
%      if no y was specified, then consolidation is still done on x.
%
%  ycon - aggregated value as specified by the aggregation_mode.
%
%
% Example usages:
%
% Group means:
%  x = round(rand(1000,1)*5);
%  y = x+randn(size(x));
%  [xg,yg] = consolidator(x,y,'mean');
%  [xg,yg]
%  ans =
%         0    0.1668
%    1.0000    0.9678
%    2.0000    2.0829
%    3.0000    2.9688
%    4.0000    4.0491
%    5.0000    4.8852
%
% Group counts on x
%  x = round(randn(100000,1));
%  [xg,c] = consolidator(x,[],'count');
%  [xg,c]
%  ans =
%         -4          26
%         -3         633
%         -2        5926
%         -1       24391
%          0       38306
%          1       24156
%          2        5982
%          3         559
%          4          21
% Unique(x,'rows'), but with a tolerance
%  x = rand(100,2);
%  xc = consolidator(x,[],[],.05);
%  size(xc)
%  ans =
%      62     2
%
% See also: unique
%
% Author: John D'Errico
% e-mail address: woodchips@rochester.rr.com
% Release: 3
% Release date: 5/2/06

% is it a character array?
if ischar(x)
  charflag = 1;
  x=double(x);
else
  charflag = 0;
end

% check for/supply defaults
if (nargin<5) | isempty(tolerance_style)
  tolerance_style = 'absolute';
else
  tolerance_style = lower(tolerance_style);
end

if (nargin<4) | isempty(tol)
  switch tolerance_style
    case 'absolute'
      tol = 0;
    case 'relative'
      tol = 1.e-12;
    otherwise
      error 'tolerance_style must be either ''absolute'' or ''relative'''
  end
end
if (tol<0) & strcmp(tolerance_style,'absolute')
  error 'Absolute tolerance must be non-negative.'
elseif (tol<=0) & strcmp(tolerance_style,'relative')
  error 'Absolute tolerance must be non-negative.'
end
tol = tol*(1+10*eps);

if (nargin<3) | isempty(aggregation_mode)
  aggregation_mode = 'mean';
else
  aggregation_mode = lower(aggregation_mode);
end
valid_agmode = {'mean' 'sum' 'min' 'max' 'std' ...
  'var' 'prod' 'geom' 'harm' 'count' 'median'};
k = strmatch(aggregation_mode,valid_agmode);
if isempty(k)
  error 'Invalid aggregation_mode'
else
  aggregation_mode = valid_agmode{k};
end

% was y supplied, or empty?
[n,p] = size(x);
if (nargin<2) | isempty(y)
  y = zeros(n,0);
end
% check for mismatch between x and y
[junk,q] = size(y);
if n~=junk
  error 'y must have the same number of rows as x.'
end

% are both x and y row vectors?
if (n == 1)
  x=x';
  n = length(x);
  p = 1;
  
  if ~isempty(y)
    y=y';
  else
    y=zeros(n,0);
  end
  
  q = size(y,2);
end

if isempty(y)
  aggregation_mode = 'count';
end

% consolidate elements of x.
% first shift, scale, and then round up. 
switch tolerance_style
  case 'absolute'
    if tol>0
      xhat = x - repmat(min(x,[],1),n,1)+tol*eps;
      xhat = ceil(xhat/tol);
    else
      xhat = x;
    end
  case 'relative'
    xhat = x - repmat(min(x,[],1),n,1)+tol*eps;
    xhat = ceil(xhat*diag(1 ./ (tol*max(xhat,[],1))));
end
[xhat,tags] = sortrows(xhat);
x=x(tags,:);
y=y(tags,:);

% count the replicates
iu = [1;any(diff(xhat),2)];
eb = cumsum(iu);
% count is the vector of counts for the consolidated
% x values
% Consolidator code was:  count=accumarray(eb,1).';
count = full(sparse(1,eb,1,1,eb(end)));

% ec is the expanded counts, i.e., counts for the
% unconsolidated x
ec = count(eb);

% special case for aggregation_mode of 'count',
% but we still need to aggregate (using the mean) on x
if strcmp(aggregation_mode,'count')
  ycon = count.';
  q = 0;
else
  ycon = zeros(length(count),q);
end

% loop over the different replicate counts, aggregate x and y
ucount = unique(count);
xcon = repmat(NaN,[length(count),p]);
for k=ucount
  if k==1
    xcon(count==1,:) = x(ec==1,:);
  else
    v=permute(x(ec==k,:),[3 2 1]);
    v=reshape(v,[p,k,prod(size(v))/p/k]);
    v=permute(v,[2 1 3]);
    xcon(count==k,:)=reshape(mean(v),p,prod(size(v))/p/size(v,1)).';
  end
  
  if q>0
    % aggregate y as specified
    if k==1
      switch aggregation_mode
        case {'std' 'var'}
          ycon(count==1,:) = 0;
        otherwise
          ycon(count==1,:) = y(ec==1,:);
      end
    else
      v=permute(y(ec==k,:),[3 2 1]);
      v=reshape(v,[q,k,prod(size(v))/q/k]);
      v=permute(v,[2 1 3]);
      
      nv = prod(size(v));
      n1 = size(v,1);
      
      switch aggregation_mode
        case 'mean'
          ycon(count==k,:)=reshape(mean(v),q,nv/n1/q).';
        case 'sum'
          ycon(count==k,:)=reshape(sum(v),q,nv/n1/q).';
        case 'min'
          ycon(count==k,:)=reshape(min(v),q,nv/n1/q).';
        case 'max'
          ycon(count==k,:)=reshape(max(v),q,nv/n1/q).';
        case 'std'
          ycon(count==k,:)=reshape(std(v),q,nv/n1/q).';
        case 'var'
          ycon(count==k,:)=reshape(var(v),q,nv/n1/q).';
        case 'median'
          ycon(count==k,:)=reshape(median(v),q,nv/n1/q).';
        case 'prod'
          ycon(count==k,:)=reshape(prod(v),q,nv/n1/q).';
        case 'harm'
          ycon(count==k,:)=reshape(1./mean(1./v),q,nv/n1/q).';
        case 'geom'
          ycon(count==k,:)=reshape(exp(mean(log(v))),q,nv/n1/q).';
%       case 'count'
%         % we already did count above
      end
    end
  end
end

% was it originally a character array?
if charflag
  xcon=char(xcon);
end


