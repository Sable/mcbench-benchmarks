function GFunValue = GClosedFun( LGObj, X, PAX )
%Input: X is the given variable, and PAX is the parents of X
%Output: GFunValue is the G function value given X and Parent(X)

%if size(PAX,1)>1
%    PAX = PAX';
%end

GFunValue = 0;
LG = struct( LGObj );
N  = LG.CaseLength;
UsedSample = DiscardNoneExist( LG.VarSample,[X PAX]);

DimX =  LG.VarRangeLength( X );
RangeX = LG.VarRange( X,: ); 
ri = DimX;
OriginalData = LG.VarSample;
% The location of the first unprocessed sample, it accelerates the
% searching. 
  d = 1 ; 
            
 while  d <= N
      Frequency = zeros( 1,DimX ); 
      while d <= N && UsedSample( d ) == 1  
            d = d + 1;
      end
      if d > N,break;end
      for t1 = 1:DimX
          if RangeX(t1) == OriginalData( d,X ), break; end
      end
      Frequency( t1 ) =  1;
      UsedSample( d )=1;
      ParentValue = OriginalData( d, PAX );
      d = d + 1;
      if d > N, break;end
      
      % test whether the class value in Sample(t) is the same as ClassValue or not. 
      for k = d : N
         if UsedSample( k )==0 
             if ParentValue == OriginalData( k, PAX )
                  t1 = 1;
                  while RangeX( t1 ) ~= OriginalData( k,X ),t1 = t1 + 1; end              
                  Frequency( t1 ) = Frequency( t1 ) + 1;
                  UsedSample( k ) = 1;
                  %Frequency
             end
         end 
      end     
      %UsedSample
      %Frequency
      Sum = sum( Frequency );
      for k = 1:ri
          if Frequency( k )~= 0
             GFunValue = GFunValue + gammaln( Frequency( k )+1 ); % Nijk is equal to Frequency( k )
          end
      end
      GFunValue = GFunValue + gammaln( ri ) - gammaln( Sum + ri ) ;    
  end
%GFunValue
end


function  [Discard,TotalNumber ] = DiscardNoneExist( OriginalData,TestVector )
% This function return a matric indicating the useful rows in OriginalData.  
% Input:  TestVector is the variables in OriginalData
%         TestVector is the set of variables.
% Output: Discard is a tag matric showing which rows in OriginalData are used

% U is the given value when the data is invalid. 
N = size(OriginalData,1); % U;  
Discard = zeros(1,N);
TotalNumber = 0;
  for p=1:N
      d = 1;
      for q = 1:size(TestVector,2)
          if OriginalData(p,TestVector(q)) == -1   % Here we assume U =-1
             d = 0;
             break;
          end
      end
      if d==0 
          Discard(p) = 1;
          TotalNumber = TotalNumber + 1;
      end
  end
end