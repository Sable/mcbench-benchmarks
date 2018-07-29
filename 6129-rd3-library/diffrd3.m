function [dA,twt]=diffrd3(fname)
% diffs an rd3 file... (requires the .rad file to be present)
% syntax: [dA,twt]=loadrd3('prof4')
%
% Aslak Grinsted 2002
%

% load details from .RAD file

fname=strrep(lower(fname),'.rd3','');

tracecount=inf;
starttrace=1;
stack=0;

infos=rd3info(fname,'scans','samples','timewindow');
sz=infos{2};
timewindow=infos{3};

twt=((1:sz)'-1)*timewindow*1e-9/sz;

%loads the rd3 file
fid=fopen([fname '.rd3'],'r');
if (starttrace>1)
   fseek(fid,(starttrace-1)*sz*2,0);
end



blocksize=1+fix(1000000/sz); %number of traces to read at a time...

lastTrace=[];
traceIdx=1;
dA=zeros(1,1);
tracesread=0;
while ((~feof(fid))&(tracesread<tracecount))
    B=fread(fid,[sz blocksize],'short');
    if isempty(lastTrace)
        lastTrace=B(:,1); %ugly hack! (but ok)
    end
    for ii=1:size(B,2)
        dA(traceIdx)=sum(abs(lastTrace-B(:,ii)).*twt); %maybe multiply by twt to do some correction for decay of amps... 
        traceIdx=traceIdx+1;
        lastTrace=B(:,ii);
    end
    tracesread=tracesread+size(B,2);
end

dA=dA/mean(dA);

fclose(fid);

