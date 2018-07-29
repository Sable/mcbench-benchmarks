function rFSDs = fEfourier(outline, iNoOfHarmonicsAnalyse, bNormaliseSizeState, bNormaliseOrientationState)
% Forward elliptical Fourier transform - see Kuhl FP and Giardina CR
% "Elliptic Fourier features of a closed contour" Computer Graphics and
% Image Processing 18:236-258 1982 for theory.
% Returns a shape spectrum of input x,y data "outline" with
% iNoOfHarmonicsAnalyse elements.
% The output FSDs will be normalised for location, size and orientation
% if bNormaliseSizeState and bNormaliseOrientationState are TRUE

% Pre-calculate some constant arrays
% n * 2 * pi
% n^2 * 2* pi^2
% where n is the number of harmonics to be used in the analysis
rTwoNPi = (1:1:iNoOfHarmonicsAnalyse)* 2 * pi;
rTwoNSqPiSq = (1:1:iNoOfHarmonicsAnalyse) .* (1:1:iNoOfHarmonicsAnalyse)* 2 * pi * pi;
	
iNoOfPoints = size(outline,1) - 1; % hence there is 1 more data point in outline than iNoOfPoints
rDeltaX = zeros(iNoOfPoints+1,1); % pre-allocate some arrays
rDeltaY = zeros(iNoOfPoints+1,1);
rDeltaT = zeros(iNoOfPoints+1,1);

for iCount = 2 : iNoOfPoints + 1
    rDeltaX(iCount-1) = outline(iCount,1) - outline(iCount-1,1);
   	rDeltaY(iCount-1) = outline(iCount,2) - outline(iCount-1,2);
end

% Calculate 'time' differences from point to point - actually distances, but we are
% carrying on the fiction of a point running around the closed figure at constant speed.	
% We are analysing the projections on to the x and y axes of this point's path around the figure
for iCount = 1 : iNoOfPoints
    rDeltaT(iCount) = sqrt((rDeltaX(iCount)^2) + (rDeltaY(iCount)^2));
end
check = (rDeltaT ~= 0);  % remove zeros from rDeltaT, rDeltaX...
rDeltaT = rDeltaT(check);
rDeltaX = rDeltaX(check);
rDeltaY = rDeltaY(check);

iNoOfPoints = size(rDeltaT,1) - 1; % we have removed duplicate points 

% now sum the incremental times to get the time at any point
rTime(1) = 0;
for iCount = 2 : iNoOfPoints + 1
   rTime(iCount) = rTime(iCount - 1) + rDeltaT(iCount-1);
end

rPeriod = rTime(iNoOfPoints+1); % rPeriod defined for readability

% calculate the A-sub-0 coefficient
rSum1 = 0;
for iP = 2 : iNoOfPoints + 1 
    rSum2 = 0;
    rSum3 = 0;
    rInnerDiff = 0;
   	% calculate the partial sums - these are 0 for iCount = 1
    if iP > 1 
        for iJ = 2 : iP-1
            rSum2 = rSum2 + rDeltaX(iJ-1);
      		rSum3 = rSum3 + rDeltaT(iJ-1);
        end
            rInnerDiff = rSum2 - ((rDeltaX(iP-1) / rDeltaT(iP-1)) * rSum3);
   	end
   	rIncr1 = ((rDeltaX(iP-1) / (2*rDeltaT(iP-1)))*(rTime(iP)^2-rTime(iP-1)^2) + rInnerDiff*(rTime(iP)-rTime(iP-1)));
    rSum1 = rSum1 + rIncr1;
end   
rFSDs(1,1) = ((1 / rPeriod) * rSum1) + outline(1,1); % store A-sub-0 in output FSDs array - this array will be 4 x iNoOfHarmonicsAnalyse

% calculate the a-sub-n coefficients
for iHNo = 2 : iNoOfHarmonicsAnalyse
    rSum1 = 0;
    for iP = 1 : iNoOfPoints
        rIncr1 = (rDeltaX(iP) / rDeltaT(iP))*((cos(rTwoNPi(iHNo-1)*rTime(iP+1)/rPeriod) - cos(rTwoNPi(iHNo-1)*rTime(iP)/rPeriod)));
        rSum1 = rSum1 + rIncr1;
    end
	rFSDs(1,iHNo) = (rPeriod / rTwoNSqPiSq(iHNo-1)) * rSum1;
end % "foriHNo = 1 :..."
   
rFSDs(2,1) = 0; % there is no 0th order sine coefficient
   
% calculate the b-sub-n coefficients
for iHNo = 2 : iNoOfHarmonicsAnalyse
    rSum1 = 0;
    for iP = 1 : iNoOfPoints
        rIncr1 = (rDeltaX(iP) / rDeltaT(iP))*((sin(rTwoNPi(iHNo-1)*rTime(iP+1)/rPeriod) - sin(rTwoNPi(iHNo-1)*rTime(iP)/rPeriod)));
        rSum1 = rSum1 + rIncr1;
    end
	rFSDs(2,iHNo) = (rPeriod / rTwoNSqPiSq(iHNo-1)) * rSum1;
end % "foriHNo = 1 :..."
   
% calculate the C-sub-0 coefficient
rSum1 = 0;
for iP = 2 : iNoOfPoints + 1 
    rSum2 = 0;
    rSum3 = 0;
    rInnerDiff = 0;
    % calculate the partial sums - these are 0 for iCount = 1
    if iP > 1 
        for iJ = 2 : iP-1
            rSum2 = rSum2 + rDeltaY(iJ-1);
            rSum3 = rSum3 + rDeltaT(iJ-1);
        end
        rInnerDiff = rSum2 - ((rDeltaY(iP-1) / rDeltaT(iP-1)) * rSum3);
    end
    rIncr1 = ((rDeltaY(iP-1) / (2*rDeltaT(iP-1)))*(rTime(iP)^2-rTime(iP-1)^2) + rInnerDiff*(rTime(iP)-rTime(iP-1)));
    rSum1 = rSum1 + rIncr1;
