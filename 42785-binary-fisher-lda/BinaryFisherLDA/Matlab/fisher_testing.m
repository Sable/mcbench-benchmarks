% Copyright (C) 2010 Quan Wang <wangq10@rpi.edu>
% Signal Analysis and Machine Perception Laboratory
% Department of Electrical, Computer, and Systems Engineering
% Rensselaer Polytechnic Institute, Troy, NY 12180, USA

%% The testing of binary Fisher's linear discriminant
%    f: n*m feature matrix, each row being a data point
%    w: projection weights
%    t: threshold, obtained by
%    l0: n*1 ground truth of binary label vector, each element being 0 or 1
%    l: n*1 resulting binary label vector, each element being 0 or 1
%    precision, recall, accuracy, F1: measurement of performance
%    display: a flag indicating whether to display results, 0 for silent
function [l,precision,recall,accuracy,F1]=fisher_testing(f,w,t,l0,display)

fp=f*w;
l=(fp>t);

if nargin<5
    display=1;
end

if nargin<4
    precision=NaN;
    recall=NaN;
    accuracy=NaN;
    F1=NaN;
else
    tp= sum( (l0==1) & (l==1) );
    fn= sum( (l0==1) & (l==0) );
    fp= sum( (l0==0) & (l==1) );
    tn= sum( (l0==0) & (l==0) );
    precision=tp/(tp+fp);
    recall=tp/(tp+fn);
    accuracy=(tp+tn)/(tp+tn+fp+fn);
    F1=2*precision*recall/(precision+recall);
    if display>0
        fprintf(['Fisher --- precision: %f, recall: %f, accuracy: %f, ' ...
            'F1-measure: %f\n'],precision,recall,accuracy,F1);
    end
end