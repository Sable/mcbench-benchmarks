function [objout] = convm2java(objin)

if iscell(objin),
    objin = cell2mat(objin);
end

if isnumeric(objin) 
   objout = m2j(objin);
elseif isstruct(objin)
    fields = fieldnames(objin);
    vals = struct2cell(objin);
    [x, y, k] = size(objin);
    objout = matlab.jmstruct.JMStruct;
    objout.setFields(fields);
    objout.setDimX(x);
    objout.setDimY(y);    
    for I=1:numel(vals)
        tmp = convm2java(vals(I));
        vals(I) = tmp;
    end    
    objout.setValues(vals);
else
    objout = cellstr(objin);
end;
return;

function [jarray] = m2j(marray)
    jarray = matlab.jmarray.JMArray;
    [x, y, k] = size(marray);
    jarray.setDimX(x);
    jarray.setDimY(y);
    jarray.setRealpart(real(marray));
    if isreal(marray),
        jarray.setReal(true);
    else
        jarray.setReal(false);
        jarray.setImagpart(imag(marray));
    end
return;
