function [outputCONTOUR,varargout] = TRACE_MooreNeighbourhood(data2D,varargin)
% TRACE_MooreNeighbourhood  2D boundary tracing using the Moore neighbourhood
%==========================================================================
% FILENAME:     TRACE_MooreNeighbourhood.m
% AUTHOR:       Adam H. Aitkenhead
% DATE:         12th April 2010
% PURPOSE:      2D boundary tracing using the Moore neighbourhood
%
% USAGE:        [listCONTOUR,listNORMALS] = TRACE_MooreNeighbourhood(data2D,pixelFIRST)
%%
% INPUT PARAMETERS:  data2D      - Mandatory.  An LxM array containing the
%                                  2D data.  All pixels within the region
%                                  to be traced must equal 1, and all
%                                  pixels outside the region must equal 0.
%                    pixelFIRST  - Optional.  A (2x1) array containing the
%                                  [x;y] coordinates of any one pixel
%                                  located on the edge of the region to be
%                                  traced.
%
% OUTPUT PARAMETERS: listCONTOUR - Mandatory.  An Nx2 array containing the
%                                  coordinates of the pixels located around
%                                  the edge of the region to be traced.
%                                  The pixels are listed in a clockwise
%                                  direction around the contour.
%                    listNORMALS - Optional.  An Nx2 array containing the
%                                  (approximate) normal vectors pointing
%                                  out of the region of interest.  The
%                                  vectors are listed in a clockwise
%                                  direction around the contour, and
%                                  correspond to each pixel listed in
%                                  listCONTOUR.
%
% EXAMPLE:      data2D = [0,0,0,0,0,0; 0,1,0,1,0,0; 0,1,1,1,1,0; 0,1,1,1,0,0; 0,1,1,1,1,0; 0,0,0,0,0,0];
%               [listCONTOUR,listNORMALS] = TRACE_MooreNeighbourhood(data2D);
%               imagesc(data2D)
%               colormap('gray')
%               hold on
%                 plot(listCONTOUR(:,2),listCONTOUR(:,1),'ro-','LineWidth',2)
%                 plot([listCONTOUR(:,2),listCONTOUR(:,2)+listNORMALS(:,2)]',[listCONTOUR(:,1),listCONTOUR(:,1)+listNORMALS(:,1)]','b','LineWidth',2)
%               hold off
%
% NOTES:      - The algorithm ends when the *second* pixel in the loop is
%               revisited, entered from the same direction as it was
%               entered on its first visit.  The second pixel is used
%               rather than the first pixel for two reasons:  1. The
%               first pixel may be encountered more than once while going
%               around the contour;  2. It is possible that the first pixel
%               will never be entered from the same direction as it was on
%               its first visit.
%             - The code does not identify any internal holes which exist
%               in the region to be traced.
%             - If more than one separate region exists in the image, the
%               code only traces one of these regions.  The user can define
%               which region by choosing an appropriate starting pixel
%               <pixelFIRST>.  Alternatively, the first region encountered
%               by the algorithm will be traced.
%
% REFERENCES: - For a guide to Contour Tracing, including a description of
%               Moore-Neighbour Tracing, see the tutorial by Abeer George
%               Ghuneim at:
%                http://www.imageprocessingplace.com/downloads_V3/
%                  root_downloads/tutorials/
%                  contour_tracing_Abeer_George_Ghuneim/index.html
%==========================================================================

%==========================================================================
% VERSION:  USER:  CHANGES:
% -------   -----  --------
% 090512    AHA    Original version
% 091021    AHA    Improved the calculation of the normals
% 100412    AHA    General housekeeping
%==========================================================================

%================================================
%  READ INPUT PARAMETERS
%================================================

% Configure the array which contains the region to be contour-traced:
if nargin<1
  error(' ERROR:  A 2D array is required as input.');
end

% Define pixelFIRST, the start coordinate (x,y) for the Moore-neighbour tracing algorithm.  This must be an edge pixel on the region to be contour-traced.
if nargin==2  
  pixelFIRST = varargin{1};
else %If pixelFIRST hasn't been defined by the user, define it now:
  [tempR,tempC] = find(data2D==1);
  pixelFIRST = [tempR(1);tempC(1)];
end

%Make sure pixelFIRST is a column vector, rather than a row vector
if size(pixelFIRST,2)==2
  pixelFIRST = pixelFIRST';
end

%Makes sure data2D is a binary image
if numel(unique(data2D))~=2  ||  min(data2D(:))~=0  ||  max(data2D(:))~=1
  error(' Input image must be an array composed only of 0s and 1s.')
