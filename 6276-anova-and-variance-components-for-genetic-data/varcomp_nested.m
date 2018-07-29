function [vc_groups, vc_sgroups, vc_error, s2a, s2bca, s2, total_s2] = varcomp_nested(x, verbose)

% VARCOMP_NESTED(X) is a program that performs a nested 2 level ANOVA model II for 
% equal or unequal sample size and returns the variance ratio value (theta).
% Data should be of the form:
%
% 1	1	0
% 1	1	1
% 1	1	1
% 2	1	0
% 2	1	1
% 2	2	1
% .   .   .
% .   .   .
% .   .   .
% K   .   .
%
% Use the enclosed file "SOKAL106.DAT to check results.
%
% See also B. Weir's Genetic Data Analysis II (1995) for a discussion of the model and intrepretation.
% Teh first level corresponds to populations, and the second to sub-populations within populations.
%
% For genetic data, the input will be 0 or 1 for the observation of a given allele or nucleotide,
% in a locus per locus basis. Global values of the population parameter Theta can be averaged then,
% or better, the among variance components added and the ratio is performed just once.
%
% The argument "verbose = 1" will cause the ANOVA tables to be displaid
%
% Juan F. Fernandez-M. Université Paris Sud XI, Laboratoire ESE
% 
% please report bugs to juanffer@yahoo.com

if nargin==1
    verbose=0;
end

% groups
a = max(unique(x(:,1)));

% maximum number of subgroups
b = max(unique(x(:,2)));

% number of subgroups within each group
for i=1:a
   temp = unique(x(find( x(:,1)==i ), 2));
   nsg(i) = temp(end);
end

% number of mesurements within each subgroup
nij = [];
for i=1:a
    temp = x(find(x(:,1)==i),:);
    subgroups_id = unique(temp(:,2));
    for j=1:max(subgroups_id)
       n(i,j) =  size(find(temp(:,2)==j),1);
       nij    = [nij size(find(temp(:,2)==j),1)];
    end
end
n = sum(n');

%%% preliminary computations %%%

% Grand mean 
Y_mean = mean(mean(x(:,3)));

% per group mean
for i=1:a
    % extract group
    pg = find(x(:,1)==i);
    group = x(pg,:);
    Ya(i) = mean(group(:,3));
end

% sums of squares among groups
SSamong = 0;
for i=1:a
    SSamong = SSamong + n(i)*(Ya(i) - Y_mean).^2;
end

% sums of squares of subgroups within groups
SSsubgr = 0;
ctr = 1;
for i=1:a

    % extract group
    pg = find(x(:,1)==i);
    group = x(pg,:);

    for j=1:max(group(:,2))
        
        % extract subgroups
        psg = find(group(:,2)==j);
        subgroup = group(psg,:);
        % estimate sub groups means Yb and do summs of squares
        Yb(ctr) = mean(subgroup(:,end)); 
        SSsubgr = SSsubgr + nij(ctr)*( Yb(ctr) - Ya(i))^2;
        ctr = ctr + 1;
        
    end
    
end

% sums of squares within (error)
SSwithin = 0;
ctr = 1;
for i=1:a
    
    % extract group
    pg = find(x(:,1)==i);
    group = x(pg,:);
    
    for j=1:max(group(:,2))
        % extract subgroups
        psg = find(group(:,2)==j);
        subgroup = group(psg,3);
        SSwithin = SSwithin + sum((subgroup - Yb(ctr)).^2);
        ctr = ctr + 1;
    end
end

SStotal = SSamong + SSsubgr + SSwithin;
df_among = a-1;
df_subgr = sum(nsg) - df_among - 1;
df_total = sum(n) - 1;
df_error = df_total - df_among - df_subgr;

% estimates mean summs of squares
MSamong  = SSamong/df_among;
MSsubgr  = SSsubgr/df_subgr;
MSwithin = SSwithin/df_error;

% estimate F
Fgroups = MSamong/MSsubgr;
Fsubgr  = MSsubgr/MSwithin;

if verbose==1
    disp(' ');
    disp('Two-Level ANOVA table:')
    disp('----------------------------------------------------------------------------')
    disp('Source                      df       SS             MS             F')
    disp('----------------------------------------------------------------------------')
    disp(['Groups                   :  ', num2str([df_among SSamong MSamong Fgroups])])
    disp(['Subgroups (within groups):  ', num2str([df_subgr SSsubgr MSsubgr Fsubgr])])
    disp(['Within groups (error)    :  ', num2str([df_error SSwithin MSwithin])])
    disp(['Total                    :  ', num2str([df_total SStotal])])
    disp('----------------------------------------------------------------------------')
end

% estimate corrected sample sizes for additional tests
q1 = sum(nij);
q2 = sum(nij.^2);
q3 = sum(n.^2);
q4 = 0;
ctr = 1;
 for i=1:a 
    % extract group
    pg = find(x(:,1)==i);
    group = x(pg,:);
    temp = [];
    for j=1:max(group(:,2))
        % extract subgroups
        temp(j) = nij(ctr);
        ctr = ctr + 1;
    end  
    q4 = q4 + sum(temp.^2)/sum(temp);
end

npo = (q4 - (q2/q1) )/df_among;
no  = (q1 - q4)/df_subgr;
nbo = (q1 - q3/q1)/df_among;


% estimate variance components
s2    = MSwithin;
s2bca = (MSsubgr - MSwithin)/no;
s2a   = (MSamong - MSsubgr)/(nbo);
total_s2 = s2 + s2bca + s2a;

vc_groups  = s2a/total_s2;
vc_sgroups = s2bca/total_s2;
vc_error   = s2/total_s2;

if verbose==1
    disp('  ')
    disp('--------------------------------------------')
    disp('Variance Components:')
    disp('--------------------------------------------')
    disp(['VC among groups (Theta)         :  ', num2str(vc_groups) ] )
    disp(['VC among subrgoups within groups:  ', num2str(vc_sgroups)] )
    disp(['VC within subgroups (error)     :  ', num2str(vc_error)  ])
    disp('--------------------------------------------')
end
