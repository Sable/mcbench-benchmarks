% pdfbflip_model.m
% By: Duncan Po
% Date: December 5/2002
% usage: newmodel = pdfbflip_model(model, level, subband)
% input: model  -   model to be flipped
%        level  -   the level where the flipping occurred
%        subband-   the subband where the flipping occurred
% output: newmodel  -   flipped model
%
% this function flip the state of a particular node (i.e. state 1
% becomes state 2, and state 2 becomes state 1 for two state case)
% This action doesn't change the model but can align the model against
% another one which is useful in image retrieval, etc.

function newmodel = pdfbflip_model(model, level, subband)
 
newmodel = model; 

if level < length(model.stdv)
    newmodel.stdv{level}{subband} = fliplr(newmodel.stdv{level}{subband});
    
    if strcmp(newmodel.zeromean, 'no') == 1
        newmodel.mean{level}{subband} = fliplr(newmodel.mean{level}{subband});
    end;
    
    if length(model.stdv{level}) == length(model.stdv{level+1})
        newmodel.transprob{level}{subband} = ...
            fliplr(newmodel.transprob{level}{subband});
    else
        % next level has double the directions
        newmodel.transprob{level}{subband*2} = ...
            fliplr(newmodel.transprob{level}{subband*2});
        newmodel.transprob{level}{subband*2-1} = ...
            fliplr(newmodel.transprob{level}{subband*2-1});
    end;

    if level ~= 1
        newmodel.transprob{level-1}{subband} = ...
            flipud(newmodel.transprob{level-1}{subband});
    else
        newmodel.rootprob = fliplr(newmodel.rootprob);
    end;
else
    %level = finest level
    newmodel.stdv{level}{subband} = fliplr(newmodel.stdv{level}{subband});
    
    if strcmp(newmodel.zeromean, 'no') == 1
        newmodel.mean{level}{subband} = fliplr(newmodel.mean{level}{subband});
    end;
    
    newmodel.transprob{level-1}{subband} = ...
            flipud(newmodel.transprob{level-1}{subband});
end;
    


    