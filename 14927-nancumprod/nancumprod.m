function B=nancumprod(A,dim,nmode)
% NANCUMPROD: Cumulative product of a matrix, with user-specified treatment of NaNs.
%     Computes the cumulative product of matrix A along dimension DIM,
%     allowing the user to replace NaNs with ones, or to maintain NaNs as
%     placeholders.
% 
% USAGE: B = nancumprod(A, DIM, NMODE)
%
% ARGUMENTS:
%
% A:    Input matrix.
%
% B:    Output cumulative product matrix, treating NaNs as determined by nmode.
%
% DIM:  B = nancumprod(A, DIM) returns the nan-cumulative product of the elements
%       along the dimension of A specified by scalar DIM. For example,
%       nancumprod(A,1) works down the columns, nancumprod(A,2) works
%       across the rows. If DIM is not specified, it defaults to the first
%       non-singleton dimension of A. 
%
% NMODE: specifies how NaNs should be treated. Acceptable values are:
%       1: REPLACE NaNs with ones (default).
%       2: MAINTAIN NaNs as position holders in B. (Skip NaNs without reset.)
%       3: RESET product to 1 on NaNs, replacing NaNs with ones.
%       4: RESET product on to 1 NaNs, maintaining NaNs as position holders.
%
% EXAMPLES:
%
% 1) a = [1:5]; a(3)=NaN;
%
% nancumprod(a,[],1)
% ans =
%     1     2     0     0     0
% 
%
% nancumprod(a)
% ans =
%     1     2   NaN     8    40
%
% nancumprod(a,[],3)
% ans =
%     1     2     8    40
%
% 2) a = magic(3); a(5)=NaN;
%
% b = nancumprod(a,2) % (Default NMode = 1)
% b =
%     8     8    48
%     3     3    21
%     4    36    72
%
% b = nancumprod(a,2,2)
% b =
%     8     8    48
%     3   NaN    21
%     4    36    72
% 
% b = nancumprod(a,2,3)
% b =
%     8     8    48
%     3     1     7
%     4    36    72
%
% b = nancumprod(a,2,4)
% b =
%     8     8    48
%     3   NaN     7
%     4    36    72
% See also: cumprod, nancumprod, nansum, nanmean, nanmedian, ...
% (nancumsum is available from the FEX; other nan* functions may require Toolboxes)

% Brett Shoelson
% brett.shoelson@mathworks.com
% 05/08/07
%
% Revision: 08/28/11
% Fixed bug in option 2 (faulty reset). Thanks to Andrew Stevens and Rick
% Patterson for reporting it. Also, eliminated old option 3 (deleting NaNs
% in a vector) as a trivial case and added two new options. 
%
% Copyright The MathWorks, Inc. 2011

% Set defaults, check and validate inputs
if nargin < 3
    nmode = 1;
end

if ~ismember(nmode,1:4)
    error('NANCUMPROD: unacceptable value for nmode parameter.');
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

% Calculate cumulative product, depending on selection of nmode
switch nmode
    case 1
        % TREAT NaNs as 1's
        B = A;
        B(B~=B) = 1;
        B = cumprod(B, dim);
    case 2
        % DO NOT INCREMENT, BUT USE NaNs AS PLACEHOLDERS.
        B = nancumprod(A,dim,1);
        B(A~=A) = NaN;
    case 3
        % RESET product to 1 on NaNs, replacing NaNs with ones.
        naninds = find(A~=A);
        for ii = 1:numel(naninds)
            B = nancumprod(A, dim, 1);
            A(naninds(ii)) = 1/B(naninds(ii));
        end
        B = cumprod(A,dim);
otherwise % case 4
        % RESET product to 1 on NaNs, maintaining NaNs as position holders.
        naninds = find(A~=A);
        B = nancumprod(A,dim,3);
        B(naninds)= NaN;
end
     

