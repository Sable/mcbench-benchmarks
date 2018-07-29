function partest(varargin)
%This function calculate the performance, based on Bayes theorem, of a
%clinical test.
%
% Syntax: 	PARTEST(X,ALPHA)
%      
%     Input:
%           X is the following 2x2 matrix.
%           ALPHA - significance level for confidence intervals (default = 0.05).
%
%....................Affected(D+)..Healthy(D-)
%                    _______________________
%Positive Test(T+)  |   True    |  False    |
%                   | positives | positives |
%                   |___________|___________|
%                   |  False    |   True    |
%Negative Test(T-)  | negatives | negatives |
%                   |___________|___________|
%
%     Outputs:
%           - Prevalence
%           - Sensibility
%           - Specificity
%           - False positive and negative proportions
%           - False discovery and discovery rates
%           - Youden's Index and Number Needed to Diagnose (NDD)
%           - Positive predictivity
%           - Positive Likelihood Ratio
%           - Negative predictivity
%           - Negative Likelihood Ratio
%           - Predictive Summary Index (PSI) and Number Needed to Screen (NNS)
%           - Test Accuracy
%           - Mis-classification Rate
%           - F-Measure
%           - Test bias
%           - Error odds ratio
%           - Diagnostic odds ratio
%           - Discriminant Power
%
%      Example: 
%
%
%           Calling on Matlab the function: partest
%           it will use a default matrix x=[731 270;78 1500] and alpha=0.05
%
%           Answer is:
%
%DIAGNOSTIC TEST PERFORMANCE PARAMETERS
% ----------------------------------------------------------------------------------------------------
% Prevalence: 31.4% (29.6% - 33.2%)
%  
% Sensitivity (probability that test is positive on unhealthy subject): 90.4% (89.1% - 91.5%)
% False negative proportion: 9.6% (8.5% - 10.9%)
% False discovery rate: 27.0% (25.3% - 28.7%)
%  
% Specificity (probability that test is negative on healthy subject): 84.7% (83.3% - 86.1%)
% False positive proportion: 15.3% (13.9% - 16.7%)
% False omission rate: 4.9% (4.2% - 5.9%)
%  
% Youden's Index (a perfect test would have a Youden's index of +1): 0.7510
% Number Needed to Diagnose (NND): 1.33
% Around 14 persons need to be tested to return 10 positive tests for the presence of disease
%  
% Precision or Predictivity of positive test
% (probability that a subject is unhealthy when test is positive): 73.0% (71.3% - 74.7%)
% Positive Likelihood Ratio: 5.9 (5.7 - 6.2)
% Moderate increase in possibility of disease presence
%  
% Predictivity of negative test
% (probability that a subject is healthy when test is negative): 95.1% (94.1% - 95.8%)
% Negative Likelihood Ratio: 0.1138 (0.1094 - 0.1183)
% Moderate increase in possibility of disease absence
%  
% Predictive Summary Index: 0.6808
% Number Needed to Screen (NNS): 1.47
% Around 15 persons need to be screened to avoid 10 events (i.e. death) for the presence of disease
%  
% Accuracy or Potency: 86.5% (85.1% - 87.8%)
% Mis-classification Rate: 13.5% (12.2% - 14.9%)
% F-measure: 80.8% (79.2% - 82.3%)
%  
% Test bias: 1.2373 (0.9474 - 1.6160)
% Test overestimates the phenomenon
% Error odds ratio: 1.6869 (1.2916 - 2.2032)
% Diagnostic odds ratio: 52.0655 (39.8649 - 68.0002)
% Discriminant Power: 2.2
%      A test with a discriminant value of 1 is not effective in discriminating between affected and unaffected individuals.
%      A test with a discriminant value of 3 is effective in discriminating between affected and unaffected individuals.
%    
%
%           Created by Giuseppe Cardillo
%           giuseppe.cardillo-edta@poste.it
%
% To cite this file, this would be an appropriate format:
% Cardillo G. (2006). Clinical test performance: the performance of a
% clinical test based on the Bayes theorem. 
% http://www.mathworks.com/matlabcentral/fileexchange/12705

%Input Error handling
args=cell(varargin);
nu=numel(args);
if nu>2
    error('Warning: Max two input data are required')
