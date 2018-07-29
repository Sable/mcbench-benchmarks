function [out]=snip(in,arg1,varargin)

%% SNIP FUNCTION  %2nd Version, 13.Sept.2013
% Snip something out of a vector or matrix. 
%
% (C) for snip.m function implementation Nicolas Ummen, under BSD2 open source copyright license.
% Comments etc. to NicolasUmmen@web.de
%
% The function snip takes the following arguments:
%
% snip(input,argument_1,argument_2)
%
% %arg_1 = what to snip, arg_2 = for matrices, to define 'r'ow or 'c'olumn
%
% It then removes either the specified kinds of elements from the input, or
% removes the element at the stated position, then compresses the input by as
% much as was deleted out of it.
% 
% LIST OF POSSIBLE ARGUMENT_1s:
% 'x'   -> remove all x's from the input vector, compress it afterwards
% '1'   -> remove all 1's from the input vector, compress it afterwards
% [all other comparable items to the above are possible]
% 1     -> remove THE FIRST element, move all one up, shorten vector by 1
% i     -> remove COMPLEX elements from input, compress it afterwards
% j     -> [same as above] - note that 'i' and 'j' would remove the characters i or j.
% nan   -> remove all nan's, compress it
% inf   -> remove all infs from the input vector, compress it afterwards
%
% etc.
%
% The rest of the possible arguments follows matlab notation, such as:
% last  -> snip off the last element
% :     -> snip from:to
%
% Note that 'partial' deletions, for example getting rid of elements from
% (2,3) to (2,6) in a 7x7 matrix = A, is much better accomplished by overwriting
% them directly as A(2,3:6) = 0; or similar. A compression of the data is
% not possible, as elements remain in e.g. (2,1:2)
%
% ALLOWED DATA TYPES: Everything except self-defined structures/objects.
%
% EXAMPLES:
%
% in = [2 1 3 NaN NaN 1]; snip(in,2)   = [2 3 NaN NaN 1]
% in = [2 1 3 NaN NaN 1]; snip(in,'1') = [2 3 NaN NaN]
% in = [2 1 3 NaN NaN 1]; snip(in,nan) = [2 1 3 1]
% in = [2 1 3 inf inf 1]; snip(in,inf) = [2 1 3 1]
% compl = complex(1,2); in = [2 1 3 compl compl 1]; snip(in,i) = [2 1 3 1]
% in = [2 1 3 NaN NaN 1]; snip(in,'last') = [2 1 3 NaN NaN]
% in = ['abcdefg']; snip(in,'c')   = abdefg
% in = ['abcdefg']; snip(in,'last') = abcdef
% in = ['abcdefg']; snip(in,2)     = acdefg
%
% Whether the input is a row or column vector doesn't matter, and the output
% is returned accordingly.
%
% Advanced vector, snip out a certain, continuous length:
%
% in = [2 1 3 NaN NaN 1]; snip(in,2:4) = [2 NaN 1]
%
% MATRIX EXAMPLES: either snip out completely rows/columns, or identify rows
% and columns that have the same elements throughout and delete these.
% Note: deleting all e.g. 3's therefore leaves 3's in mixed entry columns
% or rows. In some cases using snip.m column or row-wise on the matrix
% might help.
%
% in = [1 2 3; 3 3 3; 4 3 3]; snip(in,2,'r') = [1 2 3; 4 3 3]
% in = [1 2 3; 3 3 3; 4 3 3]; snip(in,2,'c') = [1 3; 3 3; 4 3]
% in = [1 2 3; 3 3 3; 4 3 3; 5 3 3; 6 3 3]; snip(in,2:4,'r') = [1 2 3; 6 3 3]
% in = [1 2 3; 3 3 3; 4 3 3]; snip(in,'1')     = [1 2 3; 3 3 3; 4 3 3]
% Note the above doesn't detect a complete row/column full of 1's...
% 
% in = [1 2 3; 3 3 3; 4 3 3]; snip(in,'3') = [1 2; 4 3]
% While this one detected a row and a column of solely 3's. To overwrite
% all e.g. 3s in the above matrix, rather use find - or logical indexing.
% E.g. in(in == 3) = 0 for the result [1 2 0; 0 0 0; 4 0 0].
%
% in = [1 2 nan; nan nan nan; 4 nan nan]; snip(in,nan) = [1 2; 4 nan]
% in = ['abc'; 'acb'; 'abc']; snip(in,'a') = ['bc','cb','bc']
%
% etc as above for vectors
% 
% For more complicated choices from a matrix; like the first, third and
% seventh column; use the notation A = A(:,[1,3,7])

% Change log:
% 2nd Version: Added infinity and complex number option on request.

%% (C) for snip.m function implementation Nicolas Ummen, under BSD2 open soure copyright license.
% Comments etc. to NicolasUmmen@web.de

