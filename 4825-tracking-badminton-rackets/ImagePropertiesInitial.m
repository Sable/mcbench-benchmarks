function Proc = ImagePropertiesInitial(objectID,labeled)
% **********************************************************************************
% *
% * ImagePropertiesInitial(objectID,labeled)
% * 
% * objectID = object id
% * labeled  = labeled image
% *
% * This function is used to detect the badminton racket among named objects. 
% * It uses shape descriptors to detect the badminton racket. It will return some 
% * properties of the badminton racket too.
% * 
% *    Return Values
% *
% *    arrOutPut(1) = objectID;
% *    arrOutPut(2) = cameraDistance;
% *    arrOutPut(3) = majorDist;
% *    arrOutPut(4) = minorDist;
% *    arrOutPut(5) = rotationAngle;
% *    
% *    arrOutPut(6) = topY;
% *    arrOutPut(7) = bottomY;
% *    arrOutPut(8) = leftX;
% *    arrOutPut(9) = rightX;
% *
% *
% *
% *     Author - I. Janaka Prasad Wijesena 
% *
% **********************************************************************************

% this is the size of the image
imageSize = size(labeled);


% now we are going to calculate the avarage of the points. doing this we
% get the center of gravity of the bat. and it is on the bat !!!


gravX = 0;
gravY = 0;

topY                = -1;
bottomY             = -1;
leftX               = -1;
rightX              = -1;



area            = 0;
rotationAngle   = 0;

for m = 1:imageSize(1)
  
    for n = 1:imageSize(2)
        
        if labeled(m,n) == objectID
            
            area = area + 1;
                       
            if (topY > m) | (topY == -1) 
                topY = m;     
            end
           
            if bottomY < m 
                bottomY = m;    
            end

            if (leftX > n) | (leftX == -1) 
                leftX = n;
            end
            
            if rightX < n 
                rightX = n;
            end            
            
        end
        
        
    end
    
    
end

% round them up
gravX = round((leftX + rightX)/2);
gravY = round((topY + bottomY)/2);


% -------------------------------------------------------------------------------------------------------

% function Proc = ImageEdge(labeled,xLength,yLength,gX,gY,addX,addY)

% move up from the gravity till you come to edge, record it
edgePoint = ImageEdge(labeled,0,1,gravX,gravY,1,0,objectID);
upPointX = edgePoint(1);
upPointY = edgePoint(2);


% move 1-5 from the gravity till you come to edge, record it
edgePoint = ImageEdge(labeled,1,5,gravX,gravY,1,0,objectID);
upRightPoint15X = edgePoint(1);
upRightPoint15Y = edgePoint(2);

% move 1-2 from the gravity till you come to edge, record it
edgePoint = ImageEdge(labeled,1,2,gravX,gravY,1,0,objectID);
upRightPoint12X = edgePoint(1);
upRightPoint12Y = edgePoint(2);

% move 3-3 from the gravity till you come to edge, record it
edgePoint = ImageEdge(labeled,1,1,gravX,gravY,1,0,objectID);
upRightPoint33X = edgePoint(1);
upRightPoint33Y = edgePoint(2);

% move 2-1 from the gravity till you come to edge, record it
edgePoint = ImageEdge(labeled,2,1,gravX,gravY,1,0,objectID);
upRightPoint21X = edgePoint(1);
upRightPoint21Y = edgePoint(2);

% move 5-1 from the gravity till you come to edge, record it
edgePoint = ImageEdge(labeled,5,1,gravX,gravY,1,0,objectID);
upRightPoint51X = edgePoint(1);
upRightPoint51Y = edgePoint(2);


% -------------------------------------------------------------------------------------------------------

% move up from the gravity till you come to edge, record it
edgePoint = ImageEdge(labeled,1,0,gravX,gravY,1,1,objectID);
rightPointX = edgePoint(1);
rightPointY = edgePoint(2);


% move 1-5 from the gravity till you come to edge, record it
edgePoint = ImageEdge(labeled,1,5,gravX,gravY,1,1,objectID);
downRightPoint15X = edgePoint(1);
downRightPoint15Y = edgePoint(2);

% move 1-2 from the gravity till you come to edge, record it
edgePoint = ImageEdge(labeled,1,2,gravX,gravY,1,1,objectID);
downRightPoint12X = edgePoint(1);
downRightPoint12Y = edgePoint(2);

% move 3-3 from the gravity till you come to edge, record it
edgePoint = ImageEdge(labeled,1,1,gravX,gravY,1,1,objectID);
downRightPoint33X = edgePoint(1);
downRightPoint33Y = edgePoint(2);

