function [bootstat, bootsam] = bootstrp(nboot,bootfun,varargin)
%BOOTSTRP Bootstrap statistics.
%   BOOTSTRP(NBOOT,BOOTFUN,...) draws NBOOT bootstrap data samples and
%   analyzes them using the function, BOOTFUN.  NBOOT must be a
%   positive integer.  BOOTFUN can be a function handle specified with
%   @, or the name of a function.  The third and later arguments are
%   data (scalars, column vectors, or matrices).  BOOTSTRP creates
%   bootstrap samples from the rows on the non-scalar data arguments
%   (which must have the same number of rows), and passes those
%   bootstrap samples of all the arguments to BOOTFUN.
%
%   [BOOTSTAT,BOOTSAM] = BOOTSTRP(...) Each row of BOOTSTAT contains
%   the results of BOOTFUN on one bootstrap sample. If BOOTFUN
%   returns a matrix, then this output is converted to a long
%   vector for storage in BOOTSTAT. BOOTSAM is a matrix of indices
%   into the rows of the extra arguments.
%
%   To get the output samples BOOTSAM without applying a function,
%   set BOOTFUN to empty ([]).
%
%   Examples:
%   To produce a sample of 100 bootstrapped means of random samples
%   taken from the vector Y, and plot an estimate of the density
%   of these bootstrapped means:
%      y = exprnd(5,100,1);
%      m = bootstrp(100, @mean, y);
%      [fi,xi] = ksdensity(m);
%      plot(xi,fi);
%
%   To produce a sample of 200 bootstrapped coefficient vectors for
%   a regression of the vector Y on the matrix X:
%      load hald
%      x = [ones(size(heat)), ingredients];
%      y = heat;
%      b = bootstrp(200, 'regress', y, x);
%
%   See also RANDOM, RANDSAMPLE, HIST, KSDENSITY.

%   Reference:
%      Efron, Bradley, & Tibshirani, Robert, J.
%      "An Introduction to the Bootstrap", 
%      Chapman and Hall, New York. 1993.

%   Copyright 1993-2004 The MathWorks, Inc. 
%   $Revision: 2.11.2.3 $  $Date: 2004/01/24 09:33:07 $

% Initialize matrix to identify scalar arguments to bootfun.
la = length(varargin);
scalard = zeros(la,1);

% find out the size information in varargin.
n = 1;
for k = 1:la
   [row,col] = size(varargin{k});
   if max(row,col) == 1
      scalard(k) = 1;
   end
   if row == 1 && col ~= 1
      row = col;
      varargin{k} = varargin{k}(:);
   end
   n = max(n,row);
end

% Create index matrix of bootstrap samples if necessary
haveallsamples = (nargout>=2);
if haveallsamples
   bootsam = ceil(n*rand(n,nboot));
end

if isempty(bootfun)
   bootstat = zeros(nboot,0);
   return
end

% Get result of bootfun on actual data and find its size.
thetafit = feval(bootfun,varargin{:});

% Initialize a matrix to contain the results of all the bootstrap calculations.
bootstat = {};%zeros(nboot,numel(thetafit),class(thetafit));

% Do bootfun - nboot times.
if la==1 && ~haveallsamples && ~any(scalard)
   % For special case of one non-scalar argument and one output, try to be fast
   X1 = varargin{1};
   for bootiter = 1:nboot
      onesample = ceil(n*rand(n,1));
      tmp = feval(bootfun,X1(onesample,:));
      bootstat{bootiter} = tmp;
   end
elseif la==2 && ~haveallsamples && ~any(scalard)
   % For two non-scalar arguments and one output, try to be fast
   X1 = varargin{1};
   X2 = varargin{2};
   for bootiter = 1:nboot
      onesample = ceil(n*rand(n,1));
      tmp = feval(bootfun,X1(onesample,:),X2(onesample,:));
      bootstat{bootiter} = tmp;
   end
else
   % General case
   db = cell(la,1);
   for bootiter = 1:nboot
      if haveallsamples
         onesample = bootsam(:,bootiter);
      else
         onesample = ceil(n*rand(n,1));
      end
      for k = 1:la
         if scalard(k) == 0
            db{k} = varargin{k}(onesample,:);
         else
            db{k} = varargin{k};
         end
      end
      tmp = feval(bootfun,db{:});
      bootstat{bootiter} = tmp;
   end
end
