% This Function script is used to extract TRP feature and SP-FD feature
% The related paper
% [1] Y. Tang, H. Cheng and C. Suen. “Transformation-Ring-Projection(TRP) algorithm and its VLSI implementation,” % International Journal of Pattern Recognition and Artificial Intelligence, vol. 5, pp. 25-56, 1991.
% [2] L. Dong, J. Wang, Y. Li, Y. Tang. "Sector Projection Fourier Descriptor for Chinese Character Recognition"
% IEEE International Conference on Cybernetics, to be appear, 2013.
% Author: DongLi, CIS-FST, University of Macau, PRC,
% Email: dongli363@gmail.com

function [ringFeatureVector, sectorFeatureVector] =  featureExtraction(I)
% Input: The image data I (binary data, black is 0), sized 256x256
% Output: TRP feature ringFeatureVector, SP-FD feature sectorFeatureVector
% Get the Row and Col Count
I = imresize(I,[256 256]);
RowCount = size(I,1);
ColCount = size(I,2);
% Get the gravity center of binary image
M00 = 0; M10 = 0 ; M01 = 0;
Temp = ~I;
for row = 1:RowCount
    for col = 1:ColCount
            M00 = M00 + Temp(row,col);
            M01 = M01 + col*Temp(row,col);
            M10 = M10 + row*Temp(row,col);
    end
end
% center of Binary Image
centerX = round(M10*1.0 / M00);
centerY = round(M01*1.0 / M00);
%-------- Get the Max Radius D -----
D = 100; % Here is fixed Radius
%--------  End -------

%-------- Data structure for record -----
deltaR = 1;     % step length of ring move from the center to outer circle line
Rcount = round(D*1.0/deltaR); % how many different radius
deltaT = pi/180;    % step angle delta Theta
ThetaCount = round(2*pi/deltaT); %how many angles divided by 2*pi

ringPoints = zeros(Rcount,1);    % allocate array, length is determined by D/deltaR
sectorPoints = zeros(ThetaCount,2);     % length is D/deltaR. First Col Store the #points when angle is the Second Col value.
for k=1:ThetaCount
    sectorPoints(k,1) = (k-1)*deltaT;
end
%-------- End -------
aaa = centerX-D;
bbb =centerY-D;
% determine how many points lay on each circle and sector
% check each pixel of the Character region
%-------- Start ------
for i = centerX-D: centerX+D
    for j = centerY-D: centerY+D
        if I(i,j) == 0 % Black Point
         distance = sqrt( (i-centerX)^2+(j-centerY)^2 );% calculate the distance between point and center  
         if distance <= D
             radiusIndex = round(distance);
             if radiusIndex == 0
                 ringPoints(1) = ringPoints(1) + 1;
             else
                 ringPoints(radiusIndex) = ringPoints(radiusIndex)+1;
             end 
             % determine which sector this point belongs to 
             % change the center to (0,0)
             iNew = i - centerX;
             jNew = j - centerY;
             if iNew ==0 && jNew ==0
                  %sectorPoints(thetaIndex,1) = sectorPoints(thetaIndex,1) + 1;
                  sectorPoints(thetaIndex,2) = sectorPoints(thetaIndex,2) + 1;
             else
                 currentPoint = [iNew, jNew];
                 xorign = [1 0];
                % determine the agnle between vector [0 1]
                theta= acos(dot(currentPoint,xorign)/(norm(currentPoint)*norm(xorign)));
                 if jNew < 0
                         theta = 2*pi - theta;
                 end
                thetaIndex = round(theta/deltaT);
                if thetaIndex == 0
                    sectorPoints(1,2) = sectorPoints(1,2) + 1;
                else
                    sectorPoints(thetaIndex,2) = sectorPoints(thetaIndex,2) + 1;
                end
                
             end  
         end
        end
    end
end
%-------- End ---------
% Calculate the feature vector of Ring-projection
ringFeatureVector = zeros(Rcount,1); % Feature Vector
for k=1:Rcount
    SumK = 0; % sum all the values before K
    for i=1:k
        SumK = SumK + ringPoints(i);
    end
    ringFeatureVector ( k ) =  SumK;
end

ringFeatureVector = ringFeatureVector./ringFeatureVector(Rcount);
FD = abs(fft(sectorPoints(:,2)'));
FD = FD./max(FD); % normalize
sectorFeatureVector = FD(2:30)'; % only selcet the first 30 entries

