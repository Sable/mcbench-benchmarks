function varray=makevarray(filename,format)
baseIndex = 0;
formatSize = getsize(format);

m=memmapfile(filename,'repeat', 1, ...
    'offset', baseIndex * formatSize, 'format',format);

varray=@accessarray;

    function y = accessarray(index)
        maxI = max(index);
        minI = min(index);
        if maxI > baseIndex || minI < baseIndex
            baseIndex = minI - 1;
            m.offset = formatSize * baseIndex;
        end
        requestedrange = maxI - minI + 1;

        if requestedrange > 1e6
            error('Only 1e6 can be mapped');
        end

        % need to update in case old requested range was bigger
        % than new one, and index is near end of file.
        m.repeat=requestedrange;

        y=m.Data(index - baseIndex);
    end
    function sz = getsize(fmt)
        switch fmt
            case {'double', 'uint64', 'int64'}
                sz = 8;
            case {'single', 'uint32', 'int32'}
                sz = 4;
            case {'uint16', 'int16'}
                sz = 2;
            case {'uint8', 'int8'}
                sz = 1;
        end
    end
end