% move 2-1 from the gravity till you come to edge, record it
edgePoint = ImageEdge(labeled,2,1,gravX,gravY,1,1,objectID);
downRightPoint21X = edgePoint(1);
downRightPoint21Y = edgePoint(2);

% move 5-1 from the gravity till you come to edge, record it
edgePoint = ImageEdge(labeled,5,1,gravX,gravY,1,1,objectID);
downRightPoint51X = edgePoint(1);
downRightPoint51Y = edgePoint(2);

% -------------------------------------------------------------------------------------------------------

% move up from the gravity till you come to edge, record it
edgePoint = ImageEdge(labeled,0,1,gravX,gravY,1,1,objectID);
downPointX = edgePoint(1);
downPointY = edgePoint(2);

% move 1-5 from the gravity till you come to edge, record it
edgePoint = ImageEdge(labeled,1,5,gravX,gravY,0,1,objectID);
downLeftPoint15X = edgePoint(1);
downLeftPoint15Y = edgePoint(2);

% move 1-2 from the gravity till you come to edge, record it
edgePoint = ImageEdge(labeled,1,2,gravX,gravY,0,1,objectID);
downLeftPoint12X = edgePoint(1);
downLeftPoint12Y = edgePoint(2);

% move 3-3 from the gravity till you come to edge, record it
edgePoint = ImageEdge(labeled,1,1,gravX,gravY,0,1,objectID);
downLeftPoint33X = edgePoint(1);
downLeftPoint33Y = edgePoint(2);

% move 2-1 from the gravity till you come to edge, record it
edgePoint = ImageEdge(labeled,2,1,gravX,gravY,0,1,objectID);
downLeftPoint21X = edgePoint(1);
downLeftPoint21Y = edgePoint(2);

% move 5-1 from the gravity till you come to edge, record it
edgePoint = ImageEdge(labeled,5,1,gravX,gravY,0,1,objectID);
downLeftPoint51X = edgePoint(1);
downLeftPoint51Y = edgePoint(2);


% -------------------------------------------------------------------------------------------------------

% move up from the gravity till you come to edge, record it
edgePoint = ImageEdge(labeled,1,0,gravX,gravY,0,1,objectID);
leftPointX = edgePoint(1);
leftPointY = edgePoint(2);


% move 1-5 from the gravity till you come to edge, record it
edgePoint = ImageEdge(labeled,1,5,gravX,gravY,0,0,objectID);
upLeftPoint15X = edgePoint(1);
upLeftPoint15Y = edgePoint(2);

% move 1-2 from the gravity till you come to edge, record it
edgePoint = ImageEdge(labeled,1,2,gravX,gravY,0,0,objectID);
upLeftPoint12X = edgePoint(1);
upLeftPoint12Y = edgePoint(2);

% move 3-3 from the gravity till you come to edge, record it
edgePoint = ImageEdge(labeled,1,1,gravX,gravY,0,0,objectID);
upLeftPoint33X = edgePoint(1);
upLeftPoint33Y = edgePoint(2);

% move 2-1 from the gravity till you come to edge, record it
edgePoint = ImageEdge(labeled,2,1,gravX,gravY,0,0,objectID);
upLeftPoint21X = edgePoint(1);
upLeftPoint21Y = edgePoint(2);

% move 5-1 from the gravity till you come to edge, record it
edgePoint = ImageEdge(labeled,5,1,gravX,gravY,0,0,objectID);
upLeftPoint51X = edgePoint(1);
upLeftPoint51Y = edgePoint(2);

% -------------------------------------------------------------------------------------------------------

