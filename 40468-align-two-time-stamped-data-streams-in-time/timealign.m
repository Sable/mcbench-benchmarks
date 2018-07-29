function [t,a1,a2] = timealign(t1,t2,u1,u2,res)
%TIMEALIGN   Align 2 data matrices in time.
%   The presumption is that t1 and t2 vectors are associated
%   with data matrices that must be time aligned.  There is
%   no assumption of even time spacing, but times are assumed
%   to be monotonically increasing.
%
%   Matrices u1 and u2 must be column-based, i.e.,
%     length(t1) == size(u1,1) and length(t2) == size(u2,1)
%
%   [t,a1,a2] = timealign(t1,t2,u1,u2) returns
%     t    time, the union of t1 & t2
%     a1   u1 at points where t == t1 (NaN otherwise)
%     a2   u2 at points where t == t2 (NaN otherwise)
%
%   [...] = timealign(t1,t2,u1,u2,res) aligns using a fixed 
%     resolution res
%
%
%   EXAMPLE:
%     t1 = [1 2 3]';  u1 = [6 7 8]';
%     t2 = [2 4 5]';  u2 = [3 4; -1 2; 9 12];
%     [t,a1,a2] = timealign(t1,t2,u1,u2)
%      t =         a1 =         a2 =    
%          1              6          NaN   NaN
%          2              7            3     4
%          3              8          NaN   NaN
%          4            NaN           -1     2
%          5            NaN            9    12
%
%
%   Developed under Matlab version 7.10.0.499 (R2010a)
%   Created by Qi An
%   anqi2000@gmail.com

%   QA 2/22/2013 initial skeleton

% Must have at least 4 inputs
if nargin < 4, 
  fprintf('%s: nargin < 4\n',mfilename)
  [t,a1,a2] = deal( [] );
  return;
end

% must be column oriented
if length(t1) ~= size(u1,1) || length(t2) ~= size(u2,1),
  fprintf('%s: u1 or u2 not column oriented\n',mfilename)
  [t,a1,a2] = deal( [] );
  return;
end

% Establish resolution, if necessary
if nargin > 4
  t1 = res * floor(t1 / res);
  t2 = res * floor(t2 / res);
end

t        = union(t1,t2);     % all possible times
a1       = NaN(length(t),size(u1,2));
a2       = NaN(length(t),size(u2,2));
[jnk,ia] = intersect(t,t1);  % index of t1 in t
a1(ia,:) = u1;               % place data at t1
[jnk,ia] = intersect(t,t2);  % index of t2 in t
a2(ia,:) = u2;               % place data at t2

