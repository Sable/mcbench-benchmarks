function step(n,dvl)
global h_dl

h=h_dl(n);

vl=str2num(get(h,'string'));
vl=vl+dvl;
if vl<0
    vl=0;
end
set(h,'string',num2str(vl));

