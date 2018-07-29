function [v,r] = dquat2line(dq)

% DQUAT2LINE Transforms a line position dual quaternion into 
%            its vector representation (orientation + position).
%
%     [V,R] = DQUAT2LINE(DQ) transforms the double quaternion
%         representation of a line position (in the euclidean space) into a
%         vector V which represents the line orientation (unitary vector) 
%         and a vector R which is the coordinates of the nearest point from
%         the origin belonging to the line (it could be another r, it is
%         NOT unique).
%         DQ is either a vector of size 8 or an array of size 8*N (each
%         column represents a line position dual quaternion) where N is the
%         number of lines. V and R have the same size. They are either a
%         vector of size 3 or an array of size 3*N depending on the input
%         format.
%
% See also DQUAT2POS, DQUAT2VEL, DQUAT2LINEVEL, LINE2DQUAT 

if nargout < 2 || nargout > 2
    error('DualQuaternion:dquat2line:wrongNumberOfOutputs',...
        'You specified %d outputs. It should be 2 (see documentation).',nargout);
end

sdq = size(dq);
if sdq == [1 8], dq = dq'; sdq = size(dq); end

% wrong format
if sdq(1) ~= 8 
    error('DualQuaternion:dquat2line:wrongsize',...
        '%d rows in the DQ array. It should be 8.',sdq(1));
end

% check line position dual quaternion
tol = 1e-6;
[maxval,imax] = max(max(abs(dq([1 5],:))));
if maxval > tol
   warning('DualQuaternion:dquat2line:wrongFormat',...
        'At least one dual quaternion is not a line position dual quaternion (tol = %.1e).\n Indices of max values: %d \n Max value = %.2e',...
        tol,imax,maxval);
end

% extraction of the line position parameters, v and r
v = dq(2:4,:);
w = dq(6:8,:);

% check if the norm of v is unitary (it should be)
normv2 = sum(v.^2);
[maxval2,imax2] = max(normv2);
[minval2,imin2] = min(normv2);
i2 = union(imax2,imin2);
if maxval2 > 1+tol || minval2 < 1-tol
       warning('DualQuaternion:dquat2line:wrongFormatNotUnitary',...
        'At least one dual quaternion has not a unitary orientation ( is it a line position dual quaternion?) (tol = %.1e).\n Indices of max values: %d \n Min and Max value = [%.2e %.2e]',...
        tol,i2,minval2,maxval2);
end
% r is the position vector of the point belonging to the line such that
% this point is the nearest point from the origin (it is orthogonal to the
% line orientation)
normv2 = repmat(normv2,3,1);
r = cross(v,w)./normv2;
