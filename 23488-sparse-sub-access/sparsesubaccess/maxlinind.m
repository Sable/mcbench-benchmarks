function res=maxlinind(sz)
%
% Return the maximum linear index allowed from the matrix size
%
% Author Bruno Luong <brunoluong@yahoo.com>
% Last update: 05/April/2009

persistent C MAXSIZE BUGGY

if isempty(BUGGY) % check only once
    [C MAXSIZE] = computer();
     % Buggy on 32-bit platform
    BUGGY = isempty(strfind(C,'64'));
end

if ~BUGGY % 64-bit platform
    res = MAXSIZE;
else
    % !!! Not working if using maxsize 32-bit (Matlab BUG, pitty)
    res = min(MAXSIZE,mod(prod(sz),2^32));
end