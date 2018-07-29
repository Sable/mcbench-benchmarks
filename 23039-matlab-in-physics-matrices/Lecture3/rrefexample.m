function rrefexample(A)
[r,c]=size(A);
for col=1:c-1
    disp('Press a key to continue')
    pause
    disp(['Column: ',num2str(col)])
    disp(['Divide row ',num2str(col),' by ',num2str(A(col,col))])
    A(col,:)=A(col,:)/A(col,col);
    for row=col+1:r
        disp(['Subract ',num2str(A(row,col)/A(col,col)),...
            ' times row ',num2str(col),...
            ' from row ',num2str(row)])
        A(row,:)=A(row,:)-A(row,col)/A(col,col)*A(col,:);
    end
    A
end
disp('Matrix A is now upper triangular')
A(1:r,1:r)

%   Copyright 2008-2009 The MathWorks, Inc.
%   $Revision: 35 $  $Date: 2009-05-29 15:27:34 +0100 (Fri, 29 May 2009) $
