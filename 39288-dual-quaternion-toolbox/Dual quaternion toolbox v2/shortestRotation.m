function dq = shortestRotation(p1,p2)

% SHORTESTROTATION   constructs a rotation dual quaternion which represents
%                    the rotation of smallest angle from vector p1 to p2.
%
%    DQ = SHORTESTROTATION(P1,P2) returns the dual quaternion DQ which is 
%     the dual quaternion representing the rotation from vector P1 to
%     vector P2 with the smallest rotation angle (among all the possible 
%     solutions) 
%       -   P1 (resp. P2) is a 3-vector representing vector P1 (resp. P2)
%            or a 3*N array (the i-th element represents the i-th vector P1 
%            (resp. P2)) where N is the number of vectors P1 (resp. P2). P1
%            and P2 must have the same norm.
%       -   DQ is a 8*N array representing the rotation dual quaternion: 
%               DQ = [cos(theta/2) axis'*sin(theta/2) 0 0 0 0]
%
% See also ROT2DQUAT, DQUAT2ROT

sp1 = size(p1);
sp2 = size(p2);
if sp1 == [1 3], p1 = p1'; sp1 = size(p1); end
if sp2 == [1 3], p2 = p2'; sp2 = size(p2); end


% wrong size
if sp1(1) ~= 3 || sp2(1) ~= 3
    error('DualQuaternion:shortestRotation:wrongsize',...
        '%d rows in array p1 and %d rows in array p2. It should be 3 for both.',...
        sp1(1),sp2(1));
end

np1 = sp1(2);
np2 = sp2(2);
if np1 ~= np2
    error('DualQuaternion:shortestRotation:wrongFormat',...
        '%d vectors in array p1 and %d vectors in array p2. It should be the same number for both.',...
        np1,np2);
end

tol = 1e-5;
normp1 = sqrt(sum(p1.^2));
normp2 = sqrt(sum(p2.^2));
if max(abs(normp1-normp2)) > tol
    error('DualQuaternion:shortestRotation:normError',...
        'At least two vectors of the p1 and p2 arrays do not have the same norm.');
end

minval = min(normp1);
if minval < tol
    error('DualQuaternion:shortestRotation:norm0',...
        'At least two vectors of the p1 and p2 arrays have a norm equal to 0.');
end

costheta = dot(p1,p2)./normp1.^2;
theta = acosd(costheta);
sintheta = sind(theta);
indnot0 = find(sintheta ~= 0);
axis = [ones(1,np1); zeros(2,np1)];
axis(:,indnot0) = cross(p1(:,indnot0),p2(:,indnot0))./repmat((normp1(indnot0).^2.*sintheta(indnot0)),3,1);
dq = rot2dquat(theta,axis);



