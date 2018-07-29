% This is a function file: GeneratorCOPT(G,PR,A)
% This calculates the 'Outage Probability' for a single Power SGeneratorCOPTMatrixion
% G stands for number of generating unit
% PR stands for Power Ratings of each unit (in Array form)
% A stands for Availability of each unit (in Array form)
%
% 
% By: Abhishek Chakraborty
% email: abhishek.piku@gmail.com

function Generator_COPT(G,PR,A)
format short g
X=ff2n(G);
InitiationMatrix=[zeros(1,2^G);zeros(1,2^G);ones(1,2^G);zeros(1,2^G)];
GeneratorCOPTMatrixTemp=InitiationMatrix';
for j=1:2^G
for i=1:G
    if (X(j,i)==0)
        GeneratorCOPTMatrixTemp(j,1)=GeneratorCOPTMatrixTemp(j,1)+PR(i,1);
        GeneratorCOPTMatrixTemp(j,3)=GeneratorCOPTMatrixTemp(j,3)*A(i,1);    
    else
        GeneratorCOPTMatrixTemp(j,2)=GeneratorCOPTMatrixTemp(j,2)+PR(i,1);
        GeneratorCOPTMatrixTemp(j,3)=GeneratorCOPTMatrixTemp(j,3)*(1-A(i,1));
    end
end
end
TemporaryMatrix=GeneratorCOPTMatrixTemp;
for m=1:(2^G)
    for n=1:(2^G)
    if(GeneratorCOPTMatrixTemp(m,1)==GeneratorCOPTMatrixTemp(n,1)&& m~=n && n>m)
        GeneratorCOPTMatrixTemp(m,3)=GeneratorCOPTMatrixTemp(m,3)+GeneratorCOPTMatrixTemp(n,3);
    else end
    end
end
for m=1:2^G
    for n=1:2^G
        if(GeneratorCOPTMatrixTemp(m,1)==GeneratorCOPTMatrixTemp(n,1) && m<n && m~=n && GeneratorCOPTMatrixTemp(m,1)~=0)
            GeneratorCOPTMatrixTemp(n,:)=zeros;
        else end
    end
end
for m=1:1:((2^G)-1)
    for n=1:1:((2^G)-1)
    if (GeneratorCOPTMatrixTemp(n,1)<GeneratorCOPTMatrixTemp((n+1),1))
        temp1=GeneratorCOPTMatrixTemp(n,1);
        temp2=GeneratorCOPTMatrixTemp(n,2);
        temp3=GeneratorCOPTMatrixTemp(n,3);
        GeneratorCOPTMatrixTemp(n,1)=GeneratorCOPTMatrixTemp((n+1),1);
        GeneratorCOPTMatrixTemp(n,2)=GeneratorCOPTMatrixTemp((n+1),2);
        GeneratorCOPTMatrixTemp(n,3)=GeneratorCOPTMatrixTemp((n+1),3);
        GeneratorCOPTMatrixTemp((n+1),1)=temp1;
        GeneratorCOPTMatrixTemp((n+1),2)=temp2;
        GeneratorCOPTMatrixTemp((n+1),3)=temp3;
    end
    end
end
GeneratorCOPTMatrix=GeneratorCOPTMatrixTemp;
GeneratorCOPTMatrix(~any(GeneratorCOPTMatrixTemp,2),:)=[];
GeneratorCOPTMatrix;
c=length(GeneratorCOPTMatrix(:,1));
suma=0;
for i=c:-1:1
    suma=suma+GeneratorCOPTMatrix(i,3);
    GeneratorCOPTMatrix(i,4)=suma;
end
l=length(GeneratorCOPTMatrix(:,1));

fprintf('CAPACITY AVAILABLE\t\t CAPACITY UNAVAILABLE\t\t STATE PROBABILITY\t\t CUMULITIVE PROBABILITY\n');
fprintf('==========================================================================================================\n');
for i=1:c
    fprintf('\t\t%d\t\t                 %d\t\t                  %10.8f\t\t             %10.8f\t\t\n',GeneratorCOPTMatrix(i,1),GeneratorCOPTMatrix(i,2),GeneratorCOPTMatrix(i,3),GeneratorCOPTMatrix(i,4))
end
    