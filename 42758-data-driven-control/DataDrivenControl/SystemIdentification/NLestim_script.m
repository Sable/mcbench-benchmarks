%Copyright 2013 The MathWorks, Inc.

%Creating Custom Regressors

C1 = customreg(@(x)max(min(x,100),-100),{'y1'},1); % To incorporate Saturation
C2 = customreg(@(x)((x>0.7) || (x<-0.34))*x,{'u1'},0); % To incorporate deadzone

%merge datasets
ze = merge(z7,z3,z6); %Creating estimation dataset
zv = merge(z1,z2,z4,z5,z8); %Creating validation dataset
z = merge(ze, zv);

model3 = nlarx(ze,[3 2 9],sigmoidnet('num',4),'custom',[C1;C2],'nlr',[1:2 5 6],...
   'disp','on','foc','sim','maxiter',100); % model estimation

compare(z, model); % view fit against both estimation+validation data