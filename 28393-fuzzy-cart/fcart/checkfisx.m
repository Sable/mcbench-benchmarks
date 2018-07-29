function res = checkfisx(fis)
%CHECKFISX Checks the fuzzy inference system properties for legal values.
%
%   See checkfis for syntax and explanation.
% 
%   It is completely based on MATLAB's checkfis 
%   with some modifications, so it's compatible
%   with extendent fuzzy rule structure.
% 
%   Compare also code of this function
%   with code of the original checkfis.

%   Per Konstantin A. Sidelnikov, 2009.

for i = 1 : getfisx(fis, 'numrules')
    if isempty(fis.rule(i).weight)
        error('weight of rule %d is empty.', i);        
    end
    if isempty(fis.rule(i).antecedent)
        error('antecedent of rule %d is empty.', i);        
    end
    if isempty(fis.rule(i).consequent)
        error('consequent of rule %d is empty.', i);        
    end
    if isempty(fis.rule(i).connection)
        error('connection of rule %d is empty.', i);
    end
end

for i = 1 : getfisx(fis, 'numinputs')
    if isempty(fis.input(i).name)
        error('name of input %d is empty.', i);
    end
    if isempty(fis.input(i).range)
        error('range of input %d is empty.', i);       
    end
end

for i = 1 : getfisx(fis, 'numoutputs')
    if isempty(fis.output(i).name)
        error('name of output %d is empty.', i);
    end
    if isempty(fis.output(i).range)
        error('range of output %d is empty.', i);       
    end
end

res = 1;