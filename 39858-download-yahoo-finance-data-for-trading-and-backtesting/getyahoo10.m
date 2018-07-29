function getyahoo10(symbols, directory)
% GETYAHOO10 
%   Downloads 10 years worth of daily stock data from yahoo finance.
%   The open, high, low prices are adjusted based on the adjClose 
%   field.
%   The output is saved in csv format in the directory specified
%   by the DIRECTORY parameter.
%
%   Example:
%     Download the data of 5 technology stocks and save the result
%     in the C:\StockData directory:
%
%     getyahoo10('AAPL,AMZN,GOOG,IBM,SAP', 'C:\StockData');
%   
%   Author: TA Developer Pty Ltd (www.tadeveloper.com)

% text data
posdate     = 1;

% numerical data
posopen     = 1;
poshigh     = 2;
poslow      = 3;
posclose    = 4;
posvolume   = 5;
posadjclose = 6;

startvec = datevec(addtodate(datenum(date), -10, 'year'));
endvec = datevec(date);

urlStart = 'http://ichart.finance.yahoo.com/table.csv?s=';
urlEnd = [ '&a=' num2str(startvec(2)-1) '&b=' num2str(startvec(3)) '&c=' num2str(startvec(1))];
urlEnd = [urlEnd '&d=' num2str(endvec(2)-1) '&e=' num2str(endvec(3)) '&f=' num2str(endvec(1))];
urlEnd = [urlEnd '&g=d&ignore=.csv'];

symbolVec=textscan(symbols,'%s', 'delimiter', ',');

for cellSymbol=symbolVec{1}'
    symbol=char(cellSymbol{1});    
    disp(['Downloading: ' symbol]);
    path = [ directory '/' symbol '.csv' ];
    url = [ urlStart symbol urlEnd ];    
    urlwrite(url, path);
    data = importdata(path,',',1);
    adjfactor = data.data(:,posadjclose) ./ data.data(:,posclose);
    open = adjfactor .* data.data(:,posopen);
    high = adjfactor .* data.data(:,poshigh);
    low = adjfactor .* data.data(:,poslow);
    close = adjfactor .* data.data(:,posclose);
    volume = data.data(:,posvolume);

    noOfItems = size(close, 1);

    csvSeparator = repmat(',',noOfItems,1);
    csvText=strcat(char(data.textdata(2:noOfItems+1,posdate)),csvSeparator,num2str(open),csvSeparator,num2str(high),csvSeparator,num2str(low),csvSeparator,num2str(close),csvSeparator,num2str(volume));
    csvCells=cellstr(csvText);
    fileid=fopen(path,'w');
    fprintf(fileid, 'Date,Open,High,Low,Close,Volume\r\n');
    fprintf(fileid, '%s\r\n', csvCells{:});
    fclose(fileid);
end

end