totalDistance = sqrt((upPointX-upRightPoint15X)*(upPointX-upRightPoint15X) + (upPointY-upRightPoint15Y)*(upPointY-upRightPoint15Y))                       + sqrt((upRightPoint12X-upRightPoint15X)*(upRightPoint12X-upRightPoint15X) + (upRightPoint12Y-upRightPoint15Y)*(upRightPoint12Y-upRightPoint15Y))                     + sqrt((upRightPoint12X-upRightPoint33X)*(upRightPoint12X-upRightPoint33X) + (upRightPoint12Y-upRightPoint33Y)*(upRightPoint12Y-upRightPoint33Y))                   + sqrt((upRightPoint21X-upRightPoint33X)*(upRightPoint21X-upRightPoint33X) + (upRightPoint21Y-upRightPoint33Y)*(upRightPoint21Y-upRightPoint33Y))                   + sqrt((upRightPoint21X-upRightPoint51X)*(upRightPoint21X-upRightPoint51X) + (upRightPoint21Y-upRightPoint51Y)*(upRightPoint21Y-upRightPoint51Y))                   + sqrt((rightPointX-upRightPoint51X)*(rightPointX-upRightPoint51X) + (rightPointY-upRightPoint51Y)*(rightPointY-upRightPoint51Y)) + ...
                sqrt((rightPointX-downRightPoint51X)*(rightPointX-downRightPoint51X) + (rightPointY-downRightPoint51Y)*(rightPointY-downRightPoint51Y))   + sqrt((downRightPoint21X-downRightPoint51X)*(downRightPoint21X-downRightPoint51X) + (downRightPoint21Y-downRightPoint51Y)*(downRightPoint21Y-downRightPoint51Y))     + sqrt((downRightPoint21X-downRightPoint33X)*(downRightPoint21X-downRightPoint33X) + (downRightPoint21Y-downRightPoint33Y)*(downRightPoint21Y-downRightPoint33Y))   + sqrt((downRightPoint12X-downRightPoint33X)*(downRightPoint12X-downRightPoint33X) + (downRightPoint12Y-downRightPoint33Y)*(downRightPoint12Y-downRightPoint33Y))   + sqrt((downRightPoint12X-downRightPoint15X)*(downRightPoint12X-downRightPoint15X) + (downRightPoint12Y-downRightPoint15Y)*(downRightPoint12Y-downRightPoint15Y))   + sqrt((downPointX-downRightPoint15X)*(downPointX-downRightPoint15X) + (downPointY-downRightPoint15Y)*(downPointY-downRightPoint15Y)) + ...
                sqrt((downPointX-downLeftPoint15X)*(downPointX-downLeftPoint15X) + (downPointY-downLeftPoint15Y)*(downPointY-downLeftPoint15Y))           + sqrt((downLeftPoint12X-downLeftPoint15X)*(downLeftPoint12X-downLeftPoint15X) + (downLeftPoint12Y-downLeftPoint15Y)*(downLeftPoint12Y-downLeftPoint15Y))             + sqrt((downLeftPoint12X-downLeftPoint33X)*(downLeftPoint12X-downLeftPoint33X) + (downLeftPoint12Y-downLeftPoint33Y)*(downLeftPoint12Y-downLeftPoint33Y))           + sqrt((downLeftPoint21X-downLeftPoint33X)*(downLeftPoint21X-downLeftPoint33X) + (downLeftPoint21Y-downLeftPoint33Y)*(downLeftPoint21Y-downLeftPoint33Y))           + sqrt((downLeftPoint21X-downLeftPoint51X)*(downLeftPoint21X-downLeftPoint51X) + (downLeftPoint21Y-downLeftPoint51Y)*(downLeftPoint21Y-downLeftPoint51Y))           + sqrt((leftPointX-downLeftPoint51X)*(leftPointX-downLeftPoint51X) + (leftPointY-downLeftPoint51Y)*(leftPointY-downLeftPoint51Y)) + ...
                sqrt((leftPointX-upLeftPoint51X)*(leftPointX-upLeftPoint51X) + (leftPointY-upLeftPoint51Y)*(leftPointY-upLeftPoint51Y))                   + sqrt((upLeftPoint21X-upLeftPoint51X)*(upLeftPoint21X-upLeftPoint51X) + (upLeftPoint21Y-upLeftPoint51Y)*(upLeftPoint21Y-upLeftPoint51Y))                             + sqrt((upLeftPoint21X-upLeftPoint33X)*(upLeftPoint21X-upLeftPoint33X) + (upLeftPoint21Y-upLeftPoint33Y)*(upLeftPoint21Y-upLeftPoint33Y))                           + sqrt((upLeftPoint12X-upLeftPoint33X)*(upLeftPoint12X-upLeftPoint33X) + (upLeftPoint12Y-upLeftPoint33Y)*(upLeftPoint12Y-upLeftPoint33Y))                           + sqrt((upLeftPoint12X-upLeftPoint15X)*(upLeftPoint12X-upLeftPoint15X) + (upLeftPoint12Y-upLeftPoint15Y)*(upLeftPoint12Y-upLeftPoint15Y))                           + sqrt((upPointX-upLeftPoint15X)*(upPointX-upLeftPoint15X) + (upPointY-upLeftPoint15Y)*(upPointY-upLeftPoint15Y));

                
%totalDistance

% -------------------------------------------------------------------------------------------------------

compactness = (totalDistance * totalDistance)/(4*pi*area);

%compactness

% -------------------------------------------------------------------------------------------------------

