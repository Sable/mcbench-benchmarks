function results = YahooGeoCodeAddress(appId, location)
% YAHOOGEOCODEADDRESS given a developer Application ID (appId) 
% and string representing an address LOCATION, returns
% a structure containing the possible matches for the location. This
% function uses the Yahoo Maps Service - Geocoding API
% For more information please visit to get an appId
% http://developer.yahoo.com/maps/rest/V1/geocode.html

% Examples
% This is only a demo AppId 'YD-9G7bey8_JXxQP6rxl.fBFGgCdNjoDMACQA--'
% invalid data may result in using this AppId, you must get a real appId.
%
% results = GeoCodeAddress('YD-9G7bey8_JXxQP6rxl.fBFGgCdNjoDMACQA--','The MathWorks, Natick MA')
% results = GeoCodeAddress('YD-9G7bey8_JXxQP6rxl.fBFGgCdNjoDMACQA--','3 Apple Hill drive, Natick MA')
% results = GeoCodeAddress('YD-9G7bey8_JXxQP6rxl.fBFGgCdNjoDMACQA--','Natick MA')

% Throw a warning if they are using the demo AppId
if strcmp(appId,'YD-9G7bey8_JXxQP6rxl.fBFGgCdNjoDMACQA--')
   warning('YAHOOGEOCODE:usingdemoappid',...
       ['You are using the demo AppId provided by yahoo.', char(13),...
       'To get a valid AppID you must register at',char(13),...
       'http://developer.yahoo.com/maps/rest/V1/geocode.html']);
end

% The URL for Yahoos GeoCode API
url = 'http://local.yahooapis.com/MapsService/V1/geocode';

% Replace spaces with + signs, so it can go inside a URL
location = regexprep(location,'\s+','+');

% Query yahoo for the data
try
    docNode = xmlread([url '?appid=' appId '&location=' location]);
catch  %#ok<CTCH>
    error('YAHOOGEOCODE:urlreaderror',...
        ['Could not reach Yahoo server, please check your AppID ', char(13),...
        'to make sure it is valid.']);
end

% Check for errors
if docNode.getElementsByTagName('Error').getLength>0
   % Display the first error
   errorMessage = ...
       char(docNode.getElementsByTagName('Error').item(0).getTextContent);
   error('YAHOOGEOCODE:yahooerror',errorMessage);
end

% Loop over the results and create a struct for them
resultList = docNode.getElementsByTagName('Result');
results = [];
for idx = 1:resultList.getLength
    resultNode = resultList.item(idx-1);
    results(idx).precision = char(resultNode.getAttribute('precision')); %#ok<*AGROW>
    results(idx).Latitude = GetElementText(resultNode,'Latitude');
    results(idx).Longitude = GetElementText(resultNode,'Longitude');
    results(idx).Address = GetElementText(resultNode,'Address');
    results(idx).City = GetElementText(resultNode,'City');
    results(idx).State = GetElementText(resultNode,'State');
    results(idx).Zip = GetElementText(resultNode,'Zip');
    results(idx).Country = GetElementText(resultNode,'Country');
end
end

function elementText = GetElementText(resultNode,elementName)
% GETELEMENTTEXT given a result node and an element name
% returns the text within that node

elementText = ...
    resultNode.getElementsByTagName(elementName).item(0).getTextContent;

% remove any rogue commas and casts to a char
elementText = regexprep(char(elementText),',','');
end