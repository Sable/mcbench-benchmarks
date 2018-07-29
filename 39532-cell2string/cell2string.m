function cellstring = cell2string ( var )

%CELL2STRING get the sentence which create the cell variable
%
%   CELL2STRING(varagin) Detailed explanation goes here
%
%   Inputs:
%       var             a struct type variable
%
%   Outputs:
%       cellstring      the sentence which could create the varaible 'var'
%
%   Syntax:
%       cellstring = cell2string ( var )
%
%   Example:
%
%       %% logical type variable
%       Str = '{true,false}';
%       value = eval(Str);
%       result = cell2string(value);
%       fprintf('source string: %s \ndecode string: %s \n',Str,result);
% 
%       %% char type variable
%       Str = '{''a'','''',''b'',''c''}';
%       value = eval(Str);
%       result = cell2string(value);
%       fprintf('source string: %s \ndecode string: %s \n',Str,result);
% 
%       %% unsigned and unsigned int type variable
%       Str = '{uint8(2),uint16(2),uint32(2),uint64(2)}';
%       value = eval(Str);
%       result = cell2string(value);
%       fprintf('source string: %s \ndecode string: %s \n',Str,result);
% 
%       Str = '{int8(2),int16(-2),int32(2),int64(-2)}';
%       value = eval(Str);
%       result = cell2string(value);
%       fprintf('source string: %s \ndecode string: %s \n',Str,result);
% 
%       Str = '{int8([1 2]),int16([1 2;3 4]),int32([-1 2]),int64([1 -2])}';
%       value = eval(Str);
%       result = cell2string(value);
%       fprintf('source string: %s \ndecode string: %s \n',Str,result);
% 
%       %% single and double type variable
%       Str = '{single(2),2 + 4i,double(25.501)}';
%       value = eval(Str);
%       result = cell2string(value);
%       fprintf('source string: %s \ndecode string: %s \n',Str,result);
% 
%       %% struct type variable
%       Str = '{struct(''a'',{[1,2]})}';
%       value = eval(Str)
%       result = cell2string(value);
%       fprintf('source string: %s \ndecode string: %s \n',Str,result);
%
%       %% muli-struct variable
%       Str = '{''a'',{''a1'',{''a1'',''b''}},''b'',''c''}';
%       value = eval(Str)
%       result = cell2string(value);
%       fprintf('source string: %s \ndecode string: %s \n',Str,result);
%
%   See also:
%       struct2string
% 
%   Author(s): Xiaobiao Huang
%   Copyright 2013-2020 The Xiaobiao Studio.
%   $Revision: 1.0.0.0 $  $Date: 16-Sep-2013 23:11:36 $

if ~iscell(var)
    disp('Error: the class of the intput variable isn''t cell')
    return;
end
% get the size of the variable: var
cellstring = [];
[column,row] = size(var);
% loop cell
for iColumn = 1 : column
    for iRow = 1 : row
        tempStr = value2string(var{iColumn,iRow});
        cellstring = [ cellstring tempStr ];
        if iRow < row
            cellstring = [ cellstring ','];
        end
    end 
    cellstring = [ cellstring ';'];
end
cellstring = ['{' cellstring '}'];
% varargout = {cellstring};
end % end of function  cell2string

function valueString = value2string(value)
    numericTypeList = {'uint8','uint16','uint32','uint64', ...
                          'int8','int16','int32','int64', ...
                          'single','double'};    
    switch class(value)
        case 'logical'
            tempString = 'false';
            if value
                tempString = 'true';
            end
            valueString = tempString;
            
        case 'char'
            valueString = [ '''' value '''' ];
       
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
            valueString = [varClass '(' tempValue ')'];            
        case 'cell'
            valueString = cell2string(value);
        case 'struct'
            valueString = struct2string(value);
        otherwise
            valueString = '{}';            
    end
end

