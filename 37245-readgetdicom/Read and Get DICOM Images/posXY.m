function pos=posXY(ParentOpj,a,b,c,d)

if nargin<5
    if c==0
        c=0.97-a;
        d=0.97-b;
    elseif c==1
        c=1-a;
        d=1-b;
    elseif c==2
        c=1-2*a;
        d=1-2*b;
    end
end
    
s=length(ParentOpj);

if s>1
    pos=ParentOpj;
elseif s==1
    pos=get(ParentOpj,'position');
end

pos=[a*pos(3) b*pos(4) c*pos(3) d*pos(4)];
end