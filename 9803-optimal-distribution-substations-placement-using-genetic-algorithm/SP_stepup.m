% this function step-up the transformers size until it can feed the total
% loads connected to it.
function NextVal = SP_stepup(CurVal,X_Cord,Y_Cord)

global KWTransformersTypes TransTypes CurrentTr_x CurrentTr_y
global FinalTrans_x FinalTrans_y UtilizationFactor PowerFactor
Tag = find(KWTransformersTypes == CurVal);
if (Tag ~= TransTypes)
    if (isempty(find(CurrentTr_x==X_Cord)) & isempty(find(CurrentTr_y==Y_Cord))) %check if a new candidate!?
        NextVal = KWTransformersTypes(1,Tag+1);
    elseif (CurVal == KWTransformersTypes(1,5))   % if a 315kVA transformer
        NextVal = CurVal;
    else
        NextVal = KWTransformersTypes(1,Tag+1);
    end;
else
    NextVal = CurVal;
end;
