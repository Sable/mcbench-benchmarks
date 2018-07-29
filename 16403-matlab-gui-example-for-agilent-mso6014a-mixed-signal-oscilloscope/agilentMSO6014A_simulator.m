function f = agilentMSO6014A_simulator(visaResourceString)

f.setTimeBase = @setTimeBase;
f.getTimeBase = @getTimeBase;
f.setVerticalScale = @setVerticalScale;
f.getVerticalScale = @getVerticalScale;
f.getWaveform = @getWaveform;
f.autoscale = @autoscale;
f.close = @close;

timeBase = 1e-6;
verticalScale = 1e-3;
fprintf('Setting up simulated connection\n');

%%------------------------------------------
    function out = getTimeBase
        out = timeBase;
    end

    function setTimeBase(newval)
        fprintf('setting timeBase to %g\n', newval);
        timeBase = newval;
    end

    function setVerticalScale(newval)
        fprintf('setting verticalScale to %d\n', newval);
        verticalScale = newval;
    end

    function out = getVerticalScale
        out = verticalScale;
    end
    
    function out = getWaveform
        out = randn(1000,1);
    end
    
    function autoscale
        disp('Autoscale invoked');
    end

    function close
        disp('Closing connection to instrument');
    end

%%----------------------------------------------------
end