end

% Add a one-pixel border around the array before doing the analysis.
% This prevents the code from failing if the region to be traced extends to the edge of the array.
data2Doriginal = data2D;
data2D         = [zeros(1,size(data2Doriginal,2)+2);zeros(size(data2Doriginal,1),1),data2Doriginal,zeros(size(data2Doriginal,1),1);zeros(1,size(data2Doriginal,2)+2)];
pixelFIRST     = pixelFIRST + 1;

%================================================
%  INITIAL DEFINITIONS
%================================================

%Define the initial direction of entry (x,y) into the first pixel.  This
%direction must point from the outside to the inside.
tempI = find(data2D(pixelFIRST(1)-1:pixelFIRST(1)+1,pixelFIRST(2))==0);
if isempty(tempI)==0
  directionFIRST = [2-tempI(1);0];
else
  tempI = find(data2D(pixelFIRST(1),pixelFIRST(2)-1:pixelFIRST(2)+1)==0);
  if isempty(tempI)==0
    directionFIRST = [0;2-tempI(1)];
  else
    imagesc(data2D)
    save('temp.txt','data2D','-ascii','-tabs')
    error(' ERROR:  Unable to identify a vector pointing into the first pixel on the contour.');
  end
end

%Create an array for the output.  It will hold the (x,y) coordinates of
%every pixel around the border of the region to be contour-traced.  The
%directions are also recorded, and will be used as part of the test
%criterion to end the algorithm:
listCONTOUR   = pixelFIRST;
listDIRECTION = directionFIRST;

%Create a variable which will be used to tell the algorithm when to stop:
checkLOOPEND = 0;


%================================================
%  PERFORM THE MOORE NEIGHBOURHOOD TRACING
%================================================

ROTangle     = -pi/2;   %radians
ROTmatrix90  = [ cos(ROTangle) , -sin(ROTangle) ; sin(ROTangle) , cos(ROTangle) ];
ROTangle     = -pi;   %radians
ROTmatrix180 = [ cos(ROTangle) , -sin(ROTangle) ; sin(ROTangle) , cos(ROTangle) ];

tempPIX = pixelFIRST;
tempDIR = directionFIRST;

while checkLOOPEND==0

  tempDIR = round(ROTmatrix180*tempDIR);
  tempPIX = tempPIX + tempDIR;
  if data2D(tempPIX(1),tempPIX(2)) == 1
    listCONTOUR   = [listCONTOUR,tempPIX];
    listDIRECTION = [listDIRECTION,tempDIR];
  else
    tempDIR = round(ROTmatrix90*tempDIR);
    tempPIX = tempPIX + tempDIR;
    if data2D(tempPIX(1),tempPIX(2)) == 1
      listCONTOUR   = [listCONTOUR,tempPIX];
      listDIRECTION = [listDIRECTION,tempDIR];
    else
      tempDIR = round(ROTmatrix90*tempDIR);
      tempPIX = tempPIX + tempDIR;
      if data2D(tempPIX(1),tempPIX(2)) == 1
        listCONTOUR   = [listCONTOUR,tempPIX];
        listDIRECTION = [listDIRECTION,tempDIR];
      else
        tempPIX = tempPIX + tempDIR;
        if data2D(tempPIX(1),tempPIX(2)) == 1
          listCONTOUR   = [listCONTOUR,tempPIX];
          listDIRECTION = [listDIRECTION,tempDIR];
        else
          tempDIR = round(ROTmatrix90*tempDIR);
          tempPIX = tempPIX + tempDIR;
          if data2D(tempPIX(1),tempPIX(2)) == 1
            listCONTOUR   = [listCONTOUR,tempPIX];
            listDIRECTION = [listDIRECTION,tempDIR];
          else
            tempPIX = tempPIX + tempDIR;
            if data2D(tempPIX(1),tempPIX(2)) == 1
              listCONTOUR   = [listCONTOUR,tempPIX];
              listDIRECTION = [listDIRECTION,tempDIR];
            else
              tempDIR = round(ROTmatrix90*tempDIR);
              tempPIX = tempPIX + tempDIR;
              if data2D(tempPIX(1),tempPIX(2)) == 1
                listCONTOUR   = [listCONTOUR,tempPIX];
                listDIRECTION = [listDIRECTION,tempDIR];
              else
                tempPIX = tempPIX + tempDIR;
                if data2D(tempPIX(1),tempPIX(2)) == 1
                  listCONTOUR   = [listCONTOUR,tempPIX];
                  listDIRECTION = [listDIRECTION,tempDIR];
                else
                  tempDIR = round(ROTmatrix90*tempDIR);
                  tempPIX = tempPIX + tempDIR;
                  if data2D(tempPIX(1),tempPIX(2)) == 1
                    listCONTOUR   = [listCONTOUR,tempPIX];
                    listDIRECTION = [listDIRECTION,tempDIR];
                  else
                    tempDIR = round(ROTmatrix90*tempDIR);
                    tempPIX = tempPIX + tempDIR;
                    if data2D(tempPIX(1),tempPIX(2)) == 1
                      listCONTOUR   = [listCONTOUR,tempPIX];
                      listDIRECTION = [listDIRECTION,tempDIR];
                    end %if
                    
                  end %if
                end %if
              end %if
            end %if
          end %if
        end %if
      end %if
    end %if
  end %if
  
  if size(listCONTOUR,2)>2  &&  min(isequal(tempPIX,listCONTOUR(:,2)))  &&  min(isequal(tempDIR,listDIRECTION(:,2)))
    %The stop criterion has been met, so tell the while-loop to exit:
    checkLOOPEND=1;
    %Remove the extra col from the results corresponding to the second
    %visit to the second pixel.
    listCONTOUR         = listCONTOUR(:,1:end-1);
    listDIRECTION       = listDIRECTION(:,1:end-1);
    listENTRYDIRECTIONS = -listDIRECTION;
    %Make sure the normal vector for the first pixel is the same on its
    %first visit as on its last vist:
    listENTRYDIRECTIONS(:,1) = listENTRYDIRECTIONS(:,end);
  end %if
  
