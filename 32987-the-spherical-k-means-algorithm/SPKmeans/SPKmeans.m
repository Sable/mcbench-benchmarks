%The spherical K-means algorithm
%(C) 2007-2011 Nguyen Xuan Vinh   
%Contact: vinh.nguyenx at gmail.com   or vinh.nguyen at monash.edu
%Reference: 
%   [1] Xuan Vinh Nguyen: Gene Clustering on the Unit Hypersphere with the 
%       Spherical K-Means Algorithm: Coping with Extremely Large Number of
%       Local Optima. BIOCOMP 2008: 226-233
%Usage: Clustering the data in to K cluster using the sperical K-means
%algorithm, return the best center, best objective and membership of each data point
%Empty cluster handling: split the biggest cluster
%Input: 
%       a: normalized data matrix (norm and mean); each row for one data
%       point; col for dimension (feature)
%       K: number of clusters
%       n_run: number of runs
%       pa: initialization method,   'rand' for random membership, 'seed'
%       for random seed, 'part' for random partition, otherwise choose the
%       first K data points as seeds.
%       x: initial center, optional
%Output:
%       best_x: best center
%       best_f: best objective
%       membership: best membership
%Example:
% data = [randn(100,3)+5;randn(100,3)+[5*ones(100,1) -5*ones(100,1) -5*ones(100,1)];  randn(100,3)-5;randn(100,3)+[-5*ones(100,1) 5*ones(100,1) 5*ones(100,1)]];
% X = normalize_norm(data); %norm normalize data
% [x,f,mem]=SPKmeans(X,4,10); 
% scatter3(data(:,1),data(:,2),data(:,3),4*ones(1,400),mem);title('Spherical K-means clustering');

function [best_x,best_f,best_membership,empty,loop]=SPKmeans(a,K,n_run,pa,x)
[n dim]=size(a);
empty=0;

if nargin<3 n_run=1;end;
if nargin<4 pa='part';end;
if nargin<5 x=zeros(K,dim);end;

best_f=-inf;
best_x=x;

for run=1:n_run
if nargin<4
    if pa=='rand'
        %random means initialization
        chosen=zeros(1,n);%prevent choosing the old ones
        for i=1:K
            tt=int16(rand(1,1)*(n-1)+1);
            while chosen(tt)==1 tt=int16(rand(1,1)*(n-1)+1);end;
            chosen(tt)=1;
            x(i,:)=a(tt,:);
        end
        
    elseif pa=='seed'  %generate seed with max distance from each other
        tt=int16(rand(1,1)*(n-1)+1);
        x(1,:)=a(tt,:);
        for i=2:K
            tt=int16(rand(1,1)*(n-1)+1);
            nearest=-inf;
            for j=1:i nearest=max(nearest,x(j,:)*a(tt,:)');end;
            while nearest>0.8
                tt=int16(rand(1,1)*(n-1)+1);
                nearest=-inf;
                for j=1:i nearest=max(nearest,x(j,:)*a(tt,:)');end;
            end;
            x(i,:)=a(tt,:);
        end
        
    elseif pa=='part'
        %random partitions initialization
        t=rand(1,n);
        t=int16(t*(K-1)+1);
        x=zeros(K,dim);
        for i=1:n
            x(t(i),:)=x(t(i),:)+a(i,:);
        end
        for i=1:K
            if x(i,:)>0 x(i,:)=x(i,:)/norm(x(i,:));
            else
                x(i,:)=a(int16(rand(1,1)*(n-1))+1,:);
            end
        end
        
    else
        %fixed means initialization
        for i=1:K
            x(i,:)=a(i,:);
        end
    end
else
     fprintf('Starting from a predifined seed\n');
end
    


membership=zeros(1,n);
obj=[];f_old=0;
diff=inf;moves=1;
loop=0;moves=1;

while diff>10^-(10)
% while moves>0

f=0;%objective
mem_num=zeros(1,K);  %number of points in each cluster
moves=0; %number of moves
b=zeros(K,dim); %sum of all point in a cluster

for i=1:n     %membership--------------------------------
    maxi=-inf;
    t=0;%membership indicator
    for l=1:K  %membership assignment
        temp=a(i,:)*x(l,:)';
        if temp>maxi
            maxi=temp;
            t=l;
        end
    end
    f=f+maxi;
    if membership(i)~=t moves=moves+1;end;
    membership(i)=t;
    mem_num(t)=mem_num(t)+1;
    b(t,:)=b(t,:)+a(i,:);
end

% f=f/n;
obj=[obj f];
for l=1:K     %center adjustment-------------------------------
    if mem_num(l)>0
        x(l,:)=b(l,:)/norm(b(l,:),2);
    else
        fprintf('Empty cluster encountered\n');
        empty=1;
        %search for the largest cluster
        big=0;maxi=0;
        for i=1:K
            if mem_num(i)>maxi maxi=mem_num(i);big=i;end
        end
        count=0;ii=1;
        while count<1:int16(mem_num(big)/2)
            if membership(ii)==big
                b(l,:)=b(l,:)+a(ii,:);
                b(big,:)=b(big,:)-a(ii,:);
                count=count+1;
            end
            ii=ii+1;
        end
        x(l,:)=b(l,:)/norm(b(l,:),2);
    end
end
diff=abs(f_old-f);
% moves;
f_old=f;loop=loop+1;

end %loop

if best_f<f
    best_f=f;
    best_x=x;
    best_membership=membership;
end

end
