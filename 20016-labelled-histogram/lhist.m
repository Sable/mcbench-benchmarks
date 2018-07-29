function [bm, b] = lhist(y,m,labels)
%LHIST labelled histogram.
%   [BM, B] = LHIST(Y,M,LABELS) plots the histogram for the elements in Y
%   grouping them in M bins. In addition, this function accounts for the
%   different elements that are present in each bin grouping them by
%   LABELS. The data for the stacked bar plot is returned in BM. The
%   handler for the plot is returned in B.
%
%   Example:
%       m=50;
%       y=gsamp(2,0.5,200);
%       labels=round(2*rand(200,1));
%       figure;
%       subplot(1,2,1); hist(y,m);
%       title('Normal histogram');
%       subplot(1,2,2); [bm, b] = lhist(y,m,labels);
%       title('Labelled histogram');
%
%   See also hist, bar.

if (size(y,1) == 1) y=y'; end % y becomes a vertical array
ly=length(y);

[n,x]=hist(y,m);
ym=repmat(y,1,m);   % columns are the data repeated for the M columns
xm=repmat(x,ly,1);  % rows are bin centres, repeated for each data (ly)
d=abs(ym-xm);       % distance matrix from each data to the centre of each bin

% we assign the data to the closest bin
for i=1:ly
    index=find(d(i,:)==min(d(i,:)));
    bin(i,1)=index(1);
end
[labels_set,objects_per_label]=grouplabels(labels);
ndlabels=length(labels_set);     % number of different labels

for i=1:m
    ind=find(bin==i);           % data index for each one of the bins
    labels_per_bin=labels(ind); % labels for the data assigned to the bin 'i'
    for j=1:ndlabels
        label=labels_set(j);
        bm(i,j)=numel(find(labels_per_bin==label)); % sized [m x ndlabels]
    end
end

% plots
b=bar(x,bm,'stacked');
%b=bar(x,bm,'grouped');
colormap(summer);
legend(b,num2str(labels_set));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [lset,nl]=grouplabels(l)
%GROUPLABELS presents the different set of labels and the number of
%objects for each label.
%   [LSET,NL] = GROUPLABELS(L) accounts for the identical labels in L and
%   presents the set of different labels in LSET in accordance on the
%   number of identical labels for each class (NL).

lset=[]; nl=[];
for i=1:length(l)
    current_label=l(i);
    if isempty(find(lset==current_label))
        lset=[lset; current_label];
        nl=[nl; length(find(l==current_label))];    
    end
end