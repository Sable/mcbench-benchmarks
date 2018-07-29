function [Data]=ReconstructImage(amp,phi,nb)
if (max(size(size(amp)))~=3)
    error('amp and phi must be three dimensional [nf,lat,lon]')
end

[~,ny,nx]=size(amp);

Data=zeros(nb,ny,nx);

h= waitbar(0,'Total Progress:');
WBarOuterPosition=get(h,'OuterPosition');
WBarOuterPosition(2)=WBarOuterPosition(2)-WBarOuterPosition(4);
h2=waitbar(0,'Calculating, please wait ...');
set(h2,'OuterPosition',WBarOuterPosition);

for Sample=1:nx
    waitbar(Sample/nx,h);    
    for Line=1:ny
        waitbar(Line/ny,h2,['Line:' num2str(Line) ', Sample:' num2str(Sample)]);
        amp_Pixel=squeeze(amp(:,Line,Sample));
        phi_Pixel=squeeze(phi(:,Line,Sample));
        Data(:,Line,Sample)=ReconHANTSData(amp_Pixel,phi_Pixel,nb);
    end
end
close(h);
close(h2);
end