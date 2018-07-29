%DEMO_LOCSTAT2 - performing the image enhancement based on local statistics.
% Using COLFILT function to improve speed.
%Copyright by Alex Zuo (zuoxinian@yahoo.com.cn). 

clear,clc;
%% Read original SEM images
Isem=imread('testimages/sem.jpg');
%% Caculate the global mean and variance.
f=double(Isem);
M=mean2(f);D=std2(f);
%% Perform the enhancing task.
Bsize=[3 3];
k=[0.4 0.02 0.4];
E=4.0;
tic
fsem_enh=colfilt(f,Bsize,'sliding', @mylocstat2,M,D,E,k);
t_colfilt=toc %display time-consuming
Isem_enh=im2uint8(mat2gray(fsem_enh));
%% Visualize the result.
subplot(1,2,1),imshow(Isem),title('SEM Image')
subplot(1,2,2),imshow(Isem_enh),title('Enhanced SEM Image with COLFILT')
%Save the result for publish.
%imwrite(Isem_enh,'outfiles/sem_enhanced.jpg')
%print(gcf,'-deps','outfiles/sem_locstatenh.eps')
%figure,imshow(Isem)
%print(gcf,'-deps','outfiles/sem.eps')