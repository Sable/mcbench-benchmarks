% calibrate_resolution.m

% Copyright 2003-2010 The MathWorks, Inc.

msg='Do these video images contain 3-4-5 calibration marks?';
calibrate=questdlg(msg,'Calibrate','Yes','No','No');

switch calibrate
  case 'No'
    load pixres     %used stored value (meters/pixel)
    if length(pixRes)==1
      wdisp(sprintf('Stored calibration %.3g meter/pixel',pixRes))
      pixRes=[pixRes 0];
    elseif length(pixRes)==2
      disp(sprintf('Stored calibration %.3g +/- %.2g meter/pixel',pixRes))
    else
      error(sprintf('Invalid size pixRes [ %d ]',size(pixRes)))
    end
    return          %skip the rest of this script
  case 'Yes'
    %fall through switch and proceed with pixel calibration
  otherwise
    error('User aborted program')
end
    
%calibIm=imcomplement(rgb2gray(subIm));
calibIm=imcomplement(uint8(bg));
threshold=mean2(calibIm)+3*std2(calibIm);
BW=double(calibIm)>threshold;
L=bwlabel(BW);
stats=regionprops(L,'Area','Centroid','MajorAxisLength','MinorAxisLength');

if length(stats)<3
  error('Unable to locate calibration marks')
elseif length(stats)>3
  %warning('Have to find the 3 calibration marks')
  while length(stats)>3
    aspectRatios=[stats(:).MajorAxisLength]./[stats(:).MinorAxisLength];
    [shapeFactor,leastRound]=max(aspectRatios);
    if shapeFactor>1.5
      discard=leastRound;
    else
      areas=[stats(:).Area];
      sizeRatios=areas/median(areas);
      [dummy,leastSimilar]=max(abs(log(sizeRatios)));
      discard=leastSimilar;
    end
    stats(discard)=[];
  end
end

%calibration marks
for i=1:length(stats)
  pts(i,:)=[stats(i).Centroid];
end

%distances between calibration marks
for i=1:length(stats)
  thisPt=pts(i,:);
  if i==length(stats)
    nextPt=pts(1,:);
  else
    nextPt=pts(i+1,:);
  end
  distances(i)=sqrt([thisPt(1)-nextPt(1)]^2+[thisPt(2)-nextPt(2)]^2);
end
[dummy,order]=sort(distances);
calibFactors=[3 4 5]./distances(order);                 %inches/pixel
pixRes=[mean(calibFactors) std(calibFactors)]*0.0254;   %meters/pixel
disp(sprintf('Calibrated %.3g mm/pixel (+/-%.2g%%)',1e3*pixRes(1),100*pixRes(2)/pixRes(1)))
