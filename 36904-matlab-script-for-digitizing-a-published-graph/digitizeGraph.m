%By Dr. Rex Cheung, cheung.r100@gmail.com
%May, 2012 Main Line.

function digitizedData=digitizeGraph(imageName,numberPoints)
%This function lets users digitize a published graph that is saved as
%a image e.g. jpeg
%User needs load the image into matlab workspace before running this program.
%User needs to provide the name of the image, and the number of data
%points to be digitized. The user will be asked to indicate on the
%image the pixel position corresponds to the origin, a value on x axis and
%a value on y axis. These are used to scale the user selected data points.
%usage exampe:digitizeGraph(testGraph,3);
imagesc(imageName);
imageName=imageName(:,:,1); %reduse the RGB into just any one component for digitization
%prompt user to digitize the origin
disp('Indicate the pixel position corresponds to the origin:');
[x0 y0]=ginput(1);
display('Your chosen origin is at pixel position:');
disp([x0 y0]);
%add a negative sign for y offset calculation
disp('Note that Matlab considers the left upper most pixel is the (0,0) pixel.');
disp('To transform simply set y = -(y-y0) and x = x-x0;');
%prompt user to digitize a value on x axis
disp('Digitize a value on the x axis');
[x1 y1]=ginput(1);
disp('Your chosen pixel position on x axis: ');
disp([x1 y1]);
ans1=input('What is the corresponding value to you digitized pixel position on x axis?  ','s');
xvalue=str2double(ans1);
%calculate the conversion ratio of y
xratio=xvalue/(x1-x0);
disp('xratio');
disp(xratio);
%prompt user to digitize a value on y axis
disp('Digitize a value on the y axis');
[x2 y2]=ginput(1);
disp('Your chosen pixel position on the y axis: ');
disp([x2 y2]);
ans2=input('what is the corresponding value you digitized on the y axis?  ','s');
yvalue= str2double(ans2); 
%calculate the conversion ratio of y
yratio=yvalue/-(y2-y0);
disp('yratio');
disp(yratio);
%prompt user to digitize the data points
disp('The number of points you have indicated to digitize:');
disp(numberPoints);
disp('Graphically select the data points to be digitized:');
[X Y]=ginput(numberPoints);
disp('You have selected these pixels:');
disp([X Y]);
%calucalte the digitized X and Y
digitizedX = (X-x0)*xratio;
digitizedY = -(Y-y0)*yratio;
digitizedData=[digitizedX digitizedY];
disp('These are the digitized data after scaling:');
disp(digitizedData);
plot(digitizedX,digitizedY); title('Plot using digitized data');
%save the data
disp('The digitized data file is saved as digitizedData.txt.');
save digitizedData.txt digitizedData;