function [I_Cx, I_Cxx, I_xx, H_x, H_xx, H_C] = Fuzzy_MI(data)
% Fuzzy Mutual Information and Fuzzy Entropy
% Measure the mutual information between output classes and input variables
% as well as fuzzy entropy of individual classes
%
% Input:
%          data: input veriables (No. of patterns x No. of variables + 1). Last coloumn represents the class label
% Output
%          I_Cx : Fuzzy mutual information between each feature, or variable,
%                 stored as column and the corresponding class label.
%          I_Cxx: Fuzzy mutual information between each two variables and
%                 the class label (sparse)
%          I_xx : Fuzzy mutual information between each two variables (sparse)
%          H_x  : Fuzzy entropy (marginal entropies) of each individual feature
%          H_xx : Fuzzy entropy (joint entropy) of each two features
%                 together (sparse)
%          H_C  : Entropy of class
% Example-1:
% >> load iris.dat
% >> [I_Cx, I_Cxx, I_xx, H_x, H_xx, H_C] = Fuzzy_MI(iris)
% 
% Example-2: if two features are completely redundant then 
% I_xx(f1,f2) = H_x(f1) = H_x(f2)
% Lets prove it
% >> load iris.dat
% >> iris =[iris(:,1:4) iris(:,4) iris(:,5)];
% >> [I_Cx, I_Cxx, I_xx, H_x, H_xx, H_C] = Fuzzy_MI(iris)

% References:
% [1] R. N. Khushaba, A. Al-Jumaily, and A. Al-Ani, ?Novel Feature Extraction Method based on Fuzzy Entropy and Wavelet Packet Transform for Myoelectric Control?, 7th International Symposium on Communications and Information Technologies ISCIT2007, Sydney, Australia, pp. 352 ? 357.
% [2] R. N. Khushaba, S. Kodagoa, S. Lal, and G. Dissanayake, ?Driver Drowsiness Classification Using Fuzzy Wavelet Packet Based Feature Extraction Algorithm?, IEEE Transaction on Biomedical Engineering, vol. 58, no. 1, pp. 121-131, 2011.
% 
% Fuzzy MI code by Dr. Rami Khushaba
% Research Fellow - Faculty of Engineering and IT
% University of Technology, Sydney.
% URL: www.rami-khushaba.com
% First modified 07/09/2009
% Second Modification 30/08/2011 by Dr. Rami Khushaba & Dr. Ahmed Al-Ani - UTS
% Third modification 13/03/2012 by Dr. Rami Khushaba
% Final modification 13/09/2013by Dr. Rami Khushaba (estimation should be
% more accurate now)

data(:,end) = grp2idx(data(:,end));
NC = max(data(:,end));
NF = size(data,2) - 1;
NP = size(data,1);

