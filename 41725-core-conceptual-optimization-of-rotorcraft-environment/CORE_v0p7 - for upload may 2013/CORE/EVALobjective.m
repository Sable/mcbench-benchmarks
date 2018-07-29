function [ObjOut ObjVals] = ...
    EVALobjective(Xin,Problem,Objectives,Spec,Constraints,objtype)
X0 = Problem.x0;
activeX = Problem.activeX;
weightings = Objectives.weightings;
nObj = length(weightings);

X0(activeX) = Xin;
X = X0;

AC = ACbuilder(X,Spec);
ObjVals = zeros(nObj,1);
for ii = 1:nObj
    if weightings(ii) %don't evaluate if not weighted
        ObjVals(ii) = feval(Spec.Objfuncs{ii},AC);
    end
end

switch lower(objtype(1:5))
    case 'multi'
        ObjOut = ObjVals(weightings~=0);
    case 'singl'
        ObjOut = sum(ObjVals.*weightings);
end

% penalties
if strcmpi('pen',objtype(end-2:end))
    C = EVALnonlcons(Xin,Problem,Constraints,Spec);
    
    C(C<0)=0;
    
    pen = 20*C.^(.2);
    pen(C>1) = 16+C(C>1)*4;
    
    penalty = sum(pen);
    
    ObjOut = ObjOut+penalty;
end
