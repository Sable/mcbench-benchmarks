%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Program to reconstruct Phantom-Head Model using Simple Back %%%%%%%%%%
%%%% Projection Method.                                                  %%
%%%% This code is implemented By :                                       %%
%%%%     AUTHOR: SAYEDALI A SHAIKH,                                     %%%
%%%%     M.Tech.(CSE)                                                 %%%%%
%%%%     BVBCET,HUBLI-580031, E-mail Id:sayedalishaikh@gmail.com    %%%%%%%
%%%%     Date: 11/08/2009                                       %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Call Function Input The Parameters
[size1,upto,increment]=inputsbp();
%%% Define phantom-head model 
IMG=phantom(size1);
figure,imshow(IMG);
title('Original Phantom-Head Model image ');

%%% Define parameters, Ex: projections taken from 0 degree to 180 degree
%%% with increment of 2.5 degree: increment=2.5,upto=180,

THETA=0:increment:upto;

%%% Image padding has to be done with zeros so that we don't loose side 
%%% information when we rotate.
[iLength, iWidth] = size(IMG);
iDiag = sqrt(iLength^2 + iWidth^2);
LengthPad = ceil(iDiag - iLength) + 2;
WidthPad = ceil(iDiag - iWidth) + 2;
padIMG = zeros(iLength+LengthPad, iWidth+WidthPad);
%figure,imshow(padIMG);
padIMG(ceil(LengthPad/2):(ceil(LengthPad/2)+iLength-1), ...
       ceil(WidthPad/2):(ceil(WidthPad/2)+iWidth-1)) = IMG;
%figure,imshow(padIMG);
title('Padded image ');
%%% Define one more matrix G which will help in adding projections
[pl,pw]=size(padIMG);
G(1:pl,1:pw)=0;
%figure,imshow(G);

%%% n gives number of increments, PR will have number of rows = number of
%%% rows of padIMG, & number of column = n
n = length(THETA);
PR = zeros(size(padIMG,2), n);

% Rotate the image from 0' to "upto" with "increment" & store raysum in PR
for i = 1:n
    tmpimg = imrotate(padIMG, THETA(i), 'bilinear', 'crop');
    %figure,imshow(tmpimg);title('Rotated image');
    for j=1:pl,
        PR(j,i)= sum(tmpimg(j,:));
    end
end

%Call Function To Choose The Denomenator Value w.r.t Angle and Increment
[z]=choosesbp(upto,increment);
%z=ceil((180/increment)*1);
%%% Reconstruction starts here, a backprojection is formed by smearing each
%%% view back through the image in the direction it was originally acquired
T2=zeros(size(G));
k=increment;
    for j=1:n,
        for i=1:pl,
            G(:,i)=PR(:,j)/z;
        end
        
        G2= (G + T2); %figure,imshow(G2);title('Backprojected image');
        T2 = imrotate(G2,k,'bilinear', 'crop');
    end
%%% G2 image gives the reconstructed image
    figure,imshow(G2);