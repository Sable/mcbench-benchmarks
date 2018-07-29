function response = Golden(n,p)

persistent mems
if n==1; mems=0; end


if p==0 || p==3 || n==1
    response = 'cooperate';
else
    response = 'defect';
end


if length(mems)>=4
    if isequal( mems(end-3:end), [5 0 5 0] ); response = 'cooperate'; end
end
mems(n)=p;