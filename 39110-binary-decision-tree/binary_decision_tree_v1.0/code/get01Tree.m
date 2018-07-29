% This function performs the training at node k. 

% Copyright (C) 2012 Quan Wang <wangq10@rpi.edu>, 
% Signal Analysis and Machine Perception Laboratory, 
% Department of Electrical, Computer, and Systems Engineering, 
% Rensselaer Polytechnic Institute, Troy, NY 12180, USA
% 
% You are free to use this software for academic purposes if you cite our paper: 
% Q. Wang, Y. Ou, A.A. Julius, K.L. Boyer, M.J. Kim, 
% Tracking tetrahymena pyriformis cells using decision trees, 
% in: 2012 International Conference on Pattern Recognition, Tsukuba Science City, Japan.
% 
% For commercial use, please contact the authors. 

function T=get01Tree(k,T,X,label,Depth,Splits,MinNode)

% k: current working node
% T: current decision tree
% X: N*M training data matrix, each row is one sample
% label: N*1 labels of training data, each entry takes value 0 or 1
% Depth: maximal depth of decision tree
% Splits: number of candidate thresholds at each node
% MinNode: minimal size of a non-leaf node

[d c]=index2depth(k);

%% leaf node
if d==Depth
    T.leaf(c,1)=sum(1-label);
    T.leaf(c,2)=sum(label);
    if T.leaf(c,1)+T.leaf(c,2)==0
        T.leaf_prob(c)=-1;
        return;
    end
    T.leaf_prob(c)=T.leaf(c,2)/(T.leaf(c,1)+T.leaf(c,2));
    return
end

if max(size(label))==0
    T.feature(k)=-1;
    T.threshold(k)=Inf;
    T=get01Tree(left_child(k),T,[],[],Depth,Splits,MinNode);
    T=get01Tree(right_child(k),T,[],[],Depth,Splits,MinNode);
    return;
elseif max(size(label))<=MinNode
    T.feature(k)=1;
    T.threshold(k)=Inf;
    T=get01Tree(left_child(k),T,X,label,Depth,Splits,MinNode);
    T=get01Tree(right_child(k),T,[],[],Depth,Splits,MinNode);
    return;
end

%% non-leaf node
X_mu=mean(X);
X_sigma=std(X);
X_min=min(X);
X_max=max(X);
best_feature=1;
best_threshold=0;
best_entropyDecrease=0;
label_size=max(size(label));

for feature=1:size(X,2)
    lower_bound=max(X_min(feature),X_mu(feature)-3*X_sigma(feature));
    upper_bound=min(X_max(feature),X_mu(feature)+3*X_sigma(feature));
    thresholds=linspace(lower_bound,upper_bound,Splits+2);
    thresholds=thresholds(2:end-1);
    for split=1:Splits
        current_entropy=getEntropy(label);
        left_index=X(:,feature)<=thresholds(split);
        right_index=X(:,feature)>thresholds(split);
        
        if sum(left_index)==0
            left_label=[];
            thresholds(split)=-Inf;
        else
            left_label=label(left_index);      
        end
        
        if sum(right_index)==0
            right_label=[];
            thresholds(split)=Inf;
        else
            right_label=label(right_index); 
        end
         
        left_size=max(size(left_label));
        right_size=max(size(right_label));
        left_entropy=getEntropy(left_label);
        right_entropy=getEntropy(right_label);
        current_entropyDecrease=current_entropy...
            -left_entropy*left_size/label_size...
            -right_entropy*right_size/label_size;
        if feature==1 && split==1
            best_entropyDecrease=current_entropyDecrease;
            best_threshold=thresholds(split);
        elseif current_entropyDecrease>best_entropyDecrease
            best_feature=feature;
            best_entropyDecrease=current_entropyDecrease;
            best_threshold=thresholds(split);
        end
    end
end

T.feature(k)=best_feature;
T.threshold(k)=best_threshold;

left_index=X(:,best_feature)<=best_threshold;
right_index=X(:,best_feature)>best_threshold;

if sum(left_index)==0
    left_label=[];
    left_X=[];
else
    left_label=label(left_index);
    left_X=X(left_index,:);
end

if sum(right_index)==0
    right_label=[];
    right_X=[];
else
    right_label=label(right_index);
    right_X=X(right_index,:);
end

T=get01Tree(left_child(k),T,left_X,left_label,Depth,Splits,MinNode);

T=get01Tree(right_child(k),T,right_X,right_label,Depth,Splits,MinNode);




