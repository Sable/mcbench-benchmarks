function [TempU TempV TempNormal]= Opticalflow( CurrentFrame, PreviousFrame, alpha, iterations,height,width)


TempU=zeros(height,width);
TempV=zeros(height,width);
Window=[1/12 1/6 1/12;1/6 0 1/6;1/12 1/6 1/12];

TempEx = conv2(double(CurrentFrame),double(0.25*[-1,1;-1,1]),'same') + conv2(double(PreviousFrame),double(0.25*[-1  1; -1  1]),'same');

TempEy= conv2(double(CurrentFrame), double(0.25*[-1,-1;1,1]),'same') + conv2(double(PreviousFrame),double(0.25*[-1  -1; 1  1]), 'same');

TempEt= conv2(double(CurrentFrame), double(0.25*ones(2)),'same') + conv2(double(PreviousFrame), double(-0.25*ones(2)),'same');

TempNormal=TempEt./sqrt(TempEy.^2+TempEx.^2);
TempNormal(isnan(TempNormal))=0;
TempNormal(isinf(TempNormal))=0;
% size(TempEx);
for i=iterations
    ubar=conv2(double(TempU),Window,'same');
    vbar=conv2(double(TempV),Window,'same');
    % Compute flow vectors constrained by its local average and the optical flow constraints
    TempU= ubar - ( TempEx.* ( ( TempEx.* ubar ) + ( TempEy.* vbar ) + TempEt ) ) ./ ( alpha^2 + TempEx.^2 + TempEy.^2);
    TempV= vbar - ( TempEy.* ( ( TempEx.* ubar ) + ( TempEy.* vbar ) + TempEt ) ) ./ ( alpha^2 + TempEx.^2 + TempEy.^2);
end