% get the distances

PointUpDownDIST               = sqrt((upPointX - downPointX)*(upPointX - downPointX) + (upPointY - downPointY)*(upPointY - downPointY));
PointLeftRightDIST            = sqrt((rightPointX - leftPointX)*(rightPointX - leftPointX) + (rightPointY - leftPointY)*(rightPointY - leftPointY));
Point1515XUpRightDownLeftDIST = sqrt((upRightPoint15X - downLeftPoint15X)*(upRightPoint15X - downLeftPoint15X) + (upRightPoint15Y - downLeftPoint15Y)*(upRightPoint15Y - downLeftPoint15Y));
Point1212XUpRightDownLeftDIST = sqrt((upRightPoint12X - downLeftPoint12X)*(upRightPoint12X - downLeftPoint12X) + (upRightPoint12Y - downLeftPoint12Y)*(upRightPoint12Y - downLeftPoint12Y));
Point3333XUpRightDownLeftDIST = sqrt((upRightPoint33X - downLeftPoint33X)*(upRightPoint33X - downLeftPoint33X) + (upRightPoint33Y - downLeftPoint33Y)*(upRightPoint33Y - downLeftPoint33Y));
Point2121XUpRightDownLeftDIST = sqrt((upRightPoint21X - downLeftPoint21X)*(upRightPoint21X - downLeftPoint21X) + (upRightPoint21Y - downLeftPoint21Y)*(upRightPoint21Y - downLeftPoint21Y));
Point5151XUpRightDownLeftDIST = sqrt((upRightPoint51X - downLeftPoint51X)*(upRightPoint51X - downLeftPoint51X) + (upRightPoint51Y - downLeftPoint51Y)*(upRightPoint51Y - downLeftPoint51Y));

Point1515XUpLeftDownRightDIST = sqrt((upLeftPoint15X - downRightPoint15X)*(upLeftPoint15X - downRightPoint15X) + (upLeftPoint15Y - downRightPoint15Y)*(upLeftPoint15Y - downRightPoint15Y));
Point1212XUpLeftDownRightDIST = sqrt((upLeftPoint12X - downRightPoint12X)*(upLeftPoint12X - downRightPoint12X) + (upLeftPoint12Y - downRightPoint12Y)*(upLeftPoint12Y - downRightPoint12Y));
Point3333XUpLeftDownRightDIST = sqrt((upLeftPoint33X - downRightPoint33X)*(upLeftPoint33X - downRightPoint33X) + (upLeftPoint33Y - downRightPoint33Y)*(upLeftPoint33Y - downRightPoint33Y));
Point2121XUpLeftDownRightDIST = sqrt((upLeftPoint21X - downRightPoint21X)*(upLeftPoint21X - downRightPoint21X) + (upLeftPoint21Y - downRightPoint21Y)*(upLeftPoint21Y - downRightPoint21Y));
Point5151XUpLeftDownRightDIST = sqrt((upLeftPoint51X - downRightPoint51X)*(upLeftPoint51X - downRightPoint51X) + (upLeftPoint51Y - downRightPoint51Y)*(upLeftPoint51Y - downRightPoint51Y));

% add them up 
Distmain = PointUpDownDIST + PointLeftRightDIST;
Dist1515 = Point1515XUpRightDownLeftDIST + Point1515XUpLeftDownRightDIST;
Dist1212 = Point1212XUpRightDownLeftDIST + Point1212XUpLeftDownRightDIST;
Dist3333 = Point3333XUpRightDownLeftDIST + Point3333XUpLeftDownRightDIST;
Dist2121 = Point2121XUpRightDownLeftDIST + Point2121XUpLeftDownRightDIST;
Dist5151 = Point5151XUpRightDownLeftDIST + Point5151XUpLeftDownRightDIST;

% which is the largest?

eccentricity = -1;
doundNess    = -1;