end   
rFSDs(3,1) = ((1 / rPeriod) * rSum1) + outline(1,2); % store C-sub-0 in output FSDs array - this array will be 4 x iNoOfHarmonicsAnalyse
   
% calculate the C-sub-n coefficients
for iHNo = 2 : iNoOfHarmonicsAnalyse
    rSum1 = 0;
    for iP = 1 : iNoOfPoints
        rIncr1 = (rDeltaY(iP) / rDeltaT(iP))*((cos(rTwoNPi(iHNo-1)*rTime(iP+1)/rPeriod) - cos(rTwoNPi(iHNo-1)*rTime(iP)/rPeriod)));
        rSum1 = rSum1 + rIncr1;
    end
	rFSDs(3,iHNo) = (rPeriod / rTwoNSqPiSq(iHNo-1)) * rSum1;
end % "foriHNo = 1 :..."
   
rFSDs(4,1) = 0; % there is no 0th order sine coefficient
   
% calculate the D-sub-n coefficients
for iHNo = 2 : iNoOfHarmonicsAnalyse
    rSum1 = 0;
    for iP = 1 : iNoOfPoints
        rIncr1 = (rDeltaY(iP) / rDeltaT(iP))*((sin(rTwoNPi(iHNo-1)*rTime(iP+1)/rPeriod) - sin(rTwoNPi(iHNo-1)*rTime(iP)/rPeriod)));
        rSum1 = rSum1 + rIncr1;
    end
	rFSDs(4,iHNo) = (rPeriod / rTwoNSqPiSq(iHNo-1)) * rSum1;
end % "foriHNo = 1 :...
   
% the non-normalised coefficients are now in rFSDs
% if we want the normalised ones, this is where it happens
if (bNormaliseSizeState == 1) || (bNormaliseOrientationState == 1)
    % rTheta1 is the angle through which the starting position of the first
	% harmonic phasor must be rotated  to be aligned with the major axis of
   	% the first harmonic ellipse
    rFSDsTemp = rFSDs;
    rTheta1 = 0.5 * atan(2 * (rFSDsTemp(1,2) * rFSDsTemp(2,2) + rFSDsTemp(3,2) * rFSDsTemp(4,2)) / ...
         	(rFSDsTemp(1,2)^2 + rFSDsTemp(3,2)^2 - rFSDsTemp(2,2)^2 - rFSDsTemp(4,2)^2));
    % calculate the partially normalised coefficients - normalised for
    % starting point
    for iHNo = 1 : iNoOfHarmonicsAnalyse
        rStarFSDs(1,iHNo) = cos((iHNo-1) * rTheta1) * rFSDsTemp(1,iHNo) + sin((iHNo-1) * rTheta1) * rFSDsTemp(2,iHNo);
        rStarFSDs(2,iHNo) = -sin((iHNo-1) * rTheta1) * rFSDsTemp(1,iHNo) + cos((iHNo-1) * rTheta1) * rFSDsTemp(2,iHNo);
	    rStarFSDs(3,iHNo) = cos((iHNo-1) * rTheta1) * rFSDsTemp(3,iHNo) + sin((iHNo-1) * rTheta1) * rFSDsTemp(4,iHNo);
   	    rStarFSDs(4,iHNo) = -sin((iHNo-1) * rTheta1) * rFSDsTemp(3,iHNo) + cos((iHNo-1) * rTheta1) * rFSDsTemp(4,iHNo);
    end % for iHNo = 1 : iNoOfHarmonicsAnalyse
      
    rPsi1 = atan(rStarFSDs(3,2) / rStarFSDs(1,2));
    rSemiMajor = sqrt(rStarFSDs(1,2)^2 + rStarFSDs(3,2)^2); % find the semi-major axis of the first ellipse
       
    rFSDs(:,:) = rStarFSDs(:,:) ./ rSemiMajor; % if we haven't asked for normalisation of orientation, 
                                                                             % return the coefficients normalised for starting point and size   
    if bNormaliseOrientationState == 1
        % now find the orientation normalised values - return them in rFSDs
   	    for iHNo = 1 : iNoOfHarmonicsAnalyse
            rFSDsTemp(1,iHNo) = (cos(rPsi1) * rStarFSDs(1,iHNo) + sin(rPsi1) * rStarFSDs(3,iHNo)) / rSemiMajor;
       	    rFSDsTemp(2,iHNo) = (cos(rPsi1) * rStarFSDs(2,iHNo) + sin(rPsi1) * rStarFSDs(4,iHNo)) / rSemiMajor;
	        rFSDsTemp(3,iHNo) = (-sin(rPsi1) * rStarFSDs(1,iHNo) + cos(rPsi1) * rStarFSDs(3,iHNo)) / rSemiMajor;
   	        rFSDsTemp(4,iHNo) = (-sin(rPsi1) * rStarFSDs(2,iHNo) + cos(rPsi1) * rStarFSDs(4,iHNo)) / rSemiMajor;
      	end % for iHNo = 1 : iNoOfHarmonicsAnalyse
            rFSDs = rFSDsTemp; % return fully normlised coefficients
    end
end % if (bNormaliseSizeState == 1) || (bNormaliseOrientationState == 1)