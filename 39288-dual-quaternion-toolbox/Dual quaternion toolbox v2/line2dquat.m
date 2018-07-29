function dq = line2dquat(v,r)

% LINE2DQUAT  Transforms a line position expressed in vector notation into 
%            its dual quaternion representation.
%
%     DQ = LINE2DQUAT(V,R) transforms the line position, specified by the
%       line orientation V and the coordinates of any point of the line, R,
%       into its dual quaternion representation. V and R must have the same
%       size. V  (resp. R) is either a vector of size 3 or an array of size
%       3*N (column i represents the orientation (resp. coordinates of a 
%       point) of Line i) where N is the number of lines. DQ is either a
%       vector of size 8, either an array of size (8*N) depending on V
%       format. Each column of DQ represents the dual quaternion
%       representation of the corresponding line position.
%
% See also POS2DQUAT, VEL2DQUAT, LINEVEL2DQUAT, DQUAT2LINE

sv = size(v);
sr = size(r);
if sv == [1 3]
    v = v';
    sv = size(v);
end
if sr == [1 3]
    r = r';
    sr = size(r);
end

% check that v and r have the same size
if sv ~= sr
    error('DualQuaternion:line2dquat:sizesDoNotMatch',...
        'Arrays v and r should be the same size. Size of v matrix is [%d %d] while size of r matrix is [%d %d]',sv(1),sv(2),sr(1),sr(2));
end
% if the format is wrong
if sv(1) ~= 3 
    error('DualQuaternion:line2dquat:wrongsize',...
        '%d rows in the V and R array. It should be 3. ',sv(1));
end

% normalization of the axis vector (if necessary)
n = length(v(1,:));
n2 = sum(v.^2).^0.5;
if max(n2)~=1 || min(n2)~=1
    n2 = repmat(n2,3,1);
    v =v./n2;
end   

% construction of the line dual quaternion
dq = zeros(8,n);
dq(2:4,:) = v;
dq(6:8,:) = cross(r,v);