if (Distmain >= Dist1515) & (Distmain >= Dist1212) & (Distmain >= Dist3333)  & (Distmain >= Dist2121)  & (Distmain >= Dist5151)  & (PointUpDownDIST > 0) & (PointLeftRightDIST > 0)   
    %PointUpDownDIST
    %PointLeftRightDIST
    
    if PointUpDownDIST > PointLeftRightDIST
        eccentricity = PointUpDownDIST/PointLeftRightDIST;
        doundNess = 4*area/pi*sqrt(PointUpDownDIST);

        majorDist = PointUpDownDIST;
        minorDist = PointLeftRightDIST;
        
        if sqrt((upPointX - gravX)*(upPointX - gravX) + (upPointY - gravY)*(upPointY - gravY)) > sqrt((downPointX - gravX)*(downPointX - gravX) + (downPointY - gravY)*(downPointY - gravY))
            rotationAngle = 0;
        else
            rotationAngle = 180;    
        end
        
        
    else
        eccentricity = PointLeftRightDIST/PointUpDownDIST;
        doundNess = 4*area/pi*sqrt(PointLeftRightDIST);
        
        majorDist = PointLeftRightDIST;
        minorDist = PointUpDownDIST;
        
        if sqrt((rightPointX - gravX)*(rightPointX - gravX) + (rightPointY - gravY)*(rightPointY - gravY)) > sqrt((lefttPointX - gravX)*(lefttPointX - gravX) + (lefttPointY - gravY)*(lefttPointY - gravY))
            rotationAngle = 90;
        else
            rotationAngle = 270;    
        end        
        
    end
    
elseif (Dist1515 >= Distmain ) & (Dist1515 >= Dist1212) & (Dist1515 >= Dist3333)  & (Dist1515 >= Dist2121)  & (Dist1515 >= Dist5151) & (Point1515XUpRightDownLeftDIST > 0) & (Point1515XUpLeftDownRightDIST > 0)   
    %Point1515XUpRightDownLeftDIST
    %Point1515XUpLeftDownRightDIST
    
    if Point1515XUpRightDownLeftDIST > Point1515XUpLeftDownRightDIST
        eccentricity = Point1515XUpRightDownLeftDIST/Point1515XUpLeftDownRightDIST;
        doundNess = 4*area/pi*sqrt(Point1515XUpRightDownLeftDIST);
        
        majorDist = Point1515XUpRightDownLeftDIST;
        minorDist = Point1515XUpLeftDownRightDIST;
        
        if sqrt((upRightPoint15X - gravX)*(upRightPoint15X - gravX) + (upRightPoint15Y - gravY)*(upRightPoint15Y - gravY)) > sqrt((downLeftPoint15X - gravX)*(downLeftPoint15X - gravX) + (downLeftPoint15Y - gravY)*(downLeftPoint15Y - gravY))
            rotationAngle = 11;
        else
            rotationAngle = 191;    
        end
        
    else
        eccentricity = Point1515XUpLeftDownRightDIST/Point1515XUpRightDownLeftDIST;
        doundNess = 4*area/pi*sqrt(Point1515XUpLeftDownRightDIST);
        
        majorDist = Point1515XUpLeftDownRightDIST;
        minorDist = Point1515XUpRightDownLeftDIST;     
        
        if sqrt((upLeftPoint15X - gravX)*(upLeftPoint15X - gravX) + (upLeftPoint15Y - gravY)*(upLeftPoint15Y - gravY)) > sqrt((downRightPoint15X - gravX)*(downRightPoint15X - gravX) + (downRightPoint15Y - gravY)*(downRightPoint15Y - gravY))
            rotationAngle = 349;
        else
            rotationAngle = 169;    
        end        
        
    end
    
elseif (Dist1212 >= Distmain) & (Dist1212 >= Dist1515)  & (Dist1212 >= Dist3333)  & (Dist1212 >= Dist2121)  & (Dist1212 >= Dist5151)  & (Point1212XUpRightDownLeftDIST > 0) & (Point1212XUpLeftDownRightDIST > 0)      
    %Point1212XUpRightDownLeftDIST
    %Point1212XUpLeftDownRightDIST
    
    if Point1212XUpRightDownLeftDIST > Point1212XUpLeftDownRightDIST
        eccentricity = Point1212XUpRightDownLeftDIST/Point1212XUpLeftDownRightDIST;
        doundNess = 4*area/pi*sqrt(Point1212XUpRightDownLeftDIST);

        majorDist = Point1212XUpRightDownLeftDIST;
        minorDist = Point1212XUpLeftDownRightDIST;
        
        if sqrt((upRightPoint12X - gravX)*(upRightPoint12X - gravX) + (upRightPoint12Y - gravY)*(upRightPoint12Y - gravY)) > sqrt((downLeftPoint12X - gravX)*(downLeftPoint12X - gravX) + (downLeftPoint12Y - gravY)*(downLeftPoint12Y - gravY))
            rotationAngle = 27;
        else
            rotationAngle = 207;    
        end        
        
    else
        eccentricity = Point1212XUpLeftDownRightDIST/Point1212XUpRightDownLeftDIST;
        doundNess = 4*area/pi*sqrt(Point1212XUpLeftDownRightDIST);

        majorDist = Point1212XUpLeftDownRightDIST;
        minorDist = Point1212XUpRightDownLeftDIST;  

        if sqrt((upLeftPoint12X - gravX)*(upLeftPoint12X - gravX) + (upLeftPoint12Y - gravY)*(upLeftPoint12Y - gravY)) > sqrt((downRightPoint12X - gravX)*(downRightPoint12X - gravX) + (downRightPoint12Y - gravY)*(downRightPoint12Y - gravY))
            rotationAngle = 333;
        else
            rotationAngle = 153;    
        end          
        
    end    
    
