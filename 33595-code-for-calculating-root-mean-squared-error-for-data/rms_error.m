
function [er]=rms_error(A1,A2)
% A1, A2 : Matrices of same size MxN
% er : Rms error
% Author : Kamlesh Pawar

if (~isequal(size(A1), size(A2)))
    display('Matrix dimension mismatch while calculating RMS value');
    return;
end

er = sum((A1(:)-A2(:)).^2);

er=sqrt(er/size(A1(:),1));
end


