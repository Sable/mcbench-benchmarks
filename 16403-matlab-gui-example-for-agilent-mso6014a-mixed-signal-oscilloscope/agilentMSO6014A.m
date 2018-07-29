function functionStruct = agilentMSO6014A(visaRsrcString)

iObj = visa('agilent',visaRsrcString);
set(iObj,'InputBufferSize',2048);
scopeObj = icdevice('AGNMSO6014A',iObj);
connect(scopeObj);
fprintf(scopeObj.Interface,'*RST');
functionStruct.setTimeBase = @setTimeBase;
functionStruct. getTimeBase = @getTimeBase;
functionStruct.setVerticalScale = @setVerticalScale;
functionStruct.getVerticalScale = @getVerticalScale;
functionStruct.getWaveform = @getWaveform;
functionStruct.autoscale = @autoscale;
functionStruct.close = @close;

    function setTimeBase(timebase)
        set(scopeObj,'timebase',timebase);
    end
        
    function timebase = getTimeBase
        timebase = get(scopeObj,'timebase');
    end

    function setVerticalScale(scale)
        set(scopeObj,'verticalscale',scale);
    end

    function scale = getVerticalScale
        scale = get(scopeObj,'verticalscale');
    end

    function [yData xData] = getWaveform
        [yData xData] = invoke(scopeObj,'getwaveform');
    end

    function autoscale
        invoke(scopeObj,'autoscale');
    end

    function close
        disconnect(scopeObj);
        delete(scopeObj);
        delete(iObj);
    end

end

