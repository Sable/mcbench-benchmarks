% Package: Quandl
% Function: quandl
% Pulls data from the Quandl API.
% Inputs:
% Required:
% code - Quandl code of dataset wanted. String.
% Optional:
% start_date - Date of first data point wanted. String. 'yyyy-mm-dd'
% end_date - Date of last data point wanted. String. 'yyyy-mm-dd'
% transformation - Type of transformation applied to data. String. 'diff','rdiff','cumul','normalize'
% collapse - Change frequency of data. String. 'weekly','monthly','quarterly','annual'
% rows - Number of dates returned. Integer.
% authcode - Authentication token used for continued API access. String.
% Returns:
% timeseries - If only one time series in the dataset.
% tscollection - If more than one time series in the dataset.

function [tsc] = quandl(code, varargin)
    % Parse input.
    p = inputParser;
    p.addRequired('code');
    p.addOptional('start_date',[]);
    p.addOptional('end_date',[]);
    p.addOptional('transformation',[]);
    p.addOptional('collapse',[]);
    p.addOptional('rows',[]);
    p.addOptional('authcode',[]);
    p.parse(code,varargin{:})
    start_date = p.Results.start_date;
    end_date = p.Results.end_date;
    transformation = p.Results.transformation;
    collapse = p.Results.collapse;
    rows = p.Results.rows;
    authcode = p.Results.authcode;
    % Defining auth_token to be used for mutiple function calls.
    persistent auth_token;
    
    string = strcat('http://www.quandl.com/api/v1/datasets/',code,'.csv?sort_order=asc');
    % Check for authetication token in inputs or in memory.
    if size(authcode) == 0
        if isempty(auth_token)
            'It would appear you arent using an authentication token. Please visit http://www.quandl.com/help/r or your usage may be limited.'
        else
            string = strcat(string, '&auth_token=',auth_token);
        end
    else
        auth_token = authcode;
        string = strcat(string, '&auth_token=',authcode);
    end
    % Adding API options.
    if size(start_date)
        string = strcat(string, '&trim_start=', start_date);
    end
    if size(end_date)
        string = strcat(string, '&trim_end=',end_date);
    end
    if size(transformation)
        string = strcat(string, '&transformation=',transformation);
    end
    if size(collapse)
        string = strcat(string, '&collapse=',collapse);
    end
    if size(rows)
        string = strcat(string, '&rows=',num2str(rows));
    end
    % Loading csv and checking if it exists.
    try
        csv = urlread(string);
    catch
        error('Quandl:code','Code does not exist.')
    end
    % Parsing input to be passed as a time series.
    csv = strread(csv,'%s','delimiter','\n');

    headers = strread(csv{1},'%s','delimiter',',');
    rowz = length(csv)-1;
    columns = length(headers);

    data = zeros(rowz,columns-1);
    for i = 1:rowz
        temp = str2num(csv{i+1}(12:end));
        if i == 1
            DATE = csv{i+1}(1:10);
        else
            DATE = char(DATE,csv{i+1}(1:10));
        end
        data(i,:) = temp;
    end
    DATE = cellstr(DATE);
    % Creating time series from raw data.
    ts = timeseries(data(:,1),DATE,'name',headers{2});
    if columns > 2
        tsc = tscollection({ts},'name',code);
        for i = 2:(columns-1)
            tsc = addts(tsc,data(:,i),headers{i+1});
        end
    else
        tsc = ts;
    end
end