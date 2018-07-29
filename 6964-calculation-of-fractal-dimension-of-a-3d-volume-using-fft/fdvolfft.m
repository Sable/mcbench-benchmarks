function [fds, ics, averFD, averIC] = fdvolfft(im)
% FDVOLFFT Compute fractal dimensions FDS and intercepts ICS of a 3D image
%          IM using FFT and draw rose plots of FDS and ICS 
% IM: input 3D array of a 3D image (grayvalue)
% FDS: a 2D array of size 24x12 which stores the FDs in 24x12 directions
% ICS: a 2D array of size 24x12 which stores the average intercepts in
%      24x12 directions
% AVERFD: average fractal dimension for all directions
% AVERIC: average intercept for all directions
%
%
% This script is free to use except for commercial purpose
% Written by  Mr. Jianbo ZHANG, J.Zhang@ewi.utwente.nl
% 19 Jan, 2005
%
%
% for example, the following script can compute the fractal dimension of
%    an MRI image volume
%
% load mri
% D = squeeze(D) ;
% image_num = 8;
% image(D(:,:,image_num))
% axis image
% colormap(map)
% title('Image of MRI slice No. 8 ')
% [fds ics averFD averIC]= fdvolfft(D)
% 
% Note: Since an MRI image is a self-affine, not self-similiar volume, its 
%   fractal dimensions do not necessarily lie between 3 and 4.


tic
NUM_AZI = 24; % number of azimuth directions
              % that the frequency space is evenly divided
NUM_ZEN = 12; % number of zenith directions
              % that the frequency space is evenly divided
NUM_RAD = 30; % number of points that the radial line is evenly divided

if nargin < 1, 
    error('Missed input argument which must be a 3D array!')
end

[M N P] = size(im);
xctr = 1 + bitshift(N, -1); % x coordinate of center point
yctr = 1 + bitshift(M, -1); % y coordinate of center point
zctr = 1 + bitshift(P, -1); % z coordinate of center point
imMean = mean(im(:));
fim = fftshift(fftn(double(im) - imMean)); 
psd = log(fim .* conj(fim) + 10^(-6)); 
sumBrite = zeros(NUM_AZI, NUM_ZEN, NUM_RAD); %accumulation PSD
                                          %for along each direction and
                                          %radius
nCount = zeros(NUM_AZI, NUM_ZEN, NUM_RAD); % PSD count
radius = zeros(2 * NUM_RAD,1); %accumulation PSD for all directions 
radCount = zeros(2 * NUM_RAD,1); % number of PSD for all directions

%Compute phase distribution
phase = zeros(180);
for k = 1:P
    for j = 1:M
        for i = 1:N
            realv = real(fim(j,i,k));
            imagv = imag(fim(j,i,k));
            if realv == 0
                value = pi/2;
            else
                value = atan((imagv / realv));
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
end
maxphase = max(phase);
figure, plot(phase / maxphase);
title('Phase histogram (0...2 \pi)');%        
axis off

%accumulation of PSD for each direction and radius
rmax = log(min(min(M,N),P)/2);% maximum radius
for k = 1:P
    if k ~= zctr
        zval = zctr - k;
        z2 = zval * zval;
        for j = 1:M
            if j ~= yctr
                yval = yctr - j;
                y2 = yval * yval;
                for i = 1:N
                    if i ~= xctr
                        xval = i - xctr;
                        r = sqrt(z2 + y2 + xval * xval);
                        rho = log(r);
                        if rho > 0 & rho <= rmax
                            mval = psd(j,i,k);
                            temp1 = yval / xval;
                            temp2 = zval / r;
                            theta = atan(temp1);
                            phi = acos(temp2);
                            if xval < 0
                                theta = theta + pi;
                            end
                            if theta < 0
                                theta = theta + 2 * pi;
                            end

                            aziSN = floor(NUM_AZI * theta /(2 * pi));
                            if aziSN > NUM_AZI - 1 | aziSN < 0
                                aziSN = NUM_AZI - 1;
                            end
                            zenSN = floor(NUM_ZEN * phi / pi);
                            if zenSN > NUM_ZEN - 1 | zenSN < 0
                                zenSN = NUM_ZEN - 1;
                            end
                            radSN = floor(2 * NUM_RAD * rho / rmax);
                            h = floor(radSN/2);
                            if radSN > 2 * NUM_RAD - 1
                                h = NUM_RAD - 1;
                                radSN = 2 * NUM_RAD - 1;
                            end

                            if h >= 5
                                if zenSN == 0 | zenSN == NUM_ZEN-1
                                    sumBrite(:, zenSN + 1, h + 1) = sumBrite(:, zenSN + 1, h + 1) + mval;
                                    nCount(:, zenSN + 1, h + 1) = nCount(:,zenSN + 1, h + 1) + 1;
                                else
                                    sumBrite(aziSN + 1,zenSN + 1, h + 1) = sumBrite(aziSN + 1, zenSN + 1, h + 1) + mval;
                                    nCount(aziSN + 1, zenSN + 1, h + 1) = nCount(aziSN + 1,zenSN + 1, h + 1) + 1;
                                end
                            end
                            if radSN >= 5
                                radius(radSN + 1) = radius(radSN + 1) + mval;
                                radCount(radSN + 1) = radCount(radSN + 1) + 1;
                            end
                        end
                    end
                end
            end
        end
    end
