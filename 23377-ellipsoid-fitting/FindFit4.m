% Li's ellipsoid specific fitting algorithm:

function v=FindFit4(S)


% Create constraint matrix C:

  C(6,6)=0; 

  C(1,1)=-1; C(2,2)=-1; C(3,3)=-1;

  C(4,4)=-4; C(5,5)=-4; C(6,6)=-4;

  C(1,2)=1; C(2,1)=1; 
  C(1,3)=1; C(3,1)=1; 
  C(2,3)=1; C(3,2)=1;

% Solve generalized eigensystem

  S11=S(1:6, 1:6);  S12=S(1:6, 7:10);
  S22=S(7:10,7:10);

  A=S11-S12*pinv(S22)*S12';

  %[gevec, geval]=eig(A, C);
   
  CA=inv(C)*A;
  [gevec, geval]=eig(CA);

% Find the largest eigenvalue(the only positive eigenvalue)

  In=1;
  maxVal=geval(1,1);
  for i=2:6
    if (geval(i,i)>maxVal)
        maxVal=geval(i,i);
        In=i;
    end;
  end;
  
% Find the fitting

  v1=gevec(:, In); 
  v2=-pinv(S22)*S12'*v1;
  v=[v1; v2];
  

 