end
default.values = {[731 270;78 1500],0.05};
default.values(1:nu) = args;
[x alpha] = deal(default.values{:});

if nu>=1
    if isvector(x)
        error('Warning: PARTEST requires a 2x2 input matrix')
    end
    if ~all(isfinite(x(:))) || ~all(isnumeric(x(:))) || ~isequal(x,round(x))
        error('Warning: all matrix values must be numeric integer and finite')
    end
    [r,c] = size(x);
    if (r ~= 2 || c ~= 2)
        error('Warning: PARTEST requires a 2x2 input matrix')
    end
    clear r c
end
if nu>1
    if ~isscalar(alpha) || ~isnumeric(alpha) || ~isfinite(alpha) || isempty(alpha)
        error('Warning: it is required a numeric, finite and scalar ALPHA value.');
    end
    if alpha <= 0 || alpha >= 1 %check if alpha is between 0 and 1
        error('Warning: ALPHA must be comprised between 0 and 1.')
    end
end
clear args default nu

global z N

z=-realsqrt(2)*erfcinv(2-alpha);
cs=sum(x); %columns sum
rs=sum(x,2); %rows sums
N=sum(x(:)); %numbers of elements
d=diag(x); %true positives and true negatives

clc
disp('DIAGNOSTIC TEST PERFORMANCE PARAMETERS')
disp(repmat('-',1,100))
%Prevalence
%the prevalence of disease is estimated all D+/N 
pr=(cs(1)/N); 
%95% confidence interval critical value for Prevalence
prci=newcombe(pr);
fprintf('Prevalence: %0.1f%% (%0.1f%% - %0.1f%%)\n',pr*100,prci(1).*100,prci(2).*100)
disp(' ')

%Sensitivity and Specificity
%The Sensitivity is the probability that the test is positive on sick subjects: P(T+|D+) 
%The Specificity is the probability that the test is negative on healthy subjects: P(T-|D-) 
%In Matlab both parameters are obtained with only one instruction:
SS=d./cs'; %Sensitivity and Specificity
%Of course the false proportion is the complement to 1
fp=1-SS; %false proportions
%The false discovery rate is the probability that the disease is absent when the test is positive: P(D-|T+) 
%The false omission rate is the probability that the disease is present when the test is negative: P(D+|T-) 
fd=diag(rot90(x))./rs; %false discovery and omission rate

% 95% confidence intervals
Seci=newcombe(SS(1)); Spci=newcombe(SS(2));
fnci=newcombe(fp(1)); fpci=newcombe(fp(2));
fdci=newcombe(fd(1)); foci=newcombe(fd(2));
fprintf('Sensitivity (probability that test is positive on unhealthy subject): %0.1f%% (%0.1f%% - %0.1f%%)\n',SS(1)*100,Seci(1).*100,Seci(2).*100)
fprintf('False negative proportion: %0.1f%% (%0.1f%% - %0.1f%%)\n',fp(1)*100,fnci(1).*100,fnci(2).*100)
fprintf('False discovery rate: %0.1f%% (%0.1f%% - %0.1f%%)\n',fd(1)*100,fdci(1).*100,fdci(2).*100)
disp(' ')
fprintf('Specificity (probability that test is negative on healthy subject): %0.1f%% (%0.1f%% - %0.1f%%)\n',SS(2)*100,Spci(1).*100,Spci(2).*100)
fprintf('False positive proportion: %0.1f%% (%0.1f%% - %0.1f%%)\n',fp(2)*100,fpci(1).*100,fpci(2).*100)
fprintf('False omission rate: %0.1f%% (%0.1f%% - %0.1f%%)\n',fd(2)*100,foci(1).*100,foci(2).*100)
disp(' ')

%Youden's Index
%Youden's J statistics (also called Youden's index) is a single statistic that
%captures the performance of a diagnostic test. The use of such a single index
%is "not generally to be recommended". It is equal to the risk difference for a
%dichotomous test and it defined as: J = Sensitivity + Specificity - 1. 
%A perfect test has J=1. 
J=sum(SS)-1; %Youden's index
fprintf('Youden''s Index (a perfect test would have a Youden''s index of +1): %0.4f\n', J)

