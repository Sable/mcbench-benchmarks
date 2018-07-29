function testGaborFilter
%% by dzhg: zhgdai@126.com
%% This code is to search the direction of the vessel for each point of
%% the Image. I apply Gabor Filter to this work and the corresponding
%% output Gabor filter will be choosed to be the direction of the vessel.
%% if you have any question about this code, please contact with me by
%% zhgdai@126.com without hesitate.
%% This edition is to apply adaptative size of gabor filter to detect the
%% direction of the vessel.


I = imread('00005.bmp');

if isgray(I) ==0
    I = rgb2gray(I);
end

[ImageWidth,ImageHeight] = size(I);
sizeinterval = 10;
Begin_s = 10;
End_s = 40;
angleinterval = 18;

%% papers parameters
s = Begin_s:sizeinterval:End_s;
theta = 0:pi/angleinterval:(angleinterval-1)/angleinterval*pi;

f = 1./s;
Sx = s/pi;
Sy = s/pi;
LengthTheta = length(theta);
LengthS = length(s);

GaborFilter = zeros(ImageWidth,ImageHeight,(LengthTheta-1)*LengthS);
Index = 1;
for j = 1:LengthS
    for i = 1:LengthTheta-1
    [G,gabout] = gabordzhg(I,Sx(j),Sy(j),f(j),theta(i));
    GaborModel{Index} = G;
    GaborFilter(:,:,Index) = gabout;
    Index = Index + 1;
    end
end

imshow(I);
hold on;
[a,b] = ginput;
% a = 275;
% b = 245;


GaborFilterValue = GaborFilter(floor(b),floor(a),1:end);
savevar = [];
for i = 1:LengthS
    tempvar = var(GaborFilterValue((i-1)*(angleinterval-1)+1:i*(angleinterval-1)));
    savevar = [savevar;tempvar];
end
[maxvar,maxindex] = max(savevar);
[minvalue,minindex] = min(GaborFilterValue((maxindex-1)*(angleinterval-1)+1:maxindex*(angleinterval-1)));
imshow(GaborModel{(maxindex-1)*(angleinterval-1)+minindex},[]);
