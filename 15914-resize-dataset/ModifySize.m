%function [s] = ModifySize(data,newsize)
%Changes the data size with keeping the data shape.
% data: the original data
% newsize : the target data size
% By Amr M. Gody in August 2007
function [s] = ModifySize(data,newsize)
    
    nbIn = nargin;
    if nbIn < 1 ,    error('Not enough input arguments.');
    elseif nbIn==1 , newsize = max(size(data));
    end
    
    if size(data,1) ==1
        %data in a raw
        sz = size(data,2);
        ratio = newsize/sz;
        n = 1:ratio:ratio*sz;
        if max(size(n)) <max(size(data))
            n = [n n(max(size(n)))+ratio];
        end
        n1 = 1:ratio*sz;
    else
        %data in a column
        sz = size(data,1);
        ratio = newsize/sz;
        n = 1:ratio:ratio*sz;
        if max(size(n)) <max(size(data))
            n = [n n(max(size(n)))+ratio];
        end

        n = n';
        n1 = 1:ratio*sz;
        n1 = n1';
    end
    
    
   s = interp1(n,data,n1);
end