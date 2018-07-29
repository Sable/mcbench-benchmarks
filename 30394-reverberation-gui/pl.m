function pl
global recs Fs h_dl ne h_ecb
dls=zeros(ne,1); % delays
for yc=1:ne
    h=h_ecb(yc);
    h1=h_dl(yc);
    if get(h,'value')
        dls(yc)=str2num(get(h1,'string'))/1000;
    end
end
mdls=max(dls); % maximum delay
mdlsi=round(mdls*Fs); % as index
dlsi=round(dls*Fs);

Lrecs=length(recs);

recse=zeros(1,Lrecs+mdlsi); % result with echos will be
recse(1:Lrecs)=recs;

% add echos
for yc=1:ne
    h=h_ecb(yc);
    if get(h,'value')
        recse(1+dlsi(yc):Lrecs+dlsi(yc))=recse(1+dlsi(yc):Lrecs+dlsi(yc))+recs;
    end
end

soundsc(recse,Fs);
