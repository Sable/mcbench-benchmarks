function [c,cd]=index0(s)
% INDEX :
% alternative expression of cluster structure
% of binary patterns based on various possible encodings
% named 'Cluster Indices'
% 
% -----------------------------------------------------
% RETURNS :
% c : cluster vector, cd : cluster dim.
%
% Theophanes E. Raptis, DAT-NCSRD 2010
% http://cag.dat.demokritos.gr
% rtheo@dat.demokritos.gr
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    n = length(s);
    % identify cluster structure
    sflag = 1 - s(1);
    c = zeros(1,n);k = 0;
    for j=1:n
        if s(j)==0
           if sflag == 1 k = k+1; end 
           sflag = 0;
           c(k) = c(k) - 1;
        else
           if sflag == 0 k = k+1; end
           sflag = 1; 
           c(k) = c(k) + 1;
        end
    end
    % compute cluster functions
    m = length(find(c==0));
    cd = n-m; c = c(1:cd);
end