function outbell = gbell(bsize,range,center,sigma)

%   A small prgram that creates a normalized 2 dimensional gaussian bell
%   with center peak at center
%
%   Usage:  gbell(bsize,range,center,sigma)
%
%   Where   bsize       is the matrix size ([rows columns]) of the output bell 
%           range       is the lower and upper limits of the x- and y-ranges of 
%                       the area where the bell should be created in the format:
%                       [minx maxx miny maxy] 
%           center      is the (x,y) center of the bell in the format [x y]
%           sigma       is the standard deviation of the distribution
%
%   Notes:  The standard deviation is the same for both axis, i.e the bell
%           will always be cylindrically symmetric around center, feel free to add a 
%           different sigma for the y-axis if you need it.
%
%   Created             27.5.2005
%   by                  Mathias Österberg
%                       mathias.osterberg@helsinki.fi
%                       Electronic Research Unit
%                       University of Helsinki

if isequal(length(bsize),1);    bsize = [bsize bsize];              end
if isequal(length(center),1);   center = [center center];           end
if isequal(length(range),2);    range = [range range];              end
if ~isequal(length(range),4);   error('The range must be given in the format [min max] or [minx maxx miny maxy]');  end
if sigma <= 0;  error('Sigma must be a number greater than zero');  end


outbell = zeros(bsize(1),bsize(2));
range1 = range(1):(range(2)-range(1))/(bsize(1)-1):range(2);
range2 = range(3):(range(4)-range(3))/(bsize(2)-1):range(4);

% Give values to the matrix elements based on the distance from the
% central peak
for a = 1:bsize(1)
    for b = 1:bsize(2)
        outbell(a,b) = normpdf(sqrt((center(1)-range1(a))^2+(center(2)-range2(b))^2),0,sigma);
    end
end

% Normalizing
outbell = outbell/sum(sum(outbell));