%The number needed to diagnose is defined as the number of patients that
%need to be tested to give one correct positive test.
NND=1/J; %Number needed to Diagnose (NND)
fprintf('Number Needed to Diagnose (NND): %0.2f\n',NND);
fprintf('Around %i persons need to be tested to return 10 positive tests for the presence of disease\n',ceil(NND*10)) 
disp(' ')

%Positive and Negative predictivity
%Positive predictivity is the probability that a subject is sick when test is positive: P(D+|T+)
%Negative predictivity is the probability that a subject is healthy when test is negative: P(D-|T-)
%Positive predictivity=Precision
%In Matlab both parameters are obtained with only one instruction:
PNp=d./rs; %Positive and Negative predictivity
% 95% confidence interval critical value for Positive and Negative predictivity
Ppci=newcombe(PNp(1));
Npci=newcombe(PNp(2));
%Positive and Negative Likelihood Ratio
%When we decide to order a diagnostic test, we want to know which test (or
%tests) will best help us rule-in or rule-out disease in our patient.  In the
%language of clinical epidemiology, we take our initial assessment of the
%likelihood of disease (“pre-test probability”), do a test to help us shift our
%suspicion one way or the other, and then determine a final assessment of the
%likelihood of disease (“post-test probability”). 
%Likelihood ratios tell us how much we should shift our suspicion for a
%particular test result. Because tests can be positive or negative, there are at
%least two likelihood ratios for each test.  The “positive likelihood ratio”
%(LR+) tells us how much to increase the probability of disease if the test is
%positive, while the “negative likelihood ratio” (LR-) tells us how much to
%decrease it if the test is negative.
%You can also define the LR+ and LR- in terms of sensitivity and specificity:
%LR+ = sensitivity / (1-specificity)
%LR- = (1-sensitivity) / specificity
plr=SS(1)/fp(2); %Positive Likelihood Ratio
plrci=LRci(plr,x);
nlr=fp(1)/SS(2); %Negative Likelihood Ratio
nlrci=LRci(nlr,x);

fprintf('Precision or Predictivity of positive test\n')
fprintf('(probability that a subject is unhealthy when test is positive): %0.1f%% (%0.1f%% - %0.1f%%)\n', PNp(1)*100,Ppci(1).*100,Ppci(2).*100)
fprintf('Positive Likelihood Ratio: %0.1f (%0.1f - %0.1f)\n',plr,plrci(1),plrci(2))
dlr(plr)
disp(' ')
fprintf('Predictivity of negative test\n')
fprintf('(probability that a subject is healthy when test is negative): %0.1f%% (%0.1f%% - %0.1f%%)\n', PNp(2)*100,Npci(1).*100,Npci(2).*100)
if nlr<1e-4 || nlrci(1)<1e-4
    fprintf('Negative Likelihood Ratio: %0.4e (%0.4e - %0.4e)\n',nlr,nlrci(1),nlrci(2))
else
    fprintf('Negative Likelihood Ratio: %0.4f (%0.4f - %0.4f)\n',nlr,nlrci(1),nlrci(2))
end
dlr(nlr)
disp(' ')

