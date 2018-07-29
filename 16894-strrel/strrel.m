function out=strrel(in1,in2,relop)
% function out=strrel(in1,in2,relop)
%
%  Compares strings according to strcmp and issorted according to relop
%  in1 and in2 can be character arrays or cell arrays
%  relop can be <, <=, >, >=, ==, and ~=, or their string equivalents 
%    such as 'ne' or 'gt', etc.
%
%  Examples:
%  c = {'How','much','wood','would','a','woodchuck','chuck?'};
%  s = 'wood';
%  r = strrel(s,c,'<')
%  r = strrel(s,c,'ge')

% Author: Ben Barrowes, barrowes@alum.mit.edu, 10/2007
%
% 2007-10-18 bugfix and vectorization as pointed out by Urs (us) Schwarz

out=[];
% empty out if empty in (like []==3)
if isempty(in1) || isempty(in2), return, end

%doesn't handle numerical inputs
if isnumeric(in1) || isnumeric(in2)
 error('arguments to strrel must be char arrays or cell arrays of strings');
end

%promote char arrays to cell arrays
if ischar(in1), in1={in1}; end
if ischar(in2), in2={in2}; end

%repmat smaller cell array to size of larger if needed
if ~all(size(in1)==size(in2))
 if prod(size(in1))==1
  in1=repmat(in1,size(in2));
 elseif prod(size(in2))==1
  in2=repmat(in2,size(in1));
 else
  error('input array size mismatch in strrel');
 end
end

%should both be the same size cell arrays by now
out=false(size(in1));

% Do the logic
isEqual =strcmp(in1,in2);
for i=1:numel(in1)
 %isSorted=issorted({in1{i},in2{i}});
 isSorted=issortedcellchar({in1{i},in2{i}}); %about 3-4 faster
 switch lower(relop)
   case {'<','lt'}
     out(i)=isSorted & ~isEqual(i);
   case {'<=','le'}
     out(i)=isSorted | isEqual(i);
   case {'==','eq'}
     out(i)=isEqual(i);
   case {'~=','ne','!=','/='}
     out(i)=~isEqual(i);
   case {'>','gt'}
     out(i)=~isSorted & ~isEqual(i);
   case {'>=','ge'}
     out(i)=~isSorted | isEqual(i);
   otherwise
     error(['Relational operator, ',relop,', not recognized in strrel.'])
 end
end

%%%% this handle-vectorized version seemed to be somewhat slower
%%%isSorted=cellfun(@(x,y) issorted({x,y}),in1,in2);
%%%isEqual =strcmp(in1,in2);
%%%switch lower(relop)
%%%  case {'<','lt'}
%%%    out=isSorted & ~isEqual;
%%%  case {'<=','le'}
%%%    out=isSorted | isEqual;
%%%  case {'==','eq'}
%%%    out=isEqual;
%%%  case {'~=','ne','!=','/='}
%%%    out=~isEqual;
%%%  case {'>','gt'}
%%%    out=~isSorted & ~isEqual;
%%%  case {'>=','ge'}
%%%    out=~isSorted | isEqual;
%%%  otherwise
%%%    error(['Relational operator, ',relop,', not recognized in strrel.'])
%%%end
