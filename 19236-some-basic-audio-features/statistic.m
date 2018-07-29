function S = statistic(feature, Start, End, stat, x, win, step, thres)

subFeature = feature(Start:End);
if (nargin>5)
        x = x / max(abs(x));
        E = ShortTimeEnergy(x, win, step);
        T = thres * median(E);
        L = min([length(E) length(subFeature)]);
        E = E(1:L);
        subFeature = subFeature(1:L);
        subFeatureNew = subFeature(find(E>T));
        subFeature = subFeatureNew;    
end


switch stat
    case 'maxbymean'
        Max = max(subFeature);
        Mean = mean(subFeature);
        S = Max / Mean;
    case 'maxbymedian'
        Max = max(subFeature);
        Median = median(subFeature);
        S = Max / Median;
    case 'stdbymean'
        Std = std(subFeature);
        Mean = mean(subFeature);
        S = (Std^2) / (Mean^2);
    case 'mean'
        S = mean(subFeature);
    case 'std'
        S = std(subFeature);
    case 'max'
        S = max(subFeature);
    case 'min'
        S = min(subFeature);
    case 'min1'
        temp = sort(subFeature);
        S = temp(2);       
    case 'min2'
        temp = sort(subFeature);
        S = temp(3);
    case 'min3'
        temp = sort(subFeature);
        S = temp(4);
    case 'min4'
        temp = sort(subFeature);
        S = temp(5);
    case 'min0123'
        temp = sort(subFeature);
        S = mean(temp(1:4));
    case 'median'
        S = median(subFeature);
    case 'a1'
        S = length(find(subFeature>mean(subFeature)))/length(subFeature);
    case 'a2'
        S = length(find(subFeature<0.10*mean(subFeature)))/length(subFeature);
    case 'a3'
        S = mean(find(subFeature>0.000001));
    case 'a4'
        S = length(find(subFeature>5.0*mean(subFeature)))/length(subFeature);
    case 'zcr1'
        S = length(find(subFeature>0.4))/length(subFeature);
end

S(find(isinf(S)))=mean(S(find(~isinf(S))));