elseif (Dist3333 >= Distmain) & (Dist3333 >= Dist1515)  & (Dist3333 >= Dist1212 )  & (Dist3333 >= Dist2121)  & (Dist3333 >= Dist5151) & (Point3333XUpRightDownLeftDIST > 0) & (Point3333XUpLeftDownRightDIST > 0)       
    %Point3333XUpRightDownLeftDIST
    %Point3333XUpLeftDownRightDIST
    
    if Point3333XUpRightDownLeftDIST > Point3333XUpLeftDownRightDIST
        eccentricity = Point3333XUpRightDownLeftDIST/Point3333XUpLeftDownRightDIST;
        doundNess = 4*area/pi*sqrt(Point3333XUpRightDownLeftDIST);

        majorDist = Point3333XUpRightDownLeftDIST;
        minorDist = Point3333XUpLeftDownRightDIST;
        
        if sqrt((upRightPoint33X - gravX)*(upRightPoint33X - gravX) + (upRightPoint33Y - gravY)*(upRightPoint33Y - gravY)) > sqrt((downLeftPoint33X - gravX)*(downLeftPoint33X - gravX) + (downLeftPoint33Y - gravY)*(downLeftPoint33Y - gravY))
            rotationAngle = 45;
        else
            rotationAngle = 225;    
        end           
        
    else
        eccentricity = Point3333XUpLeftDownRightDIST/Point3333XUpRightDownLeftDIST;
        doundNess = 4*area/pi*sqrt(Point3333XUpLeftDownRightDIST);

        majorDist = Point3333XUpLeftDownRightDIST;
        minorDist = Point3333XUpRightDownLeftDIST;

        if sqrt((upLeftPoint33X - gravX)*(upLeftPoint33X - gravX) + (upLeftPoint33Y - gravY)*(upLeftPoint33Y - gravY)) > sqrt((downRightPoint33X - gravX)*(downRightPoint33X - gravX) + (downRightPoint33Y - gravY)*(downRightPoint33Y - gravY))
            rotationAngle = 315;
        else
            rotationAngle = 135;    
        end          
        
    end
    
elseif (Dist2121 >= Distmain) & (Dist2121 >= Dist1515)  & (Dist2121 >= Dist1212 )  & (Dist2121 >= Dist3333 )  & (Dist2121 >= Dist5151)  & (Point2121XUpRightDownLeftDIST > 0) & (Point2121XUpLeftDownRightDIST > 0)      
    %Point2121XUpRightDownLeftDIST
    %Point2121XUpLeftDownRightDIST

    if Point2121XUpRightDownLeftDIST > Point2121XUpLeftDownRightDIST
        eccentricity = Point2121XUpRightDownLeftDIST/Point2121XUpLeftDownRightDIST;
        doundNess = 4*area/pi*sqrt(Point2121XUpRightDownLeftDIST);

        majorDist = Point2121XUpRightDownLeftDIST;
        minorDist = Point2121XUpLeftDownRightDIST;       
        
        if sqrt((upRightPoint21X - gravX)*(upRightPoint21X - gravX) + (upRightPoint21Y - gravY)*(upRightPoint21Y - gravY)) > sqrt((downLeftPoint21X - gravX)*(downLeftPoint21X - gravX) + (downLeftPoint21Y - gravY)*(downLeftPoint21Y - gravY))
            rotationAngle = 63;
        else
            rotationAngle = 243;    
        end         
        
    else
        eccentricity = Point2121XUpLeftDownRightDIST/Point2121XUpRightDownLeftDIST;
        doundNess = 4*area/pi*sqrt(Point2121XUpLeftDownRightDIST);
        
        majorDist = Point2121XUpLeftDownRightDIST;
        minorDist = Point2121XUpRightDownLeftDIST;     
        
        if sqrt((upLeftPoint21X - gravX)*(upLeftPoint21X - gravX) + (upLeftPoint21Y - gravY)*(upLeftPoint21Y - gravY)) > sqrt((downRightPoint21X - gravX)*(downRightPoint21X - gravX) + (downRightPoint21Y - gravY)*(downRightPoint21Y - gravY))
            rotationAngle = 297;
        else
            rotationAngle = 117;    
        end           
        
    end    
    
