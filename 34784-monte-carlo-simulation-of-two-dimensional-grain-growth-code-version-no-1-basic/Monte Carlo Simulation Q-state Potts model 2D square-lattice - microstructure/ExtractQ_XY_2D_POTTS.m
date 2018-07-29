function [xyQ,stateindex] = ExtractQ_XY_2D_POTTS(state,x,y,Q)

display('Extracting Q_[X, Y] values')
xyQ=cell(1,Q);
stateindex=xyQ;
for q = 1:Q
    stateindex{1,q}=find(state(:,:)==q);
    xyQ{1,q}=[];
    for count=1:prod(size(stateindex{1,q}))
        ElementRnCn(count,:)=FindRC_2D_QPOTTS(stateindex{1,q}(count),state);
        xyQ{1,q}=[xyQ{1,q};...
            x(ElementRnCn(count,1),ElementRnCn(count,2)) y(ElementRnCn(count,1),ElementRnCn(count,2))];
    end
end