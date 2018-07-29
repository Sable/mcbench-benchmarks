function B=nancumsum(A,dim,nmode)
% NANCUMSUM: Cumulative sum of a matrix, with user-specified treatment of NaNs.
%     Computes the cumulative sum of matrix A along dimension DIM, allowing
%     the user to replace NaNs with zeros, to skip over them, or to reset
%     on NaNs, maintaining NaNs as placeholders. 
% 
% USAGE: B = nancumsum(A, DIM, NMODE)
%
% ARGUMENTS:
%
% A:    Input matrix.
%
% B:    Output cumulative sum matrix, treating NaNs as determined by nmode.
%
% DIM:  B = nancumsum(A, DIM) returns the nan-cumulative sum of the elements
%       along the dimension of A specified by scalar DIM. For example,
%       nancumsum(A,1) works down the columns, nancumsum(A,2) works
%       across the rows. If DIM is not specified, it defaults to the first
%       non-singleton dimension of A. 
%
% NMODE: specifies how NaNs should be treated. Acceptable values are:
%       1: REPLACE NaNs with zeros (default).
%       2: MAINTAIN NaNs as position holders in B. (Skip NaNs without reset.)
%       3: RESET sum on NaNs, replacing NaNs with zeros.
%       4: RESET sum on NaNs, maintaining NaNs as position holders.
%
% EXAMPLES:
%
% 1) a = [NaN,2:5];
%
% nancumsum(a)
% ans =
%     0     2     5     9    14
%
% nancumsum(a,[],2)
% ans =
%   NaN     2     5     9    14
%
% nancumsum(a,[],3)
% ans =
%     2     5     9    14
%
% 2) a = magic(3); a(5)=NaN;
%
% b = nancumsum(a,2) % (Default NMode = 1)
% b =
%     8     9    15
%     3     3    10
%     4    13    15
%
% b = nancumsum(a,2,2)
% b =
%     8     9    15
%     3   NaN    10
%     4    13    15
%
% b = nancumsum(a,2,3)
% b =
%     8     9    15
%     3     0     7
%     4    13    15
%
% b = nancumsum(a,2,4)
% b =
%     8     9    15
%     3   NaN     7
%     4    13    15

% See also: cumsum, nansum, nancumprod, nanmean, nanmedian, ...
% (nancumprod is available from the FEX. Other nan* may require Toolboxes)

% Brett Shoelson
% brett.shoelson@mathworks.com
% 05/04/07
%
% Revision: 08/28/11
% Fixed bug in option 2 (faulty reset). Thanks to Andrew Stevens and Rick
% Patterson for reporting it. Also, eliminated old option 3 (deleting NaNs
% in a vector) as a trivial case and added two new options. 
% Revision: 09/15/11
% Fixed a bug with multiple NaNs. Thanks to Tim Yates.
%
% Copyright The MathWorks, Inc. 2011

% Set defaults, check and validate inputs
if nargin < 3
    nmode = 1;
end

if ~ismember(nmode,1:4)
    error('NANCUMSUM: unacceptable value for nmode parameter.');
end

if nargin < 2 || isempty(dim)
    if ~isscalar(A)
        dim = find(size(A)>1);
        dim = dim(1);
    else
        % For scalar inputs (no nonsingleton dimension)
        dim = 1;
    end
end

% Calculate cumulative sum, depending on selection of nmode
switch nmode
    case 1
        % TREAT NaNs as 0's
        B = A;
        B(B~=B) = 0;
        B = cumsum(B, dim);
    case 2
        % DO NOT INCREMENT, BUT USE NaNs AS PLACEHOLDERS.
        B = nancumsum(A, dim, 1);
        B(A~=A) = NaN;
     case 3
        % RESET sum on NaNs, replacing NaNs with zeros.
        naninds = find(A~=A);
        for ii = 1:numel(naninds)
            B = nancumsum(A, dim, 1);
            A(naninds(ii)) = -B(naninds(ii));
        end
        B = cumsum(A,dim);
    otherwise %case 4
        % RESET sum on NaNs, maintaining NaNs as position holders.
        naninds = find(A~=A);
        B = nancumsum(A,dim,3);
        B(naninds)= NaN;
end
     

