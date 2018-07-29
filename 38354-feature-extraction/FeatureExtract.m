function A=FeatureExtract(X_change,m_b,ClassNum,EachClassNum,TrainX)

%--------------------------------------------------------------------------
Sb_t=(X_change')*X_change;
%计算Sb_t的特征值和特征向量
[eigvec,eigval]=eig(Sb_t);
eigval=diag(eigval)';
[eigval,I]=sort(eigval);
eigval_Sb_t=fliplr(eigval);
eigvec_Sb_t=fliplr(eigvec(:,I));

% 提取前m_b个特征值和特征向量
eigval_Sb=eigval_Sb_t(:,1:m_b);
eigval_Sb=diag(eigval_Sb);
eigvec_Sb=X_change*eigvec_Sb_t(:,1:m_b);         %求投影矩阵
A=eigvec_Sb;
%for i=1:m_b
    %A(:,i)=orth(A(:,i));
    %A(:,i)=A(:,i)/norm(A(:,i));
%end