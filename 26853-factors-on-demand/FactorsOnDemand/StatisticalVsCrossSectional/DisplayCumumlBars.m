function DisplayCumumlBars(C)

CumSum=cumsum(C);
N=length(C);
if C(1)>0
    Base(1)=0;
    Top(1)=C(1);
else
    Top(1)=0;
    Base(1)=C(1);
end
for n=2:N
    if C(n)>0
        Base(n)=CumSum(n-1);
        Top(n)=CumSum(n);
    else
        Top(n)=CumSum(n-1);
        Base(n)=CumSum(n);
    end
end

for n=1:N
    hold on
    h=bar(n,Top(n));
    if C(n)>0
        set(h,'FaceColor','r','EdgeColor','k','basevalue',Base(n))
    else
        set(h,'FaceColor','b','EdgeColor','k','basevalue',Base(n))
    end
end
hold on 
h=bar(n,0);
set(h,'basevalue',0)