%set(hdls.slider1,'value',pso*pco/size(s,1));
tm=pso*pco/Fs;
tm0=size(s,1)/Fs;
t1=floor(tm/60);
t2=floor(mod(tm,60));
if t2<10
    t2s=['0' num2str(t2)];
else
    t2s=num2str(t2);
end

t10=floor(tm0/60);
t20=floor(mod(tm0,60));

if t20<10
    t20s=['0' num2str(t20)];
else
    t20s=num2str(t20);
end
    

set(hdls.time,'string',[num2str(t1) ':'  t2s '  of  ' num2str(t10) ':'  t20s]);