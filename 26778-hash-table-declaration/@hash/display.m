function dispay(h,t)
% dispay(h)
% Displays tha content of the hash h

% Dimitar Atanasov, 2010
% datanasov@nbu.bg

if nargin == 1
    t = '';
end;

 K = hash_keys(h);
for k = K
      k = cell2mat(k);  
      v = hash_get_value(h,k);
      if isa(v,'hash')
         disp([t '   ' k ' => ' ]);     
         display(v, [t '     ']);
      else
         disp([ t '   ' k ' => ' num2str(v)]);    
      end;   
end;