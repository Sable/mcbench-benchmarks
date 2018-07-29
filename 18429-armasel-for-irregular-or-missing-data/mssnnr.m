function msnn = mssnnr(ti, xi, T, w);
% multi shift slotted nearest neighbor resampling
%
% ti : irregular input times [s]
% xi : irregular input signal
% T  : regular output resampling time [s]
% w  : slot width as fraction of T
% 
% mssnnr resamples according to NN
% startings time for multi shift records Tw, 2*Tw, ... ninit*Tw
% only samples with t(i) - 1/2*Tw < t(i) < kT+init*Tw < t(i) + 1/2*Tw.
% Program requires w < = T

if w > 1
    return;
end

N = length(xi);
ninit=floor(1/w); % init= 1:ninit as starting points
Tw = w * T;

msnn=cell(2,ninit);

ti=ti-ti(1)+Tw;  %shift of entire time scale

for init=1:ninit,
   
    xout = zeros(1,N);
    tout = zeros(1,N);
    
    t = init*Tw;
    i = 1;
    j = 1;
    
    while i <= N
        while (ti(i) <= (t - 0.5 *Tw))
            i = i + 1;
            if i > N
                break;
            end
        end
        
        if i <= N
            dtmin = abs(ti(i) - t);
            dtmini = 0;
            while (ti(i) < (t + 0.5 .* Tw))
                if abs(ti(i) - t) <= dtmin
                    dtmin = abs(ti(i)-t);
                    dtmini = i;
                end
                i = i + 1;
                if i > N
                    break;
                end
            end
            
            if (dtmini ~= 0)
                tout(j) = t;
                xout(j) = xi(dtmini);
                j = j + 1;
            end
        end
        
        t = t + T;	
    end
    
    msnn{1,init} = round((tout(1:j-1)-(init-1)*Tw)/T);
    msnn{2,init} = xout(1:j-1);
    
end