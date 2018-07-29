function S=ParticleSize(S)

%% RC Moffet 2010
MatSiz=size(S.LabelMat);
XSiz=S.Xvalue/MatSiz(2);
YSiz=S.Yvalue/MatSiz(1);


for i=1:max(max(S.LabelMat))
    [j,k]=find(S.LabelMat==i);
    idx=sub2ind(size(S.LabelMat),j,k);
    PartSiz(i)=2*sqrt((length(idx)*(XSiz*YSiz))/pi); %% Area equiv diameter
    clear j k idx;
end
if exist('PartSiz')
S.Size=PartSiz;
else
    S.Size=[];
end