function [class,siz]=ChemSiz(Sin)

%% Give Labels and size for plotting chemical size distributions
%% Label definintions: 
%% 1=OC, 2=ECOCIn, 3=ECOC, 4=InOC, 5=NoID
%% RC Moffet, 2010
siz=Sin.Size;
class=zeros(1,length(Sin.PartLabel));
for i = 1:length(Sin.PartLabel)
    NoIdidx=strmatch('NoID',Sin.PartLabel{i},'exact');
    OCidx=strmatch('OC',Sin.PartLabel{i},'exact');
    OCAidx=strmatch('OCsp2',Sin.PartLabel{i},'exact');
    ECidx=findstr(Sin.PartLabel{i},'EC');
    Inidx=findstr(Sin.PartLabel{i},'In');
    Kidx=findstr(Sin.PartLabel{i},'K');
    if ~isempty(OCidx) || ~isempty(OCAidx) %% OC
        class(i)=1;
    elseif ~isempty(ECidx) && (~isempty(Inidx) || ~isempty(Kidx)) %% ECOCIn
        class(i)=2;
    elseif ~isempty(ECidx) && (isempty(Inidx) || isempty(Kidx)) %% ECOC
        class(i)=3;
    elseif (~isempty(Inidx) || ~isempty(Kidx)) && isempty(ECidx) %% InOC
        class(i)=4;
    elseif ~isempty(NoIdidx)  %% NoID
        class(i)=5;
    end
    clear OCidx ECidx Inidx NoIdidx;
end


