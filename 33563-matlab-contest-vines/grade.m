function [score,board,moves,vine] = grade(moves,vine,board,limit)
% GRADE scores the solution for a given problem for the Vines Contest 
%
% board is an m-by-n array of distinct positive integers. 
% limit is the total budget of moves plus vine length. 
% moves is an p-by-2 array of move orders (using absolute indices). 
% vine  is a vector of absolute indices into board that specifies the
%       highest value path through the board.  

% The MATLAB Contest Team 
% Copyright 2011 The MathWorks, Inc.

m = size(board,1);
mn = numel(board);
originalsum = sum(board(:));

% Make "moves" input bulletproof
if isempty(moves) || ~isnumeric(moves) || ~isreal(moves) || size(moves,2)~=2
    moves = zeros(0,2);
else
    moves = reshape(double(moves(:)),numel(moves)./2,2);
    moves = round(min(mn,max(1,moves)));
end

h = isconnected(moves(:,1),moves(:,2),m);
if any(~h)
    moves = moves(h,:);
    %warning('%d invalid moves are ignored.',sum(~h))
end

% Check that number of moves does not exceed the allowed limit
if size(moves,1)>limit
    moves = moves(1:limit,:);
    %warning('Some moves are ignored since it exceeds the limit.')
end

% Perform moves on the board:
for i = 1:size(moves,1)
    board(moves(i,:)) = [0 board(moves(i,1))];
end

% Make "vine" input bulletproof
if isempty(vine) || ~isnumeric(vine) || ~isreal(vine)
    vine = [];
else
    vine = round(min(mn,max(1,double(vine(:)))));   
end

% Check that a single piece in not used twice or more times in a vine
if ~isempty(vine)
    h = accumarray(vine,1)>1;
    if any(h)
        vine(h(vine))=[];
        %warning('One board piece appears twice or more times in the vine.')
    end
end

% Check components in vine are connected, if there are unconnected
% elements, the vine is truncated.
h = find(~isconnected(vine(1:end-1),vine(2:end),m),1);
if ~isempty(h)
    vine = vine(1:h);
    %warning('Part of the vine is ignored since it is disconnected.')
end

% Check vine is monotonically non-decreasing, any invalid value will
% truncate the vine.
h = find(diff(board(vine))<0,1);
if ~isempty(h)
    vine = vine(1:h);
    %warning('Part of the vine is ignored since it is not monotonically increasing.')
end
   
score = originalsum - sum(board(vine));

end

function flag = isconnected(a,b,m)
% a,b:  Absolute indices
% m,n:  Size of board
% flag: True if indices a and b are four connected 
d = abs(a(:)-b(:));
flag = (d == m) | (d == 1 & mod(min(a(:),b(:)), m));
end
