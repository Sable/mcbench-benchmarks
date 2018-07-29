function structstring = struct2string ( var )

%STRUCT2STRING get the sentence which could create the struct variable
%
%   STRUCT2STRING(varagin) Detailed explanation goes here
%
%   Inputs:
%       var             a struct type variable
%
%   Outputs:
%       structstring    the sentence which could create the varaible 'var'
%
%   Syntax:
%       structstring = struct2string ( var )
%
%   Example:
%       %% logical type variable
%       Str = 'struct(''a'',true,''b'',false)';
%       value = eval(Str);
%       result = struct2string(value);
%       fprintf('source string: %s \ndecode string: %s \n',Str,result);
% 
%       %% char type variable
%       Str = 'struct(''a'','''',''b'',''c'')';
%       value = eval(Str);
%       result = struct2string(value);
%       fprintf('source string: %s \ndecode string: %s \n',Str,result);
% 
%       %% unsigned and unsigned int type variable
%       Str = 'struct(''a'',uint8(2),''b'',uint16(2),''c'',uint32(2),''d'',uint64(2))';
%       value = eval(Str);
%       result = struct2string(value);
%       fprintf('source string: %s \ndecode string: %s \n',Str,result);
% 
%       Str = 'struct(''a'',int8(-2),''b'',int16(2),''c'',int32(-2),''d'',int64(2.4))';
%       value = eval(Str);
%       result = struct2string(value);
%       fprintf('source string: %s \ndecode string: %s \n',Str,result);
% 
%       Str = 'struct(''a'',int8([1 2]),''b'',int16([1 2;3 4]),''c'',int32([-1 2]),''d'',int64([1 -2]))';
%       value = eval(Str);
%       result = struct2string(value);
%       fprintf('source string: %s \ndecode string: %s \n',Str,result);
% 
%       %% single and double type variable
%       Str = 'struct(''a'',single(2),''b'',2 + 4i,''c'',single(2),''d'',double(25.501))';
%       value = eval(Str);
%       result = struct2string(value);
%       fprintf('source string: %s \ndecode string: %s \n',Str,result);
% 
%       %% cell type variable
%       Str = 'struct(''a'',{[1,2]})';
%       value = eval(Str)
%       result = struct2string(value);
%       fprintf('source string: %s \ndecode string: %s \n',Str,result);
%
%       %% muli-struct variable
%       Str = 'struct(''a'',struct(''a1'',struct(''a1'',''b'')),''b'',''c'')';
%       value = eval(Str)
%       result = struct2string(value);
%       fprintf('source string: %s \ndecode string: %s \n',Str,result);
%
%   See also:
%       cell2string
% 
%   Author(s): Xiaobiao Huang
%   Copyright 2013-2020 The Xiaobiao Studio.
%   $Revision: 1.0.0.0 $  $Date: 17-Sep-2013 00:13:15 $

structstring = '';
if ~isstruct(var)
    disp('Error: the intput variable is not a struct')
    return;
end
[m,n] = size(var);
if m > 1 | n > 1
    disp('Error: not support for struct array')
    return;
end
f = fieldnames(var);
v = struct2cell(var);
if isempty(v)
  v = cell(length(f),1);
end
structstring = [];
for ifield=1:length(f)
    valueString = handlestruct(f{ifield,1},v{ifield,1});
    structstring = [ structstring valueString ];
    if ifield < length(f)
        structstring = [ structstring ','];
    end        
end
structstring = ['struct(' structstring ')'];
end % end of function  struct2string

function valueString = handlestruct(field,value)
    numericTypeList = {'uint8','uint16','uint32','uint64', ...
                          'int8','int16','int32','int64', ...
                          'single','double'};
    switch class(value)
        case 'logical'
            logcicalStr = 'false';
            if value 
              logcicalStr = 'true';
            end
            valueString = [ '''' field ''',' logcicalStr ''];
            
        case 'char'
            valueString = [ '''' field ''',''' num2str(value) ''''];
            
        case numericTypeList
            varClass = class(value);
            [m,n] = size(value);
            if m > 1 | n > 1
              tempValue = num2str(value);
              tempValue = mat2str(tempValue);
              if strcmp(tempValue(1),'''')
                tempValue = ['[' tempValue(2:end-1) ']' ];
              else
                tempValue = strrep(tempValue,'''',' ');
              end
            elseif isempty(value)
              tempValue = '''''';
            else
              tempValue = num2str(value);
            end
            valueString = [ '''' field ''',' varClass '(' tempValue ')'];
        
        case 'cell'
            cellstring = cell2string(value);
            valueString = [ '''' field ''',' cellstring];
        case 'struct'
            valueString = [ '''' field ''',' struct2string(value) ];            
        otherwise
            error(['non support data class in field:' field]);
        
    end

end
