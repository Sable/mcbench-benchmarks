function [s_new, field_names, field_values] = structdlg(s_old, fields_per_inputdlg)
% STRUCTDLG Struct dialog box.
%
%  S_NEW  = STRUCTDLG(S_OLD) creates a modal dialog box that 
%  asks the user for the new values of each field in the structure S_OLD,
%  then it creates a new structure S_NEW with the same fields but
%  new values.
%  In other words, this function takes a structure as input, then it automatically builds a 
%  graphical user interface to modify its field values. It is based on INPUTDLG.
%
%  [S_NEW, FIELD_NAMES, FIELD_VALUES]  = STRUCTDLG(S_OLD, FIELDS_PER_INPUTDLG)
%  Inputs:
%  S_OLD is an input structure
%  FIELDS_PER_INPUTDLG (Optinal) is the number of fields to request the input value each time.
%                                It represents the size of each inputdlg window we use
%                                (This is necessary when structures have a lot of fields...)
%  Outputs:
%  S_NEW is the structure with field values changed by the user through the function input values
%  FIELD_NAMES  is a cell of strings with the names of each field
%  FIELD_VALUES is a cell of strings with the new values entered by the user
%
%  Known limitations:
%  This function does not work with arrays and cells with more than two dimensions.
%
%  Example
%     s_old.Author_name = 'Marco';
%     s_old.Author_surname = 'Cococcioni';
%     s_old.function_name = 'structdlg';
%     s_old.function_version  = '1.0';
%     s_old.Bugs_to = 'm.cococcioni@gmail.com';
%     s_new = structdlg(s_old);
%
%  See also INPUTDLG, QUESTDLG, UIWAIT.

%  Copyright Marco Cococcioni (Please report bugs to m.cococcioni@gmail.com)
%  $Revision: 1.0, October 2005 $


%%%%%%%%%%%%%%%%%%%%
%%% Nargin Check %%%
%%%%%%%%%%%%%%%%%%%%
if nargin < 1,
    s_old.Author_name = 'Marco';
    s_old.Author_surname = 'Cococcioni';
    s_old.function_name = 'structdlg';
    s_old.function_version  = '1.0';
    s_old.Bugs_to = 'm.cococcioni@gmail.com';
    disp('The old structure was:');    
    s_old
    [s_new, field_names, field_values] = structdlg(s_old);
    disp('The new structure is:');
    s_new
    return
end

if nargin < 2,
    fields_per_inputdlg = 10;
end

if nargin == 1,
    struct_name = inputname(1);
else
    struct_name = 's_old';
end

field_names = fieldnames(s_old);
N = length(field_names);
field_values = cell(N,1);
val = cell(N,1);

for n=1:N
    value = getfield(s_old,field_names{n});
    if iscell(value),
        if length(size(value))<3,
            val{n} = '{';
            for i=1:size(value,1),
                for j=1:size(value,2)
                    val{n} = sprintf('%s%s, ',val{n},value_tochar(value{i,j},1));
                end
                val{n}(end-1) =';';
            end
            val{n}(end-1) = '}';
            val{n}(end) = [];
        else
            error('Arrays or cells with more than two dimensions are not supported!');
        end
    else
        val{n} = value_tochar(value);
    end
end

inputdlg_n = ceil(N/fields_per_inputdlg); % number of inputdlg to call. Each inputdlg shows fields_per_inputdlg fields

for i=1:inputdlg_n
    start = (i-1)*fields_per_inputdlg+1;
    stop  = i*fields_per_inputdlg;
    if stop > N,
        stop = N;
    end
    field_values(start:stop) = inputdlg(field_names(start:stop),sprintf('Insert values for fields of structure ''%s'' (%d/%d)',struct_name,i,inputdlg_n),1,val(start:stop));
end

s_new = s_old;

%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Setting new values %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%
for n=1:N
     if ischar(getfield(s_new,field_names{n})),
         s_new = setfield(s_new,field_names{n},field_values{n});
     else         
         s_new = setfield(s_new,field_names{n},eval(field_values{n}));
     end
end

return

%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Utility function  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%
function value_aschar = value_tochar(value, is_inside_a_cell)
if nargin < 2,
    is_inside_a_cell = 0;
end

if ischar(value)
    if is_inside_a_cell,
        value_aschar = ['''',value, ''''];
    else
        value_aschar = value;
    end
elseif isnumeric(value),
    if length(size(value))<3,
        value_aschar = mat2str(value);
    else
        error('Arrays or cells with more than two dimensions are not supported!');
    end
else
    value_aschar = ['[',sprintf('%dx',size(value))];
    value_aschar(end)=[];
    value_aschar = [value_aschar, '] ', class(value)];
end

