% locate_balls.m

% Copyright 2003-2010 The MathWorks, Inc.

%locate ball position in each frame
for i=1:nFrames
  LM=bwlabel(bw(:,:,i));
  stats=regionprops(LM);
  if length(stats)>1 %ball plus shadow maybe noise too
    A=[stats.Area];
    biggest=find(A==max(A));
    stats=stats(biggest);
  end
  XY(i,:)=stats.Centroid;
end
X=XY(:,1);
Y=XY(:,2);

%display set of all positions (all frames)
imshow(avg,[]), axis on
hold on
plot(X+x1,Y+y1,'.'), shg
hold off
myFig=gcf;
