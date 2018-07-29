function s = char(p)
%PREAL/CHAR The preal class char converter.

baseDims=7;

if ~isscalar(p)
    error('preal/char does not support arrays.')
end
unit_labels={'m','kg','s','K','A','mol','rad'};
tol=0.001;
s=num2str(p.value,4);
if isnan(p.value)
    return
end
for k=1:baseDims
    if abs(p.units(k))<tol, continue, end
    if p.units(k)<0, continue, end
    if p.units(k)==1
        s=[s,' ',unit_labels{k}];
    else
        s=[s,' ',unit_labels{k},'^',num2str(p.units(k))];
    end
end
for k=1:baseDims
    if abs(p.units(k))<tol, continue, end
    if p.units(k)>0, continue, end
    if p.units(k)==1
        s=[s,' ',unit_labels{k}];
    else
        s=[s,' ',unit_labels{k},'^',num2str(p.units(k))];
    end
end