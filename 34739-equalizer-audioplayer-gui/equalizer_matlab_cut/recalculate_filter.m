function recalculate_filter
% reaclulate filter object (after sliders changed)
global hdls
global g1 g2 n hs
global Q f filts_type
global hp hpp
global Fs
global hd1 hd2

gg=[];
ssa=[];
ssb=[];
for nc=1:n
    g=get(hs(nc),'value');
    gg=[gg g];
    switch filts_type(nc)
        case 1
            [b a]=get_low_shelving_filter(g,Q(nc),f(nc),Fs);
        case 2
            [b a]=get_peak_filter(g,Q(nc),f(nc),Fs);
        case 3
            [b a]=get_high_shelving_filter(g,Q(nc),f(nc),Fs);
    end
    
%     if nc==1
%     
%         aa=a;
%         bb=b;
%         
%     else
% 
%         aa=conv(aa,a);
%         bb=conv(bb,b);
%     
%     end

    ssa=[ssa; a];
    ssb=[ssb; b];
end
ss=[ssb ssa];
% recreate filter and copy state from old filter to new one if possible:
ex=exist('hd1.States','var');
if ex
    os=hd1.States; % old states
end
hd1=dfilt.df1sos(ss);
if ex
    hd1.States=os;
end
hd1.PersistentMemory=true;
ex=exist('hd2.States','var');
if ex
    os=hd2.States; % old states
end
hd2=dfilt.df1sos(ss);
if ex
    hd2.States=os;
end
hd2.PersistentMemory=true;
[h,w] = freqz(hd1);

fq=(w/pi)*Fs/2;
%set(hp,'XData',fq,'YData',abs(h));
set(hp,'XData',fq,'YData',20*log10(abs(h)));
set(hpp,'XData',f,'YData',gg);
xlim(hdls.axes1,[fq(1) fq(end)]);
ylim(hdls.axes1,[g1 g2]);

if isstable(hd1)
    set(hdls.ftx,'string','filter: stable');
else
    set(hdls.ftx,'string','filter: unstable');
end

drawnow;
    

            
            
