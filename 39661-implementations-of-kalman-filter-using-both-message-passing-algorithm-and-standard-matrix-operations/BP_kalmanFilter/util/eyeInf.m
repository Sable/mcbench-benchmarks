%% generate eye inf.
% author: Shuang Wang
% email: shw070@ucsd.edu
% Division of Biomedical Informatics, University of California, San Diego.
function a = eyeInf(len)
    a = zeros(len);
    a(1:length(a)+1:numel(a)) = Inf;
end