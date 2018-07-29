function y = imcircle(n)

% y = imcircle(n);
%
% Draw a solid circle of ones with diameter n pixels 
% in a square of zero-valued pixels.
%
% Example: y = imcircle(50);
%
% For a hollow circle (line circle) of diameter n,
% add the instruction bwmorph from the Image Processing
% Toolbox.
%
% Example: y = bwmorph(imcircle(50),'remove');

if rem(n,1) > 0, 
   disp(sprintf('n is not an integer and has been rounded to %1.0f',round(n)))
   n = round(n);
end

if n < 1     % invalid n
   error('n must be at least 1')
   
elseif n < 4 % trivial n
   y = ones(n);

elseif rem(n,2) == 0,  % even n
   
   DIAMETER = n;
   diameter = n-1;
   RADIUS = DIAMETER/2;
   radius = diameter/2;
   height_45 = round(radius/sqrt(2));
   width = zeros(1,RADIUS);
   semicircle = zeros(DIAMETER,RADIUS);   

   for i  = 1 : height_45
       upward = i - 0.5;
       sine = upward/radius;
       cosine = sqrt(1-sine^2);
       width(i) = ceil(cosine * radius);
   end

   array = width(1:height_45)-height_45;

   for j = max(array):-1:min(array)
       width(height_45 + j) = max(find(array == j));
   end

   if min(width) == 0
      index = find(width == 0);
      width(index) = round(mean([width(index-1) width(index+1)]));
   end

   width = [fliplr(width) width];

   for k  = 1 : DIAMETER
       semicircle(k,1:width(k)) = ones(1,width(k));
   end   

   y = [fliplr(semicircle) semicircle];

else   % odd n
   
   DIAMETER = n;
   diameter = n-1;
   RADIUS = DIAMETER/2;
   radius = diameter/2;
   semicircle = zeros(DIAMETER,radius);
   height_45 = round(radius/sqrt(2) - 0.5);
   width = zeros(1,radius);

   for i  = 1 : height_45
       upward = i;
       sine = upward/radius;
       cosine = sqrt(1-sine^2);
       width(i) = ceil(cosine * radius - 0.5);
   end

   array = width(1:height_45) - height_45;

   for j = max(array):-1:min(array)
       width(height_45 + j) = max(find(array == j));
   end

   if min(width) == 0
      index = find(width == 0);
      width(index) = round(mean([width(index-1) width(index+1)]));
   end

   width = [fliplr(width) max(width) width];

   for k  = 1 : DIAMETER
       semicircle(k,1:width(k)) = ones(1,width(k));
   end   

   y = [fliplr(semicircle) ones(DIAMETER,1) semicircle];

end
