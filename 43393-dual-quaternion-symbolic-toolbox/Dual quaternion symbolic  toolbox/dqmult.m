function ds = dqmult(dq,dr,varargin)

%  DQMULT   Dual quaternion multiplication
%
%      DS = DQMULT(DQ,DR) returns the dual quaternion DS which is the dual
%      quaternion product of DQ and DR. DQ (resp. DR, DS) is a vector of
%      size 8 representing a dual quaternion or an array of size 8*N (column 
%      i represents dual quaternion i) where N is the number of dual 
%      quaternions.
%      There are several combinations possible:
%       - 1*N:DQ is a 8-vector and DR is an array 8*N ==> DS is an array 8*N. 
%        DQ is multiplied with each column (dual quaternion) of DR.
%       - N*1:DQ is an array 8*N and DR is a 8-vector ==> DS is an array 8*N.
%        Each column (dual quaternion) of DQ is multiplied with DR.
%       - N*N:DQ and DR are both arrays of size 8*N  ==> DS is an array 8*N. 
%        The dual quaternion muliplication is carried out on corresponding
%        columns.
%      THE ORDER MATTERS: the dual quaternion muliplication is NOT
%      commutative: DQMULT(Q,R) is different from DQMULT(R,Q)
%
%      DS = DQMULT(DQ1,DQ2,DQ3,...,DQN) returns the dual quaternion DS which 
%      is the dual quaternion product of DQ1, DQ2, ... and DQN. 
%      If * represents the dual quaternion mulitplication, then we can 
%       write: DS = DQ1*DQ2*DQ3*...*DQN. Please note that the dual
%       quaternion product is associative: (DQ1*DQ2)*DQ3) = DQ1*(DQ2*DQ3) =
%       DQ1*DQ2*DQ3.
%      DQ1, DQ2, ..., DQR must have the same format as above (see DS =
%      DQMULT(DQ,DR))
%
% See also QMULT, DQCONJ
soptargin = size(varargin,2); % number of optional dual quaternions to multiply
sdq = size(dq);
sdr = size(dr);
if sdq == [1 8]
    dq = dq.'; 
    sdq = size(dq); 
end

if sdr == [1 8]
    dr = dr.'; 
    sdr = size(dr); 
end

if soptargin > 0 % more than  2 dual quaternions: use of recursion
    temp = dqmult(dq,dr);
    dqopt1 = varargin{1,1}; 
    sdqopt1 = size(dqopt1);
    if sdqopt1 == [1 8]
        dqopt1 = dqopt1.'; 
    end
    ds = dqmult(temp,dqopt1,varargin{1,2:end});
else % dual quaternion multiplication of two dual quaternions
    
    % wrong size
    if sdq(1) ~= 8 || sdr(1) ~= 8        
        error('DualQuaternion:DQmult:wrongsize',...
            '%d rows in array dq and %d rows in array dr. It should be 8 for both.',...
            sdq(1),sdr(1));
    end
    
    nq = sdq(2);
    nr = sdr(2);
    % wrong format for the inputs
    if nq ~= nr && nq > 1 && nr > 1
        error('DualQuaternion:DQmult:wrongFormat',...
            '%d columns in array q and %d columns in array r. It should be the same number for both, or one of these should be 1.',...
            nq,nr);
    end
    
    % dual quaternion multiplication
    ds0 = qmult(dq(1:4,:),dr(1:4,:));
    ds1 = qmult(dq(1:4,:),dr(5:8,:))+qmult(dq(5:8,:),dr(1:4,:));
    ds = [ds0 ; ds1];
end
    

