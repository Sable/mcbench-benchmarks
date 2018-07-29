function varargout = htmlcal(startdate,stopdate,htmlfile,days)
% HTMLCAL Create an HTML calendar for a range of months.
%    HTMLCAL(FIRSTMONTH,LASTMONTH) creates an HTML file with one or more
%    monthly calendars. Use 'mm/yyyy' or 'mm-yyyy' strings to specify the
%    months. You will be prompted for the name of the output file, whose
%    name will be returned as output if any output variable is given.
%
%    HTMLCAL(FIRSTMONTH,LASTMONTH,HTMLFILE) also specifies the name of the
%    output file.
%
%    HTMLCAL(FIRSTMONTH,LASTMONTH,HTMLFILE,DAYS) allows you to specify
%    which days of the week are included, as a length-7 logical vector
%    starting with Sunday. The default is [0 1 1 1 1 1 0], for M-F.
%
%    HTMLCAL by itself prompts for the first and last month as well as the
%    file name, and offers to show the calendar in a web browser. 
%
%    See also DATENUM, DATEVEC.

% Copyright 2005 by Toby Driscoll. 
% Created 20 January 2005. 
%         30 August 2007 -- documentation added, style tweaked

if nargin < 2
  if nargin < 1
    dv = datevec(date);
    default = sprintf('%i/%i',dv(2),dv(1));
    startdate = input(['First month (',default,')? '],'s');
    if isempty(startdate), startdate = default; end
    default = startdate;
    stopdate = input(['Last month (',default,')? '],'s');
    if isempty(stopdate), stopdate = default; end
  else
    stopdate = startdate;
  end
end
  
if nargin < 3 || isempty(htmlfile)
  [fn,pn] = uiputfile( {'*.html','HTML Files'}, ...
                       'Select output file');
  if isequal(fn,0) || isequal(pn,0)
    error('No output file selected.')
  else
    htmlfile = fullfile(pn,fn);
  end
end

if nargin < 4 || isempty(days)
  days = logical([ 0 1 1 1 1 1 0 ]);
elseif ischar(days)
  % This allows the "command syntax" to work consistently.
  days = eval(days);   
end
days = days(:).';

mth = {'January','February','March','April','May','June',...
      'July','August','September','October','November','December'};
dow = {'Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'};

% Parse dates.
[m0,startdate] = strtok(startdate,'/-');
[y0,startdate] = strtok(startdate,'/-');
[m1,stopdate] = strtok(stopdate,'/-');
[y1,stopdate] = strtok(stopdate,'/-');

m0 = str2double(m0);  m1 = str2double(m1);
y0 = str2double(y0);  y1 = str2double(y1);
if any(isnan([m0 y0 m1 y1]))
  error('Invalid month specification.')
end

% Open output file and write headers.
outfile = CreateHTMLFile(htmlfile);

% Walk through month by month.
m1 = m1 + 12*(y1-y0);			% account for year-end boundaries
numdays = sum(days);
for m = m0:m1
  Month = rem(m-1,12) + 1;
  Year = y0 + floor(m/13);
  MonthName = mth{Month};

  cal = calendar(Year,Month);

  select = false(size(cal));
  select(:,days) = 1;                   % include these days
  select(~cal) = 0;			% but not those outside the
                                        % actual month
  
  % Begin table in output.
  fmt = '<div class="monthname">%s %i</div>\n';
  fprintf(outfile,fmt,MonthName,Year);
  fprintf(outfile,...
          '<table class="calendar" align="center" width=85%% border=1>\n');
  
  % Header row.
  fprintf(outfile,'<tr>\n  ');
  for d=find(days)
    fprintf(outfile,'<th width=%i%%>%s</th>',round(100/numdays),dow{d});
  end
  fprintf(outfile,'\n</tr>\n');
  
  % Body.
  for week = 1:size(cal,1)
    if any(select(week,:))
      fprintf(outfile,'<tr>\n');
      for day = find(days)
        fprintf(outfile,'  <td>');
        if select(week,day)
          fprintf(outfile,'<div class="date">%2i</div>',cal(week,day));
        end
        fprintf(outfile,'</td>\n');
      end
      fprintf(outfile,'</tr>\n');
    end
  end
  
  % End the month
  fprintf(outfile,'</table>\n\n');
end
    
fclose(outfile);

% Wrap up
if nargin==0
  msg = 'Do you want to view the calendar in a browser window?';
  answer = questdlg(msg,'Success!','Yes','No','Yes');
  if strcmp(answer,'Yes')
    web(htmlfile,'-browser');
  end
end

if nargout > 0
  varargout{1} = htmlfile;
end

% --------------------------------------------------------------------
function outfile = CreateHTMLFile(htmlfile)

% Create an HTML output file with a stylesheet header. Returns file id
% used by fprintf.

[outfile,msg] = fopen(htmlfile,'w');
if ~isempty(msg)
  error(msg)
end

headstr = { 
    '<!-- Uncomment the follwing link if you want to move the style elements'
    '     into a separate file called calendar.css. -->'
    '<!-- link rel="stylesheet" type="text/css" href="calendar.css" -->'
    '<style type="text/css">'
    '.calendar {'
    '    margin-bottom:3em;'
    '  }'
                      ''
    '.calendar td {'
    '    vertical-align:top;'
    '    font-size:smaller;'
    '    height:5em;'
    '  }'
                      ''
    '.calendar th {'
    '    background : #fff7cc;'
    '    font : bold medium;'
    '    color : #00008b;'
    '    text-align : center;'
    '  }'
                      ''
    '.date {'
    '    font-weight:bold;'
    '    text-align:right;'
    '    font-size:larger;'
    '    margin:0px 0px 2px 0px;'
    '  }'
                      ''
    '.date a {'
    '    color : black;'
    '    background :  #DEE4FF;'
    '    text-decoration:none;'
    '    padding: 0px 3px 2px 3px;'
    '    border-style: none solid solid none;'
    '    border-width : thin;'
    '    border-color: grey;'
    '  }'

    '.date a:hover {'
    '    background-color:#FFF091;'
    '  }'
                      ''
    '.monthname {'
    '    color : #555555;'
    '    display : block;'
    '    font-size : 140%;'
    '    margin-bottom : 1ex;'
    '    margin-left : 0ex;'
    '    margin-right : 0ex;'
    '    margin-top : 2ex;'
    '    text-align : center;'
    '  }'
    '</style>'
          };
    
fprintf(outfile,'%s\n',headstr{:});
fprintf(outfile,'\n');


