function [tarr, pcount] = poissonti(tmax, lambda, nproc)

% POISSONTI generate N independent Poisson processes as matrix
% columns
%
% [tarr] = poissonti(tmax, lambda [, nproc])
%
% Inputs: tmax - time window
%         lambda - arrival intensity
%         nproc - optional, the number of processes to
%           generate. Default 1.
%
% Outputs: tarr - a matrix with <nproc> columns of arrrival times of
%          the processes
%
% See also POISSONJP

% Authors: R.Gaigalas, I.Kaj
% v1.3 Created 07-Oct-02
%      Modified 02-Dec-05 Changed the names of variables, added the
%      counting process, truncation at tmax

  % default parameter values
  if (nargin ==2)
    nproc = 1;
  end

  % add zero to the arrival times for nicer plots 
  tarr = zeros(1, nproc);

  % sums of exponentialy distributed interarrival times
  % as matrix columns
  i = 1;                  
  while (min(tarr(i,:))<=tmax)
    tarr = [tarr; tarr(i, :)-log(rand(1, nproc))/lambda];  
    i = i+1;
  end

  % cut off arrival times greater than tmax
  ex_i = find(tarr>tmax);
  tarr(ex_i) = tmax;  
  
  % generate the jumps of counting processes as matrix columns; 
  % do not add up as yet since we don't want values for times
  % greater than tmax
  pcount = [zeros(1, nproc); ones(size(tarr, 1)-1, nproc)];
  % set the counts of the exceeding times to zero	       
  pcount(ex_i) = 0;
  % add up the jumps
  pcount = cumsum(pcount);    
  
  % plot the counting processes
  stairs(tarr, pcount);  




