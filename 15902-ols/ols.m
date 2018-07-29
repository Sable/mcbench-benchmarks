function [x, ind, r_act, A_o, x_o] = ols(A,b,r,threshold)
% OLS   Orthogonal Least Quares.
% 
% [x, ind] = OLS(A,b,r) gives the solution to the least squares problem 
% using only the best r regressors chosen from the ones present in matrix A. 
% This function also returns in the vector ind the indexes of the
% best r regressors (i.e., the best columns of A to use).
%
% If r is equal to n, the solution x given by OLS is the same as the solution 
% given by A\b, but in ind we still have the regressors sorted by their 
% importance. % This means that one can perform a feature selection by taking 
% the first k entries in ind (k<r).
% 
% THEORETICAL BACKGROUND
% Let us consider the Linear Least Squares Problem:
% 
%      min   (A*x-b)'*(A*x-b)
% 
% where A is a m-by-n matrix, b an m-dimentional vector and x, the unknown, 
% an n-dimentional vector. The problem is well posed when m>n. 
% A can be viewed as a set of columns, usually called regressors, while b typically 
% is the vector of desired outputs.
% The solution to this problem can be computed in Matlab through the function 
% MLDIVIDE as follows:
%
%   x = A\b
%
% Although this function is very powerful, it does not give any information on which 
% regressor is better than others. 
% On the other hand, Orthogonal Least Squares (OLS) can extract this information.
% It is mainly based on the Gram-Schmidt orthogonalization algorithm.
% 
% In pattern recognition problems, usually a training matrix A_tr is given, 
% associated with the vector of desired outputs b_tr, plus a test set pair (A_ts, b_ts) 
% where the system has to be tested. In such cases the OLS function can be
% used as follows, with a value of r chosen by the user:
%
% [x, ind] = OLS(A_tr, b_tr, r);
%
% err_tr = (A_tr*x-b_tr)' *(A_tr*x-b_tr)/length(b_tr); % Mean Squared Error on training set.
% err_ts = (A_ts*x-b_ts)' *(A_ts*x-b_ts)/length(b_ts); % Mean Squared Error on test set.
% While a large value for r will probably give a low error on the training set, 
% it could happen that a lower value of it would give a lower error on the test set. 
% In such cases, the value of r which minimizes the error on the test set should be chosen.
% 
% ALTERNATIVE SYNTAX
%
% [x, ind, r_act] = OLS(A,b,[], threshold) is another way to call the OLS function. 
% This call requires a threshold in place of the number of regressors r. 
% The threshold, which has to be a decimal number in the interval [0,1], 
% indicates the maximum relative error allowed between the approximated output b_r 
% and the desired output b, when the number of regressors used is r. 
% The provided output r_act gives the number of regressors actually used, which
% are necessary to reduce the error untill the desired value of the threshold.
% Please not that r_act is also equal to the length of the vector ind. 
% The pseudocode for this call is the following:
%
% for r=1:n
%     x_r = OLS(A,b,r);
%     b_r = A*x_r;
%     err = 1-sum(b_r.^2)/sum(b.^2);
%     if threshold < err,
% 	      break;
%     end	
% end
% r_act = r; 
% 
% When threshold is near to 1, r tends to be 1 (a regressor tends to be sufficient).
% When threshold is near to 0, r tends to be n (all regressor tends to be needed to reach the desired accuracy). The parameter threshold is an indirect way to choose the parameter r.
% 
% ALTERNATIVE SYNTAX
%
% OLS(A,b); using this syntax the OLS(A,b,r) function is called for r=1:n and the Error Reduction Ratio
% is collected and then plotted. It gives an idea on the possible values
% for threshold.
%
% ALTERNATIVE SYNTAX
%
% The function OLS computes new, orthogonal regressors in a transformed space. The new regressors
% can be extracted by using the following syntax:
%
% [x, ind, r_act, A_o] = OLS(A,b,[], threshold);
% or the following one:
%
% [x, ind, r_act, A_o] = OLS(A,b,r);
%
% The output A_o is an m-by-r_act matrix.
%
% To test the orthogonality of new generated regressors use the following instructions:
% A_o(:,u)'* A_o(:,v)
% u,v being integer values in {1,…,r_act}
%
% ALTERNATIVE SYNTAX
% 
% [x, ind, r_act, A_o, x_o] = OLS(A,b,r); % This syntax can be used to extract the vector x_o,
% which is the vector of solutions in the orthogonally transformed space.
% This means that the length of vector x_o is r_act, as the number of columns of A_o.
% Numerically, A*x is equal to A_o*x_o.
% 
% FINAL REMARK
%
% The implementation of this function follows the notation given in [1].
%
% AKNOLEDGEMENTS
% 
%   A special thank to Eng. Bruno Morelli for the help provided in writing
%   this function.
%
% REFERENCES
%
% [1] L. Wang, R. Langari, "Building Sugeno-yype models using fuzzy
%     discretization and Orthogonal Parameter Estimation Techniques,"
%     IEEE Trans. Fuzzy Systems, vol. 3, no. 4, pp. 454-458, 1995
% [2] S.A. Billings, M. Koremberg, S. Chen, "Identification of non-linear 
%     output-affine systems using an orthogonal least-squares algorithm,"
%     Int. J. Syst. Sci., vol. 19, pp. 1559-1568, 1988
% [3] M. Koremberg, S.A. Billings, Y.P. Liu, P.J. McIlroy, "Orthogonal
%     parameter estimation algorithm for nonlinear stochastic systems,"
%     Int. J. of Control, vol. 48, pp. 193-210, 1988
%
%   See also MLDIVIDE, LSQLIN, PINV, SVD, QR.

