function [data_mod, index_rem]=feat_sel_sim(data, measure, p)
%
% Feature selection method using similarity measure and fuzzy entroropy 
% measures based on the article:
%
% P. Luukka, (2011) Feature Selection Using Fuzzy Entropy Measures with
% Similarity Classifier, Expert Systems with Applications, 38, pp.
% 4600-4607
%
% Function call:
% [data_mod, index_rem]=feat_sel_sim(data, measure, p)
%
% OUTPUTS:
% data_mod      data without removed feature
% index_rem     index of removed feature in original data
%
%INPUTS:
% data          data matrix, contains class values
% measure       fuzzy entropy measure, either 'luca' or 'park' 
%               currently coded
% p             parameter of Lukasiewicz similarity measure
%               p in (0, \infty) as default p=1.
if nargin<3
   p=1;
end
if nargin<2
    measure='luca'
end

l=max(data(:,end));     % #-classes
m=size(data,1);         % #-samples
t=size(data,2)-1;       % #-features
dataold=data;
tmp=[];
% forming idealvec using arithmetic mean
idealvec=zeros(l,t);
for k=1:l
    idealvec_s(k,:)=mean(data(find(data(:,end)==k),1:t));
end


%scaling data between [0,1]
data_v=data(:,1:t);
data_c=data(:,t+1); %labels
mins_v = min(data_v);
Ones = ones(size(data_v));
data_v = data_v+Ones*diag(abs(mins_v));
for k=1:l
    tmp=[tmp;abs(mins_v)];
end
tmp;
idealvec_s = idealvec_s+tmp;
maxs_v = max(data_v);
data_v = data_v*diag(maxs_v.^(-1));
idealvec_s=idealvec_s./repmat(maxs_v,l,1);
data = [data_v, data_c];
% sample data
datalearn_s=data(:,1:t);

% similarities
sim=zeros(t,m,l);
for j=1:m
    for i=1:t
        for k=1:l
            sim(i,j,k)=(1-abs(idealvec_s(k,i)^p-datalearn_s(j,i))^p)^(1/p);
        end
    end
end


% reduce number of dimensions in sim
sim=reshape(sim,t,m*l)';

% possibility for two different entropy measures
if measure=='luca'
% moodifying zero and one values of the similarity values to work with 
% De Luca's entropy measure
    delta=1E-10;
    sim(find(sim==0))=delta;
    sim(find(sim==1))=1-delta;
    H=sum(-sim.*log(sim)-(1-sim).*log(1-sim));
    
elseif measure=='park'
    H=sum(sin(pi/2*sim)+sin(pi/2*(1-sim))-1);  
end

% find maximum feature
[i, index_rem]=max(H);

% removing feature from the data
data_mod=[dataold(:,1:index_rem-1) dataold(:,index_rem+1:end)];
j=1;

return
