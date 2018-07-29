function [Out, Settings] = MSSQLconn(dbname, userpassmethod, varargin)

% MSSQLCONN Establishes connection with MS SQL 
% 
%   MSSQLCONN(DBNAME) Every other input by default
%       - dbname: database name to which you want to connect (char format)
%       
%   MSSQLCONN(DBNAME, USERPASSMETHOD) Supply username and password, else by default
%       - userpassmethod --> {'username','password'}; 1st cell username,2nd cell password
%       - userpassmethod --> '-win'; use windows authentication (only for R2008b)
%       - userpassmethod --> '-manual'; supply credentials through inputdlg
%
%   MSSQLCONN(DBNAME,USERPASSMETHOD,OPTIONAL1...3) Supply variable number of optionals. 
%       - servername: string with the server where the database is hosted
%       - portnumber: integer of the port
%       - oldversion: if MS SQL is older than 2005 ed. supply '-old';
%
%   [OUT,SETTINGS] = ...
%       - Class 'database': connection to the server.
%       - Class 'structure' with the settings used to connect (except password).
%
%   DEFAULT SETTINGS:
%       - user = ''; 
%       - pass = '';
%       - server = 'localhost';
%       - port = 1433;
%       - driver = 'com.microsoft.sqlserver.jdbc.SQLServerDriver' (MS SQL 2005 and above);
%       - windows authentication: false;
%
% Examples:
%   - MSSQLconn('MyDB')                      % use the whole set of default settings
%   - MSSQLconn('MyDB',{'Oleg','****'})      % supply username and password 
%   - MSSQLconn('MyDB',{'Oleg',''})          % supply just the username, password by inputdlg 
%   - MSSQLconn('MyDB','-win')               % use windows authentication 
%   - MSSQLconn('MyDB','-manual')            % supply both username and password through inputdlg
%   - MSSQLconn(...,'myserver')              % supply servername with any combination of dbname and userpassmethod 
%   - MSSQLconn(...,1433, 'myserver','-old') % full set of optionals
%
% Additional features: 
% - <a href="matlab: web('http://msdn.microsoft.com/en-us/data/aa937724.aspx','-browser')">MS SQL server JDBC Driver Webpage</a>
% - <a href="matlab: web('http://www.mathworks.com/matlabcentral/fileexchange/25577-ms-sql-jdbc-connection','-browser')">FEX MSSQLconn page</a>
% - <a href="matlab: web('http://www.mathworks.com/support/solutions/en/data/1-9SHNAT/','-browser')">TMW Support Win Authentication</a>
% 
% See also DATABASE

% Author: Oleg Komarov (oleg.komarov@hotmail.it)
% Date: 13 oct 2009 - created
%       14 oct 2009 - added links to MS JDBC drivers and to FEX submission page
%       28 oct 2009 - reorganized input checks and added single input syntax
%       11 nov 2009 - changed input syntax; added win authentication, TMW support link and settings output
            

%-------------------------------------------------------------------------------------
% CHECK part 
%-------------------------------------------------------------------------------------

% 1. # of inputs
error(nargchk(1,5,nargin))

% 2. dbname
if ~ischar(dbname);  error('MSSQLconn:strFmt', 'dbname must be char'); end

% 3. userpassmethod
if nargin == 1 || isempty(userpassmethod); 
    method = '-default';
elseif iscell(userpassmethod)
    method = '-cell';
else method = userpassmethod;
end
winAuth = 'false'; user = ''; pass = '';                                      % Default values
switch method
    case '-default'                                                           % Use default values
    case '-cell'
        if numel(userpassmethod) == 2                                         % [1] IF 2 cells
        user = userpassmethod{1}; pass = userpassmethod{2};
            if ~isempty(user) && ischar(user) && isempty(pass)                % [2] IF pass empty
            while isempty(pass) 
                pass = inputdlg('Supply password: ', 'Empty not admitted',1); 
                pass = pass{:};
            end
            elseif ~isempty(pass) && ischar(pass) && isempty(user)            % [2] IF user empty
            while isempty(user) 
                user = inputdlg('Supply username: ', 'Empty not admitted',1); 
                user = user{:};
            end
            end
        else error('MSSQLconn:upmFmt', 'userpassmethod wrong format');               
        end
    case '-win'
        if any(str2double(struct2cell(ver('database'))) < 3.5) ;
           error('MSSQLconn:wauMth', 'Feature unavailable for Database Toolbox release older than 3.5 (R2008b)')
        else winAuth = 'true';
        end
    case '-manual'
         while isempty(user) || isempty(pass)
            userpass = inputdlg({'Supply username: '; 'Supply password: '}, 'ENTER BOTH',1,{'',''},'on');
            user = userpass{1}; pass = userpass{2};
        end
end
 
% 4. Oldver
IDXo = strcmp('-old',varargin);
if any(IDXo)
    drv = 'com.microsoft.jdbc.sqlserver.SQLServerDriver'; 
else
    drv = 'com.microsoft.sqlserver.jdbc.SQLServerDriver'; 
end
    
% 5. Port
IDXn = cellfun(@isnumeric,varargin);
if nnz(IDXn) == 1 && mod(varargin{IDXn},1) == 0
    port = num2str(varargin{IDXn});
elseif nnz(IDXn) > 1 
    error('MSSQLconn:prtFmt', 'Only one numeric integer port is accepted')
else port = '1433';
end

% 6. Server
IDXs = cellfun(@ischar, varargin) & ~IDXo;
if any(IDXs); server = varargin{IDXs}; else server = 'localhost'; end

%-------------------------------------------------------------------------------------
% ENGINE part
%-------------------------------------------------------------------------------------

% Url concatenation
URL = ['jdbc:sqlserver://' server ':' port ';database=' dbname ';integratedSecurity=' winAuth ';']; 

% Set connection timeout (s)
logintimeout(drv, 10);

% Connect
Out = database('', user, pass, drv, URL);

% Settings 
if nargout == 2 
    Settings = cell2struct({dbname; user; drv; server; port; ~strcmp(winAuth,';');Out.Message},...
    {'databaseName'; 'user'; 'driver'; 'server'; 'port'; 'windowsAuthentication'; 'errorMsg'});
end

% [1] IF connected
if isconnection(Out)
    % Initialize Status
    Status = '.';
    % [2] IF readonly
    if isreadonly(Out); Status = ' in "READONLY" mode.'; end % [2]
    % Display connection status
    sprintf('Connected%s', Status)
else % [1] IF not connected
    % Display error
    error('MSSQLconn:conInv',Out.Message)
end % [1]

end
