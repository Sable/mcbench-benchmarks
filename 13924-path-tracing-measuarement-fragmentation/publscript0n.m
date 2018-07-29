%% PATH TRACING, MEASUREMENTS, FRAGMENTATION

%% Path Tracing and Computation
% 
%       An application of path tracing is intended for 
% detecting  an external borders  of 1-connected black
% pixels' sets (spots), computing of  spots' and whole
% image quantitative  characteristics,  extracting and 
% removing spots or group of spots.
%
%       An output includes:
% - two matrices with coordinates of each spot border 
%   pixels; 
% - matrice with data for each spot in a proper string:
%   - coordinates of points of optimal location (centers
%     of mass) for a spot and for a spot border,
%   - perimeter (as length of line connecting  centers of 
%     border pixels and as a number of border pixels'
%     external edges), 
%   - number of  pixels in a spot and its border,
%   - coordinates of the most remote pixels,
%   - a distance between them, 
%   - coordinates of vertices of minimal  rectangle 
%     with a spot inside it.
% - The last string of the above mentioned matrice 
%   contains data for all spots in the image:
%   - mass center coordinates of all curves,
%   - mass center coordinates of all spots,
%   - a number of pixels of all borders, 
%   - a number of pixels of all spots, 
%   - coordinates of the most remote black points in the image,
%   - a distance between them,
%   - perimeter (a number of border pixels' external edges),
%   - perimeter (the total length of lines connecting 
%     border pixels' centers), 
% - a series of image files with spots.
%       Output data might be calculated from both the  
% image and a numeric matrix.
% The author - Eduard Polityko, PHD.
% E-mail     - Edpolit@gmail.com
% Edition 07-Feb-2007

alfa='examp16.bmp'; 
[A B XC]=digisn(alfa);

%% Displaying results

figure; C=[0 0 0;1 1 1];
image(imread(alfa));    colormap(C);
title('Spots'); axis xy;    grid on
format short g;
rp=repmat('_',1,26);
disp('     Coordinates');   disp(rp)
disp('Centers of mass of contours')
disp(XC(1:end-1,1:2));
disp('Centers of mass of spots');
disp([XC(1:end-1,3:4)]);
disp(['Rectangles to crop ';'(ends of diagonal) '])
disp(XC(1:end-1,10:13))
disp('The most remote points')
disp([A(XC(1:end-1,7)),B(XC(1:end-1,7)),A(XC(1:end-1,8)),...
  B(XC(1:end-1,8))])
disp(rp);   disp('Maximal distances between')
disp('points:');    disp(XC(1:end-1,9));
disp('A number of black pixels:')
disp(['       Border      ','Spot'])
disp([XC(1:end-1,5) XC(1:end-1,6)])
disp('         Perimeter:')
disp('  a number of external edges')
disp('      of border pixels ');
disp(XC(1:end-1,14))
disp('  lengths of lines connecting') 
disp('  centers of border pixels')
disp(XC(1:end-1,15));   disp([rp;rp])
disp('SUMMARY DATA');   
disp('     Coordinates');   disp(rp)
disp('Center of mass of contours'); disp(XC(end,1:2));
disp('Center of mass of spots   '); disp(XC(end,3:4));
disp('The most remote points'); disp(XC(end,7:10)); 
disp(rp);   disp('Maximal distance between')
disp(['points - ' num2str(XC(end,11))]);    disp(' ')
disp('A number of black pixels:')
disp(['       Border      ','Spot'])
disp([XC(end,5) XC(end,6)]);
disp('        Perimeter:')
disp('  a number of external edges')
disp(['  of border pixels - ' num2str(XC(end,14))])
disp('  length of lines connecting') 
disp('  centers of border pixels -');   disp(XC(end,15))
figure; zx1=plot(XC(end,1),XC(end,2),'+k',...
  XC(end,3),XC(end,4),'*k',[XC(end,7),XC(end,9)],...
  [XC(end,8),XC(end,10)],'ok');grid on
legend(['center of  '; 'curves mass'],...
  ['center of '; 'spots mass'],...,
  ['the most     ';'remote points'],'location', 'best');
title('Measurement');   set(zx1,'markersize',6)
hold on;    zx=plot(A,B,'.'); set(zx,'markersize',1)

%% Series images with spots
%Extract all spots and place them as image files
%"Newpic1.bmp", "Newpic2.bmp"...

figure; newpic='newpic';
digisn(alfa,newpic);
sXC=size(XC,1)-1;
for i=1:sXC
  sX=ceil(sXC/3);
  subplot(sX,3,i)
image(imread([newpic num2str(i),'.bmp']));colormap(C)
end

%% Spots removing
%Remove the first three spots from the image and place 
%the rest as image file 'RestAfterRemoving3.bmp', 
%where 3 is a number of removed spots)

figure; k=3;    digisn(alfa,-k);
image(imread(['RestAfterRemoving' num2str(k) '.bmp']));
title(['The rest after removing first ' num2str(k) ' spots']);
colormap(C);    grid on;

%% Keep spots
%Extract spots from #3 to #5 and place them as
%image file "Keep_35.bmp"
figure; k=[3;5];    digisn(alfa,k);
image(imread(['Keep' num2str(k(1)) '_' num2str(k(2)) '.bmp'])); 
title(['Spots from #' num2str(k(1)) ' to #' num2str(k(2))]);
colormap(C);grid on
