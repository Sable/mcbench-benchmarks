
function varargout = map(array, varargin)
% OUTPUT = MAP(ARRAY, FUNC, TYPE)
% [OUPUT1, .., OUTPUTN] = MAP(ARRAY, FUNCS*, TYPE1, .., TYPEN)
%   MAP takes the elements of ARRAY, and applies FUNC to each element.  The
%   result OUTPUT is of the same shape as ARRAY, but the values are the
%   result of FUNC.  If TYPE is given, then it is used as a `cast' between
%   the two types (not providing the right type can result in an error).
%   It is not needed when mapping between the same types.  If FUNC is not
%   given, then this reduces to an `identity' mapping, but can be used to
%   change types of an array.  Such as:
%      intCell = map(1:10, 'cell')
%   Here, 'cell' is an acceptable value for TYPE.  The list of acceptable
%   values is:
%     cell, double, single, int8, int16, int32, int64, uint8, uint16,
%     uint32, uint64, char, struct, id, logical
%
%   With multiple output values, the result of FUNC must provide that many
%   outputs.  Each output is again the same shape as ARRAY, with the first
%   OUTPUT being composed of the first output of FUNC.  Any number of TYPE
%   values may be given, and are applied to each OUTPUT as above.
%

  [ctype, cfunc] = deal({}, {});
  types = '^cell|double|single|(u?int(8|16|32|64))|char|struct|id|logical$';

  nout = max(nargout, 1);

  % Grab the conversion functions.
  [funclist, varargin] = select(varargin, @islambda);
  if numel(funclist) > 1
    error('Map:Arguments', 'At most one function can be mapped.  Use composition for more than one function.');
  end
  func = @id;
  if ~isempty(funclist), func = funclist{1}; end

  if ~isempty(varargin)
    ctype = select(varargin, grep(types, 's'));
    cfunc = map(ctype, @str2func);
  end

  if iscell(array) && isempty(ctype)
    ctype = {'cell'};
    cfunc = {@cell};
  end
  
  % Empty array can't possibly map to anything!
  if isempty(array)
    for outi = 1:nout
      if outi <= numel(ctype)
        if strcmp(ctype{outi}, 'cell')
          varargout{outi} = {};
        else
          trans = cfunc{outi};
          varargout{outi} = trans([]);
        end
      else
        varargout{outi} = [];
      end
    end
    return;
  end

  % We just need to handle variable outputs...
  output = cell(numel(array), nout);

  % Apply the map!
  for i = 1:numel(array)
    if iscell(array)
      [output{i, 1:nout}] = func(array{i});
    else
      [output{i, 1:nout}] = func(array(i));
    end
  end

  % Now we have to go through and add to the outputs.
  arrsize = size(array);
  for i = 1:nout
    if i <= numel(ctype)
      if strcmp(ctype{i}, 'cell')
        varargout{i} = output(:, i); %#ok<AGROW>
      else
        trans = cfunc{i};
        varargout{i} = trans([output{:, i}]);
      end
    else
      if nout == 1 && iscell(array)
        varargout{1} = output;
      else
        varargout{i} = [output{:, i}];
      end
    end
    varargout{i} = reshape(varargout{i}, arrsize);
  end
end
