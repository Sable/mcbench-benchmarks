function Proc = ImageEdge(labeled,xLength,yLength,gX,gY,addX,addY,objectID)
% **********************************************************************************
% *
% * ImageEdge(labeled,xLength,yLength,gX,gY,addX,addY,objectID)
% * 
% * labeled  = labeled image
% * xLength  = distance to travel it x dir
% * yLength  = distance to travel it y dir
% * gX       = center of gravity x
% * gY       = center of gravity y
% * addX     = add or minus the xLength from gX to travel to the boundry of the object
% * addY     = add or minus the yLength from gy to travel to the boundry of the object
% * objectID = ID of the currently processing image
% *
% *
% * When center of gravity and increment\ decrement values are passed to the function. 
% * Then it will use them to travel to the boundary of the image of a given object (selected by ObjectID). 
% * Then pass the boundary value to the main program. 
% * 
% *    Return Values
% *
% *     edgePointXY(1) = edgeX;
% *     edgePointXY(2) = edgeY; 
% *
% *
% *
% *     Author - I. Janaka Prasad Wijesena
% *
% **********************************************************************************
edgePointXY = 1:2;

edgeX = gX;
edgeY = gY;


imageSize = size(labeled);


loopEnd = 0;

while loopEnd == 0
    
    if addX == 1
        edgeX = edgeX + xLength;
    else
        edgeX = edgeX - xLength;
    end

    if addY == 1
        edgeY = edgeY + yLength;
    else
        edgeY = edgeY - yLength;
    end    
    
    if edgeX <= 0 
        edgeX = 1;
        loopEnd = 1; 
    end
    
    if edgeY <= 0
        edgeY = 1;
        loopEnd = 1; 
    end
    
    if edgeX > imageSize(2)
        edgeX = imageSize(2);
        loopEnd = 1; 
    end
    
    if edgeY > imageSize(1)
        edgeY = imageSize(1);
        loopEnd = 1; 
    end
    
    if labeled(edgeY,edgeX) ==  0
       loopEnd = 1;     
       
    end
   
    
end

edgePointXY(1) = edgeX;
edgePointXY(2) = edgeY;

%edgeX
%edgeY

%edgePointXY

Proc = edgePointXY;