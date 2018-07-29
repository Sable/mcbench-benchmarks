function [M,R] = ballatsq(N)
% BALLATSQ - Balanced Latin Square
%    M = BALLATSQ(N) creates a balanced latin square of size N containing
%    the numbers 1 to N. N should be an even positive integer.
%
%    [M, R] = BALLATSQ(N) also returns a randomized balanced latin square in R. 
%
%    A latin square of size M is a MxM matrix filled with the M different
%    numbers in such a way that each number occurs exactly once in each row
%    and exactly once in each column. A balanced latin square has the further
%    restriction that each sequence of two values in a row does not occur
%    more than once in the whole matrix. They have applications in the
%    design of experiments.
%    More information: http://en.wikipedia.org/wiki/Latin_square
%
%    Example:
%      M = ballatsq(6) % ->
%      %      1     2     6     3     5     4
%      %      2     3     1     4     6     5
%      %      3     4     2     5     1     6
%      %      4     5     3     6     2     1
%      %      5     6     4     1     3     2
%      %      6     1     5     2     4     3
%
%     Note that "sort(ballatsq(N),1-2)" will return 1:N in each column-row.
%
%    See also MAGIC, GALLERY, CIRCSHIFT
%             LATSQ, CIRCULANT (FEX)

% for Matlab R13 and up
% version 2.2 (mar 2009)
% (c) Jos van der Geest
% email: jos@jasen.nl

% History
% 1.0 (feb 2006) created
% 2.0 (apr 2006) previous algorithm was faulty. Thanks to Jen M. (UK)
% 2.1 (sep 2006) can now also return a randomize balanced latin square
% 2.2 (mar 2009) added internal comments, changed variable names, improved
%     randomization


if nargin ~= 1 || ~isnumeric(N) || numel(N)~=1 || N<2 || rem(N,2) || fix(N)~=N,
    error('Single argument should be a positive even integer') ;
end

V = 1:N ;        % values in each column
CSI = [V ; -V] ; % circular shift index
M = zeros(N) ;   % pre-allocation

% the first colum just contains the numbers 1 to N
M(:,1) = V(:) ;
for i=2:N,
    % every column contains the numbers 1 to N shifted circularly according
    % to CSI  
    M(:,i) =  rem(V(:)+CSI(i-1)+(N-1),N) + 1 ;
end

if nargout==2,
    % randomize the values 1:N
    rN = randperm(N) ;
    R = rN(M) ;
end





