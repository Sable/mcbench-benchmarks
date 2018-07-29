%% Copyright

%Copyright (c) 2009, The MathWorks, Inc.
%All rights reserved.

%Redistribution and use in source and binary forms, with or without 
%modification, are permitted provided that the following conditions are 
%met:

 %   * Redistributions of source code must retain the above copyright 
 %     notice, this list of conditions and the following disclaimer.
 %   * Redistributions in binary form must reproduce the above copyright 
 %     notice, this list of conditions and the following disclaimer in 
 %     the documentation and/or other materials provided with the distribution
 %   * Neither the name of the The MathWorks, Inc. nor the names 
 %     of its contributors may be used to endorse or promote products derived 
 %     from this software without specific prior written permission.
      
%THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
%AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
%IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
%ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
%LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
%CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
%SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
%INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
%CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
%ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
%POSSIBILITY OF SUCH DAMAGE.


%% Import Data into MATLAB and create a dataset array

clc
clear all
chole = dataset('xlsfile','chole.xls');

%% Show a summary of chole

summary(chole)

%% Create a logical mask

chole.mask = isnan([chole.compliance])

%% Median Replacement

chole.compliance(chole.mask == true) = nanmedian(chole.compliance)
chole.improvement(chole.mask == true) = nanmedian(chole.improvement)

%% Filtered dataset array

Filtered = chole(chole.mask == false,{'compliance', 'improvement'})

%% Another example of filtering

Newfiltered = Filtered(Filtered.improvement > 80, {'compliance','improvement'})

%% Dataset array can contain multiple types of information including ordinal
% Here we're using "good" and "bad", however think "red" versus "blue" versus "green",
% different species or fish, or different brands of brake rotors

chole.ord = ordinal(repmat({'good'}, size(chole.improvement)),[],{'good' 'bad'});
chole.ord(chole.mask == true) = 'bad'

%% Import into cftool

cftool(Filtered.improvement,Filtered.compliance);

%% Create a LOESS smooth using a span of .3

hold off
scatter1 = scatter(Filtered.improvement,Filtered.compliance,'k','.');
hold on

Z = smooth(Filtered.improvement,Filtered.compliance,.3, 'loess');
ZPlot = plot(Filtered.improvement,Z,'b','linestyle','-','linewidth',2);
legend('Data Point','LOESS: Span = .3')

%% Illustrate the effect of changing the smoothing parameter

% Enter a smoothing parameter with a very low span

Z03 = smooth(Filtered.improvement,Filtered.compliance,.03,'loess');
Z03Plot = plot(Filtered.improvement,Z03, 'color','r','linestyle','-','linewidth',2);

legend('Data Point','LOESS: Span = .3', 'LOESS: Span = .03')

%% Illustrate the effect of changing the smoothing parameter

% Enter a smoothing parameter with a very high span

Z9 = smooth(Filtered.improvement,Filtered.compliance,.9,'loess');
Z9Plot = plot(Filtered.improvement,Z9, 'color','k','linestyle','-','linewidth',2);
legend('Data Point','LOESS: Span = .5', 'LOESS: Span = .03', 'LOESS: Span = .9')

%% Use Cross Validation to Derive an Optimal Span

%Simple Explanation of Cross Validation
% Test Set versus training Set

delete (scatter1,ZPlot, Z03Plot, Z9Plot);

% Sample 9 out of every 10 data points

cp = cvpartition(size(Filtered.improvement,1),'k',10);

trainingset1 = Filtered.improvement(training(cp,1));
trainingset2 = Filtered.compliance(training(cp,1));

testset1 = Filtered.improvement(test(cp,1));
testset2 = Filtered.compliance(test(cp,1));

trainingscatter = scatter(trainingset1,trainingset2,'+', 'r');
testscatter = scatter(testset1, testset2,'FaceColor','b','Filled');
legend('Training Set','Test Set');

%% Use Training Set to create a LOESS smooth

delete(testscatter);
Z = smooth(Filtered.improvement,Filtered.compliance,.5,'loess');
ZPlot = plot(Filtered.improvement, Z, 'color','r','linestyle','-','linewidth',2);

%% Use Test Set to evaluate the goodness of fit
% Using the test set to evaluate goodness of fit protects against
% overfitting.  If we measured goodness of fit using the training dataset
% our goodness of fit measurement would always recommend chosing the lowest
% spanning parameter possible.

delete(trainingscatter);
testscatter = scatter(testset1, testset2,'FaceColor','b','Filled');

%% Choice of smoothing parameter.
% The smooth function performs loess with some default value of a smoothing
% parameter.  Actually that parameter is adjustable.  Let's try to figure
% out what value works best for this data set.
%
% Specify a range of values for the "span" of the data used in smoothing:
% we're going to test 80 different bandwidths between .01 and .8

