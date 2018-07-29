function google_GeoCodeAddress(KEY,location)
MAPS_HOST = 'maps.google.com';

%location = '1217 fayettevelle St., Durham,NC'; 

%developers key
%KEY='ABQIAAAA7VerLsOcLuBYXR7vZI2NjhTRERdeAiwZ9EeJWta3L_JZVS0bOBRIFbhTrQjhHE52fqjZvfabYYyn6A'

 base_url =[ 'http://'  MAPS_HOST '/maps/geo?output=xml&key='  KEY];

    request_url = [base_url '&q=' location];
    
    try
    docNode = xmlread(request_url);
    catch  %#ok<CTCH>
        error('URL Read Error',...
            ['Could not reach Google server, please check your AppID ', char(13),...
            'to make sure it is valid.']);
    end
    
    
    % Loop over the results and create a struct for them
resultList = docNode.getElementsByTagName('Placemark');
results = [];
for idx = 1:resultList.getLength
    resultNode = resultList.item(idx-1);
    results(idx).coords = char(GetElementText(resultNode,'coordinates'));
    lat_lon= findstr(',',results(idx).coords);
    results(idx).Latitude = results(idx).coords(1:lat_lon(1)-1);
    results(idx).Longitude = results(idx).coords(lat_lon(1)+1:lat_lon(2)-1);
    results(idx).Address = GetElementText(resultNode,'ThoroughfareName');
    results(idx).City = GetElementText(resultNode,'LocalityName');
    results(idx).State = GetElementText(resultNode,'AdministrativeAreaName');
    results(idx).Zip = GetElementText(resultNode,'PostalCodeNumber');
    results(idx).Country = GetElementText(resultNode,'CountryName');
end
disp('Latitude is')
disp(results.Latitude)
disp('Longitude is')
disp(results.Longitude)
end



function elementText = GetElementText(resultNode,elementName)
% GETELEMENTTEXT given a result node and an element name
% returns the text within that node

elementText = ...
    resultNode.getElementsByTagName(elementName).item(0).getTextContent;

end


