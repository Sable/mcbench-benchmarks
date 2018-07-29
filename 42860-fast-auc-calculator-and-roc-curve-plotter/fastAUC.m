function [auc,fpr,tpr] = fastAUC(labels,scores,plot_flag)
% function [auc,fpr,tpr] = myauc(labels,scores,plot_flag)
%
% This function calculates m AUC values for m ranked lists.
% n is the number of ranked items. 
% m is the number of different rankings.
%
% Input:  labels is nXm binary logical.
%         scores is nXm real. For a high AUC the higher scores should have
%         labels==1.
%         plot_flag: binary flag, if TRUE then m ROC curves will be plotted
%         (default FALSE).
%
% Output: auc is mX1 real, the Area Under the ROC curves.
%         fpr is nXm real, the false positive rates.
%         tpr is nXm real, the true positive rates.

if ~exist('plot_flag','var')
    plot_flag = 0;
end
if ~islogical(labels)
    error('labels input should be logical');
end
if ~isequal(size(labels),size(scores))
    error('labels and scores should have the same size');
end
[n,m] = size(labels);
num_pos = sum(labels);
if any(num_pos==0)
    error('no positive labels entered');
end
if any(num_pos==n)
    error('no negative labels entered');
end

[~,scores_si] = sort(scores,'descend');
clear scores
scores_si_reindex = scores_si+ones(n,1)*(0:m-1)*n;
l = labels(scores_si_reindex);
clear scores_si labels 

tp = cumsum(l==1,1);
fp = repmat((1:n)',[1 m])-tp;

num_neg = n-num_pos;
fpr = bsxfun(@rdivide,fp,num_neg); %False Positive Rate
tpr = bsxfun(@rdivide,tp,num_pos); %True Positive Rate

%Plot the ROC curve
if plot_flag==1
    plot(fpr,tpr);
    xlabel('False Positive');
    ylabel('True Positive');
end

auc = sum(tpr.*[(diff(fp)==1); zeros(1,m)])./num_neg;


