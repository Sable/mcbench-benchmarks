function [yOut, amp, phi]=ApplyHants(y,nb,nf,fet,dod,HiLo,low,high,delta)
if (max(size(size(y)))~=3)
    error('Input data must be three dimensional [time,lat,lon]')
end

[ni ny,nx]=size(y);

yOut= zeros(ni,ny,nx,'single');
amp = zeros(nf+1,ny,nx,'single');
phi = zeros(nf+1,ny,nx,'single');
ts=1:ni;

h= waitbar(0,'Total Progress:');
WBarOuterPosition=get(h,'OuterPosition');
WBarOuterPosition(2)=WBarOuterPosition(2)-WBarOuterPosition(4);
h2=waitbar(0,'Calculating, please wait ...');
set(h2,'OuterPosition',WBarOuterPosition);
for Sample=1:nx
    waitbar(Sample/nx,h);
    for Line=1:ny
        waitbar(Line/ny,h2,['Line:' num2str(Line) ', Sample:' num2str(Sample)]);
        data=y(:,Line,Sample);
        if (sum(isnan(data))~=ni)
            data(isnan(data))=low-1.0;
            [amp(:,Line,Sample),phi(:,Line,Sample),yOut(:,Line,Sample)] ...
                    = HANTS(ni,nb,nf,data,ts,HiLo,low,high,fet,dod,delta);
        end
    end
end
close(h);
close(h2);
end