end %while

% Adjust the results to remove the effect of the one-pixel border that was
% added around the array before the contour was traced:
listCONTOUR = listCONTOUR - 1;

%================================================
%  COMPUTE THE NORMALS
%  A combination of two methods is used to compute the normals:
%  -1-  The gradient of the two surrounding contour points is found, and
%       then rotated 90 degrees to get the gradient at the point of
%       interest.
%  -2-  The midpoint of the two surrounding points is found, and the vector
%       from this point to the point of interest is found.
%  Method 1 handles concave edges and diagonal edges better, but gets
%  confused in places where the region of interest ends in a one-pixel-wide
%  line, since at that point the two surrounding points are coincident.
%================================================

% Remove last point, which is a duplicate of the first point.
listCONTOURtemp = listCONTOUR(:,1:end-1);

% Method 1:  Gradient:
listGRADIENTS = (circshift(listCONTOURtemp,[0,-1])-circshift(listCONTOURtemp,[0,1]))/2;  % Calculate the gradient of the two surrounding contour-points.
ROTangle      = pi/2;   %radians                                                         % Rotate the gradient by +90 degree to produce the normals.
ROTmatrix     = [ cos(ROTangle) , -sin(ROTangle) ; sin(ROTangle) , cos(ROTangle) ];
listNORMALS_G = ROTmatrix * listGRADIENTS;

% Method 2:  Midpoint:
listMIDPOINT  = (circshift(listCONTOURtemp,[0,-1])+circshift(listCONTOURtemp,[0,1]))/2;  %Find the midpoint of the two surrounding contour-points.
listNORMALS_M = (listCONTOURtemp - listMIDPOINT)./2;                                     % Calculate the vector to the point of interest

% Combine results from the two methods:
method1sign = sign(round(10*listNORMALS_G));
method2sign = sign(round(10*listNORMALS_M));
method1sign(method1sign==0) = method2sign(method1sign==0);
listNORMALS_M = method1sign.*abs(listNORMALS_M);
listNORMALS        = listNORMALS_M;
listNORMALS(:,:,2) = listNORMALS_G;
listNORMALS = mean(listNORMALS,3);

% For cases where the ROI is larger than a single pixel, ensure the normals are units vectors
if size(listNORMALS,2)>1
  normalLENGTHS = sqrt(sum(listNORMALS.^2,1));
  listNORMALS   = listNORMALS./([1;1]*normalLENGTHS);
else
  listNORMALS = [-1;0];
end

% Replace last point, which is a duplicate of the first point.
listNORMALS   = [listNORMALS,listNORMALS(:,1)];

%================================================
%  DEFINE THE OUTPUT ARGUMENTS
%================================================

outputCONTOUR = listCONTOUR';
listNORMALS   = listNORMALS';
  
if nargout == 2
  varargout(1) = {listNORMALS};
end
