%This function was developed by Oswaldo Ludwig. The arguments are the
%desired number of selected features (feat_numb), the matrix X, where each
%column is a feature vector example, and their respective target data y,
%which is a line vector. The output is a vector with the indexes of the 
%features that composes the optimum set of features.


function [Selected]=GA_feature_selector(feat_numb,X,y)

%Parameters:
c=1;
max_generations=80;
indiv=200*feat_numb;
pressao=6;
elit=1;
hold
S_max=-2e20;
S_min=2e20;
[Hx,Hy,MIxy,MIxx]=statistics(X,y);
[L,C]=size(MIxx);
if feat_numb<=L
%starting genes:
Popul=round((L-1)*rand(feat_numb,indiv))+1;
Sh=[0];
Sh2=[0.05];
%**************************************************************************
%Loop over the generations:
%**************************************************************************
generation=0;
while and(generation<=max_generations,abs(Sh(end)-Sh2(end))>0.002)
    generation=generation+1;
    %ranking:
    S=zeros(1,indiv);
    for k=1:indiv
        Xind=Popul(:,k);
        %relevance:
        mean_MIxy=0;
        for n=1:feat_numb
            mean_MIxy=mean_MIxy+MIxy(Xind(n));
        end
        mean_MIxy=mean_MIxy/feat_numb;
        %redundancy:
        mean_MIxx=0;
        for n=1:feat_numb
            for m=1:feat_numb
                mean_MIxx=mean_MIxx+MIxx(Xind(n),Xind(m));
            end
        end
        mean_MIxx=(mean_MIxx-feat_numb)/(feat_numb^2-feat_numb);
        %fitness:
        S(k)=mean_MIxy-c*mean_MIxx;
        if S(k)>S_max
            S_max=S(k);
        end
        if S(k)<S_min
            S_min=S(k);
        end
    end
    Sh=[Sh,mean(S)];
    Sh2=[Sh2,max(S)];
    title(['Fitness function S=',num2str(max(S))])
    xlabel(['generation=',num2str(generation)])
    plot(Sh(2:end))
    pause(0.001)
    %Rearranging the population according to their fitness:
    Popul_rearranged=Popul;
    for k=1:indiv
        [m,pos]=max(S);
        Popul_rearranged(:,k)=Popul(:,pos);
        S(pos)=-1e10;
    end
    if not(generation==1)
        Selected=Popul_rearranged(:,1);
    end
    %crossover:
    for k=1:indiv
    r=rand;
    pai=round((indiv-1)*(exp(pressao*r)-1)/(exp(pressao)-1))+1;
    r=rand;
    mae=round((indiv-1)*(exp(pressao*r)-1)/(exp(pressao)-1))+1;
    nf=1;
        for n=1:feat_numb
            r=round(rand);
            if r>0
                Popul(n,k)=Popul_rearranged(n,pai);
            else
                Popul(n,k)=Popul_rearranged(n,mae);
            end
        end
        %Verifying not used features:
        nuf=[];
        for n=1:L
            flag=1;
            for m=1:feat_numb
                if Popul(m,k)==n
                    flag=0;
                end
            end
            if flag==1
                nuf=[nuf,n];
            end
        end
        nf_max=max(size(nuf));
        %Verifying reapeated features and features without entropy:
        for n=1:feat_numb
            if Hx(Popul(n,k))==0
                if nf>nf_max
                    'It is not possible to select that number of features because there are features with nule entropy'
                end
                Popul(n,k)=nuf(nf);
                nf=nf+1;
            end
            if n>1
                for m=1:n-1
                    if Popul(m,k)==Popul(n,k)
                        if nf>nf_max
                            'It is not possible to select that number of features because there are features with nule entropy'
                        end
                        Popul(n,k)=nuf(nf);
                        nf=nf+1;
                    end
                end
            end
        end
    end
    if not(generation==1)
        if elit==1
            Popul(:,8)=Selected;
        end
    end
end
else
    'The number of selected features must be smallest than the total number of features'
end
hold off