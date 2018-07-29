function x = noisy(x,n)

%        X = NOISY(X,N) reverses randomly N pixels
%	       		of the patterns X (RxQ)

%	(c) Val Ninov, 1997, valninov@total.net

if nargin < 2 n=1; end;
[r,c]=size(x);
if n<1 | n>(r*c)  
 error(' Wrong number of elements to be iverted');
end

% Add noise to the input pattern
%-------------------------------
fprintf(' Wait...');
for q=1:c
 for k=1:n
% Generating Random Pairs of Indices
%-----------------------------------
  i(1) = fix(rand(1)*r+1);
  for k=2:r
    i(k) = fix(rand(1)*r+1);
    repeated =1;
    while repeated
      repeated=0; 
      i(k) = fix(rand(1)*r+1);    
      for m=k-1:-1:1
       if  i(k)==i(m) 
       repeated =1;
       end
      end
    end
  end
  x(i(k),q) = ~x(i(k),q);
 end
end
fprintf('  Done.\n');