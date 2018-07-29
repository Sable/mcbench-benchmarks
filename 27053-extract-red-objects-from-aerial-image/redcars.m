function redcars
	% 	REDCARS Extract Red Objects from Aerial Image
	%
	%   This code takes the aerial image accompanied with it
	%   ('high.jpg') and marks all objects deemed "red" on it.
	%
	% 	To run, simply type redcars in the MATLAB Command
	% 	Window with this file in the current directory.
	% 	Alternatively, you can choose Debug -> Run from this
	% 	editor window, or press F5.
	%
	%   All of the values used in the code can be changed to
	%   suit different images.
	%
	% 	numandina@gmail.com, March 2010
	
	% read image from current directory and store it in 'i'
	i = imread('high.jpg');
	
	% take red element of picture
	r = i(:,:,1);
	
	% take green element of picture
	g = i(:,:,2);
	
	% take blue element of picture
	b = i(:,:,3);
	
	% redness in the picture is defined. this equation can be changed
	% according to application and desired results
	red = (r > 2*g) & (r > 2*b) & r > 30;
		
	% group all red object within 5 pixels of each other as one object
	se = strel('disk',5);
	red = imclose(red,se);
	
	% delete all objects smaller than 35 pixels in area
	red = bwareaopen(red,35);
	
	% take the centroids of all objects and store them in S
	s = regionprops(bwlabel(red),'centroid');
	S = vertcat(s.Centroid);
	
	% plot the image and the centroids
	figure
	imshow(i)
	hold on
	plot(S(:,1),S(:,2),'+')
	zoom on
	
end