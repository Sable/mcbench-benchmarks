
function [AI,det] = inv1(AO)
%     Find inverse and determinant of square matrix
%     using automatic optimum pivoting.
%     F C Chang       11/29/2012
%
       n = size(AO,1);
       D = abs(AO);
   for k = 1:n,
       [r,ijp] = max(D(:));
       jp(k) = ceil(ijp/n);  ip(k) = ijp-(jp(k)-1)*n;
       D(ip(k),:) = 0; D(:,jp(k)) = 0;
   end;
       det = 1;
       AI = [ ];
  for  k = 1:n,   
       d = AO(ip(k),jp(k)) ...
          -AO(ip(k),jp(1:k-1))*AI*AO(ip(1:k-1),jp(k));   
    if abs(d) < 10.^-08,    AI = NaN;    det = 0;   
       disp('Given matrix may be singular !!'), return,   
    end;
       det = det*d;
       AI = [AI,zeros(k-1,1); zeros(1,k-1),0] ...
           +[AI*AO(ip(1:k-1),jp(k));-1] ...
           *[AO(ip(k),jp(1:k-1))*AI,-1] /d;
  end;
       AI(jp,ip) = AI;                                







function AI = inv0(AO)
%    Find inverse of square matrix
%    Warning: It may fail for some !
%    F C Chang     11/29/2012
%
     AI = [ ];
  for k = 1:size(AO),
     AI = [AI,zeros(k-1,1);zeros(1,k-1),0]    ...
         +[AI*AO(1:k-1,k);-1]*[AO(k,1:k-1)*AI,-1] ...
         /(AO(k,k)-AO(k,1:k-1)*AI*AO(1:k-1,k));
  end; 
