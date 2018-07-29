function [auc auh acc0 accm thrm thrs acc sens spec hull] = ...
    rocplot(scores, classes, plottype, Nthr)
%rocplot: plot a Receiver Operating Characteristic (ROC) curve
% ROC curves illustrate the performance on a binary classification problem
% where classification is based on simply thresholding a set of scores at
% varying levels. Low thresholds give high sensitivity but low specificity,
% high thresholds give high specificity but low sensitivity; the ROC curve
% plots this trade-off over a range of thresholds.
%
% Examples:
%   rocplot(scores, classes);
%   rocplot(scores, classes, plottype);
%   rocplot(scores, classes, plottype, Nthr);
%   [AUC AUH] = rocplot(scores, classes);
%   [AUC AUH acc0 accM thrM thr acc sens spec hull] = rocplot(...);
%  
% classes is a Boolean vector of the same size as scores, which should
% be true where scores >= threshold should yield true, e.g. true for
% patients, and false for healthy control subjects, in medical diagnosis.
% If you have two vectors of scores, e.g. patient and control, first do:
%   scores  = [control(:); patient(:)];
%   classes = [false(numel(control), 1); true(numel(patient), 1)];
%
% plottype controls what is plotted, it defaults to 2, where:
%   0 gives no plot (useful to get AUC without creating a plot)
%   1 gives a standard ROC curve, with sensitivity vs (1 - specificity)
%   2 gives my preferred convention, with sensitivity vs specificity
% Nthr is an optional number of thresholds to consider (points in the ROC),
% if left off, all unique values in scores are considered, or, if there are
% more than 100 of those, then 100 values equally spaced from min to max of
% scores are used. Alternatively, Nthr can be a vector of thresholds.
%
% AUC is the area under the ROC curve, a measure of overall accuracy,
% which gives the probability that the classifier would rank a randomly
% chosen true instance (e.g. patient) higher than a random false one
% (e.g. control subject).
%
% AUH is the area under the convex hull of the ROC curve, which is of
% interest because it is theoretically possible to operate at any point on
% the convex hull of the points in an ROC curve (by using some proportional
% selection of classifiers that operate at two points defining the relevant
% section of the convex hull. This is just a more complex version of the
% logic that gives the null line for an ROC plot; if a threshold of -inf
% gives (spec=0,sens=1) and +inf gives (1,0), then using -inf for half of
% your data and +inf for the other half is expected to give (0.5,0.5) if
% you have equal numbers of true and false instances).
%
% Also recorded in the plot legend, and optionally returned, are acc0, the
% accuracy at a threshold of zero, which is of special importance
% in some algorithms, e.g. if your scores come from a linear classifier
% like a Support Vector Machine which can give scores(i) = w'*x(:, i) - b,
% as equivalent to testing for w'*x(:, i) > b, and accM, the max accuracy
% from the tested set of thresholds, which occurs at the threshold thrM.
%
% The function can also return a vector of all considered thresholds, along
% with the corresponding accuracies, sensitivities and specificities, in
% the variables thr, acc, sens, spec. The output hull contains the indices
% into sens and spec that give the convex hull. These arguments can then be
% used to plot multiple ROC curves and/or convex hulls on the same axis,
% e.g. after calling rocplot twice (with plottype 0), you could do:
%   plot(spec1,sens1,'b', spec2,sens2,'r', [0 1],[1 0],'g');
%
% See also: roc, prec_rec, get_concave_ROC, auroc, bookmaker
%
% These can be found in the MATLAB Central File Exchange:
% roc             http://www.mathworks.com/matlabcentral/fileexchange/19950
% roc             http://www.mathworks.com/matlabcentral/fileexchange/21318
% prec_rec        http://www.mathworks.com/matlabcentral/fileexchange/21528
% get_concave_ROC http://www.mathworks.com/matlabcentral/fileexchange/21382
% auroc           http://www.mathworks.com/matlabcentral/fileexchange/19468
% bookmaker       http://www.mathworks.com/matlabcentral/fileexchange/5648
% There is also a book "Ordinal Data Modeling", by Valen Johnson, with
% companion code  http://www.mathworks.com/matlabcentral/fileexchange/2264

% Copyright 2009 Ged Ridgway

scores = scores(:);
% need max thr greater than max(scores) so roc sens drops to zero
maxscoreplus = max(scores) + eps(max(scores));
classes = classes(:);
if any(double(logical(classes)) ~= double(classes))
    error('Classes vector must contain true (or 1) and false (or 0) only')
end

if ~exist('Nthr', 'var') || isempty(Nthr)
    if numel(scores) > 100
        Nthr = 100; % no need for more points in plot
    else
        thrs = unique([scores;maxscoreplus]);
        Nthr = numel(thrs);
    end
end
if ~exist('thrs', 'var')
    if ~isscalar(Nthr) % user-specified set of thrs to consider
        thrs = unique(Nthr); % (also sorts)
        Nthr = numel(thrs);
        % thrs(Nthr) = maxscoreplus; % commented out, assuming expert user.
    else
        thrs = linspace(min(scores), maxscoreplus, Nthr);
    end
end
thrs = thrs(:);

acc = zeros(Nthr, 1); sens = acc; spec = sens;
for n = 1:Nthr
    thr = thrs(n);
    result = scores >= thr;
    acc(n) = mean(result == classes);
    sens(n) = sum(result == 1 & classes == 1)/sum(classes == 1);
    spec(n) = sum(result == 0 & classes == 0)/sum(classes == 0);
end
% area under ROC curve
auc = trapz(spec, sens);
% test special case of 0 threshold, since training often assumes this
result0 = scores >= 0;
acc0 = mean(result0 == classes);
sens0 = sum(result0 == 1 & classes == 1)/sum(classes == 1);
spec0 = sum(result0 == 0 & classes == 0)/sum(classes == 0);
% threshold giving highest overall accuracy
[accm indm] = max(acc);
thrm = thrs(indm);
sensm = sens(indm);
specm = spec(indm);
% compute convex hull of ROC curve and area under hull
[hull auh] = convhull([spec;0], [sens;0]);
hull = unique(hull);
hull(end) = []; % don't close loop
% sanity check:
if abs(trapz(spec(hull), sens(hull)) - auh) > eps
    warning('rocplot:auh', 'Area under ROC convex hull may be incorrect');
end
if ~exist('plottype', 'var') || isempty(plottype)
    plottype = 2;
end
switch plottype
    case 0, return % no plot
    case 1 % standard TPR (= sens) vs FPR (= 1-spec)
        plot(1-spec,sens,'b', 1-spec(hull),sens(hull),'c', ...
            1-spec0,sens0,'ro', 1-specm,sensm,'ms', 1-[0 1],[1 0],'g');
        xlabel('False Positive Rate (1 - Specificity)');
        ylabel('True Positive Rate (Sensitivity)');
        legpos = 'SE';
        axis([0 1 0 1])
    case 2 % my convention, sens vs spec
        plot(spec,sens,'b', spec(hull),sens(hull),'c', ...
            spec0,sens0,'ro', specm,sensm,'ms', [0 1],[1 0],'g');
        xlabel('Specificity');
        ylabel('Sensitivity');
        legpos = 'SW';
        axis([0 1.05 0 1.05])
end
legend(sprintf('ROC Curve\nAUC = %.3g', auc), ...
    sprintf('Conv Hull\nAUC = %.3g', auh), ...
    sprintf('Acc(0) = %.3g', acc0), ...
    sprintf('Max Acc %.3g', accm), ... 'Chance', ...
    'Location', legpos)

if nargout == 0, clear auc, end % quieten rocplot(scores,classes) without ;
