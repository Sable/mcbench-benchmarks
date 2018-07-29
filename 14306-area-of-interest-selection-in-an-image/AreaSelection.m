%%%% This function lets tou select desired region on an image%%%%%%%%%%%
%%%% Be sure before you input the image into the function that you read the image using imread%%%%%%%%%%%
function [I2,dataX,dataYY] = AreaSelection(b)

 GH = figure; imshow(b)%%%Shows the input image%%%%
  waitforbuttonpress  %%%%%%Press left click on the image%%%%
  ss = size(b);
  point1 = get(gcf,'CurrentPoint') ;
  rect = [point1(1,1) point1(1,2) 335 219]; %Coordinates of rectangle%
  [r2] = dragrect(rect);                    %%%Drag the rectangle while keeping leftclick pressed and leave the click when region to be selected is decided%%
  [dataX, dataY] = pix2data(r2(1,1),r2(1,2));
  ggr = ss(1,1) - dataY ;
  dataY = ggr+0.5;
  dataX=dataX+0.5;                      %Top left hand side X coordinate of the image%
  dataYY =dataY-r2(1,4);                %Top left hand side Y coordinate of the image%  
  I2 = imcrop(b,[dataX dataYY 335 219]);%Final Cropped image%
  close(GH)