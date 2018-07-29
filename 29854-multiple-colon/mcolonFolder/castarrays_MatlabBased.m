function varargout = castarrays(varargin)
% 
% Cast the numerical arrays to the most-inferior class
%
% [A, B, C, ...] = castarrays(A, B, C, ...)
%
% Author: Bruno Luong <brunoluong@yahoo.com>
% Date: 31-Dec-2010 Change the order of char to be lower than int16

numclass = {'logical' 'char' ...
            'uint8' 'int8' 'uint16' 'int16' ...
            'uint32' 'int32' 'uint64' 'int64' ...
            'single' 'double'};

varargout = varargin;
for n = 1:length(numclass)
    cls = numclass{n};
    b = cellfun('isclass', varargout, cls);
    if any(b)
        varargout(~b) = cellfun(str2func(cls), varargout(~b), ...
                                'Uniform', false);
        return;
    end
end

end % castarrays