elseif (Dist5151 >= Distmain) & (Dist5151 >= Dist1515)  & (Dist5151 >= Dist1212 )  & (Dist5151 >= Dist3333 )  & (Dist5151 >= Dist2121 )  & (Point5151XUpRightDownLeftDIST > 0) & (Point5151XUpLeftDownRightDIST > 0)      
    %Point5151XUpRightDownLeftDIST
    %Point5151XUpLeftDownRightDIST
    
    if Point5151XUpRightDownLeftDIST > Point5151XUpLeftDownRightDIST
        eccentricity = Point5151XUpRightDownLeftDIST/Point5151XUpLeftDownRightDIST;
        doundNess = 4*area/pi*sqrt(Point5151XUpRightDownLeftDIST);

        majorDist = Point5151XUpRightDownLeftDIST;
        minorDist = Point5151XUpLeftDownRightDIST;     
        
        if sqrt((upRightPoint51X - gravX)*(upRightPoint51X - gravX) + (upRightPoint51Y - gravY)*(upRightPoint51Y - gravY)) > sqrt((downLeftPoint51X - gravX)*(downLeftPoint51X - gravX) + (downLeftPoint51Y - gravY)*(downLeftPoint51Y - gravY))
            rotationAngle = 79;
        else
            rotationAngle = 259;    
        end  
        
    else
        eccentricity = Point5151XUpLeftDownRightDIST/Point5151XUpRightDownLeftDIST;
        doundNess = 4*area/pi*sqrt(Point5151XUpLeftDownRightDIST);
        
        majorDist = Point5151XUpLeftDownRightDIST;
        minorDist = Point5151XUpRightDownLeftDIST; 
        
        if sqrt((upLeftPoint51X - gravX)*(upLeftPoint51X - gravX) + (upLeftPoint51Y - gravY)*(upLeftPoint51Y - gravY)) > sqrt((downRightPoint51X - gravX)*(downRightPoint51X - gravX) + (downRightPoint51Y - gravY)*(downRightPoint51Y - gravY))
            rotationAngle = 281;
        else
            rotationAngle = 101;    
        end           
        
    end
    
end    


eccentricity = majorDist/minorDist;
roundNess = 4*area/pi*sqrt(majorDist);


% -------------------------------------------------------------------------------------------------------

initialSymmetry1 = abs(sqrt((leftPointX - gravX) * (leftPointX - gravX) + (leftPointY - gravY) * (leftPointY - gravY)) - sqrt((rightPointX - gravX) * (rightPointX - gravX) + (rightPointY - gravY) * (rightPointY - gravY)));
initialSymmetry2 = abs(sqrt((upRightPoint15X - gravX) * (upRightPoint15X - gravX) + (upRightPoint15Y - gravY) * (upRightPoint15Y - gravY)) - sqrt((upLeftPoint15X - gravX) * (upLeftPoint15X - gravX) + (upLeftPoint15Y - gravY) * (upLeftPoint15Y - gravY)));
initialSymmetry3 = abs(sqrt((upRightPoint12X - gravX) * (upRightPoint12X - gravX) + (upRightPoint12Y - gravY) * (upRightPoint12Y - gravY)) - sqrt((upLeftPoint12X - gravX) * (upLeftPoint12X - gravX) + (upLeftPoint12Y - gravY) * (upLeftPoint12Y - gravY)));
initialSymmetry4 = abs(sqrt((upRightPoint33X - gravX) * (upRightPoint33X - gravX) + (upRightPoint33Y - gravY) * (upRightPoint33Y - gravY)) - sqrt((upLeftPoint33X - gravX) * (upLeftPoint33X - gravX) + (upLeftPoint33Y - gravY) * (upLeftPoint33Y - gravY)));
initialSymmetry5 = abs(sqrt((upRightPoint21X - gravX) * (upRightPoint21X - gravX) + (upRightPoint21Y - gravY) * (upRightPoint21Y - gravY)) - sqrt((upLeftPoint21X - gravX) * (upLeftPoint21X - gravX) + (upLeftPoint21Y - gravY) * (upLeftPoint21Y - gravY)));
initialSymmetry6 = abs(sqrt((upRightPoint51X - gravX) * (upRightPoint51X - gravX) + (upRightPoint51Y - gravY) * (upRightPoint51Y - gravY)) - sqrt((upLeftPoint51X - gravX) * (upLeftPoint51X - gravX) + (upLeftPoint51Y - gravY) * (upLeftPoint51X - gravY)));
initialSymmetry7 = abs(sqrt((downRightPoint15X - gravX) * (downRightPoint15X - gravX) + (downRightPoint15Y - gravY) * (downRightPoint15Y - gravY)) - sqrt((downLeftPoint15X - gravX) * (downLeftPoint15X - gravX) + (downLeftPoint15Y - gravY) * (downLeftPoint15Y - gravY)));
initialSymmetry8 = abs(sqrt((downRightPoint12X - gravX) * (downRightPoint12X - gravX) + (downRightPoint12Y - gravY) * (downRightPoint12Y - gravY)) - sqrt((downLeftPoint12X - gravX) * (downLeftPoint12X - gravX) + (downLeftPoint12Y - gravY) * (downLeftPoint12Y - gravY)));
initialSymmetry9 = abs(sqrt((downRightPoint33X - gravX) * (downRightPoint33X - gravX) + (downRightPoint33Y - gravY) * (downRightPoint33Y - gravY)) - sqrt((downLeftPoint33X - gravX) * (downLeftPoint33X - gravX) + (downLeftPoint33Y - gravY) * (downLeftPoint33Y - gravY)));
initialSymmetry10 = abs(sqrt((downRightPoint21X - gravX) * (downRightPoint21X - gravX) + (downRightPoint21Y - gravY) * (downRightPoint21Y - gravY)) - sqrt((downLeftPoint21X - gravX) * (downLeftPoint21X - gravX) + (downLeftPoint21Y - gravY) * (downLeftPoint21Y - gravY)));
initialSymmetry11 = abs(sqrt((downRightPoint51X - gravX) * (downRightPoint51X - gravX) + (downRightPoint51Y - gravY) * (downRightPoint51Y - gravY)) - sqrt((downLeftPoint51X - gravX) * (downLeftPoint51X - gravX) + (downLeftPoint51Y - gravY) * (downLeftPoint51Y - gravY)));

