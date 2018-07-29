function dq = linevel2dq(v,r,vp,rp)

% LINEVEL2DQ     Transforms a line velocity expressed in vector notation 
%                into its dual quaternion representation.
%
%      DQ = LINE2DQ(V,R,VP,RP) transforms the line position, specified by:
%          - the line orientation V
%          - the position of any point of the line, R.
%          - the line orientation rate of change, VP
%          - the velocity component (orthogonal to the line orientation V)
%          of point P, RP
%       V does not need to be unitary, but VP must be orthogonal to V. If
%       RP has a component in the V orientation, it does not matter, since
%       it does not change the expression of the resulting dual quaternion
%       DQ.
%       V,R,VP and RP must have the same size. The inputs (V,R,VP,RP) are
%       either a vector of size 3 or an array of size 3*N (column i 
%       represents the input component of Line velocity i) where N is the
%       number of lines. DQ is either a vector of size 8, either an array 
%       of size (8*N) depending on the input format. Each column of DQ 
%       represents the dual quaternion representation of the corresponding
%       line position velocity.
%
% See also POS2DQ, VEL2DQ, LINE2DQ

sv = size(v);
sr = size(r);
svp = size(vp);
srp = size(rp);
if sv == [1 3],  v = v.'; sv = size(v); end
if sr == [1 3],  r = r.'; sr = size(r); end
if svp == [1 3],  vp = vp.'; svp = size(vp); end
if srp == [1 3],  rp = rp.'; srp = size(rp); end

% check that all inputs have the same size
tab_s = [sv; sr; svp; srp];
if max(tab_s) ~= min(tab_s)
      error('DualQuaternion:linevel2dquat:sizesDoNotMatch',...
        'Arrays v, r, vp and r should be the same size. Size of \n - v is [%d %d] \n - r is [%d %d] \n - vp is [%d %d] \n - rp is [%d %d]',...
           sv(1),sv(2),sr(1),sr(2),svp(1),svp(2),srp(1),srp(2)); 
end

% if the format is wrong
if sv(1) ~= 3 
    error('DualQuaternion:linevel2dquat:wrongsize',...
        '%d rows in the V,R,VP and RP  arrays. It should be 3. ',sv(1));
end
   
% normalization of the axis vector (if necessary)
n = length(v(1,:));
n2 = sum(v.^2).^0.5;
n2 = repmat(n2,3,1);
v=v./n2;
vp=vp./n2;

% construction of the line velocity dual quaternion
dq = sym(zeros(8,n));
dq(2:4,:) = vp;
dq(6:8,:) = cross(r,vp)+cross(rp,v);


