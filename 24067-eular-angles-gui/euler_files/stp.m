function stp(h,st,clb,fig)


sr=str2num(get(h,'string'));

fud=get(fig,'UserData');
st=fud{2}*sign(st);

if length(sr)==0
    nan_error;
else
    sr=sr+st;
end

set(h,'string',num2str(sr));

eval(clb);