% main function body

%scrutinize what the user wants, operate on most likely first
flagflipped = 0; 
if isstruct(in)
   out = in;
   warning('snip function: structures cannot be snipped!')
   return
end

[z s] = size(in);
if z == 0
    out = in;
    warning('snip function: 0x0 input detected!')
    return
end

if z > s
    in = in';
    flagflipped = 1;
    [z s] = size(in);
end

%operate on numerical things first

%if it is a vector
if z == 1 && strcmpi(arg1,'last') %snip end command
    out = in(1,1:end-1);
    if flagflipped == 1
        out = out';
    end
    return
end

if z == 1 && isnan(arg1(1)) %sort nans out
    out = in(~isnan(in));
    if flagflipped == 1
        out = out';
    end
    return
end

if z == 1 && isinf(arg1(1)) %sort infs out
    out = in(~isinf(in));
    if flagflipped == 1
        out = out';
    end
    return
end

if z == 1 && ~isreal(arg1(1)) %sort complex numbers out
    out = in(~imag(in));
    if flagflipped == 1
        out = out';
    end
    return
end

if z == 1 && isnumeric(arg1) %snip out a specific place/length from vector
    if arg1(end) > s
        out = in;
        if flagflipped == 1
            out = out';
        end
        warning('snip function: the vector is too short for that snip!')
        return
    end
    out = [in(1:arg1(1)-1) in(arg1(end)+1:end)];
    if flagflipped == 1
        out = out';
    end
    return
end

if z == 1 && iscell(in) %if it is a cell vector
    if strcmpi(arg1,'last') %snip end command
        out = in{1,1:end-1};
        if flagflipped == 1
            out = out';
        end
        return
    end
    arg1 = str2num(arg1);
    if arg1(end) > s
        out = in;
        if flagflipped == 1
            out = out';
        end
        warning('snip function: the vector is too short for that snip!')
        return
    end
    out = [in{1:arg1(1)-1} in{arg1(end)+1:end}];
    if flagflipped == 1
        out = out';
    end
    return
end

if z == 1 %snip out all objects, like 'a', or '1' from a vector
    if length(str2num(arg1)) == 1
        arg1 = str2num(arg1);
    end
    out = in(in~=arg1);
    if flagflipped == 1
        out = out';
    end
    return
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%if it is a matrix

if z >= 1 && isnan(arg1(1)) %snip out all nans
    in = in(:,all(isnan(in),1) ~= 1);
    out = in(all(isnan(in),2) ~= 1,:);
    if flagflipped == 1
        out = out';
    end
    return
end

if z >= 1 && isinf(arg1(1)) %snip out all infs
    in = in(:,all(isinf(in),1) ~= 1);
    out = in(all(isinf(in),2) ~= 1,:);
    if flagflipped == 1
        out = out';
    end
    return
end

if z >= 1 && ~isreal(arg1(1)) %snip out complex numbers
    in = in(:,all(imag(in),1) ~= 1);
    out = in(all(imag(in),2) ~= 1,:);
    if flagflipped == 1
        out = out';
    end
    return
end

if z >= 1 && isempty(varargin) == 1 && ischar(arg1) && ischar(in(1,1)) %snip out all equal elements
    in = in(:,all(in==arg1,1) ~= 1);
    out = in(all(in==arg1,2) ~= 1,:);
    if flagflipped == 1
        out = out';
    end
    return
end

if z >= 1 && isempty(varargin) == 1 %snip out all equal elements
    arg1 = str2num(arg1);
    in = in(:,all(in==arg1,1) ~= 1);
    out = in(all(in==arg1,2) ~= 1,:);
    if flagflipped == 1
        out = out';
    end
    return
end

if z >= 1 && ischar(varargin{1}) %snip out specific row(s) or column(s)
    arg2 = varargin{1};
    if flagflipped == 1
        if strcmp(arg2,'c')
            arg2 = 'r';
        else
            if strcmp(arg2,'r')
            arg2 = 'c';
            end
        end
    end
    switch arg2
        case 'c'
            if arg1(end) > s
                out = in;
                if flagflipped == 1
                    out = out';
                end
                warning('snip function: the matrix is not large enough for this snip!')
                return
            end
            out = [in(:,1:arg1(1)-1) in(:,arg1(end)+1:end)];
        case 'r'
            if arg1(end) > z
                out = in;
                if flagflipped == 1
                    out = out';
                end
                warning('snip function: the matrix is not large enough for this snip!')
                return
            end
            out = [in(1:arg1(1)-1,:); in(arg1(end)+1:end,:)];
    end
    if flagflipped == 1
        out = out';
        return
    end
    return
end

%catch things that didn't go in the above cases

out = in;

if flagflipped == 1
    out = out';
end
warning('snip function: function completed, but no relevant case to execute occured!')
return

end