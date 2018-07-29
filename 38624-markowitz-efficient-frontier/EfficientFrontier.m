function FrontierCoordinates = EfficientFrontier( Assets , NumPoints, LongOnly)
% This function calculates the coordinates of NumPoints-1 equally spaced
% points and those of the minimum variance portfolio of Markowitz efficient
% frontier. If LongOnly is specified to be true then the frontier will be a
% long only constrained one. Risk is mesured by the std. deviation.
% Returns a structure with members Return and Risk
if (nargin<2 || nargin>3)
    error('Wrong Number of Arguments');
end
if (nargin==2 || (LongOnly~=0 && LongOnly~=1))
    LongOnly=0;
end
[obs, regs]=size(Assets);
if(regs<2)
    error('You need to specify at least 2 assets to build a frontier');
end
if (obs<=regs)
    error('Not enough degrees of freedom');
end
if (NumPoints<=1)
    error('Numpoints must be greater than 2');
end
PointsVar=NaN(NumPoints-1,1);
PointsExpRet=NaN(NumPoints-1,1);
options = optimset('Algorithm','interior-point','Display', 'off');
MaxExpRet=max(mean(Assets));
MinExpRet=min(mean(Assets));
PointsExpRet(:)=MinExpRet:(MaxExpRet-MinExpRet)/(NumPoints-2):MaxExpRet;
if(LongOnly)
    [temp, MinVarVar]=fmincon(@(x)var(Assets*x),(1/regs)*ones(regs,1),-1*eye(regs),zeros(regs,1),ones(1,regs),1,[],[],[],options);
    MinVarExp=mean(Assets*temp);
    for i=1:NumPoints-1
        [~, PointsVar(i)]=fmincon(@(x)var(Assets*x),(1/regs)*ones(regs,1),-1*eye(regs),zeros(regs,1),[ones(1,regs);sum(Assets)],[1;PointsExpRet(i)*obs],[],[],[],options);
    end
else
    [temp, MinVarVar]=fmincon(@(x)var(Assets*x),(1/regs)*ones(regs,1),[],[],ones(1,regs),1,[],[],[],options);
    MinVarExp=mean(Assets*temp);
    for i=1:NumPoints-1
        [~, PointsVar(i)]=fmincon(@(x)var(Assets*x),(1/regs)*ones(regs,1),[],[],[ones(1,regs);sum(Assets)],[1;PointsExpRet(i)*obs],[],[],[],options);
    end
end
IndBelow=PointsExpRet<=MinVarExp;
FrontierCoordinates.Return=[PointsExpRet(IndBelow); MinVarExp; PointsExpRet(~IndBelow)];
FrontierCoordinates.Risk=sqrt([PointsVar(IndBelow); MinVarVar; PointsVar(~IndBelow)]);
end

