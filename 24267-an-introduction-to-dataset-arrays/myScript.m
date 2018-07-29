%% Create dataset object
% Our bonds are located in a number of XLS-files.  Through a simple
% FOR-loop, we can grab all of the bonds and place them into a simgle
% workspace variable.
data = dataset;
for yearIdx = 1980:2000
    fileName = ['bonds' num2str(yearIdx) '.xls'];
    data = [data; dataset('xlsfile', fileName)];
end
% This single command is all we need to work with the data set.  There are,
% however, three improvements that we can make by applying our knowledge of
% the nature of this dataset.  These changes will make operations on the
% array have a simpler syntax and operate faster, and they will make the
% memory footprint smaller as an added bonus.

% Variable size is 1370656 bytes.
clearvars -except data
%% Tuning the dataset
%% 1. Nominal arrays
% Three fields (the ticker symbol, the description, and the currency) are
% filled with often-repeated, categorical data.  These should be recast
% into nominal arrays, which are more efficient at storing the repeated
% data and are also much faster for indexing and searching purposes.

data.ticker      = nominal(data.ticker);
data.description = nominal(data.description);
data.currency    = nominal(data.currency);
% Variable size is now 859844 bytes: 63% of the original size.

%% 2. Ordinal arrays
% The "index quality" field gives the bond ratings as assigned by S&P.
% These are similar to nominal array in that there are often-repeated
% labels, but furthermore there is now a definite order in that some
% ratings are better than others.  This is a perfect use for ordinal
% arrays.  All we must do is supply the ratings scale from lowest to
% highest (or else it will default to alphabetical order):

ratingsScale = ...
    {'BBB-', 'BBB', 'BBB+', 'A-', 'A', 'A+', 'AA-', 'AA', 'AA+', 'AAA'};
data.indexQuality = ordinal(data.indexQuality, [], ratingsScale);
% Variable size is now 701570 bytes: 51% of the original size.

%% 3. Change dates into MATLAB date numbers
% The three date columns are, by default, imported as character strings.
% Using the DATENUM command we can convert them to MATLAB's numeric data
% format, which allows for relational indexing.  It also uses less memory.

data.valDate      = datenum(data.valDate);
data.maturityDate = datenum(data.maturityDate);
% Some small savvy is required to properly handle the blank dates in the
% data.call_date set:
data.callDate     = cellfun(@datenan, data.callDate);
% Variable size is now 206982 bytes: only 15% of the original size!

%% 4. Load another dataset with sector information
% If we have data in different locations we can read in the data into
% another dataset and tune the dataset.
sectorInfo = dataset('xlsfile', 'sectorInfo.xls');

sectorInfo.ticker = nominal(sectorInfo.ticker);
sectorInfo.description = nominal(sectorInfo.description);
sectorInfo.sector = nominal(sectorInfo.sector);

%% 5. Join datasets together
% Once the dataset is tuned we can use the join function to join the two
% datasets based on a similar column or key.  Here we join the datasets
% based on the ticker to include sector information that was not in the
% original data we brought in.
dataFull = join(data, sectorInfo, 'key', 'ticker', 'RightVars', 'sector');

%% Some simple examples of data manipulation and indexing using datasets
% Now that we have a finely-tuned dataset, we can peform a number of
% intuitive indexing tasks as well as some operations.
%% 1. Searching for all instruments of a given ticker name
% First, let us list all of the ticker labels in our array.  This
% information is stored in the data.ticker nominal array.  We can list all
% categories in a nominal array with the GETLABELS function...

getlabels(dataFull.ticker)
%%
% ...and we can focus on a specific ticker (say, Good Foods) with array
% indexing:

dataFull( dataFull.ticker == 'GOOD', {'description', 'par', 'marketValue'} )

%% 2. Searching for all instruments of certain grades
% Thanks to ordinal arrays, we can search for all high- and prime-grade
% instruments with a single command:

dataFull( dataFull.indexQuality >= 'AA-', {'ticker', 'par', 'indexQuality'})

%% 3. Searching for all instruments of certain valuation dates
% With MATLAB serial dates, we can use relational operators to find all
% instruments between certain dates:
subset = dataFull( dataFull.valDate >= datenum('Dec-01-1980') ...
    & dataFull.valDate <= datenum('Jan-01-1981'), {'description', 'coupon', 'par'} )

%%
% Incidentally, it is straightforward to export a dataset to a variety of
% delimited files.  Here, we export the subset created above to a
% tab-delimited file:
export( subset, 'XLSFile', 'Dec1980.xls')

%% 4. A simple example of taking an average on a 2-month block of data
% Let us suppose we wanted to find the simple average coupon and par value
% of the instruments with a valuation date between 12/01/80 and 01/01/81,
% (the same date range as above):
avgCouponAndPar = datasetfun( @mean, dataFull( dataFull.valDate >= datenum('Dec-01-1980') ...
    & dataFull.valDate <= datenum('Jan-01-1981'), {'coupon', 'par'}) )

%% 5. A way to easily look at group statisics
% If we wanted to see the mean of the coupon for each of the instruments,
% we can use the GRPSTATS function:
avgCoupon = grpstats(dataFull, 'ticker', {@mean, @std}, 'DataVars', 'coupon')

%% 6. Other visualizations
% We can create a heatmap function that allows us to quickly look at how
% our portfolio is distributed across the different bonds.
generate_heatmap(dataFull);