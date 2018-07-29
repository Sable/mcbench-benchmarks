% Copyright (C) 2013 Quan Wang <wangq10@rpi.edu>,
% Signal Analysis and Machine Perception Laboratory,
% Department of Electrical, Computer, and Systems Engineering,
% Rensselaer Polytechnic Institute, Troy, NY 12180, USA
%
% You are free to use this software for academic purposes if you cite our paper:
% Quan Wang and Kim L. Boyer.
% Feature Learning by Multidimensional Scaling and its Applications in Object Recognition.
% 2013 26th SIBGRAPI Conference on Graphics, Patterns and Images (Sibgrapi). IEEE, 2013.
%
% For commercial use, please contact the authors.


% Get the next interested point to be added to the constraining set A.

function k=get_interested_point(Dist,constraining_set,strategy)
% Dist: distance matrix
% constraining_set: the set of indices of MDS codes to be fixed
% strategy: the initialization strategy
%     0: random order (default)
%     1: largest-distance-first
%     2: smallest-distance-first
% k: resulting index of interested point


if nargin==2
    strategy=0;
end

N=size(Dist,1);

switch strategy
    case 0 % random order
        while 1
            k=mod(round(rand(1)*10^10),N)+1;
            if constraining_set(k)==false
                return;
            end
        end
    case 1 % largest-distance-first
        V_dist=zeros(N,1);
        for i=1:N
            if constraining_set(i)==true
                V_dist(i)=-1;
            else
                V_dist_to_constraining_set=Dist(constraining_set,i);
                V_dist(i)=max(V_dist_to_constraining_set);
            end
        end
        [~, k]=max(V_dist);
    case 2 % smallest-distance-first
        V_dist=zeros(N,1);
        for i=1:N
            if constraining_set(i)==true
                V_dist(i)=10^10;
            else
                V_dist_to_constraining_set=Dist(constraining_set,i);
                V_dist(i)=min(V_dist_to_constraining_set);
            end
        end
        [~, k]=min(V_dist);   
end
