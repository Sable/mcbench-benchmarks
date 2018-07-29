function d = EditDist(s1,s2,varargin)
%EDITDIST Finds the Edit Distance between strings s1 and s2. The Edit Distance
%         is defined as the minimum number of single-character edit operations 
%         (deletions, insertions, and/or replacements) that would convert 
%         s1 into s2 or vice-versa. Uses an efficient dynamic programming
%         algorithm. Useful for gene sequence matching, among other applications.
%
%         Example: d = EditDist('cow','house') returns a value of 4.
%         Example: s1 = 'now'; s2 = 'cow'; EditDist(s1,s2) returns a value of 1.
%         Example from gene sequence matching:
%         EditDist('ATTTGCATTA','ATTGCTT') returns a value of 3.
%         
%         If there are more than two inputs, the 3d, 4th, and 5th inputs will be
%         interpreted as the costs of the three edit operations: DELETION,
%         INSERTION, and REPLACEMENT respectively. The default is 1 for all
%         three operations. Note that if the cost of replacement is at least twice
%         the respective costs of deletion and insertion, replacements will never be 
%         performed.
%
%         Example: EditDist('cow','house',1,1,1) returns a value of 4.
%         Example: EditDist('cow','house',1,2,1.5) returns a value of 5.
%         Example: EditDist('cow','house',1,1,2) returns a value of 6.
%
%
%USAGE:   d = EditDist('string1','string2');
%
%         d = EditDist('string1,'string2',1.5,1,2);
%
%

%Written and tested in Matlab 5.3, Release 11.1 (should work with earlier versions).
%Copyright 2000, Miguel A. Castro 6/4/2000
%talk2miguel@yahoo.com
%------------------------------------------------------------------------------------------

%Determine the number of inputs. If 2 inputs, set default edit costs to 1.
%Otherwise, make sure there are exactly 5 inputs, and set edit costs accordingly.
if ~isempty(varargin)
   if length(varargin) ~= 3
      error('Usage is: EditDist(''string1'',''string2'',DeleteCost,InsertCost,ReplaceCost)');
   end;
   DelCost = varargin{1};
   InsCost = varargin{2};
   ReplCost = varargin{3};
else
   DelCost = 1;
   InsCost = 1;
   ReplCost = 1;
end;

[m1,n1] = size(s1);
[m2,n2] = size(s2);

%Make sure input strings are horizontal.
if ~(ischar(s1) & ischar(s2) & m1 == 1 & m2 == 1)  
   error('s1 and s2 must be horizontal strings.');
end;

%Initialize dynamic matrix D with appropriate size:
D = zeros(n1+1,n2+1);

%This is dynamic programming algorithm:
for i = 1:n1
   D(i+1,1) = D(i,1) + DelCost;
end;

for j = 1:n2
   D(1,j+1) = D(1,j) + InsCost;
end;

for i = 1:n1
   for j = 1:n2
      if s1(i) == s2(j)
         Repl = 0;
      else
         Repl = ReplCost;
      end;
      D(i+1,j+1) = min([D(i,j)+Repl D(i+1,j)+DelCost D(i,j+1)+InsCost]);
   end;
end;

d = D(n1+1,n2+1);