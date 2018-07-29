%% Specifications
minspec=70;
maxspec=200;

%% Find how many pass
found=0;
for k=1:numel(data)
    found=found + (data(k)>minspec && data(k)<maxspec);
end

%% Display result
Percent=100*found/length(data(:))