R = NC;
data1 = mapstd(data(:,1:NF)',0,1);
data(:,1:NF) = data1';
clear data1

H_x = zeros(1,NF);
H_xx = zeros(NF,NF);
I_xx = zeros(NF,NF);
I_Cx = zeros(1,NF);
I_Cxx = zeros(NF,NF);
Ps_x = zeros(NC,NF);
Ps_Cx = zeros(NC,NC);
U = zeros(NC,NP,NF);
Pr_C = zeros(1,NC);
%% Compute the entropy of the class label
for k=1:NC,
    Pr_C(k) = length(find(data(:,end)==k))/NP;
end
H_C = -sum(Pr_C.*log(Pr_C));    % entropy of class label

%%
C = MeanClust(data);            % Mean of the different classes
expo = 1.152;                    % fuzzifier
for i=1:NF
    distA = ((Rdistfcm(C(:,i), data(:,i))+eps));               % fill the distance matrix
    %distA = distA./(ones(NP,1)*var(distA,0,2)')';
    U_new = ((distA).^(-2/(expo-1)));
    U_new = U_new./(ones(NC, 1)*sum(U_new));
    x1 = size(U_new,1);
    U(1:x1,:,i) = U_new;
    temp = (U_new*U_new')/NP;clear U_new;
    temp = temp(temp>0);
    H_x(i) = -sum(temp.*log(temp));
%     Ps_x(:,i) = temp';
    for j=1:NC
        matC = repmat(data(:,end)==j,1,R);
        Ps_Cx(:,:,j)= ((U(:,:,i)'.*matC)'*(U(:,:,i)'.*matC))/NP;
    end
    temp = Ps_Cx(Ps_Cx>0);
    H_Cx = -sum(temp.*log(temp));
    I_Cx(i) = H_x(i) + H_C - H_Cx;
end

tempC = zeros(NC,R,R);

for n=1:NF-1,
    for m=n+1:NF,
        xxa = double(shiftdim(U(:,:,n)));
        xxb = double(shiftdim(U(:,:,m)));
        temp = (xxa*xxb')/NP;
        temp = temp(temp>0);
        H_xx(n,m) = -sum(temp.*log(temp));
        I_xx(n,m) = H_x(n) + H_x(m) - H_xx(n,m);
        for k=1:NC,
            matC = repmat(data(:,end)==k,1,R);
            tempC(k,:,:) = ((xxa'.*matC)'*(xxb'.*matC))/NP;
        end
        temp = tempC(tempC>0);
        H_Cxx = -sum(temp.*log(temp));
        I_Cxx(n,m) = H_xx(n,m) + H_C - H_Cxx;
    end
end
% [i,j,s] = find(I_xx);
% I_xx = sparse(i,j,s);
% 
% [i,j,s] = find(H_xx);
% H_xx = sparse(i,j,s);
% 
% 
% [i,j,s] = find(I_Cxx);
% I_Cxx = sparse(i,j,s);


%%
function center = MeanClust(data)
M = max(data(:,end));
center =zeros(M,size(data,2)-1);
for i = 1:M
    classs = data(data(:,end)==i,1 :end-1);
    if size(classs,1)>1
        center(i,:) = mean(classs);
    else
        center(i,:) = classs;
    end
end

%%
function out = Rdistfcm(center, data)


out = zeros(size(center, 1), size(data, 1));

% fill the output matrix

if size(center, 2) > 1,
    for k = 1:size(center, 1),
        out(k, :) = sqrt(sum((((data-ones(size(data, 1), 1)*center(k, :)).^2)')./var(data)));
    end
else    % 1-D data
    for k = 1:size(center, 1),
        out(k, :) = abs((center(k)-data)./var(data))';
    end
end

%% Previous code for reference
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % function [I_Cx, I_Cxx, I_xx, H_x, H_xx, H_C] = Fuzzy_MI(data)
% % Fuzzy Mutual Information and Fuzzy Entropy
% % Measure the mutual information between output classes and input variables
% % as well as fuzzy entropy of individual classes
% %
% % Input:
% %          data: input veriables (No. of patterns x No. of variables + 1). Last coloumn represents the class label
% % Output
% %          I_Cx : Fuzzy mutual information between each feature, or variable,
% %                 stored as column and the corresponding class label.
% %          I_Cxx: Fuzzy mutual information between each two variables and
% %                 the class label (sparse)
% %          I_xx : Fuzzy mutual information between each two variables (sparse)
% %          H_x  : Fuzzy entropy (marginal entropies) of each individual feature
% %          H_xx : Fuzzy entropy (joint entropy) of each two features
% %                 together (sparse)
% %          H_C  : Entropy of class
% % Example-1:
% % >> load iris.dat
% % >> [I_Cx, I_Cxx, I_xx, H_x, H_xx, H_C] = Fuzzy_MI(iris)
% % 
% % Example-2: if two features are completely redundant then 
% % I_xx(f1,f2) = H_x(f1) = H_x(f2)
% % Lets prove it
% % >> load iris.dat
% % >> iris =[iris(:,1:4) iris(:,4) iris(:,5)];
% % >> [I_Cx, I_Cxx, I_xx, H_x, H_xx, H_C] = Fuzzy_MI(iris)
% 
% % References:
% % [1] R. N. Khushaba, A. Al-Jumaily, and A. Al-Ani, ?Novel Feature Extraction Method based on Fuzzy Entropy and Wavelet Packet Transform for Myoelectric Control?, 7th International Symposium on Communications and Information Technologies ISCIT2007, Sydney, Australia, pp. 352 ? 357.
% % [2] R. N. Khushaba, S. Kodagoa, S. Lal, and G. Dissanayake, ?Driver Drowsiness Classification Using Fuzzy Wavelet Packet Based Feature Extraction Algorithm?, IEEE Transaction on Biomedical Engineering, vol. 58, no. 1, pp. 121-131, 2011.
% % 
% % Fuzzy MI code by Dr. Rami Khushaba
% % Research Fellow - Faculty of Engineering and IT
% % University of Technology, Sydney.
% % URL: www.rami-khushaba.com
% % First modified 07/09/2009
% % Second Modification 30/08/2011 by Dr. Rami Khushaba & Dr. Ahmed Al-Ani - UTS
% % Third modification 13/03/2012 by Dr. Rami Khushaba
% 
% data(:,end) = grp2idx(data(:,end));
% NC = max(data(:,end));
% NF = size(data,2) - 1;
% NP = size(data,1);
% 
% R = NC;
% data1 = mapstd(data(:,1:NF)',0,1);
% data(:,1:NF) = data1';
% clear data1
% 
% H_x = zeros(1,NF);
% H_xx = zeros(NF,NF);
% I_xx = zeros(NF,NF);
% I_Cx = zeros(1,NF);
% I_Cxx = zeros(NF,NF);
% Ps_x = zeros(NC,NF);
% Ps_Cx = zeros(NC,NC);
% U = zeros(NC,NP,NF);
% Pr_C = zeros(1,NC);
% %% Compute the entropy of the class label
% for k=1:NC,
%     Pr_C(k) = length(find(data(:,end)==k))/NP;
% end
% H_C = -sum(Pr_C.*log(Pr_C));    % entropy of class label
% 
% %%
% C = MeanClust(data);            % Mean of the different classes
% expo = 1.52;                    % fuzzifier
% for i=1:NF
%     distA = ((distfcm(C(:,i), data(:,i))+eps));               % fill the distance matrix
%     distA = distA./(ones(NP,1)*var(distA,0,2)')';
%     U_new = ((distA./((ones(NP,1)*max(distA,[],2)')')+eps).^(-2/(expo-1)));
%     U_new = U_new./(ones(NC, 1)*sum(U_new));
%     x1 = size(U_new,1);
%     U(1:x1,:,i) = U_new;
%     temp = sqrt(U_new*U_new')/NP;clear U_new;
%     temp = temp(temp>0);
%     H_x(i) = -sum(temp.*log(temp));
% %     Ps_x(:,i) = temp';
%     for j=1:NC
%         matC = repmat(data(:,end)==j,1,R);
%         Ps_Cx(:,:,j)= sqrt((U(:,:,i)'.*matC)'*(U(:,:,i)'.*matC))/NP;
%     end
%     temp = Ps_Cx(Ps_Cx>0);
%     H_Cx = -sum(temp.*log(temp));
%     I_Cx(i) = H_x(i) + H_C - H_Cx;
% end
% 
% tempC = zeros(NC,R,R);
% 
% for n=1:NF-1,
%     for m=n+1:NF,
%         xxa = double(shiftdim(U(:,:,n)));
%         xxb = double(shiftdim(U(:,:,m)));
%         temp = sqrt(xxa*xxb')/NP;
%         temp = temp(temp>0);
%         H_xx(n,m) = -sum(temp.*log(temp));
%         I_xx(n,m) = H_x(n) + H_x(m) - H_xx(n,m);
%         for k=1:NC,
%             matC = repmat(data(:,end)==k,1,R);
%             tempC(k,:,:) = sqrt((xxa'.*matC)'*(xxb'.*matC))/NP;
%         end
%         temp = tempC(tempC>0);
%         H_Cxx = -sum(temp.*log(temp));
%         I_Cxx(n,m) = H_xx(n,m) + H_C - H_Cxx;
%     end
% end
% [i,j,s] = find(I_xx);
% I_xx = sparse(i,j,s);
% 
% [i,j,s] = find(H_xx);
% H_xx = sparse(i,j,s);
% 
% 
% [i,j,s] = find(I_Cxx);
% I_Cxx = sparse(i,j,s);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% old version of I_xx and I_Cxx for further enhancements
% for n=1:NF-1,
%     for m=n+1:NF,
%         distA = ((distfcm(C(:,[n m]), data(:,[n m]))+eps));
%         distA = distA./(ones(NP,1)*var(distA,0,2)')';               % fill the distance matrix
%         U_new = ((distA./((ones(NP,1)*max(distA,[],2)')')+eps).^(-2/(expo-1)));
%         U_new = U_new./(ones(NC, 1)*sum(U_new));
%         temp = sum(U_new,2)/NP;
%         temp = temp(temp>0);
%         H_xx(n,m) = -sum(temp.*log(temp));
%         I_xx(n,m) = H_x(n) + H_x(m) - H_xx(n,m);
%         for k=1:NC,
%             tempC(k,:)= sum(U_new' .*repmat(data(:,end)==k,1,NC))./NP;
%         end
%         temp = tempC(tempC>0);
%         H_Cxx = -sum(temp.*log(temp));
%         I_Cxx(n,m) = H_xx(n,m) + H_C - H_Cxx;
%     end
% end
% % % % function [I_Cx, I_Cxx, I_xx, H_x, H_xx, H_C] = Fuzzy_MI(data)
% % % % % Fuzzy Mutual Information and Fuzzy Entropy
% % % % % Measure the mutual information between output classes and input variables
% % % % % as well as fuzzy entropy of individual classes
% % % % %
% % % % % Input:
% % % % %          data: input veriables (No. of patterns x No. of variables + 1). Last coloumn represents the class label
% % % % % Output
% % % % %          I_Cx : Fuzzy mutual information between each feature, or variable,
% % % % %                 stored as column and the corresponding class label.
% % % % %          I_Cxx: Fuzzy mutual information between each two variables and
% % % % %                 the class label (sparse)
% % % % %          I_xx : Fuzzy mutual information between each two variables (sparse)
% % % % %          H_x  : Fuzzy entropy (marginal entropies) of each individual feature
% % % % %          H_xx : Fuzzy entropy (joint entropy) of each two features
% % % % %                 together (sparse)
% % % % %          H_C  : Entropy of class
% % % % % Example:
% % % % % >> load iris.dat
% % % % % >> [I_Cx, I_Cxx, I_xx, H_x, H_xx, H_C] = Fuzzy_MI(iris)
% % % % % 
% % % % % Fuzzy MI code by Dr. Rami Khushaba
% % % % % Research Fellow - Faculty of Engineering and IT
% % % % % University of Technology, Sydney.
% % % % % URL: www.rami-khushaba.com
% % % % % Last modified 07/09/2009
% % % % 
% % % % 
% % % % data(:,end) = grp2idx(data(:,end));
% % % % NC = max(data(:,end));
% % % % NF = size(data,2) - 1;
% % % % NP = size(data,1);
% % % % 
% % % % R = NC;
% % % % data1 = mapstd(data(:,1:NF)',0,1);
% % % % data(:,1:NF) = data1';
% % % % clear data1
% % % % 
% % % % H_x = zeros(1,NF);
% % % % H_xx = zeros(NF,NF);
% % % % I_xx = zeros(NF,NF);
% % % % I_Cx = zeros(1,NF);
% % % % I_Cxx = zeros(NF,NF);
% % % % Ps_x = zeros(NC,NF);
% % % % Ps_Cx = zeros(NC,NC);
% % % % U = zeros(NC,NP,NF);
% % % % Pr_C = zeros(1,NC);
% % % % %% Compute the entropy of the class label
% % % % for k=1:NC,
% % % %     Pr_C(k) = length(find(data(:,end)==k))/NP;
% % % % end
% % % % H_C = -sum(Pr_C.*log(Pr_C));    % entropy of class label
% % % % 
% % % % %%
% % % % C = MeanClust(data);            % Mean of the different classes
% % % % expo = 1.52;                    % fuzzifier
% % % % for i=1:NF
% % % %     distA = ((distfcm(C(:,i), data(:,i))+eps));               % fill the distance matrix
% % % %     distA = distA./(ones(NP,1)*var(distA,0,2)')';
% % % %     U_new = ((distA./((ones(NP,1)*max(distA,[],2)')')+eps).^(-2/(expo-1)));
% % % %     U_new = U_new./(ones(NC, 1)*sum(U_new));
% % % %     x1 = size(U_new,1);
% % % %     U(1:x1,:,i) = U_new;
% % % %     temp = sum(U_new,2)/NP;clear U_new;
% % % %     temp = temp(temp>0);
% % % %     H_x(i) = -sum(temp.*log(temp));
% % % %     Ps_x(:,i) = temp';
% % % %     for j=1:NC
% % % %         Ps_Cx(j,:)= sum(U(:,:,i)' .*repmat(data(:,end)==j,1,NC))./NP;
% % % %     end
% % % %     temp = Ps_Cx(Ps_Cx>0);
% % % %     H_Cx = -sum(temp.*log(temp));
% % % %     I_Cx(i) = H_x(i) + H_C - H_Cx;
% % % % end
% % % % 
% % % % tempC = zeros(NC,R);
% % % % 
% % % % for n=1:NF-1,
% % % %     for m=n+1:NF,
% % % %         distA = ((distfcm(C(:,[n m]), data(:,[n m]))+eps));
% % % %         distA = distA./(ones(NP,1)*var(distA,0,2)')';               % fill the distance matrix
% % % %         U_new = ((distA./((ones(NP,1)*max(distA,[],2)')')+eps).^(-2/(expo-1)));
% % % %         U_new = U_new./(ones(NC, 1)*sum(U_new));
% % % %         temp = sum(U_new,2)/NP;
% % % %         temp = temp(temp>0);
% % % %         H_xx(n,m) = -sum(temp.*log(temp));
% % % %         I_xx(n,m) = H_x(n) + H_x(m) - H_xx(n,m);
% % % %         for k=1:NC,
% % % %             tempC(k,:)= sum(U_new' .*repmat(data(:,end)==k,1,NC))./NP;
% % % %         end
% % % %         temp = tempC(tempC>0);
% % % %         H_Cxx = -sum(temp.*log(temp));
% % % %         I_Cxx(n,m) = H_xx(n,m) + H_C - H_Cxx;
% % % %     end
% % % % end
% % % % [i,j,s] = find(I_xx);
% % % % I_xx = sparse(i,j,s);
% % % % 
% % % % [i,j,s] = find(H_xx);
% % % % H_xx = sparse(i,j,s);
% % % % 
% % % % 
% % % % [i,j,s] = find(I_Cxx);
% % % % I_Cxx = sparse(i,j,s);
% % % % 
% % % % 
% % % % %%
% % % % function center = MeanClust(data)
% % % % M = max(data(:,end));
% % % % center =zeros(M,size(data,2)-1);
% % % % for i = 1:M
% % % %     classs = data(data(:,end)==i,1 :end-1);
% % % %     if size(classs,1)>1
% % % %         center(i,:) = mean(classs);
% % % %     else
% % % %         center(i,:) = classs;
% % % %     end
% % % % end