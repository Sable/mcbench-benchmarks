function idx = sub2allind(sz, varargin)
% sub2allind - Find linear indices for all elements covered by the given subscripts
%
%   idx = sub2allind(sz, sub1, sub2, sub3, ... )
%
%   Like Matlab's sub2ind, sub2allind computes the equivalent linear indices for
%   given subscripts of an array with size SZ.
%   Unlike sub2ind, it computes a field of all combinations of
%   subscripts. So, instead of calling A( 2:3, 1, 4:11) you might
%   use
%       linIdx = sub2allind( size(A), 2:3, 1, 4:11 );
%
%   and then call A(linIdx) or A(linIdx(:)) or you reshape linIdx the way you need.
%
%   A(linIdx) has the shape of the cut out part of the array
%   A(linIdx(:)) is a column vector with all entries.
%
%   Example:
%   >> A = magic(4)
%
%   A =
%
%       16   _ 2 ___ 3 _  13
%        5  | 11    10  |  8
%        9  |  7     6  | 12
%        4  | 14    15  |  1
%
%   >> linIdx = sub2allind( size(A), 2:4, 2:3 );
%   >> A(linIdx)
%
%   ans =
%
%       11    10
%        7     6
%       14    15
%
%   >> A(linIdx(:)).'
%
%   ans =
%
%       11     7    14    10     6    15
%
%   Using the colon operator is allowed:
%   linIdx = sub2allind( sz, sub1, :, sub3 );

% Michael Völker, 2011
% This is Matlab FileEx #30096

  if nargin < 2
      error('sub2allind:NoOfInputs', 'At least two inputs, please.')
  end

  Ndims = length(sz(:));      % No. of dimensions

  % ------------------------------------------------------------------
  % Make sure, "sz" is fine
  %
    if Ndims < 2 || ~all(isnumeric(sz(:))) || ~all(isfinite(sz(:))) || ~all(isreal(sz(:)))
        error('sub2allind:szNotSane', 'Size vector must be real and have at least 2 elements.');
    end
    sz  = sz(:).';

    if Ndims < nargin-1
        ResDims = nargin-1 - Ndims;
        sz = [sz   ones(1,ResDims)];                    % Adjust for trailing singleton dimensions
    elseif Ndims > nargin-1
        sz = [sz(1:nargin-2)  prod(sz(nargin-1:end))];  % Adjust for linear indexing on last element
    end
  %
  % ------------------------------------------------------------------

  % ------------------------------------------------------------------
  % Make sure all subscripts are fine, including the use of ":"
  %
    for d = 1:Ndims

      subs = varargin{d}(:);
                                                    % Check if subs are...
      flagNum  = all( isnumeric( subs )     );      %   ... numeric...
      flagReal = all(    isreal( subs )     );      %   ... real valued ...
      flagFin  = all(  isfinite( subs )     );      %   ... finite ...
      flagInt  = all( subs == floor(subs)   );      %   ... integers.

      if ~flagNum || ~flagReal || ~flagFin || ~flagInt

        if isequal( subs, ':' )         % We allow exactly one type of non-numeric input
            varargin{d} = 1:sz(d);      % interpret ":" as in usual subscript syntax
            subs = 1:sz(d);
        else
            error('sub2allind:SubsNotSane', 'Subscripts must either be valid matrix subscripts or the well known '':''.')
        end

      end

      % subscripts within allowed range?
      if any(  subs < 1   |   subs > sz(d)  )
        error('sub2allind:IndexOutOfRange', 'Out of range subscript.');
      end

    end % for d = 1:Ndims
  %
  % ------------------------------------------------------------------

  % ------------------------------------------------------------------
  %  Compute linear indices, e.g. in 3D, with edges L1, L2, L3:
  %
  %       idx = x1 + (x2-1)*L1 + (x3-1)*L1*L2,
  %
  %  for every permutation (x1,x2,x3)
    k = [1 cumprod(sz(1:end-1))];       % k(d) holds the accumulated No. of array elements
                                        % up to the d'th subscript (or dimension)

    idx = 1;                            % smallest possible index

    for d = 1:Ndims

        xd = varargin{d}(:);                        % the d'th subscripts --> x1, x2, x3, x4 ...

        reshrule = [ ones(1,d)  length(xd) ];       % how to reshape the size of xd

        xd = reshape( xd, reshrule );               % prepare for bsxfun's needs

        idx = bsxfun( @plus, idx, (xd-1)*k(d) );    % iteratively calculate the sum shown above

    end
  %
  % ------------------------------------------------------------------

  szIdx = size( idx );
  szIdx = [ szIdx(2:end)  1 ];

  idx = reshape( idx, szIdx );

  % linearify indices:
  % idx = idx(:);       % note: Information is lost when you apply this (--> the shape of idx)

end

% Same result, but slow on large fields of subscripts (Thx to Jos (10584)):
%
% function idx = sub2allind(sz, varargin)
%
%     [subix{1:nargin-1}] = ndgrid(varargin{:});
%     idx = sub2ind(sz,subix{:});
%
% end
