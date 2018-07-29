% This function computes the entropy of a label set. 

% Copyright (C) 2012 Quan Wang <wangq10@rpi.edu>, 
% Signal Analysis and Machine Perception Laboratory, 
% Department of Electrical, Computer, and Systems Engineering, 
% Rensselaer Polytechnic Institute, Troy, NY 12180, USA
% 
% You are free to use this software for academic purposes if you cite our paper: 
% Q. Wang, Y. Ou, A.A. Julius, K.L. Boyer, M.J. Kim, 
% Tracking tetrahymena pyriformis cells using decision trees, 
% in: 2012 International Conference on Pattern Recognition, Tsukuba Science City, Japan.
% 
% For commercial use, please contact the authors. 

function label_ent=getEntropy(label)

% label: one label vector
% label_ent: resulting entropy

n1=sum(1-label);
n2=sum(label);
if n1+n2==0
    label_ent=0;
    return;
end
p1=n1/(n1+n2);
p2=n2/(n1+n2);
if p1==0
    label_ent=-p2*log(p2);
    return;
elseif p2==0
    label_ent=-p1*log(p1);
    return;
end
label_ent=-p1*log(p1)-p2*log(p2);