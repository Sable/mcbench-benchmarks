function lpcb
global lowpass hlp

if get(hlp,'value')
    lowpass=true;
else
    lowpass=false;
end