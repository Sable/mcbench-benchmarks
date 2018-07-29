function dq = av2dq(AV)

% AV2DQ   transforms an angular vector into a rotation dual quaternion      
%
%       DQ = AV2DQ(AV) returns the rotation dual quaternion DQ from its 
%       angular vector representation AV [deg].
%       - AV is the angular vector representation of a rotation of angle
%          theta and unitary vecotr n. AV = theta*n = theta*[nx ny nz]. It
%          is expressed in [deg]. AV is a 3-vector or an 3*N array (where 
%          column i is the angular vector representation of rotation i).
%       - DQ is a rotation dual quaternion. It is an 8*N array (each column
%         is a rotation dual quaternion). 
%
% See also DQ2AV

sAV = size(AV);
if sAV == [1 3]
    AV = AV.'; 
    sAV = size(AV); 
end

% wrong format
if sAV(1) ~= 3
    error('DualQuaternion:AV2dquat:wrongsize',...
        '%d rows in the AV array. It should be 3.',sAV(1));
end

n = sAV(2);
theta = sym(sqrt(sum(AV.^2))); %default is column sum
axis = sym([ones(1,n); zeros(2,n)]);
axis(:,n) = AV(:,n)./repmat(theta(n),3,1);

dq = rot2dq(theta,axis);