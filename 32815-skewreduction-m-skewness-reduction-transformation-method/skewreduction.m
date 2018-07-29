function [xt r sk]=skewreduction(x)
% This function tranform x (a skewed data) to xt in which xt has skewness close to zero.
% This is useful to trasform skewed data to normal (or close to normal)data.

% Input: 
% x: original data (skewed data)

% Outputs:
% xt: transformed data (data with skewness close to 0)
% r: a root in which xt=x.^r
% sk: skewness of transfomed data

% Example 1 (x has positive skewness): 
% x=gamrnd(1,4,1,1000);
% [xt r sk]=skewreduction(x)

% Example 2 (x has negative skewness): 
% x=wblrnd(3,20,1,1000);
% [xt r sk]=skewreduction(x)


% Copyright(c) Babak Abbasi, RMIT University, 2011
% b.abbasi@gmail.com

%Reference: Niaki, S.T.A and Abbasi, B., 2007, Skewness Reduction Approach in Multi-Attribute Process Monitoring
% Communications in Statistics - Theory and Methods Volume 36, Issue 12, 2007

Sk=skewness(x);
r1=.005;
r2=.995;
m=1;
if Sk > 0
    sk1=skewness(x.^r1);
    sk2=skewness(x.^r2);
    ss=sk1;
    rr=sk1;
    while (abs(ss)>.05 & m<200)
        m=m+1;
        rr=(r1+r2)/2;
        skrr=skewness(x.^rr);
        ss=skrr;
        if skrr*sk1<0
            sk2=skrr;
            r2=rr;
            ss=skrr;
        else
            sk1=skrr;
            ss=skrr;
            r1=rr;
        end
    end
else
    r1=(1/r1);
    r2=(1/r2);
    sk1=skewness(x.^(r1));
    sk2=skewness(x.^(r2));
    ss=sk1;
    rr=sk1;
    while (abs(ss)>.05 & m<200)
        m=m+1;
        rr=(r1+r2)/2;
        skrr=skewness(x.^rr);
        ss=skrr;
        if skrr*sk1<0
            sk2=skrr;
            ss=skrr;
            r2=rr;
        else
            sk1=skrr;
            ss=skrr;
            r1=rr;
        end
    end
end
r=rr;
sk=skewness(x.^rr);
xt=x.^r;