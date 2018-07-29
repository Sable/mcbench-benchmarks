%Demo IGRF11
%
%Charles L. Rino
%Rino Consulting
%crino@mindspring.com
clear
global gh
if exist('GHcoefficients','file')==2
    load('GHcoefficients')
else
    gh=GetIGRF11_Coefficients(1);
end


fyear=2009.7;
alt=300;
z =zeros(size(length([-180:179]),length([-89:90])));
dip=z;
for long=-180:179
    for lat=-89:90
        xyzt=igrf11syn(fyear,alt,lat,long);
        z(long+181,lat+90)=xyzt(3);
        dip(long+181,lat+90)=atan2(xyzt(3),sqrt(xyzt(1).^2+xyzt(2).^2));
    end
end

figure
imagesc([-180:179],[-89:90],z')
axis xy
colorbar
xlabel('Longitude--deg')
ylabel('Latitude--deg')
title('Bz--at alt=0 NTeslas')

zlon_deg=-180:179;
zlat_deg=-89:90;
figure
imagesc(zlon_deg,zlat_deg,z')
axis xy
hold on
%An equator location of interest
rtd=180/pi;
origin_llh =[-0.0453,-0.7716,48.2000];
hold on
plot(origin_llh(2)*rtd, origin_llh(1)*rtd,'mp')
colorbar
title('Bz--at alt=0 NTeslas')
xlabel('Longitude--deg')
ylabel('Latitude--deg')
LINESPEC='w';
hold on
[cs,h]=contour(zlon_deg,zlat_deg,z',20,LINESPEC);

save Bz300 zlon_deg zlat_deg z dip