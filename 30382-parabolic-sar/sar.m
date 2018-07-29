function sar = sar(high, low)
    %constants
    uptrend = 1;
    downtrend = 2;
    sar(1)=NaN;
    
    %variables
    alpha=0.02;
    EP=high(1);%between the high and low
    
    %'previous trade' is either long or short on day 1. sar(1)=NaN
    
    %decide whether to start with long or short
    if(high(1)>high(2))
        position=uptrend;
    else
        position=downtrend;
    end
        
    if(position==uptrend)
        sar(1)=high(1);
    else
        sar(1)=low(1);
    end
    
    for n=1:length(high)-1
        if(position==uptrend)
            EP=min(EP,low(n));
        else
            EP=max(EP,high(n));
        end
        alpha=min(alpha+0.02,0.2);
        sar(n+1)=sar(n)+alpha*(EP-sar(n));
        
        %"Parabolic SAR is never moved within the range of the current
        %or previous day (highest High to lowest Low over the 2 days)."
        if(n>2)
            if(sar(n+1)<max(high(n-1),high(n)) && sar(n)>min(low(n-1),low(n)))
                if(position==downtrend)
                    sar(n+1)=min(low(n-1),low(n));
                else
                    sar(n+1)=max(high(n-1),high(n));
                end
            end
        end
        if(sar(n+1)<high(n+1) && sar(n+1)>low(n+1))
            sar(n+1)=EP;
            if(position==uptrend)
                position=downtrend;
                EP=low(n);
            else
                position=uptrend;
                EP=high(n);
            end
            alpha=0.02;
            %sar(n+1)=sar(n)+alpha*(EP-sar(n));
        end
    end
end