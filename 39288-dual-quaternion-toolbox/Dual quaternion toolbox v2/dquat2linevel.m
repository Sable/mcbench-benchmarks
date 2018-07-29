function [vp,mp] = dquat2linevel(dq)

% DQUAT2LINEVEL Transforms a line velocity dual quaternion into 
%            its vector representation.
%
%     [VP,MP] = DQUAT2LINEVEL(DQ) transforms the double quaternion
%         representation of a line velocity (in the euclidean space) into a
%         vector VP which represents the line orientation rate of change 
%         and a vector MP which is the rate of change of the moment vector 
%         (the moment vector m = r x v) is the cross product of any point 
%         belongig to the line, r, and the line orientation, v). In other
%         terms, MP = dot(r) x v + r x dot(v).
%         DQ is either a vector of size 8 or an array of size 8*N (each
%         column represents a line velocity dual quaternion) where N is the
%         number of lines. VP and MP have the same size. They are either a
%         vector of size 3 or an array of size 3*N depending on the input
%         format.
%
% See also DQUAT2POS, DQUAT2VEL, DQUAT2LINE, LINEVEL2DQUAT 

if nargout < 2 || nargout > 2
    error('DualQuaternion:dquat2linevel:wrongNumberOfOutputs',...
        'You specified %d outputs. It should be 2 (see documentation).',nargout);
end

sdq = size(dq);
if sdq == [1 8], dq = dq'; sdq = size(dq); end

% wrong format
if sdq(1) ~= 8 
    error('DualQuaternion:dquat2linevel:wrongsize',...
        '%d rows in the DQ array. It should be 8.',sdq(1));
end

% check line velocity dual quaternion (not structurally different from a
% line position dual quaternion).
tol = 1e-6;
[maxval,imax] = max(max(abs(dq([1 5],:))));
if maxval > tol
   warning('DualQuaternion:dquat2linevel:wrongFormat',...
        'At least one dual quaternion is not a line velocity dual quaternion (tol = %.1e).\n Indices of max values: %d \n Max value = %.2e',...
        tol,imax,maxval);
end

% extraction of the line position parameters, v and r
vp = dq(2:4,:);
mp = dq(6:8,:);