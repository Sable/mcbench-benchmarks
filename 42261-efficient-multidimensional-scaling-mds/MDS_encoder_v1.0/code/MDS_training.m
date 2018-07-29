% Copyright (C) 2013 Quan Wang <wangq10@rpi.edu>,
% Signal Analysis and Machine Perception Laboratory,
% Department of Electrical, Computer, and Systems Engineering,
% Rensselaer Polytechnic Institute, Troy, NY 12180, USA
%
% You are free to use this software for academic purposes if you cite our paper:
% Quan Wang and Kim L. Boyer.
% Feature Learning by Multidimensional Scaling and its Applications in Object Recognition.
% 2013 26th SIBGRAPI Conference on Graphics, Patterns and Images (Sibgrapi). IEEE, 2013.
%
% For commercial use, please contact the authors.


% The training of a MDS model.

function [X, total_cost]=MDS_training(Dist,d,iter,strategy,display_flag)
% Dist: distance matrix
% d: dimensionality of target space
% iter: max number of iterations
% strategy: the initialization strategy
%     0: random order (default)
%     1: largest-distance-first
%     2: smallest-distance-first
% display_flag: whether to display intermediate output
%     0: no display
%     1: display iteration
% X: resulting MDS codes
% total_cost: the raw stress in each iteration

if nargin==3
    strategy=0;
    display_flag=1;
elseif nargin==4
    display_flag=1;
end


epsilon=10^-6; % 10^-3
N=size(Dist,1);
X=zeros(N,d);
constraining_set=false(N,1); % which concepts have already been encoded
total_cost=zeros(iter+1,1);

options = optimset('Display', 'off', ...
    'Algorithm', {'levenberg-marquardt',0.01},'MaxIter',10,'MaxFunEvals',100);

%% most beginning: first two points
if display_flag~=0
    fprintf('Training: initialization\n');
end
switch strategy
    case 0 % random order
        i=mod(round(rand(1)*10^10),N-1)+1;
        while 1
            j=mod(round(rand(1)*10^10),N-1)+2;
            if j>i
                break;
            end
        end
        
    case 1 % largest-distance-first
        [V1, index1]=max(Dist);
        [~, index2]=max(V1);
        j=index2;
        i=index1(index2);
        if i<j % ensure i>=j
            temp=i;i=j;j=temp;
        end
    case 2 % smallest-distance-first
        temp=eye(N);
        Dist=Dist+temp*10^10;
        [V1, index1]=min(Dist);
        [~, index2]=min(V1);
        j=index2;
        i=index1(index2);
        if i<j % ensure i>=j
            temp=i;i=j;j=temp;
        end
    otherwise
        disp('Invalid strategy');
        return;
end
constraining_set([i j])=true;
X(j,1)=Dist(i,j);

%% first stage: adding points to constraining_set
count=2;
while sum(constraining_set)<N
    count=count+1;
    if mod(count,100)==0 && display_flag~=0
        fprintf('  point: %d\n',count);
    end
    
    k=get_interested_point(Dist,constraining_set,strategy);
    x=X(k,:);
    constraining_set_=constraining_set;
    constraining_set_(k)=false;
    constraining_set_find=find(constraining_set_);
    X_=X(constraining_set_find,:);
    V_dist=Dist(constraining_set_find,k);
    x=lsqnonlin(@(x)MDS_cost_vector(x,V_dist,X_),x,[],[],options);
    constraining_set(k)=true;
    X(k,:)=x;
end

%% second stage: adjusting for many iterations
for t=1:iter
    total_cost(t)=MDS_training_cost_total(X,Dist);
    if t>1 && abs(total_cost(t-1)-total_cost(t))/(total_cost(t)+eps)<epsilon
        total_cost(t+1:end)=total_cost(t);
        return;
    end
    if display_flag~=0
        fprintf('Training: iteration %d\n',t);
    end
    
    rand_order=randperm(N);
    count=0;
    for k=rand_order
        count=count+1;
        if mod(count,100)==0 && display_flag~=0
            fprintf('  point: %d\n',count);
        end
        
        x=X(k,:);
        constraining_set_find=[1:k-1 k+1:N];
        X_=X(constraining_set_find,:);
        V_dist=Dist(constraining_set_find,k);
        x=lsqnonlin(@(x)MDS_cost_vector(x,V_dist,X_),x,[],[],options);
        constraining_set(k)=true;
        X(k,:)=x;
    end
end

total_cost(iter+1)=MDS_training_cost_total(X,Dist);


