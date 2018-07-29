function LabelMat=ConstThresh(ImIn,Thresh)

%% Give the binary matrix of components over a constant threshold

LabelMat=ImIn;
LabelMat(LabelMat<Thresh)=0;
LabelMat(LabelMat>=Thresh)=1;
% LabelMat=bwlabel(LabelMat,8);
NPart=max(max(LabelMat));
for i=1:NPart
    [j,k]=find(LabelMat==i);
    linidx=sub2ind(size(LabelMat),j,k);
    if length(linidx)<3
        LabelMat(linidx)=0;
    end
    clear j k linidx;
end
% LabelMat=bwlabel(LabelMat,8);
% imagesc(LabelMat),
% for i=1:max(max(LabelMat))
%     [k,j]=find(LabelMat==i);
%     text(j(1),k(1),num2str(i),'color',[1,1,1],'FontWeight','bold')
%     clear i j
% end

return

