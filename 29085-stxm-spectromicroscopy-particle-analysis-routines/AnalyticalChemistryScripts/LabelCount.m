function [out]=LabelCount(Sin)

%% This script counts particles containing component labels. Run DiffMaps
%% and PartLabel first.
%% RC Moffet

OCCnt=0;
OCECCnt=0;
OCInCnt=0;
OCECInCnt=0;

for i = 1:length(Sin.PartLabel)
    OCidx=strmatch('OC',Sin.PartLabel{i},'exact');
    ECidx=findstr(Sin.PartLabel{i},'EC');
    Inidx=findstr(Sin.PartLabel{i},'In');
    Kidx=findstr(Sin.PartLabel{i},'K');
    if ~isempty(OCidx)
        OCCnt=OCCnt+1;
    elseif ~isempty(ECidx) && (~isempty(Inidx) || ~isempty(Kidx))
        OCECInCnt=OCECInCnt+1;
    elseif ~isempty(ECidx) && (isempty(Inidx) || isempty(Kidx))
        OCECCnt=OCECCnt+1;
    elseif (~isempty(Inidx) || ~isempty(Kidx)) && isempty(ECidx)
        OCInCnt=OCInCnt+1;
    end
    clear OCidx ECidx Inidx;
end

out=[OCCnt,OCECCnt,OCECInCnt,OCInCnt];
