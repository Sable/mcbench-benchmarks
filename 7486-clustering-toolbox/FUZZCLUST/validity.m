function result = validity(result,data,param)
%validation of the clustering

N = size(result.data.f,1);
c = size(result.cluster.v,1);
n = size(result.cluster.v,2);
v = result.cluster.v;

if exist('param.m')==1, m = param.m;else m = 2;end;

if param.val==1
        %partition coefficient (PC)
        fm = (result.data.f).^m;
        PC = 1/N*sum(sum(fm));
        %classification entropy (CE)
        fm = (result.data.f).*log(result.data.f);
        CE = -1/N*sum(sum(fm));
     
     %results   
     result.validity.PC = PC;
     result.validity.CE = CE;   
        
        
        
 elseif param.val==2
        %partition index(SC)
        ni = sum(result.data.f);                        %calculate fuzzy cardinality
        si = sum(result.data.d.*result.data.f.^(m/2));  %calculate fuzzy variation
        pii=si./ni;
        mask = zeros(c,n,c);                            %calculate separation of clusters 
        for i = 1:c
            for j =1:c
                mask(j,:,i) = v(i,:);
            end
            dist(i) = sum(sum((mask(:,:,i) - v).^2));
        end
        s = dist;

        SC = sum(pii./s);

        %separation index (S)
        S = sum(pii)./(N*min(dist));

        %Xie and Beni's index (XB)
        XB = sum((sum(result.data.d.*result.data.f.^2))./(N*min(result.data.d)));
    %results    
    result.validity.SC = SC;
    result.validity.S = S;
    result.validity.XB = XB;    
        
        
        
elseif param.val==3
        %Dunn's index (DI)
        %%for identification of compact and well separated clusters
        [m,label] = min(result.data.d');%crisp clustering(Kmeans)

        for i = 1:c
           index=find(label == i);
           dat{i}=data.X(index,:);
           meret(i)= size(dat{i},1);
        end
        mindistmatrix =ones(c,c)*inf;
        mindistmatrix2 =ones(c,c)*inf;
        
        for cntrCurrentClust = 1:c
           for cntrOtherClust = (cntrCurrentClust+1):c
               for cntrCurrentPoints = 1:meret(cntrCurrentClust)
                   dd = min(sqrt(sum([(repmat(dat{cntrCurrentClust}(cntrCurrentPoints,:),meret(cntrOtherClust),1) ...
                   -dat{cntrOtherClust}).^2]')));
                                       %calculate distances for an alternative Dunn index 
                   dd2 = min(abs(result.data.d(cntrCurrentClust,:)-result.data.d(cntrOtherClust,:)));
                       
                   if mindistmatrix(cntrCurrentClust,cntrOtherClust) > dd
                      mindistmatrix(cntrCurrentClust,cntrOtherClust) = dd;
                   end
                   if mindistmatrix2(cntrCurrentClust,cntrOtherClust) > dd2
                      mindistmatrix2(cntrCurrentClust,cntrOtherClust) = dd2;
                   end
               end
            end
        end

        minimalDist = min(min(mindistmatrix));
        minimalDist2 = min(min(mindistmatrix2));
        
        maxDispersion = 0;
        for cntrCurrentClust = 1:c
            actualDispersion = 0;
            for cntrCurrentPoints1 = 1:meret(cntrCurrentClust)
              dd = max(sqrt(sum([(repmat(dat{cntrCurrentClust}(cntrCurrentPoints1,:),meret(cntrCurrentClust),1) ...
                           -dat{cntrCurrentClust}).^2]')));
              if actualDispersion < dd
                 actualDispersion = dd;
              end
              if maxDispersion < actualDispersion
               maxDispersion = actualDispersion;
              end
           end
        end

        DI = minimalDist/maxDispersion;
        %alternative Dunn index
        ADI = minimalDist2/maxDispersion;
    %results
    result.validity.DI = DI;
    result.validity.ADI = ADI;   
        
else
       %partition coefficient (PC)
        fm = (result.data.f).^m;
        PC = 1/N*sum(sum(fm));
        %classification entropy (CE)
        fm = (result.data.f).*log(result.data.f);
        CE = -1/N*sum(sum(fm)); 

     %results   
     result.validity.PC = PC;
     result.validity.CE = CE; 
end



