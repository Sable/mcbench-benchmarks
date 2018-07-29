function [op ismax]=find_all_optimums(s)
s1=s(1:end-2);
s2=s(2:end-1);
s3=s(3:end);

% maximums:
imx=1+find((s1<=s2)&(s2>=s3));
Lmx=length(imx);

% minimums:
imn=1+find((s1>=s2)&(s2<=s3));
Lmn=length(imn);

ii=[imx; imn];

[iis iii]=sort(ii);

op=iis;

ismax=(iii<=Lmx);