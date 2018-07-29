function [ discdata,discvalues,discscheme ] = cacc(data)
    
    % Author: Julio Zaragoza
    % The University of Adelaide, Adelaide, South Australia
    %
    % This function follows the paper:
    % 'A Discretization Algorithm based on Class-Attribute Contingency Coefficient' (CACC), 
    % by Sheng-Jung Tsai, Shien-I Lee and Wei-Pang Yang, Information Sciences, Elsevier, 2008
    %
    % input:
    % data: a MxN matrix containing the data to be discretized where M is 
    %       the number of examples and N is the number of features 
    %       (including the class).    
    %
    %       Data should be organized as follows F1,F2,...,Fn-1,S (the last 
    %       column is taken as the class)
    
    % output:
    % discdata: a MxN matrix containing the discretized data (it can be 
    %           normalized or not normalized... check the end of this file).
    % discvalues: a Nx1 cell containing the possible values of each feature.
    % discscheme: a N-1x1 cell containing the discretization scheme (the
    %             boundaries for each feature).
    
    fprintf('cacc discretization...\n');
    
    % variables for storing the discretized data, values and 
    % the discretization scheme
    discdata = zeros(size(data));
    discvalues = cell([size(data,2) 1]);
    discscheme = cell([size(data,2)-1 1]);
    
    % s is the number of target classes of S (possible class values)
    s = unique(data(:,size(data,2)));
    
    % assume the maximum number of intervals is M*0.75 (there is no point in 
    % using an algorithm to discretize a dataset if the resulting discretized 
    % dataset contains a lot of possible values/intervals)
    maxnumintervals = floor(size(data,1)*0.75);
    
    % following the pseudo-code of the paper:
    % for each continuous attribute Ai
    for A = 1:size(data,2)-1 % (-1 because we are not discretizing the class)
        
        % find the maximum dn and the minimum d0 values of Ai
        d0 = min(data(:,A));
        dn = max(data(:,A));
        
        % form a set of all distinct values of A in ascending order
        distincvaluesA = sort(unique(data(:,A)));
        
        % calculate the midpoints of all the adjacent pairs in the set
        B = (distincvaluesA(1:length(distincvaluesA)-1)+distincvaluesA(2:length(distincvaluesA)))/2;
        
        % set the initial discretization scheme as D: {[d0,dn]} and globalcacc = 0;
        D = [d0 dn];
        globalcacc = 0;
        
        % initialize k = 1 (well... = 0 in this code), this is for helping 
        % the algorithm to stop once we have reached the maximum number of 
        % intervals
        k = 0;
        
        %for each inner boundary B which is not already in scheme D, Add it into D
        %   calculate the corresponding cacc value
        %   pick up the scheme D' with the highest cacc value:        
        for i=1:length(B)
            auxB = B;
            maxcacc = 0;
            while length(auxB) > 0
                if(auxB(1) == d0)                    
                    auxB(1) = [];
                    continue;
                end
                % add the boundary B which is not already in scheme D
                D = unique(sort([D, auxB(1)]));
                
                % calculate cacc value
                caccval = caccvalue(data(:,A), D, s, data(:,size(data,2)));
                
                % print acc value
                caccval 
                
                % pick up the scheme D' with the highest cacc value
                if(caccval > maxcacc)
                    Dprime = D;
                    maxcacc = caccval;
                    toremove = auxB(1);
                end
                % remove the boundary B (since we already tried with it)
                D=D(D~=auxB(1));
                auxB(1) = [];
            end
            
            % if cacc > globalcacc
            %    replace D with D', globalcacc = cacc:
            if maxcacc > globalcacc
                B = B(B~=toremove);
                D = Dprime;
                globalcacc = maxcacc;
                k = k + 1;
                if  k > maxnumintervals % if we have reached the maximun number 
                    break;              % of intervals we stop and continue with 
                end                     % the next attribute Ai+1
            end
        end
        
        % output the discretization scheme D' and discretized 
        % data with k intervals for continuous attribute Ai
        discscheme{A} = D;
        discdata(:,A) = discretizedata(data(:,A),D);
        discvalues{A} = unique(discdata(:,A));
    end
    discdata(:,size(data,2)) = data(:,size(data,2));
    discvalues{size(data,2)} = unique(discdata(:,size(data,2)));
end

function caccval = caccvalue(data, discscheme, s, c)
    M = size(data,1);
    
    % discretize the continuous data and compute the quanta matrix:
    
    % I decided not to call the 'discretizedata' function (at the end of this file)
    % and then compute the quanta matrix since that would require two for-
    % loops iterating over each instance on the dataset each one (one for 
    % discretizing the data in the 'discretizedata' function and another 
    % one for computing the quanta matrix).
    % I discovered that I could use only one for-loop to discretize the data and compute
    % the quanta matrix at the same time as follows:    
    discretizeddata = zeros(size(data,1),1);
    quantamatrix = zeros(length(s),length(discscheme)-1);
    for i = 1:size(data,1)
        for t = 2:length(discscheme)
           if data(i) <= discscheme(t)
               discretizeddata(i) = t-1; % discretize data
               break;
           end
        end
        % compute quanta matrix
        quantamatrix(c(i),discretizeddata(i)) = quantamatrix(c(i),discretizeddata(i)) + 1;
    end
    
    % compute y value by using the quanta matrix:
    y = 0;
    rowquantamatrix = sum(quantamatrix,2);
    columnquantamatrix = sum(quantamatrix,1);    
    for p = 1:length(s)
        for q = 1:length(discscheme)-1
           if rowquantamatrix(p) > 0 && columnquantamatrix(q) > 0
              y = y + (quantamatrix(p,q))^2 / (rowquantamatrix(p)*columnquantamatrix(q));
           end
        end
    end
    
    % compute y' value from y value:
    yprime = M*(y-1)/log(length(discscheme));
    
    % compute cacc value from y' value:
    caccval = sqrt(yprime/(yprime+M));
end

function discdata = discretizedata(data, discscheme) 
    % discretize the continuous data upon the 
    % discretization scheme, 
    % this function is called at the end of the cacc algorithm, when we
    % already have the 'final' discretization scheme
    discdata = zeros(size(data,1),1);
    for p = 1:size(data,1)
        for t = 2:length(discscheme)
           if data(p) <= discscheme(t)
               discdata(p) = t-1;
               break;
           end
        end
    end
       
    % normalize discrete data
    % i.e., if the discretized data 
    % for attribute Ai is e.g.: 1,9,13,15, 
    % 'normalize' these discrete values as 1,2,3,4:
    % (you can comment the next 4 lines of code if you
    % don't want this functionality):
    normvalues = sort(unique(discdata));
    for i = 1:length(normvalues)
        discdata(find(discdata==normvalues(i))) = i;
    end
end 
