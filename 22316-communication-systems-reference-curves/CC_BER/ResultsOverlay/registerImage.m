myResults4 = imread('myResults4.bmp');
cdata = imread('OdenWalder_7_2_code_bw.bmp');

% The following line opens the Control Point Selection Tool.
% Choose 4 points on the two images that are equiavlent points.
% See documentation for cpselect for more information.
cpselect(cdata, myResults4)

% These are control points that I selected:
load transformPts

% Compute the required transform
mytform = cp2tform(input_points, base_points, 'affine');
% Apply the transform
registered = imtransform(cdata, mytform,'fillvalue',1,'XData', [1 size(myResults4,2)],'YData', [1 size(myResults4,1)]);

% Now running the Simulink model will overlay the two images