%Predictive Summary Index (similar to Youden's Index)
PSI=sum(PNp)-1;
NNS=1/PSI; %Number needed to screen
fprintf('Predictive Summary Index: %0.4f\n', PSI)
fprintf('Number Needed to Screen (NNS): %0.2f\n',NNS);
fprintf('Around %i persons need to be screened to avoid 10 events (i.e. death) for the presence of disease\n',ceil(NNS*10)) 
disp(' ')

%Accuracy and Mis-classification rate
%Diagnostic accuracy (or Power) is defined as the proportion of all tests
%that give a correct result. The Mis-classification rate is its complement to 1. 
%In statistics, the F1 score (also F-score or F-measure) is a measure of a
%test's accuracy. It considers both the Precision (positive predictivity) 
%and the Sensitivity of the test to compute the score: 
%P is the number of correct results divided by the number of all returned results
%S is the number of correct results divided by the number of results that should 
%have been returned. 
%The F1 score can be interpreted as a weighted average of the Precision and
%Sensitivity, where an F1 score reaches its best value at 1 and worst score at 0. 
acc=trace(x)/N; %Accuracy
accci=newcombe(acc);
mcr=1-acc; %Mis-classification rate
mcrci=newcombe(mcr);
FMeasure=harmmean([SS(1) PNp(1)]); %F-measure
FMci=newcombe(FMeasure);
fprintf('Accuracy or Potency: %0.1f%% (%0.1f%% - %0.1f%%)\n',acc*100,accci(1).*100,accci(2).*100)
fprintf('Mis-classification Rate: %0.1f%% (%0.1f%% - %0.1f%%)\n',mcr*100,mcrci(1).*100,mcrci(2).*100)
fprintf('F-measure: %0.1f%% (%0.1f%% - %0.1f%%)\n',FMeasure*100,FMci(1).*100,FMci(2).*100)
disp(' ')

orse=realsqrt(sum(1./x(:))); %standard error of log(OR)
cv=([-1 1].*(z*orse));

%Test Bias (TB)
%A test which shows provable and systematic differences in the results of people
%based on group membership. For example, a test might be considered biased if
%members of one particular gender or race consistently and systematic have
%statistically different results from the rest of the testing population. 
%It is defined as (T+)/(D+)=(TP+FP)/(TP+FN)
%A perfect test has a TB=1;
%If TB<1 the test underestimates the disease because there are more affected than positive test
%If TB>1 the test overestimates the disease because there are more positive test than affected
TB=rs(1)/cs(1); %Test Bias
orci=exp(reallog(TB)+cv); %OR confidence interval
fprintf('Test bias: %0.4f (%0.4f - %0.4f)\n',TB,orci(1),orci(2))
if TB>1
    disp('Test overestimates the phenomenon')
elseif TB<1
    disp('Test underestimates the phenomenon')
else
    disp('There is not test bias')
end

%Error Odds Ratio. 
%Indicates if the probability of being wrongly classified is highest in the
%diseased or in the non-diseased group. If the error odds is higher than one the
%probability is highest in the diseased group (and the specificity of the test
%is better than the sensitivity), if the value is lower than one the probability
%of an incorrect classification is highest in the non-diseased group (and the
%sensitivity of the test is better than the specificity).     
%It is defined as (Sensitivity/(1-Sensitivity))/(Specificity/(1-Specificity));
EOR=(SS(1)/fp(1))/(SS(2)/fp(2)); %Error odds ratio
orci=exp(reallog(EOR)+cv); %OR confidence interval
fprintf('Error odds ratio: %0.4f (%0.4f - %0.4f)\n',EOR,orci(1),orci(2))

%Diagnostic Odds Ratio. 
%Diagnostic odds ratio is defined as how much more likely will the test
%make a correct diagnosis than an incorrect diagnosis in patients with the
%disease (Scott et al. 2008).  
%Often used as a measure of the discriminative power of the test. Has the value
%one if the test does not discriminate between diseased and not diseased. Very
%high values above one means that a test discriminates well. Values lower than
%one mean that there is something wrong in the application of the test.   
%It is defined as (Sensitivity/(1-Sensitivity))/((1-Specificity)/Specificity);
DOR=(SS(1)/fp(1))/(fp(2)/SS(2)); %Diagnostic odds ratio
orci=exp(reallog(DOR)+cv); %OR confidence interval
fprintf('Diagnostic odds ratio: %0.4f (%0.4f - %0.4f)\n',DOR,orci(1),orci(2))

%Discriminant power
%The discriminant power for a test, also termed the test effectiveness, is a
%measure of how well a test distinguishes between affected and unaffected
%persons. It is the sum of logs of Sensivity and Specificity over own false
%proportion, scaled by the standard deviation of the logistic normal
%distribution curve (square root of 3 divided by π). Test effectiveness is
%interpreted as the standardized distance between the means for both populations.     
%A test with a discriminant value of 1 is not effective in discriminating between affected and unaffected individuals.
%A test with a discriminant value of 3 is effective in discriminating between affected and unaffected individuals.
dpwr=(realsqrt(3)/pi)*sum(log(SS./fp)); %Discriminant power
fprintf('Discriminant Power: %0.1f\n',dpwr)
disp([blanks(5) 'A test with a discriminant value of 1 is not effective in discriminating between affected and unaffected individuals.'])
disp([blanks(5) 'A test with a discriminant value of 3 is effective in discriminating between affected and unaffected individuals.'])


%Display graphs
xg=cs./N;
figure
hold on
H=zeros(1,4);
H(1)=fill(xg(1)+[0 xg(2) xg(2) 0],SS(2)+[0 0 fp(2) fp(2)],'r');
H(2)=fill([0 xg(1) xg(1) 0],fp(1)+[0 0 SS(1) SS(1)],'g');
H(3)=fill([0 xg(1) xg(1) 0],[0 0 fp(1) fp(1)],'y');
H(4)=fill(xg(1)+[0 xg(2) xg(2) 0],[0 0 SS(2) SS(2)],'b');
hold off
axis square
title('PARTEST GRAPH')
xlabel('Subjects proportion')
ylabel('Parameters proportion')
legend(H,'False Positive','True Positive (Sensibility)','False Negative','True Negative (Specificity)','Location','NorthEastOutside')

%The rose plot is a variation of the common pie chart. For both, we have k data
%points where each point denotes a frequency or a count. Pie charts and rose
%plots both use the area of segments of a circle to convey amounts. 
%The pie chart uses a common radius and varies the central angle according to
%the data. That is, the angle is proportional to the frequency. So if the i-th
%point has count X and the total count is N, the i-th angle is 360*(X/N). 
%For the rose plot, the angle is constant (i.e., divide 360 by the number of
%groups, k) and it is the square root of the radius that is proportional to the
%data. 
%According to Wainer (Wainer (1997), Visual Revelations: Graphical Tales of Fate
%and Deception from Napolean Bonaporte to Ross Perot, Copernicus, Chapter 11.),
%the use of a common angle is the strength of the rose plot since it allows us
%to easily compare a sequence of rose plots (i.e., the corresponding segments in
%different rose plots are always in the same relative position). 
%In particular, this makes rose plots an effective technique for displaying the
%data in contingency tables.  
%As an interesting historical note, Wainer points out that rose plots were used
%by Florence Nightingale (she referred to them as coxcombs).  
%color={'r','g','y','b'};
H=roseplot([fp(2) SS(1) fp(1) SS(2)]);
title('ROSEPLOT PARTEST GRAPH')
legend(H,'False Positive','True Positive (Sensibility)','False Negative','True Negative (Specificity)','Location','NorthEastOutside')
return
end

function dlr(lr) %Likelihood dialog
if lr==1
    disp('Test is not suggestive of the presence/absence of disease')
    return
end

if lr>10 || lr<0.1
    p1='Large (often conclusive)';
elseif (lr>5 && lr<=10) || (lr>0.1 && lr<=0.2)
    p1='Moderate';
elseif (lr>2 && lr<=5) || (lr>0.2 && lr<=0.5)
    p1='Low';
elseif (lr>1 && lr<=2) || (lr>0.5 && lr<=1)
    p1='Poor';
end

p2=' increase in possibility of disease ';

if lr>1
    p3='presence';
elseif lr<1
    p3='absence';
end
disp([p1 p2 p3])
return
end

function H=roseplot(x)
color={'r','g','y','b'};
k=length(x); H=zeros(1,k);
ang=(0:1:k)./k.*2.*pi;
figure
axis square
hold on
for I=1:k
    theta=[ang(I) linspace(ang(I),ang(I+1),500) ang(I+1)];
    rho=[0 repmat(realsqrt(x(I)),1,500) 0];
    [xg,yg]=pol2cart(theta,rho);
    H(I)=patch(xg,yg,color{I});
end
hold off
return
end

function ci=newcombe(p)
global z N
a=2*N*p+z^2;
b=z*realsqrt((z^2-2-1/N+4*p*(N*(1-p)+1)));
c=(2*(N+z^2));
%Of course, the critical interval lower bound cannot be less than 0 and the
%upper bound cant be greater than 1 and so:
ci(1)=max([0 (a-b-1)/c]);
ci(2)=min([1 (a+b+1)/c]);
return
end

function ci=LRci(lr,x)
global z
a=log(lr); b=realsqrt(sum(1./diag(x))-sum(1./sum(x,2)))*z;
ci=exp([a-b a+b]);
return
end