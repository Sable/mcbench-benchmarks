function [slope, intercept, averslope, averIC] = fdsurfft(im)
% FDSURFFT Compute fractal dimension (slope) of surface image im and draw rose plots
%          of slope and intercept 
%     im: input array of surface image (grayvalue or range image)
%     slope: an array of size 24 which stores the average slopes in 24
%            directions
%     intercept: an array of size 24 which stores the average intercepts in 24
%                directions
%     averslope: average slope for all directions
%     averIC: average intercept for all directions

% This is a matlab version of John C. Russ 's program

% Written by Mr. Jianbo Zhang, J.Zhang@ewi.utwente.nl
% 2 Nov, 2004

tic
NUM_DIR = 24; % number of directions that the frequency space is uniformally divided
NUM_RAD = 30; % number of points that the radius is uniformally divided
if nargin < 1, 
    error('Missed input argument which must be an array!')
end

[M N] = size(im);
xctr = 1 + bitshift(N, -1); % x coordinate of center point
yctr = 1 + bitshift(M, -1); % y coordinate of center point
imMean = mean(im(:));
fim = fftshift(fft2(double(im) - imMean)); 

% power spectrum
mag = log(fim .* conj(fim)+ 10 ^ (-6)); 
sumBrite = zeros(NUM_DIR, NUM_RAD); %accumulation magnitude for each direction and radius
nCount = zeros(NUM_DIR, NUM_RAD); %number of magnitude
radius = zeros(2 * NUM_RAD,1);%accumulation magnitude for all directions 
radCount = zeros(2 * NUM_RAD,1);% number of magintude for all directions

%Compute phase image and phase histogram
phaseim = zeros(M,N);
phase = zeros(180);
for j = 1:M
    for i = 1:N
        realv = real(fim(j,i));
        imagv = imag(fim(j,i));
        if realv == 0
            value = pi/2;
        else 
            value = atan((imagv / realv));
            phaseim(j, i) = value;
            ang = floor(180 * (pi / 2 + value) / pi);
        end
        if ang < 0
            ang = 0;
        end
        if ang > 179
            ang = 179;
        end
        phase(ang + 1) = phase(ang + 1) + 1;
    end 
end
maxphase = max(phase);
figure; imshow(phaseim, []);
title('Phase image');
figure; plot(phase / maxphase);
title('Phase histogram (0...2 \pi)');%        
axis off


%accumulation of magnitude for each dirction and radius
rmax = log(min(M,N)/2);% maximum radius
for j = 1:M
    if j ~= yctr
        yval = yctr - j;
        y2 = yval * yval;
        for i = 1:N
            if i ~= xctr
                xval = i - xctr;
                rho = log(sqrt(y2 + xval * xval));
                if rho > 0 & rho <= rmax
                    mval = mag(j,i);
                    temp = yval /xval;
                    theta = atan(temp);
                    if xval < 0
                        theta = theta + pi;
                    end
                    if theta < 0
                        theta = theta + 2 * pi;
                    end

                    ang = floor(NUM_DIR * theta /(2* pi));
                    if ang > NUM_DIR - 1 | ang < 0
                        ang = NUM_DIR - 1; 
                    end
                    k = floor(2*NUM_RAD * rho / rmax);
                    h = floor(k/2); 
                    if k > 2 * NUM_RAD - 1
                        h = NUM_RAD - 1;
                        k = 2 * NUM_RAD - 1;
                    end
                 
                    if h >= 5
                        sumBrite(ang + 1, h + 1) = sumBrite(ang + 1, h + 1) + mval;
                        nCount(ang + 1, h + 1) = nCount(ang + 1, h + 1) + 1;
                    end
                    if k >= 5
                        radius(k + 1) = radius(k + 1) + mval;
                        radCount(k + 1) = radCount(k + 1) + 1;
                    end
                end
            end
        end
    end
end

%linear regression
for ang = 1:NUM_DIR
    sumx = 0;
    sumy = 0;
    sumx2 = 0;
    sumxy = 0;
    sumn = 0;
    for range = 6:NUM_RAD
        if nCount(ang, range) > 0
            yval = sumBrite(ang, range)/nCount(ang, range);
            xval = (range -1) * rmax / NUM_RAD; 
            sumx = sumx + xval;
            sumy = sumy + yval;
            sumx2 = sumx2 + xval * xval;
            sumxy = sumxy + xval * yval;
            sumn = sumn + 1;
        end
    end
    slope(ang) = (sumn * sumxy - sumx * sumy) / (sumn * sumx2 - sumx * sumx);
    intercept(ang) = (sumy - slope(ang) * sumx) / sumn;
end

%compute average slope over all directions and scales
sumn = 0;
for k = 6:(2 * NUM_RAD)
    if radCount(k) > 0
        sumn = sumn + 1;
        yval(sumn) = radius(k) / radCount(k);
        tempr(sumn) = (k -1) * rmax / (2 * NUM_RAD);
    end
end
p = polyfit(tempr,yval,1);
averslope = p(1);
averIC = p(2);

fitln = polyval(p,tempr);
figure; plot(tempr,yval,tempr,fitln,'r-');
title('Log Log plot of Magn. vs Freq.');
ylabel('Log Magnitude');
xlabel('Log Frequency');

slope(NUM_DIR + 1) = slope(1);
intercept(NUM_DIR + 1) = intercept(1);

%draw rose plot of slope and intercept
ang = 1: (NUM_DIR + 1);
figure;
polar(pi/NUM_DIR + (ang -1) * 2* pi / NUM_DIR, intercept(ang), 'r-');  
title('Rose plot of intercept');
figure;
polar(pi/NUM_DIR + (ang - 1)* 2 * pi / NUM_DIR, abs(slope(ang)), '-');          
title('Rose plot of slope');
disp(['Elapsed time: ' num2str(toc)]);