end

%linear regression
for aziSN = 1:NUM_AZI
    for zenSN = 1: NUM_ZEN
        sumx = 0;
        sumy = 0;
        sumx2 = 0;
        sumxy = 0;
        sumn = 0;
        for range = 6:NUM_RAD
            if nCount(aziSN, zenSN, range) > 0
                yval = sumBrite(aziSN, zenSN, range)/nCount(aziSN, zenSN, range);
                xval = (range -1) * rmax / NUM_RAD;
                sumx = sumx + xval;
                sumy = sumy + yval;
                sumx2 = sumx2 + xval * xval;
                sumxy = sumxy + xval * yval;
                sumn = sumn + 1;
            end
        end
        slope(aziSN, zenSN) = (sumn * sumxy - sumx * sumy) / (sumn * sumx2 - sumx * sumx);
        ics(aziSN, zenSN) = (sumy - slope(aziSN, zenSN) * sumx) / sumn;
        fds(aziSN, zenSN) = (11 + slope(aziSN, zenSN))/2;
    end
end

%compute average slope over all directions and radius
sumn = 0;
for radSN = 6:(2 * NUM_RAD)
    if radCount(radSN) > 0
        sumn = sumn + 1;
        yval(sumn) = radius(radSN) / radCount(radSN);
        tempr(sumn) = (radSN -1) * rmax / (2 * NUM_RAD);
    end
end
p = polyfit(tempr,yval,1);
averFD =(11+ p(1))/2; % Overall average fractal dimension
averIC = p(2); % Overall average intercept
fitln = polyval(p,tempr);
figure; plot(tempr,yval,tempr,fitln,'r-');
title('Log Log plot of PSD. vs Freq.');
ylabel('Log PSD');
xlabel('Log Frequency');
legend('data','LSE fit line');

% draw hedgehog plot of fractal dimension and intercept
% I personally prefer to call these 3D visulization plots of fractal
% dimension and intercept as 'hedgehog' plot
fd = [fds; fds(1,:)];
fd = [fd, fd(:,1)];
aziSN = (1:NUM_AZI + 1)';
zenSN = 1:(NUM_ZEN + 1);
[ph th] = meshgrid(pi/2 - ((zenSN - 1) * pi / NUM_ZEN) , 2 * pi / NUM_AZI / 2 + (aziSN - 1) * 2 * pi / NUM_AZI);
[x,y,z] = sph2cart(th,ph, fd);
figure, surf(x,y,z,fd); colorbar
title('Hedgehog plot of fractal dimension');
  
ic = [ics; ics(1,:)];
ic = abs([ic, ic(:,1)]); % ic stores the absolue value of ics 
aziSN = (1:NUM_AZI + 1)';
zenSN = 1:(NUM_ZEN + 1);
[ph th] = meshgrid(pi/2 - ((zenSN - 1) * pi / NUM_ZEN) , 2 * pi / NUM_AZI / 2 + (aziSN - 1) * 2 * pi / NUM_AZI);
[x,y,z] = sph2cart(th,ph, ic);
figure, surf(x,y,z, ic); colorbar
title('Hedgehog plot of intercept');

disp(['Elapsed time: ' num2str(toc)]);