function [GrayCode,GrayCodeLength] = ImprovedGenerateGrayCode( Range )
% Input: Range is vector storing the maximum state in each digit.
% Output; GrayCode is the generated Graycode,GrayCodeLength is the number
% of generated Gray code.
Len = size( Range,2 );
if isempty( find( Range>1 ) ) == 1 %#ok<EFIND>
    GrayCode = zeros(1,Len);  GrayCodeLength = 1;
    return
end
[ LocalGrayCode,GrayCodeLength ] = GenerateGrayCode( Range( Range > 1 ) );

 t = 1;GrayCode  = zeros( GrayCodeLength,Len );
for p = 1:Len
   if Range( p ) == 1 
      GrayCode(:,p) = zeros( GrayCodeLength,1 );
   else
      GrayCode(:,p) = LocalGrayCode(:,t);
      t = t + 1;
   end
end

end

