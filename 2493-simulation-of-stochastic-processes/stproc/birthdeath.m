function [tjump, state] = birthdeath(npoints, flambda, fmu)
% BIRTHDEATH generate a trajectory of a birth-death process 
%
% [tjump, state] = birthdeath(npoints[, flambda, fmu])
%
% Inputs: npoints - length of the trajectory 
%         flambda - optional, an inline function to compute the
%           birth intensity at a point. Default
%           flambda = inline('5/(1+i)', 'i');
%         fmu - optional, an inline function to compute the
%           death intensity at a point. Default
%           fmu = inline('i', 'i');
%
% Outputs: tjump - jump times
%          state - states of the embedded Markov chain

% Authors: R.Gaigalas, I.Kaj
% v1.2 04-Oct-02

  % default parameter values if ommited
  if (nargin==1)
    flambda = inline('5/(1+i)', 'i');
    fmu = inline('i', 'i');    
  end

  i=0;     %initial value, start on level i
  tjump(1)=0;  %start at time 0
  state(1)=i;  %at time 0: level i
  for k=2:npoints
     % compute the intensities
     lambda_i=flambda(i);
     mu_i=fmu(i);
      
     time=-log(rand)./(lambda_i+mu_i);      % Inter-step times:
                                        % Exp(lambda_i+mu_i)-distributed
    
     if rand<=lambda_i./(lambda_i+mu_i)
       i=i+1;     % birth
     else
       i=i-1;     % death
     end          %if
     state(k)=i;
     tjump(k)=time;
  end              %for i

  tjump=cumsum(tjump);     %cumulative jump times

  % plot the process
  stairs(tjump, state);     

