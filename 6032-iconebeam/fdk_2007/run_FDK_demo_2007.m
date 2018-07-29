% simple file for demonstrating the Feldkamp - Devis - Kress algorithm 
% for tomo reconstruction according to cone beam geometry

clear all, 
close all  

global size_proj % size of the projection 
global Sinog % make available projections to read_1proj function

%
NI=128; % NI is a scalar that specifies the number of rows and col. in the phantom.
phant = phantom(NI); % generating phantom image 

% Generate set of projections around 360 degrees with a fan beam geometry
Radius=150; % distance focal spot - object ratation axis
[F,Floc,Fangles] = fanbeam(phant,150,'FanRotationIncrement',1, 'FanSensorGeometry' ,'line');  
Sinog=rot90(F,-1); % sinogram 
%figure, imshow(Floc,Fangles,Sinog,[ ],'n'), axis normal
figure, imshow(Sinog,[ ]), axis normal
ylabel('Rotation Angles (degrees)')
xlabel('Sensor Positions (degrees)')
title('sinogram');
colormap(hot), colorbar

% Recontruction from sinthetic projections 
tic
Ifb = ifanbeam(F,Radius,'FanSensorGeometry' ,'line');  
toc
figure, imshow(phant,[]); title('phantom');
figure, imshow(Ifb); title(' ifanbeam');

% Using FDK cone beam code to reconstruct the central slice 

% filter parameters
df=1;  
filter='ram-lak' % high pass for sintetic images 
% interpolation parameter : notice that we use bilinear in cone beam 
%and linear in fan beam 
interp='nearest neighbor',  % interpolation method
interp='bilinear',  % interpolation method
interp='n_n_demo',  % interpolation method

% not needed for this demo 
dir='dummy' % radiographic directoryname 
fl_prefix='pcon_'; % prefix tomographic data i
%

range_slices=[ ] ; % only central slice is reconst
step=1; % all slices 
Proj_Crop=[1 size(Sinog,2) ]; % i.e. no crop because the sinogram in centered

% call iconebeam function for filterd backprojection
NI=0;
tic 

[Vol] = ...
    iconebeamdemo2007(dir,fl_prefix,-Fangles,interp,filter,df,NI,step,Radius,range_slices,Proj_Crop);

toc


[svx,svy,svz]=size(Vol);
for is=1:svz
    vct=Vol(:,:,is); vct=vct(:);
%b=max(vct);
%a=min(vct);
a=prctile(Vol(:),3);
b=prctile(Vol(:),97);
end


if svz >1 
% Rendering !!
figure,
hs=slice(Vol,[round(svx/2)],[round(svy/2)],[round(svz/3), round(svz*2/3)]);%,'linear') ; %SLICE(V,Sx,Sy,Sz) 
view(3); %grid off;
set(hs,'FaceColor','interp','Edgecolor','none')
colormap(gray(256));
%draws slices along the x,y,z directions at the points in the vectors Sx,Sy,Sz.
else
   Img=Vol(:,:,1)'; Img=fliplr(Img);
   figure, imshow(Img,[a  b]) ; title(' iconebeam');

end

%save filename Vol % to save vol on disk !
% author: schena@units.it