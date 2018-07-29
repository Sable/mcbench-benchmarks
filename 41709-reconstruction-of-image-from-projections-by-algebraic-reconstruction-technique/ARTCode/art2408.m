%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Program to reconstruct Phantom-Head Model using Algebraic    %%%%%%%%%
%%%% Reconstruction Method.                                               %
%%%%     This code is implemented By :                                   %%                                                    %%
%%%%     AUTHOR: SAYEDALI A SHAIKH,                                     %%%
%%%%     M.Tech.(CSE)                                                  %%%%
%%%%     BVBCET,HUBLI-580031, E-mail Id:sayedalishaikh@gmail.com      %%%%%
%%%%     Date: 28/08/2009                                       %%%%%%%%%%%
% % %   Guided by: Mr Shrinivas D Desai                         %%%%%%%%%%%
%%%     Associate Prof, Dept of ISE, BVBCET Hubli - 580031      %%%%%%%%%%%
%%%%    sd_desai@bvb.edu    9845275066                          %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Call Function Inputs To Enter Following Parameters
[size1,rotation,incr,s]=inputart();
%Orginal Image
I=phantom(size1);
[r1,c1]=size(I);
figure,imshow(I);
title('Original Phantom-Head Model Image ');

%Guessed Image
G=zeros(size(I));
[r2,c2]=size(G);
G2=zeros(size(G));

% Call Function To Pad The Original Image
[r3,c3,padIMG]=padO(I);
%figure,imshow(padIMG);
T1=padIMG;

% Call Function To Pad The Guessed Image
[r4,c4,padGIMG]=padG(G);
%figure,imshow(padGIMG);
T2=padGIMG;

% Calculate The Correction Factor
%Call Function To Choose The Denomenator Value w.r.t Angle and Increment

[z]=chooseart(rotation,incr);
z1=0;
z2=incr;
T3=T2;
THETA=0:incr:rotation;
s1=length(THETA);
for a=1:s1,
    org1=imrotate(T1,z1,'bilinear','crop');
% Call Function To Calculate The Row Sum and Column Sum for Original Image
    [rsumO,csumO]=calc_sum(org1,r3,z);
% Call Function To Calculate The Row Sum and Column Sum for Guessed Image
    [rsumG,csumG,padGIMG]=corr_factor(T2,r4,rsumO,csumO,r3,c3,s,z);
    %figure,imshow(padGIMG);
    G2=padGIMG;
    %figure,imshow(G2);
    T3=T3+G2;
    figure,imshow(T3);
    T3=imrotate(T3,z2,'bilinear','crop');
    z1=z1+incr;
end