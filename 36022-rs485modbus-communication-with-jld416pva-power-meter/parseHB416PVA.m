function [vv,ii,pp,crcCheck] = parseHB416PVA(instrResponse)
% Processes response from HB416PVA when queried for all 6 measured data
% registers (voltage, voltage description, current, current description,
% power and power description).  Returns quantities in units of Volts,
% Amps, and Volt-Amps (Watts). Accounts for decimal place and unit.  Also
% returns the value of the CRC ckeck.

% Copyright (c) 2012, 
% Profs. W. R. Ashurst and T. D. Placek
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:
% 
%     * Redistributions of source code must retain the above copyright
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright
%       notice, this list of conditions and the following disclaimer in the
%       documentation and/or other materials provided with the distribution
%       
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
% IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
% THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
% PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
% CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
% EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
% PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
% PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
% LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
% NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
% SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

crcCheck = checkCRC(instrResponse);
if (crcCheck) % message is OK
    hByteVolt = instrResponse(4); lByteVolt = instrResponse(5);
    multVolt = instrResponse(6); unitVolt = instrResponse(7);
    hByteAmp = instrResponse(8); lByteAmp = instrResponse(9);
    multAmp = instrResponse(10); unitAmp = instrResponse(11);
    hBytePwr = instrResponse(12); lBytePwr = instrResponse(13);
    multPwr = instrResponse(14); unitPwr = instrResponse(15);

    vv = (256*hByteVolt + lByteVolt)*scmult(multVolt,unitVolt);
    ii = (256*hByteAmp + lByteAmp)*scmult(multAmp,unitAmp);
    PPint = (256*hBytePwr + lBytePwr);
    if (PPint > (intmax('uint16')/2 - 1))
        PPint = double(intmax('uint16')/2 - 1) - double(PPint);
        pp = PPint*scmult(multPwr,unitPwr);
    else
        pp = PPint*scmult(multPwr,unitPwr);
    end
else % the crc check failed
    vv = NaN; ii = NaN; pp = NaN;
end
end

function scalefactor = scmult(decimals, unit)
% Unit will only be 0, 1 or 2.  Decimals will only be 0, 1, 2 or 3.  The
% interpretation of the descriptor byte is not clearly documented - the
% following are guesses, but seem to match the display.

switch unit
    case 0
        scalefactor = 1;
    case 1
        scalefactor = 1000;
    case 2
        scalefactor = 1000000;
end

switch decimals
    case 0
        scalefactor = scalefactor*1;
    case 1
        scalefactor = scalefactor*0.1;
    case 2
        scalefactor = scalefactor*0.01;
    case 3
        scalefactor = scalefactor*0.001;
end

end
