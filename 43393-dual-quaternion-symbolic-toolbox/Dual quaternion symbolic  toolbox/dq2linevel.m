function [vp,mp] = dq2linevel(dq)

% DQ2LINEVEL Transforms a line velocity dual quaternion into 
%            its vector representation.
%
%         [VP,MP] = DQ2LINEVEL(DQ) transforms the dual quaternion
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
% See also DQ2POS, DQ2VEL, DQ2LINE, LINEVEL2DQ

sdq = size(dq);
if sdq == [1 8]
    dq = dq.'; 
    sdq = size(dq); 
end

% wrong format
if sdq(1) ~= 8 
    error('DualQuaternion:dquat2linevel:wrongsize',...
        '%d rows in the DQ array. It should be 8.',sdq(1));
end

% extraction of the line position parameters, v and r
vp = dq(2:4,:);
mp = dq(6:8,:);