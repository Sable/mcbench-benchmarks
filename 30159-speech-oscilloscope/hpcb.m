function hpcb
global highpass hhp

if get(hhp,'value')
    highpass=true;
else
    highpass=false;
end