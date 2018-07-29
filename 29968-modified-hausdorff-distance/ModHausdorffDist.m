function [ mhd ] = ModHausdorffDist( A, B )

% Code Written by B S SasiKanth, Indian Institute of Technology Guwahati.
% Website: www.bsasikanth.com
% E-Mail:  bsasikanth@gmail.com
% 
% This function computes the Modified Hausdorff Distance (MHD) which is 
% proven to function better than the directed HD as per Dubuisson et al. 
% in the following work:
% 
% M. P. Dubuisson and A. K. Jain. A Modified Hausdorff distance for object 
% matching. In ICPR94, pages A:566-568, Jerusalem, Israel, 1994.
% http://ieeexplore.ieee.org/xpls/abs_all.jsp?arnumber=576361
% 
% The function computed the forward and reverse distances and outputs the 
% minimum of both.
% 
% Format for calling function:
% 
% MHD = ModHausdorffDist(A,B);
% 
% where
% MHD = Modified Hausdorff Distance.
% A -> Point set 1
% B -> Point set 2
% 
% No. of samples of each point set may be different but the dimension of
% the points must be the same.

% BEGINNING OF CODE

% Compute the sizes of the input point sets
Asize = size(A);
Bsize = size(B);

% Check if the points have the same dimensions
if Asize(2) ~= Bsize(2)
    error('The dimensions of points in the two sets are not equal');
end

% Calculating the forward HD

fhd = 0;                    % Initialize forward distance to 0
for a = 1:Asize(1)          % Travel the set A to find avg of d(A,B)
    mindist = Inf;          % Initialize minimum distance to Inf
    for b = 1:Bsize(1)      % Travel set B to find the min(d(a,B))
        tempdist = norm(A(a,:)-B(b,:));
        if tempdist < mindist
            mindist = tempdist;
        end
    end
    fhd = fhd + mindist;    % Sum the forward distances
end
fhd = fhd/Asize(1);         % Divide by the total no to get average

% Calculating the reverse HD

rhd = 0;                    % Initialize reverse distance to 0
for b = 1:Bsize(1)          % Travel the set B to find avg of d(B,A)
    mindist = Inf;          % Initialize minimum distance to Inf
    for a = 1:Asize(1)      % Travel set A to find the min(d(b,A))
        tempdist = norm(A(a,:)-B(b,:));
        if tempdist < mindist
            mindist = tempdist;
        end
    end
    rhd = rhd + mindist;    % Sum the reverse distances
end
rhd = rhd/Bsize(1);         % Divide by the total no. to get average

mhd = max(fhd,rhd);         % Find the minimum of fhd/rhd as 
                            % the mod hausdorff dist


end

