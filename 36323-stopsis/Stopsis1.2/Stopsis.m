function [CCS,Sstar,Sneg,Order]=Stopsis(WD,FDM,k,m,n,ideal,criteria,simi)
% Where for inputs:
% 
% WD: all importance weights
% FDM: decision matrix
% k: no of decision makers
% n: number of criterias
% ideal: which criteria you want to use to calculate FPIS and FNIS from three alternatives.
% criteria: information whether criteria is benefit or cost criteria given as a vector.
% simi: which similarity measure is chosen. Integer number, 4 possibilities coded. 
%
% for outputs:
% 
% CCS: closeness value when now similarity is used to calculate it.
% Sstar: Similarities w.r.t. attribute and FPIS.
% Sneg: Similarities w.r.t. attribute and NPIS.
% Order: alternatives 


%Weight aggregation
Wagg=aggregateW(WD,k,n);
%Next we calculate aggregated fuzzy decision matrix.
for i=1:m
    FDMA(i,:)=aggregateFDM(FDM,i,k,n);
end

%Forming normalized aggregated fuzzy decision matrix FDMN:

for j=1:n
    for i=1:m
        matrixB(i,j)=FDMA{i,j}(4);  %getting dij's
        matrixC(i,j)=FDMA{i,j}(1);  %getting aij's
    end
end


    dividerB=max(matrixB);   %dplus for benefit criterias 
    dividerC=min(matrixC);   %aminus for cost criterias


for i=1:m
    for j=1:n
        if criteria(j)==1
            FDMN{i,j}(1:4)=FDMA{i,j}(1:4)./dividerB(j);
        elseif criteria(j)==2
            FDMN{i,j}(1:4)=dividerC(j)./FDMA{i,j}(4:-1:1);
        end
    end
end

%Weighted normalized fuzzy decision matrix:

for i=1:m
    for j=1:n
        FDMNW{i,j}(1:4)=FDMN{i,j}(1:4).*Wagg(j,:);
    end
end

%Calculating  FPIS and FNIS, Here three possible choices are implemented.
%See [1.] for more information about them.

if ideal==1
    %First possible criteria for positive and negative ideal solutions:
    for i=1:m
        for j=1:n
            maxi(i,j)=FDMNW{i,j}(4);
            mini(i,j)=FDMNW{i,j}(1);
        end
    end
    FPIStmp=max(maxi);
    FNIStmp=min(mini);
    for i=1:n
        FPIS{i}(1:4)=FPIStmp(i)*ones(1,4);
        FNIS{i}(1:4)=FNIStmp(i)*ones(1,4);
    end
elseif ideal==2
    %Second possible criteria for positive and negative ideal solutions:
    for i=1:n
        FPIS{i}(1:4)=ones(1,4);
        FNIS{i}(1:4)=zeros(1,4);
    end
elseif ideal==3
%Third possible criteria for positive and negative ideal solutions:
    for j=1:n
        for i=1:m
            maxi2(i,:)=FDMNW{i,j}(1:4);
        end
        FPIS{j}(1:4)=max(maxi2);
        FNIS{j}(1:4)=min(maxi2);
    end
end

%Calculating fuzzy similarities between the weighted normalized decision matrix and FPIS:

for i=1:m
    Sstar(i,:)=fuzzsimveca(FDMNW(i,:),FPIS,n,simi);
end

%Aggregating over the criterias:
SstarAgg=sum(Sstar,2)/n;
Sstar=SstarAgg';

%Calculating fuzzy similarities between the weighted normalized decision matrix and FNIS:

for i=1:m
    Sneg(i,:)=fuzzsimveca(FDMNW(i,:),FNIS,n,simi);
end
SnegAgg=sum(Sneg,2)/n;
Sneg=SnegAgg';
%Closeness coefficient:
for i=1:m
    CCS(i)=SstarAgg(i)/(SstarAgg(i)+SnegAgg(i));
end
[Y,I]=sort(CCS,'descend');
%Order of the attributes (suppliers in the example):
Order=I';
