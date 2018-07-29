function [pvalue Vlstar Vl] = WhiteRealityCheck( alternative , flag, benchmark , n , display)


%% This file contains the White reality check for data snooping
%  -   This can be used to test whether atleast one of the created models
%  outperforms a benchmark model  
%  - This can also be used to test whether you have found atleast one profitable
%  trading strategy, or test whether you have found atleast one trading
%  strategy that outperforms the benchmark.


%  The H0 hypothesis is always  that you have not found an outperforming
%  strategy or model

% input:
% 'Alternative' is a matrix with  Returns ==> [-1 , +Inf ]
%  or residuals of predictions with a model ==> [ -Inf ; +Inf]
% Important, the rows stand for new observation the columns for the models
%  'Flag'  indicates which loss function you want to use
%  Flag = 1 test for model superiority vs benchmark by mean squared error
%  Flag = 2 test for trading return superiorty vs benchmark 
%  Flag = 3 test for model superiority vs benchmark by absolute error
% 'Benchmark' contains a vector with - (1) The residuals from the predictions
% of the benchmark model , (2) The returns of your benchmark trading
% strategy, (3) Special case where Benchmark is the single number 0 where
% your benchmark is zero.
%  'n' is the number of bootstrapped series you want to create aka the
%  number of simulations. In academic papers this is usually  set 
%  to atleast 500 for reasonable results
% 'display' is a number [ 0, 1] if 0 then display is set off if 1 then
% display is on

% Examples of possibles testing can be found in help.txt file 



[r,~]=size(alternative);


%  condition whether you have a benchmark or you want to test vs 0
if benchmark ~=0|| numel(benchmark)>1
    mat = repmat(benchmark,1,c);
else
    mat = benchmark; % mat = 0 benchmark is zero
end
    




% %  loss functions 
if flag ==1   
     f = - alternative.^2 + mat.^2;
elseif flag==2
    f = log(1+alternative)-log(1+mat);
elseif flag ==3
    f = - abs (alternative) + abs(mat);
end


%  input for average block size for P&R bootstrap (geometric distribution)
input = inputdlg('What do you want as average block size for the Politis Romano stationary bootstrap?');
blockparam = 1/(str2num(input{1})+1);


% Actual Politis Romano bootstrap as described in Politis& Romano (1994)
fstarroof =  PolitisRomanoBootstrap( alternative , n , blockparam,display,flag,mat);


froof = mean(f,1);
Vl = max(sqrt(r)*froof);

delta = fstarroof - repmat(froof,n,1);
Vlstar = max(sqrt(r)*delta,[],2);


Vlstar = sort(Vlstar);

% 'Vl' and 'Vlstar' are the same as in the paper of 
% Sullivan, Timmermann and White (1999) or White(2000)

better = Vlstar>Vl;

pvalue = sum(better)/n;

% compare Vl and Vlstar to get the p-value









    
    
     




