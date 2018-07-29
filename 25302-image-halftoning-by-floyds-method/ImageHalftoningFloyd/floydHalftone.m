%Program for Image Halftoning by Floyd Method

%Program Description
% The input gray image will be converted into halftone image
% of same size using Floyd's Error Diffusion Method.
%
%Parameters
% inImg   -   Input Gray Image
% outImg  -   Output Halftoned Image

%Author : Athi Narayanan S
%Student, M.E, EST,
%K.S.R College of Engineering
%Erode, Tamil Nadu, India.
%s_athi1983@yahoo.co.in
%http://sites.google.com/site/athisnarayanan/

function outImg  = floydHalftone(inImg)
inImg = double(inImg);

[M,N] = size(inImg);
T = 127.5; %Threshold
y = inImg;
error = 0;

for rows = 1:M-1  
    
    %Left Boundary of Image
    outImg(rows,1) =255*(y(rows,1)>=T);
    error = -outImg(rows,1) + y(rows,1);
    y(rows,1+1) = 7/16 * error + y(rows,1+1);
    y(rows+1,1+1) = 1/16 * error + y(rows+1,1+1);
    y(rows+1,1) = 5/16 * error + y(rows+1,1);
    
    for cols = 2:N-1
        %Center of Image
        outImg(rows,cols) =255*(y(rows,cols)>=T);
        error = -outImg(rows,cols) + y(rows,cols);
        y(rows,cols+1) = 7/16 * error + y(rows,cols+1);
        y(rows+1,cols+1) = 1/16 * error + y(rows+1,cols+1);
        y(rows+1,cols) = 5/16 * error + y(rows+1,cols);
        y(rows+1,cols-1) = 3/16 * error + y(rows+1,cols-1);
    end
    
    %Right Boundary of Image
    outImg(rows,N) =255*(y(rows,N)>=T);
    error = -outImg(rows,N) + y(rows,N);
    y(rows+1,N) = 5/16 * error + y(rows+1,N);
    y(rows+1,N-1) = 3/16 * error + y(rows+1,N-1);
    
end

%Bottom & Left Boundary of Image
rows = M;
outImg(rows,1) =255*(y(rows,1)>=T);
error = -outImg(rows,1) + y(rows,1);
y(rows,1+1) = 7/16 * error + y(rows,1+1);

%Bottom & Center of Image
for cols = 2:N-1
    outImg(rows,cols) =255*(y(rows,cols)>=T);
    error = -outImg(rows,cols) + y(rows,cols);
    y(rows,cols+1) = 7/16 * error + y(rows,cols+1);
end

%Thresholding
outImg(rows,N) =255*(y(rows,N)>=T);

outImg = im2bw(uint8(outImg));
