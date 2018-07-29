function VM_Demo

% A new visibility metric is proposed.
% This work is written by zhengguo dai in Beijing JX Digital Wave Co.ltd
% zhgdai@126.com

%% Demo1: Haze Images
%% testimgname: forest; train; canyon; canon3; gugong; hongkong; ny1; tiananmen1
close all ;
testimgname = 'ny1' ;

im1 = double( rgb2gray( imread( strcat(testimgname,'.bmp') ) ) ) ;
CNR1 = Compute_VM( im1, 5, 5 ) ;

im2 = double( rgb2gray( imread( strcat(testimgname,'_res.png') ) ) ) ;
CNR2 = Compute_VM( im2, 5, 5 ) ;

figure ; 
subplot(1,2,1);imshow( im1, [] ); title(strcat( 'Visibility Metric =',num2str(CNR1))) ;
subplot(1,2,2);imshow( im2, [] ); title(strcat( 'Visibility Metric =',num2str(CNR2))) ;

% haze_improve = CNR2 - CNR1 