%   OLS, $Version: 0.81, August 2007
%   Author: Marco Cococcioni
%   Please report any bug to m.cococcioni <at> gmail.com

if nargin < 2, % Running in demo mode
    close all
    clc
    disp(sprintf('Not enough input arguments provided. Running in demo mode.'));

    disp('First demo');
    disp('--------------------------------------------------------------');
    m = 1000;
    n = 5;
    A = randn(m, n);
    b1_str = '(0.5*A(:,1)+0.07*A(:,2)+2*A(:,3)+0.004*A(:,4)+60*A(:,5)).^3';
    b1 = eval(b1_str);
    disp(sprintf('Observations (m): %d, variables (n): %d, random matrix of regressors (A): randn(m,n)', m, n));
    disp(sprintf('Vector of outputs b = %s', b1_str));
    disp('');
    disp('Given the previous vector b, it is evident that regressors sorted by');
    disp('decreasing order of importance are: [5 3 1 2 4] (look to the coefficients used in b)');
    ols_demo(A,b1);

    close all
    clc
    disp('Second demo');
    disp('--------------------------------------------------------------');
    b2_str = '(A(:,1)+A(:,2)+A(:,3)+A(:,4)+A(:,5)).^3';
    b2 = eval(b2_str);
    disp(sprintf('In this second demo, we change the vector b as follows\nb = %s', b2_str));
    disp('In this case, it is evident that all regressors have the same importance.');
    disp('This will be highlighted by the chart on Error Reduction Ratio as a function of the')
    disp('number of regressors: it will be practically a straight line.');
    disp('Furthermore, the order of the most important is random!');
    ols_demo(A,b2);
     
    clear all
    return
end
    
if nargin == 2,
    [m, n]=size(A);
    sse = zeros(n,1);
    for r = 1:n
        [x{r}, ind{r}] = ols(A,b,r); % ind{r} contains the index of the r most important regressors
        sse(r) = (A*x{r}-b)'*(A*x{r}-b);
        b_r{r} = A*x{r};
        err(r) = 1-sum(b_r{r}.^2)/sum(b.^2);
    end
    plot(err,'.-b');
    ylabel('Error Reduction Ratio (ERR)');
    xlabel('Index of the most important regression variables');
    title(sprintf('Matrix A has %d rows (observations) and %d columns (regression variables)', m,n));
    set(gca,'xtick',1:n);
    set(gca,'xticklabel',ind{end});
    
    x = x{end};
    ind = ind{end};
    return
end

[m, n]=size(A);

if m <= n,
    error ('OLS error: The number of observations shall be strictly greater than the number of variables');
end

A=A';
cum_error=0;
ind=[];

error_break = false;

if isempty(r),
    r = n; % In case the number of orthogonal regressors is not provided,
    % it will be set equal to the number of variables (regressors)

    error_break=true;
    % this case requires threshold
    if nargin < 4 || isempty(threshold),
        error('The threshold parameter shall be provided when r is empty');
    end
else
    if nargin > 3 && not(isempty(threshold)),
        error('If r is provided, the threshold parameter has to be empty');
    end
end

if r > n,
    error('The number of regressors cannot be greater than the number of columns of A');
end
if r <= 0,
    error('The number of regressors cannot be less or equal to zero');
end

if floor(r)~= r,
    error('The number of regressors r must be a positive integer in the range (1,size(A,2))');
end

A_o=zeros(n,m);
alpha_tot=zeros(n,n);
tmp_sum_output2=sum(b.^2);
x_o=zeros(1,n);

wi=A;
tmp_wi2=sum(wi.^2,2);
gi=wi*b./tmp_wi2;

erri=(gi.^2).*tmp_wi2/tmp_sum_output2;
[value index]=max(erri);
cum_error=cum_error+value;
reg_err=1-cum_error;
ind=[ind index];
avail_index=[1:(index-1) (index+1):n];
A_o(1,:)=A(index,:);
x_o(1,1)=gi(index);

if(error_break && (reg_err<=threshold))
    r=1;   % avoid entering next cycle
