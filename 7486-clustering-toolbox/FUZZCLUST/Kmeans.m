function result=kmeans(data,param);

%checking the parameters given
%if exist('param.c') == 1, c = param.c;else error('Nincs megadva a c, es ez baj...');end;
%if exist('param.vis')~=1, param.vis=0;end;


%data normalization
data=clust_normalize(data,'range');

X=data.X;
[N,n]=size(X);

%initialization
if max(size(param.c))==1,
    c = param.c;
    index=randperm(N);
    v=X(index(1:c),:);v = v + 1e-10;
    v0=X(index(1:c)+1,:);v0 = v0 - 1e-10;
else
    v = param.c;    
    c = size(param.c,1);
    index=randperm(N);
    v0=X(index(1:c)+1,:);v0 = v0 + 1e-10;
end   
iter = 0;
while prod(max(abs(v - v0))),
    iter = iter +1;  
    v0 = v;
        %Calculating the distances
         for i = 1:c
            dist(:,i) = sum([(X - repmat(v(i,:),N,1)).^2],2);
        end
        %Assigning clusters
           [m,label] = min(dist');
           distout=sqrt(dist);
      
      %Calculating cluster centers
      for i = 1:c
         index=find(label == i);
         if ~isempty(index)  
             v(i,:) = mean(X(index,:));
         else 
             ind=round(rand*N-1);
             v(i,:)=X(ind,:);
         end   
         f0(index,i)=1;
     end
   J(iter) = sum(sum(f0.*dist));           %calculate objective function   
    if param.vis
       clf
       hold on
       plot(v(:,1),v(:,2),'ro')
       colors={'r.' 'gx' 'b+' 'ys' 'md' 'cv' 'k.' 'r*' 'g*' 'b*' 'y*' 'm*' 'c*' 'k*' };
       for i=1:c
           index = find(label == i);
           if ~isempty(index)  
            dat=X(index,:);
            plot(dat(:,1),dat(:,2),colors{i})
           end
       end    
       hold off
       pause(0.1)
   end  
    
end


%results
   
result.cluster.v = v;
result.data.d = distout;
   %calculate the partition matrix      
f0=zeros(N,c);
for i=1:c
  index=find(label == i);
  f0(index,i)=1;
end       
result.data.f=f0;
result.iter = iter;
result.cost = J;