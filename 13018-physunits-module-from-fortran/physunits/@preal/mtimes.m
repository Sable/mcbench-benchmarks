function p3 = mtimes(p1,p2)
%PREAL/MTIMES Overloaded mtimes (*) operator for class preal.

global useUnitsFlag

if ~(useUnitsFlag) % If physunits is disabled...
    p3=mtimes(double(p1),double(p2)); % ... treat as double.
    return
end

p1=preal(p1);
p2=preal(p2);
if isscalar(p1)||isscalar(p2)
    p3=p1.*p2;
elseif ndims(p1)==2&&ndims(p2)==2
    p3=matmul(p1,p2);
else
    error(['Input arguments must be 2-D',...
        ' (use .* for element-wise multiplication).'])
end

% --- Helper function: matmul ---
function p3=matmul(p1,p2)
%MATMUL Matrix multiplication.
if size(p1,2)==size(p2,1)
    p3=preal(ones(size(p1,1),size(p2,2)));
    for j=1:size(p3,1)
        for k=1:size(p3,2)
            p3(j,k)=sum(p1(j,:).*p2(:,k)');
        end
    end
else
    error('Inner matrix dimensions must agree')
end