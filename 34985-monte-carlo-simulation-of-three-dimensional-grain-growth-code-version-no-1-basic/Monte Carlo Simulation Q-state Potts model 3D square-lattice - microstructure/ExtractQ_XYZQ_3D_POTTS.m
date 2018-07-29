function [xyzQ,stateindex] = ExtractQ_XYZQ_3D_POTTS(state,x,y,z,Q)

display('Extracting Q_[X, Y, Z] values')
xyzQ=cell(1,Q);
stateindex=xyzQ;
for q = 1:Q
    stateindex{1,q}=find(state(:,:,:)==q);
    xyzQ{1,q}=[];
    for count=1:prod(size(stateindex{1,q}))
        ElementRnCnPn(count,:)=FindPRC_3D_QPOTTS(stateindex{1,q}(count),state);
        xyzQ{1,q}=[xyzQ{1,q};...
            x(ElementRnCnPn(count,1),ElementRnCnPn(count,2),ElementRnCnPn(count,3)),...
            y(ElementRnCnPn(count,1),ElementRnCnPn(count,2),ElementRnCnPn(count,3)),...
            z(ElementRnCnPn(count,1),ElementRnCnPn(count,2),ElementRnCnPn(count,3))];
    end
end