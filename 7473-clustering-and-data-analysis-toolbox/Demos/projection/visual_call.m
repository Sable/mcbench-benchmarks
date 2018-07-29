%Calling function of the visualization functions
close all
clear all
colors={'r.' 'gx' 'b+' 'ys' 'm.' 'c.' 'k.' 'r*' 'g*' 'b*' 'y*' 'm*' 'c*' 'k*' };
path(path,'..\..\FUZZCLUST')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Selecting the data set
wine=1;
iris=0;
wisc=0;

if wine
    load winedat.txt
    data=winedat(:,1:end-1);
    C=winedat(:,end);
end

if iris
    load iris
    data=iris(:,1:4);
    C=zeros(length(data),1);
    for i=1:3
        C(find(iris(:,4+i)==1))=i;
    end    
end
if wisc
   %Data preprocessing
    wisc=wk1read('wisconsin.wk1');
    NI=9;
    NT=length(wisc);
    data.X=[wisc(:,11) wisc(:,2:10)];
    data.X=sortrows(data.X,1);
    [I,J]=find(data.X(:,7)~=0);
    data.X=data.X(I,:);
    [I,J]=find(data.X(:,1)==2);
    data.X(I,1)=1;
    [I,J]=find(data.X(:,1)==4);
    data.X(I,1)=2;
    C=data.X(:,1);
    data=data.X(:,2:end); 
end    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
% %normalization of the data
data.X=data;
data=clust_normalize(data,'range');
%fuzzy c-means clustering 
param.m=2;
param.c=2;
param.val=1;
param.vis=0;
result=Kmeans(data,param);
result=validity(result,data,param);
%Assignment for classification
[d1,d2]=max(result.data.f');
Cc=[];
for i=1:param.c
    Ci=C(find(d2==i));
    dum1=hist(Ci,1:param.c);
    [dd1,dd2]=max(dum1);
    Cc(i)=dd2;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Principal Component Projection of the data and the cluster centers
param.q=2;
result = PCA(data,param,result); 
%visualization
figure(1)
clf
for i=1:max(C)
    index=find(C==i);
    err=(Cc(d2(index))~=i);
    eindex=find(err);
    misclass(i)=sum(err);
    plot(result.proj.P(index,1),result.proj.P(index,2),[colors{i}])
    hold on
    plot(result.proj.P(index(eindex),1),result.proj.P(index(eindex),2),'o')
    hold on
end 
    xlabel('y_1')
    ylabel('y_2')
    title('PCA projection')
%The error value of classification
perfclass=sum(misclass)/length(C)*100    
%    
plot(result.proj.vp(:,1),result.proj.vp(:,2),'r*');
%calculating realtion-indexes
result = samstr(data,result);
perf = [projeval(result,param) result.proj.e];
%
disp('Press any key.')
pause   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%SAMMON mapping

proj.P=result.proj.P;   %Sammon uses the output of PCA for initializing
param.alpha = 0.4;
param.max=100;

figure(2)
result = Sammon(proj,data,result,param)
%visualization
clf
for i=1:max(C)
    index=find(C==i);
    err=(Cc(d2(index))~=i);
    eindex=find(err);
    misclass(i)=sum(err);
    plot(result.proj.P(index,1),result.proj.P(index,2),[colors{i}] )
    hold on
    plot(result.proj.P(index(eindex),1),result.proj.P(index(eindex),2),'o')
    hold on
end    
    xlabel('y_1')
    ylabel('y_2')
    title('Conventional Sammon mapping')
%
plot(result.proj.vp(:,1),result.proj.vp(:,2),'r*');    
%calculating realtion-indexes
result = samstr(data,result);
perfs = [projeval(result,param) result.proj.e];
%
disp('Press any key.')
pause
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Modified fuzzy SAMMON mapping
  
proj.P=result.proj.P; %FuzSam uses the output of Sammon for initializing
param.alpha = 0.4;
param.max=100;

figure(3)
result=FuzSam(proj,result,param);

clf
for i=1:max(C)
    index=find(C==i);
    err=(Cc(d2(index))~=i);
    eindex=find(err);
    misclass(i)=sum(err);
    plot(result.proj.P(index,1),result.proj.P(index,2),[colors{i}] )
    hold on
    plot(result.proj.P(index(eindex),1),result.proj.P(index(eindex),2),'o')
    hold on
end    
    xlabel('y_1')
    ylabel('y_2')
    title('Fuzzy Sammon mapping')
    
plot(result.proj.vp(:,1),result.proj.vp(:,2),'r*')
%calculating realtion-indexes
result = samstr(data,result);
perff = [projeval(result,param) result.proj.e];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
perf
perfs
perff






