% Descriptor for simple shapes (e.g letters).
% Computes the descriptor twice in order to describe horizontally and vertically with the same accuracy.
% 
% Input: image (2-D, binary or gray)
%        depth of recursion (default 7),
%        plotFlag(if on - plot Illustration)
% Output: 
%        vec - descriptor: Division locations, values around zero. Of length 2*(2^depth - 2) 
%        (levels: the depth of the division locations.)
%
% Shahar Armon. 3/1/2012

function  [vec levels] = hierarchicalCentroid(im, depth, plotFlag)
    if nargin < 2
        depth = 7;
        plotFlag = 0;
    elseif nargin < 3
        plotFlag = 0;
    end
    
    im(im < 0) = 0;

    [vec1 levels1] = hierarchicalCentroid1(im  ,depth, plotFlag);
    [vec2 levels2] = hierarchicalCentroid1(im' ,depth, 0);  % transpose iamge
    
    vec = [vec1, vec2];
    levels = [levels1,-levels2];  % Minus is only to mark the transpose.
end


% The descriptor. Includes Normalization.
function  [vec levels] = hierarchicalCentroid1(im, d, plotFlag)

    p = hierarchicalCentroidRec(im, 1, d);
    
    if plotFlag  % Illustration
        showLines(im, p);
    end
    
    meany = ([1:size(im,1)]*sum(im,2))/sum(sum(im));          
    indVer = (mod(p(:,2),2) == 1);
    % Normalization for location:    
    p(indVer,1) = p(indVer,1) - p(1,1);
    p(~indVer,1) = p(~indVer,1) - meany;
    
    % Normalization for size (keeping aspect ratio):
    p(:,1) = p(:,1)/size(im,1);    
    % Normalization for size:
    % p(indVer,1) = p(indVer,1)/size(im,2);
    % p(~indVer,1) = p(~indVer,1)/size(im,1);
    
    % Illustration of the lines after normalization without the image
    %     showLines([], p);
    
    vec = p(2:end,1)';
    levels = p(2:end,2)';
end



function p = hierarchicalCentroidRec(im, depth, maxDepth)    
    if depth > maxDepth
        p = [];
    else
        area = sum(sum(im));
        [rows,cols] = size(im);
        % compute the centroid-x
        if cols == 1
            centroid = 0.5;
        elseif area == 0
            centroid = cols/2;
        elseif rows == 1
            centroid = (im*[1:cols]')/area;            
        else
            centroid = sum(im)*[1:cols]'/area;            
        end
        
        leftIm = im(:,1:floor(centroid));
        rightIm = im(:,ceil(centroid):end);
        
       
        pLeft  = hierarchicalCentroidRec(leftIm'  , depth+1, maxDepth);    
        pRight = hierarchicalCentroidRec(rightIm' , depth+1, maxDepth);
        
        %  Updates the distances so they will be in relation to the complete image
        if size(pRight,1) > 1
            ind = find((1-mod(depth,2))-mod(pRight(2:end,2),2)) + 1;
            pRight(ind,1) = pRight(ind,1) + ceil(centroid) - 1; 
            pRight(1,1) = pRight(1,1) - 1;    
        end
        
        p = [centroid, depth; pLeft; pRight];                        
    end
end




function showLines(im, p)
    if max(p(:,1))<3
        hold on;
        axis([-1 1 -1 1])
        axis ij;
        temp = mod(p(:,2),2);
        indVer = find(temp);
        indHor = find(~temp);        
        showLinesRec(min(p(indVer,1)),max(p(indVer,1)),min(p(indHor,1)),max(p(indHor,1)), p);
    else
        imshow(im); 
        hold on;
        showLinesRec(0,size(im,2),0,size(im,1), p);        
    end
    hold off
end

function p = showLinesRec(x1,x2,y1,y2, p)
    p1 = p(1,:);
    w = 1+max(p(:,2))-p1(1,2);
    t = p1(1);
    p = p(2:end,:);
    if mod(p1(1,2),2)
        plot([t t],[y1 y2],'-m','LineWidth',w);
    else        
        plot([x1 x2],[t t],'-r','LineWidth',w);  
    end
    if (p1(1,2) < max(p(:,2)))
        if mod(p1(1,2),2)
            p = showLinesRec(x1,t,y1,y2, p);
            p = showLinesRec(t,x2,y1,y2, p);
        else
            p = showLinesRec(x1,x2,y1,t, p);
            p = showLinesRec(x1,x2,t,y2, p);            
        end
    end
    
end
