%JC 7/16/08-sim_qpsk_video
%I thought some might be interested in this m-file, since we live in a 
%world of data,text,audio and video.
%User has the option of using Data or an image(Lena1.bmp) to determine BER/SER for
%M=2,4 or 8 PSK.
%User also has the option of using Gray coding or no Gray coding.
%Viewing a still image file thru a channel with AWGN added gives an intuitive insight into the
%degradation of video at different levels of SNR. Running the image takes
%approx 8 minutes. The program showes, for (M=2,4), the image is reproduced
%(without errors) at approx. 10dB and M=8 requires approx 14 dB which
%agrees with theory. The bandwidth efficiency for M=2 is 1(bit/sec/Hz), M=4
%is 2(bits/sec/Hz), and M=8 is 3(bits/sec/Hz). Therefore M=4 and M=8 are good 
%choices for band limited channels. I restructered this program from one
%written by
%Chen Zhifeng
%4/28/2007
%Search WEB for "Performance Analysis of Channel Estimation and
%Equalization in Slow Fading Channels"
%--------------------------------------------------------------------------
close all;
clear all;
clc;
%--------------------------------------------------------------------------
%Set parameters
%--------------------------------------------------------------------------
%randn('state',0);%keeps noise characteristics the same on reruns
%rand('state',0)%keeps intergers same on rerun
%Holding all values constant, shows a slight improvement on BER @minus5dB when using Gray
%coding and shows a slight degredation @plus 9dB. Is this valid according to theory?
%An interesting test would be to see the results with FEC(with and without Gray coding) if
%you have the Communications Toolbox(I don't) and also to test these
%results against it. Also,
%I challenge someone to write an easy to understand m-file Viterbi decoder
%that can be used in conjunction with the convolutional encoder m-file
%under JC files in author index. This would be helpful to many folks,
%including myself.
Max_dB =10  % input SNR in dB
modtype = 'psk'
M=8                    %M-ary
gray_encode = 1;      %1=yes 0=no
Ndata = 1000000;      %limit to 1000000 samples for matlab processing
Test_image = 1;       %1=yes 0=no
Image_name = 'Lena1.bmp' %color photo Lena1  im 128x128x3 uint8 array
                          %M=4   128x128x3x4=196608
k=log2(M);
ebn0=10.^(Max_dB/10);
%--------------------------------------------------------------------------
%produce Data or load image
%--------------------------------------------------------------------------
%use this method because the program may transmit data from file, such as a image
Data=My_randint(1,Ndata,0,3);%produce intergers from 0 to 3(QPSK-M=4)-Change for M=2,8
%Data=My_randint(1,Ndata,0,1);%M=8
%Data=My_randint(1,Ndata,0,1);%M=2
%use Data=randint(1,Ndata,M); if you have this function(Communications Toolbox) 
if Test_image    
    im = imread('Lena1.bmp');
    disp('Fig 1 showing original image before AWGN added');
    image(im);
    drawnow
    [Data, row_im, col_im, third_im] = image2data(im, M);
end
Ndata = length(Data);
Transmit = Data;
datalen = length(Transmit);
%--------------------------------------------------------------------------
%encode-Gray or no Gray
%--------------------------------------------------------------------------
if gray_encode
    % Create Gray encoding and decoding arrays-flip(2=3)and(3=2 for M=4)
    grayencod = bitxor(0:M-1, floor((0:M-1)/2));
    [dummy graydecod] = sort(grayencod); graydecod = graydecod - 1;

    % Gray encode symbols
    Transmit_gray = grayencod(Transmit+1);
end
%--------------------------------------------------------------------------
%Modulation
%--------------------------------------------------------------------------
if gray_encode
    step=2*pi/M;
    S=exp(j*Transmit_gray.*step);
else %no Gray encode
    step=2*pi/M;
    S=exp(j*Transmit.*step);
end      
%-----------------------------------------------------------------------           
%uniform the noise power by 1/var=SNR=Es/(N0/2)=2*k*ebn0       
std=(1/2/k./ebn0).^0.5;
%-----------------------------------------------------------------------
%-----------------------------------------------------------------------
%add AWGN
%-----------------------------------------------------------------------
Z = std*( randn(1,datalen)+j*randn(1,datalen) );
R=S+Z;
%-------------------------------------------------------------------------
%demodulation
%-------------------------------------------------------------------------
step=2*pi/M;
Rphase = atan2(imag(R), real(R));%1 radian=57.296 degrees
%Sphase = atan2(imag(S), real(S));%for testing only
Receive = Rphase/step;%error is made if noise causes phase to fall outside +-45 degrees for M=4
                      
Receive = round(Receive);
Receive = mod(Receive,M);           
if gray_encode  
% Gray decode message
Receive = graydecod(Receive+1);%Received image or data
end
                      
ne=sum(Data~=Receive)%number of errors
BER=ne/Ndata%bit error rate
SER=ne/Ndata/k
           
if Test_image 
   ima = data2image(Receive, row_im, col_im, third_im, M);
   ima = uint8(ima);
   imwrite(ima,'Received_image.bmp');
   disp(' ');
   disp('Fig 2 received image(after AWGN added) is saved as Received_image.bmp in the same directory');
   disp(' ');
   figure
   image(ima);
   drawnow                           
end

%INFO-The analytical expressions and references used in berawgn, bercoding, berfading, and
%BERTool are found in the Communications Toolbox documentation.






