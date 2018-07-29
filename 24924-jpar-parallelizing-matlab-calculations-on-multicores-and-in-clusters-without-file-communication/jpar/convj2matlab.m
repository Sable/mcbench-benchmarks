function [objout] = convj2matlab(objin)

if isa(objin, 'matlab.jmarray.JMArray') 
    objout = j2m(objin);
    [x,y,z] = size(objout);
    if x ~= objin.getDimX() | y ~= objin.getDimY(),
        if x == objin.getDimY() & y == objin.getDimX(),
            objout = reshape(objout,y,x);
        else
            disp('Dimension mismatch!');
            keyboard;
        end
    end
elseif isa(objin, 'matlab.jmstruct.JMStruct')
    fields = cell(objin.getFields);
    vals = cell(objin.getValues);
    for I=1:numel(vals),
        jobj = cell2mat(vals(I));
        tmp = convj2matlab(jobj);
        vals(I) = {tmp};
    end    
    objout = cell2struct(vals, fields, 1);
    [x,y,z] = size(objout);
    if x ~= objin.getDimX() | y ~= objin.getDimY(),
        if x == objin.getDimY() & y == objin.getDimX(),
            objout = reshape(objout,y,x);
        else
            disp('Dimension mismatch!');
            keyboard;
        end
    end
else 
    objout = objin;
end

return;
function [marray] = j2m(jarray)
    if jarray.isReal(),
        marray = jarray.getRealpart();
    else
        marray = jarray.getRealpart() + i*jarray.getImagpart();
    end
return
