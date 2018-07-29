%% this is safe inv, which can handle inverse of inf matrix
% author: Shuang Wang
% email: shw070@ucsd.edu
% Division of Biomedical Informatics, University of California, San Diego.
function iA = inv_s(A, iA)
    if(~isempty(iA))
       return;
    else
        if(~isempty(A))
            B = eyeInf(size(A, 1));
            if(sum(B ~= A) == 0)
                iA = zeros(size(A));
            else
                iA = inv(A);
            end
        else
            error('both A and iA are empty');
        end
    end
end