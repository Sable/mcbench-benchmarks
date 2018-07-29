function [Hn,Xn] = myHist(Data)

nBins = round(length(Data) / 15);

[H,X] = hist(Data, nBins);

[Max,IMax] = max(H);

sumH = sum(H);
curSum = 0.0;

T = 0.990;

i1 = IMax;
i2 = IMax;
I1 = i1;
I2 = i2;
stop1 = 0;
stop2 = 0;
while ((i1>=1) || (i2<=length(X)))
    if (i1~=i2)
        if (stop1~=1) curSum = curSum + H(i1); end
        if (stop2~=1) curSum = curSum + H(i2); end 
    else
        curSum = curSum + H(i1);        
    end
    if (curSum <= sumH * T)
        I1 = i1;
        I2 = i2;
        if (i1>1)
            i1 = i1 - 1;
        else
            stop1 = 1;
        end
        if (i2<length(X))
            i2 = i2 + 1;
        else
            stop2 = 1;
        end
    else        
        break;
    end
end

Xn = X(I1:I2);
Hn = H(I1:I2);

%plot(Xn,Hn + max(H));
%hold on;
%plot(X,H,'r')
