function Str = vec2str(V)
%VEC2STR Convert a vector to a string in MATLAB syntax.
%   STR = VEC2STR(V) converts the vector V to a MATLAB string, so that
%   STR2NUM(STR) produces the original vector, using the colon operator to
%   represent linearly spaced subvectors.
%   
%   Column vectors are represented as the transpose of a row vector.
%   Higher-dimensional arrays are represented as the result of reshaping a row
%   vector, so that STR2NUM(STR) produces the original array.
%
%   Examples
%       vec2str([1 2 3 4 5 6 8 9 10])
%           produces the string           [ 1:6, 8:10 ]
%
%       vec2str([1 2 3 4 5 6 8 10])
%           produces the string           [ 1:6, 8, 10 ]
%
%       vec2str([1;3;5;5;9;8;7;6;5])
%           produces the string           [ 1:2:5, 5, 9:-1:5 ].'
%
%       vec2str([1 4 8;2 5 6;3 10 4])
%           produces the string           reshape([ 1:5, 10:-2:4 ],[3 3])
%       
%       vec2str(speye(4))    produces the string
%           reshape([ 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 ],[4 4])
%       
%   See also MAT2STR, COLON, STR2NUM.

%   Copyright 2010 Sven Bossuyt
%   Version history:
%     2010-01-21:
%       first public release
%     2010-01-24:
%       fixed bug where end of one subsequence is start of next one
%       added spaces for readability
%       changed behaviour for subsequences of length 2
%     2010-02-01:
%       generate error immediately if array is not numeric
%       changed logic of algorithm, to also handle NaN elements

assert(isnumeric(V),'vec2str:check','vec2str works with numeric arrays.')
if numel(V) <= 1
  Str= num2str(V);
elseif numel(V) ~= size(V,2)
  if numel(V) == size(V,1)
    Str= [vec2str(V') '.'''];
  else
    Str= ['reshape(' vec2str(V(:).') ',' mat2str(size(V)) ')'];
  end
else
  %% identify elements that start or end linearly spaced subsequence
  D= diff(V);
  D(~isfinite(D))= 0; % avoid problems with NaN's or Inf's
  TF= [true diff(D)~=0, true]; % false in middle of linearly spaced triplet
  TF= TF | [true, D==0]; % true for repeated values
  D(end+1)= 0;
  Head= [true TF(1:end-1)] & TF;
  Tail= TF & [TF(2:end) true];
  %% catch case where end of one subsequence is start of next one
  Overlap = [false ~TF(1:end-1)] & TF & [~TF(2:end) false];
  Tail(Overlap)= true;
  Head([false Overlap(1:end-1)])= true;
  %% don't bother with trivial subsequences
  Overlap= Head & [Tail(2:end) false];
  Tail(Overlap)= true;
  Head([false Overlap(1:end-1)])= true;
  %% assemble output string
  SubSeq= cell(1,nnz(TF));
  ixx= 1;
  for ix= [V(Head); D(Head); V(Tail)]
    switch ix(2)
      case 0 % single element
      SubSeq{ixx}= sprintf(' %g,', ix(1));
      case 1 % unit spacing
        SubSeq{ixx}= sprintf(' %g:%g,', ix([1 3]));
      otherwise
        SubSeq{ixx}= sprintf(' %g:%g:%g,', ix);
    end
    ixx= ixx+1;
  end
  Str= ['[',SubSeq{:}];
  Str(end:end+1)=' ]';
end
%   Str= '[';
%   for ix= [V(TF); D(TF); V(TF([2:end 1]))]
%     if ix(3)==ix(1) % start and end of linearly spaced subsequence are same
%       Str= sprintf('%s %g,',Str, ix(1));
%     else % linearly spaced sequence
%       if ix(2)==1 % unit spacing
%         Str= sprintf('%s %g:%g,',Str, ix([1 3]));
%       else
%         Str= sprintf('%s %g:%g:%g,',Str, ix);
%       end
%     end
%   end
%   Str(end:end+1)=' ]';
