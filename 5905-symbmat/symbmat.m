function S = symbmat(ch,m,n)
%
% OUT = SYMBMAT(CH,M,N)
% OUT is a symbolic marix of dimension M,N.
% Elements have name CH (default 'x') and are subscripted according to position
% M,N have default 1
% SYMBMAT('a',2,3) returns
% [ a11, a12, a13]
% [ a21, a22, a23]

% Mukhtar Ullah
% mukhtar.ullah@informatik.uni-rostock.de
% September 21, 2004

nIn = nargin;

if  ~nIn , ch = 'x'; end

if nIn < 2, S = sym(ch); return, end

if nIn < 3, n = 1; end

if ~isscalar(m) || ~isscalar(n)
    error('2nd and 3rd arguments must be scalar')
end

m = floor(m);
n = floor(n);
N = m*n;

if m == 1 || n == 1
    list = int2str((1:N).').';
else
    [I,J] = ind2sub([m,n],1:N);
    list = [int2str(I.').'; int2str(J.').'];
end

str = ([ch ',']).';
str = str(:,ones(1,N));
list = [str(1:end-1,:); list; str(end,:)];
list = list(:).';
list(isspace(list)) = [];
list(list==',') = ' ';

eval(['syms  ', list])
S = reshape(eval(['[', list, ']']), m, n);