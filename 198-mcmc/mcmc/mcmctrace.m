% MCMCTRACE - trace plots
% Copyright (c) 1998, Harvard University. Full copyright in the file Copyright
%
%   mcmctrace(A)
%
% A = an array of MCMC output, the last dimension
%     is the index of the different samples
%
% The resulting graph will be an array of trace
% plots of the values over time.  
%
% if the first element of each trace is NaN, the
% trace plot will be empty.
%
% See also: MCMCLT, MCMCSUMM

function mcmctrace(A) 

dd = size(A) ;
ll = length(dd) ;
d1 = dd(1) ;
d2 = dd(2) ;

if (ll==2),
  aa = reshape(A, [d1 1 d2]) ;
  d3 = d2 ;
  d2 = 1 ;
else
  aa = A ;
  d3 = dd(3) ;
end ;

ix = 0 ;
for i1 = 1:d1,
for i2 = 1:d2,
  ix = ix + 1 ;
  bb = reshape(aa(i1,i2,:),[1 d3]) ;
  if ( ~isnan (bb(1,1)) ),
    subplot(d1,d2,ix), plot(bb,'k-') ;
  end 
end
end
