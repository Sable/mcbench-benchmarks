function whelp(classpath)
% Display help about the available options to the console.
%
% classpath - the full path to the class omiting 'weka'.
%
% Example: whelp classifiers.bayes.BayesNet

    eval(['weka.',classpath,'.main(''-h'')']);
end