% -------------------------------------------------------------------------------------------------------

boundVal = 50;



if (eccentricity < 1.5) & (area > 500) & (doundNess > 2000) & (initialSymmetry1 < boundVal)  & (initialSymmetry2 < boundVal) & (initialSymmetry3 < boundVal) & (initialSymmetry4 < boundVal) & (initialSymmetry5 < boundVal) & (initialSymmetry6 < boundVal) & (initialSymmetry7 < boundVal) & (initialSymmetry8 < boundVal) & (initialSymmetry9 < boundVal) & (initialSymmetry10 < boundVal) & (initialSymmetry11 < boundVal)

        
    %objectID
    %area
    %doundNess    
    %eccentricity
    %initialSymmetry1
    %initialSymmetry2
    %initialSymmetry3
    %initialSymmetry4
    %initialSymmetry5
    %initialSymmetry6
    %initialSymmetry7
    %initialSymmetry8
    %initialSymmetry9
    %initialSymmetry10
    %initialSymmetry11
    
    
    % -------------------------------------------------------------------------------------------------------
    % now we have the object we need to work on the lence equation now.
    % what is the distance we should keep the camera?

    playingFieldDistance                    = 100 * 1.5;                                % cm = 1.5 meters
    badmintonRacketHeight                   = 23.3;                                     % cm
    delta                                   = 1.15;                                     % Now assuming that we accept error term delta where delta > 1
                                                                                        % h1 = delta * h2

    imageResolution                         = 37.795;                                   % pixels/cm                                                            
    heightImageRacketAtBackPosition         = PointUpDownDIST/imageResolution;                                                 
    
    cameraDistance                          = (playingFieldDistance/(delta-1))*(1 + (heightImageRacketAtBackPosition/badmintonRacketHeight));
    
    cameraDistance                          = cameraDistance/100;                       % now in meters
    
    
    %cameraDistance
  
    % -------------------------------------------------------------------------------------------------------
    
    
    
    % -------------------------------------------------------------------------------------------------------
    arrOutPut = 1:9;

    arrOutPut(1) = objectID;
    arrOutPut(2) = cameraDistance;
    arrOutPut(3) = majorDist;
    arrOutPut(4) = minorDist;
    arrOutPut(5) = rotationAngle;
    
    arrOutPut(6) = topY;
    arrOutPut(7) = bottomY;
    arrOutPut(8) = leftX;
    arrOutPut(9) = rightX;
    
    arrOutPut
    
    Proc = arrOutPut;
   
else
    Proc = -1;
end

% -------------------------------------------------------------------------------------------------------

