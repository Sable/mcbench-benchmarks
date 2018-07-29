function [y] = srconv(x,fsin,fsout)
%
% function to convert sampling rate from one sampling rate to another
% so long as the sampling rates have an integer least common multiple
%
% Inputs:
%   x: input signal at rate fsin
%   fsin: sampling rate on input
%   fsout: new sampling rate on output
%
% Output:
%   y: output signal at sampling rate fsout
%
% determine m, the least common multiple (lcm) of fsin and fsout
    m=lcm(fsin,fsout);
    
% determine the up and down sampling rates
    up=m/fsin;
    down=m/fsout;
    
% resample the input using the computed up/down rates
    y=resample(x,up,down);

end