spans = linspace(.01,.8,80);

% Perform cross-validation to evaluate the sum of squared errors for each
% value of span.

sse = zeros(size(spans));
cp = cvpartition(size(Filtered.improvement,1),'k',10);

% the myloess function perfoms linear interpolation on a loess curve

for j=1:length(spans)
    f = @(train,test) norm(test(:,2) - mylowess(train,test(:,1),spans(j)))^2;
    sse(j) = sum(crossval(f,[Filtered.improvement,Filtered.compliance],'partition',cp));
end

hold off
plot(spans,sse,'bo-')

% Identify the minimum span

[minsse,minj] = min(sse);
span = spans(minj);

hold on
scatter(minj/100,min(sse),'r','FaceColor','Filled');

legend('SSE','Minimum');
xlabel('Span');
ylabel('Sum of the Squared Errors');


%%
%The shape of the function suggests that a span somewhere between .5 and .6 
%works best. Let's compare the original lowess with the one that minimizes 
%the minimum cross-validation error here.

hold off

scatter(Filtered.improvement,Filtered.compliance,'b', '.');
x = linspace(min(Filtered.improvement),max(Filtered.improvement));
line(x,mylowess([Filtered.improvement,Filtered.compliance],x,.3),'color','k','linestyle','-', 'linewidth',2)
line(x,mylowess([Filtered.improvement,Filtered.compliance],x,span),'color','r','linestyle','-', 'linewidth',2)
legend('Data','Span = 0.3',sprintf('Span = %g',span));

%% Part 2

% Restore the diagram with the improved LOESS span
 
hold off
scatter1 = scatter(Filtered.improvement,Filtered.compliance,'k', '.');
hold on

%Plot a LOESS smooth with the optimal span

Z = smooth(Filtered.improvement,Filtered.compliance,span,'loess');
ZPlot = plot(Filtered.improvement, Z, 'color','b','linestyle','-','linewidth',2);


%% Display the effect of resampling
% draw 164 random samples (with replacement) from the set of datapoints
delete(ZPlot);
a = sort(randsample(length(Filtered),length(Filtered),true));
b = Filtered(a(:),:);

% display the random subset

scatter2 = scatter(b(:,2),b(:,1),'r', '.');

%% Derive a LOESS curve from the random subset using the optimal spanning parameter

A = smooth(b.improvement,b.compliance,span,'loess');

h3 = plot (b(:,2),A, 'color','r','linestyle','-', 'linewidth',2);

%% Repeat

a = sort(randsample(length(Filtered),length(Filtered),true));
b = Filtered(a(:),:);
scatter3 = scatter(b(:,2),b(:,1),'g', '.');

A = smooth(b.improvement,b.compliance,span,'loess');
h4 = plot (b(:,2),A, 'color','g','linestyle','-', 'linewidth',2);

%% Resample a few more times.  Derive 15 LOESS curves

scatter1 = scatter(Filtered.improvement,Filtered.compliance,'k','.');

delete(scatter3,h3,h4); % first resampling from plot

bootsample = 15;
for i = 1:bootsample
   a = sort(randsample(length(Filtered),length(Filtered),true));
   b = Filtered(a(:),:);
   A = smooth(b.improvement,b.compliance,span,'loess');
   plot (b(:,2),A, 'color','g');
end


%% Here begins the actual bootstrap

% Clean up our graph
hold off
scatter1 = scatter(Filtered.improvement,Filtered.compliance,'b','.');
hold on

% Start timer
tic

% Note:  We're using the bootstrp function from Statistics Toolbox

f = @(xy) mylowess(xy,Filtered.improvement,.52);
yboot2 = bootstrp(1000,f,[Filtered.improvement,Filtered.compliance])';

% End timer
toc

meanloess = mean(yboot2,2);
h1 = line(Filtered.improvement, meanloess,'color','k','linestyle','-','linewidth',2);

%% Plot some bounds using +/- 2 standard deviations

stdloess = std(yboot2,0,2);
h2 = line(Filtered.improvement, meanloess+2*stdloess,'color','r','linestyle','--','linewidth',2);
h3 = line(Filtered.improvement, meanloess-2*stdloess,'color','r','linestyle','--','linewidth',2);
legend('data','Mean LOESS','95% CI');

%% Alternatively, plot the percentiles containing 95% of the curves
delete([h2 h3])
h2 = line(Filtered.improvement, prctile(yboot2,2.5,2),'color','k','linestyle',':','linewidth',2);
h3 = line(Filtered.improvement, prctile(yboot2,97.5,2),'color','k','linestyle',':','linewidth',2);