end
r_act=1;
for m=2:r,
    kk=0;
    sav=size(avail_index);
    alpha=zeros(n,sav(1,2));
    for av=avail_index
        kk=kk+1;
        for i=1:m-1
            alpha(i,kk)=A_o(i,:)*transpose(A(av,:))/sum(A_o(i,:).^2);
        end
    end
    wi=A(avail_index,:)-(alpha(1:m-1,:)')*A_o(1:m-1,:);
    tmp_wi2=sum(wi.^2,2);
    gi=wi*b./tmp_wi2;
    erri=(gi.^2).*tmp_wi2/tmp_sum_output2;
    [value index]=max(erri);

    cum_error=cum_error+value;
    reg_err=1-cum_error;
    ind(m) = avail_index(1,index);
    davail_index=size(avail_index);
    avail_index=[avail_index(1:(index-1)) avail_index((index+1):davail_index(1,2))];
    A_o(m,:)=wi(index,:);
    x_o(1,m)=gi(index);
    alpha_tot(:,m) = alpha(:,index);
    % alpha_tot = [alpha_tot alpha(:,index)];
    r_act=m;
    if (error_break && (reg_err <= threshold))
        break
    end
end

sav=size(ind);
sav=sav(1,2);
x=zeros(1,n);
x(1,sav)=x_o(1,sav);    % (21)
for i=sav-1:-1:1
    x(1,i)=(x_o(1,i)-alpha_tot(i,i+1:sav)*transpose(x(1,i+1:sav))); % (22)
end

tmp=x;
x=zeros(1,n);
for i=1:sav
    x(1,ind(i))=tmp(1,i);
end

x=x';
A_o = A_o';
A_o = A_o(:,1:r_act);
x_o = x_o(1,1:r_act)';

end


%-ols_demo function-----------------------------------------------
function ols_demo(A,b)
[m, n] = size(A);

x_ls = A\b;
disp(' ');
disp('(Classical) Least Square (LS) solution');
disp(x_ls);

r = n;
[x, ind] = ols(A,b,r);
disp('Orthogonal Least Square (OLS) solution using all regressors:');
disp(x);
disp('Order of relevance between regressors (sorted from the more important to the less one):');
disp(ind);
pause

clear x ind x_ls
sse = zeros(5,1);
err = zeros(5,1);
err_ols_vs_ls = 0;

for r = 1:5
    [x{r}, ind{r}] = ols(A,b,r); % ind{r} contains the index of the r most important regressors 
    x_ls{r} = zeros(5,1);
    x_ls{r}(ind{r}) = A(:,ind{r})\b;
    err_ols_vs_ls = err_ols_vs_ls + sum((x{r}-x_ls{r}).^2);
    % The error err_o_ls is computed to check wheter the solution given 
    % by the Least Squares using the selected most important r regressors
    % coincides with the solution given by OLS procedure
     
    sse(r) = (A*x{r}-b)'*(A*x{r}-b);
    b_r{r} = A*x{r};
    err(r) = 1-sum(b_r{r}.^2)/sum(b.^2);
end

subplot(2,1,1);
plot(sse,'.-b');
ylabel('Sum of Squared Errors (SSE)');
set(gca,'xtick',1:n);
set(gca,'xticklabel',ind{end});
xlabel('Index of the most important regression variables');
title(sprintf('Matrix A has %d rows (observations) and %d columns (regression variables)', m,n));


subplot(2,1,2);
plot(err,'.-b');

ylabel('Error Reduction Ratio (ERR)');
set(gca,'xtick',1:n);
set(gca,'xticklabel',ind{end});
xlabel('Index of the most important regression variables');

threshold = (max(err)+min(err))/2;
[x_t, ind_t, r_act] = ols(A,b,[],threshold);

set(gca,'nextplot','add');
plot([1, 5],[threshold, threshold], ':r');

plot([r_act, r_act],[min(err), max(err)], ':g');
legend('Error Reduction Ratio (ranges in [0,1])',sprintf('threshold (%g)',threshold),...
       sprintf('number of regressors needed to reach the threshold (%d)',r_act));

pause

disp('Now we check wether the solution provided by OLS for a given r is the same as');
disp('the solution given by LS (Classical Least Squares), when considering the best r regressors');
disp(sprintf('returned by OLS (if the value is significantly low then the test is passed): %g\n', err_ols_vs_ls));
   
pause

disp('Now we test the orthogonality of the transformed regressors in the orthogonal space');
disp('');
clear x ind r_act
r = 3;
[x, ind, r_act, A_o, x_o] = ols(A,b,r);
disp(sprintf('Orthogonality test between first and second regressors: %g', A_o(:,1)'*A_o(:,2)));
disp(sprintf('Orthogonality test between first and third  regressors: %g', A_o(:,1)'*A_o(:,3)));
disp(sprintf('Orthogonality test between second and third regressors: %g', A_o(:,2)'*A_o(:,3)));
disp(sprintf('\nTest if the error between A*x and A_o*x_o is sufficiently small: %g', sum((A*x-A_o*x_o).^2)));

pause
end
%-end ols_demo function-----------------------------------------------