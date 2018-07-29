function y=comb(x)

% This function is used to create all possible combinations
% of Input Term Nodes Outputs to be fed into the Rule Nodes.
% Each combination is fed to a single rule neuron responsible
% for the processing of this specific combination.

[rows columns] = size(x);

y = zeros(columns^rows,rows);

for i=1:rows
   
    if i<=rows-1
   
      j=1; 
   
      for m=0:columns^(rows-i):(columns^rows - columns^(rows-i))      
               
        if j<=columns  
         
             for l=1:columns^(rows-i)
                      y(m+l,i) = x(i,j);
             end
         
         else
         
            j=1;
             for l=1:columns^(rows-i)
                     y(m+l,i) = x(i,j);
             end

         end
      
         j = j + 1;     
      
      end  
   
    elseif i==rows
      
        for m=0:columns:(columns^rows - columns)
            
            j=1; 
            for l=1:columns 
                y(m+l,i) = x(i,j);
                j=j+1; 
            end
        end
   
    end    % end of "if i" loop.
    
end      % end of " for i" loop.
