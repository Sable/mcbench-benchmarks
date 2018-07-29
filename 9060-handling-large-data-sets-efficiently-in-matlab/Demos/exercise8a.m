%% Specifications
minspec=70;
maxspec=200;

%% Find
found= data(:)>minspec & data(:)<maxspec;
Percent=sum(found)/length(found)