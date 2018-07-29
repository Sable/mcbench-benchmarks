function Demo()
% Object matching demo based on "Lowe, D.G. 1999. Object recognition from local scale-invariant features.
% In International Conference on Computer Vision, Corfu, Greece, pp. 1150–1157.
% uses SURF instead of SIFT 

% please download SURFmex (SURFmex Library http://www.maths.lth.se/matematiklth/personal/petter/surfmex.php) 
% and include in path (right click folder add to path)

% see more on http://computervisionblog.wordpress.com/

clear;
close all;

targetImage = imread('TrainImage/drill.bmp');

targetModelImage = imread('TrainImage/model.bmp');

testImage = imread('TestImage/test2.jpg');

% create target model from target image and target model image

targetModel = createTargetModel(targetImage, targetModelImage);

% use target model to match target in test image

matchTarget(targetModel, testImage);

end