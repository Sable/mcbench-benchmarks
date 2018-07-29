% -----------------------------------------------
function dateNtick(ax,dateform)
%
%SPECIALIZED VERSION OF DATETICK
%   ADDS ANOTHER OPTION (#19) ALLOWS DATES TO BE DISPLAYED
%   ON TWO LINES
%   TESTED ON MATLAB 5.3
%
%DATETICK Date formatted tick labels. 
%   DATETICK(TICKAXIS,DATEFORM) annotates the specified tick axis with
%   date formatted tick labels. TICKAXIS must be one of the strings
%   'x','y', or 'z'. The default is 'x'.  The labels are formatted
%   according to the format number or string DATEFORM (see table
%   below).  If no DATEFORM argument is entered, DATETICK makes a
%   guess based on the data for the objects within the specified axis.
%   To produce correct results, the data for the specified axis must
%   be serial date numbers (as produced by DATENUM).
%
%   DATEFORM number   DATEFORM string         Example
%      0             'dd-mmm-yyyy HH:MM:SS'   01-Mar-1995 15:45:17 
%      1             'dd-mmm-yyyy'            01-Mar-1995  
%      2             'mm/dd/yy'               03/01/95     
%      3             'mmm'                    Mar          
%      4             'm'                      M            
%      5             'mm'                     3            
%      6             'mm/dd'                  03/01        
%      7             'dd'                     1            
%      8             'ddd'                    Wed          
%      9             'd'                      W            
%     10             'yyyy'                   1995         
%     11             'yy'                     95           
%     12             'mmmyy'                  Mar95        
%     13             'HH:MM:SS'               15:45:17     
%     14             'HH:MM:SS PM'             3:45:17 PM  
%     15             'HH:MM'                  15:45        
%     16             'HH:MM PM'                3:45 PM     
%     17             'QQ-YY'                  Q1-96        
%     18             'QQ'                     Q1
%     19             'mm/dd over HH:MM'       03/01
%                                             15:45  
%
%       
%
%   If the HOLD is ON then DATETICK, will change the tick labels into
%   date-based labels without changing their locations.  When the HOLD
%   is OFF, DATETICK changes the locations of the ticks as well.
%
%Here is an example of how to use dateNtick
%
%yr = 1999;
%M = 10;
%MI = 0;
%sec = 0;
%
%X = [];
%
%for day = 3:4,
%   for  hr = 0:.2:23.5,
%      X = [X; datenum(yr,M,day,hr,MI,sec)]; 
%    end
%end
%
%Y = rand(length(X),1);
%
%plot(X,Y); grid
%
%hold
%dateNtick('x',19);
%hold off
%
%   DATETICK relies on DATESTR to convert date numbers to date strings.
%
%   Example (based on the 1990 U.S. census):
%      t = (1900:10:1990)'; % Time interval
%      p = [75.995 91.972 105.711 123.203 131.669 ...
%          150.697 179.323 203.212 226.505 249.633]';  % Population
%      plot(datenum(t,1,1),p) % Convert years to date numbers and plot
%      datetick('x','yyyy') % Replace x-axis ticks with 4 digit year labels.
%    
%   See also DATESTR, DATENUM.
%
%		Author(s): C.F. Garvin, 4-03-95, Clay M. Thompson 1-29-96
%   Copyright (c) 1984-98 by The MathWorks, Inc.
%
%
%   $Revision: 1.14 $  $Date: 1997/11/21 23:48:01 $
%     added #19 to do 2 lines (date/time) at each tick.         
%     By Arthur Newhall
%			anewhall@whoi.edu


labels = [];


if nargin == 0
  ax = 'x';
end


if nargin==1 & ~isstr(ax),
  error('The axis must be ''x'',''y'', or ''z''.');
end


% Compute data limits.  If the limits are manual, use them instead of
% looking at the data to determine vmin and vmax.
if strcmp(get(gca,[ax 'limMode']),'manual')
  lim = get(gca,[ax 'lim']);
  vmin = lim(1);
  vmax = lim(2);
else
  h = get(gca,'children');
  vmin = inf; vmax = -inf;
  for i=1:length(h),
    t = get(h(i),'type');
    if strcmp(t,'surface') | strcmp(t,'patch') | ...
       strcmp(t,'line') | strcmp(t,'image') 
      vdata = get(h(i),[ax,'data']);
      vmin = min(vmin,min(vdata(:)));
      vmax = max(vmax,max(vdata(:)));
    elseif strcmp(t,'text')
      pos = get(h(i),'position');
      switch ax
      case 'x'
        vdata = pos(1);
      case 'y'
        vdata = pos(2);
      case 'z'
        vdata = pos(3);
      end
      vmin = min(vmin,min(vdata(:)));
      vmax = max(vmax,max(vdata(:)));
    end
  end
end


if nargin==2 & isstr(dateform), % Determine dateformat from string.
  switch dateform
  case 'dd-mmm-yyyy HH:MM:SS', dateform = 0;
  case 'dd-mmm-yyyy', dateform = 1;
  case 'mm/dd/yy', dateform = 2;
  case 'mmm', dateform = 3;
  case 'm', dateform = 4;
  case 'mm', dateform = 5;
  case 'mm/dd', dateform = 6;
  case 'dd', dateform = 7;
  case 'ddd', dateform = 8;
  case 'd', dateform = 9;
  case 'yyyy', dateform = 10;
  case 'yy', dateform = 11;
  case 'mmmyy', dateform = 12;
  case 'HH:MM:SS', dateform = 13;
  case 'HH:MM:SS PM', dateform = 14;
  case 'HH:MM', dateform = 15;
  case 'HH:MM PM', dateform = 16;
  case 'QQ-YY', dateform = 17;
  case 'QQ', dateform = 18;
  case 'mm/dd-HH:MM', dateform = 19;
  otherwise
    error(sprintf('Unknown date format: %s',dateform))
  end
end


% If hold is on don't change the axis tick locations
if ~ishold,
    if nargin==2,
      switch dateform
      case 0, dateChoice = 'yqmwdHMS';
      case 1, dateChoice = 'yqmwd';
      case 2, dateChoice = 'yqmwd';
      case 3, dateChoice = 'yqm';
      case 4, dateChoice = 'yqm';
      case 5, dateChoice = 'yqm';
      case 6, dateChoice = 'yqmwd';
      case 7, dateChoice = 'yqmwd';
      case 8, dateChoice = 'yqmwd';
      case 9, dateChoice = 'yqmwd';
      case 10, dateChoice = 'y';
      case 11, dateChoice = 'y';
      case 12, dateChoice = 'yqm';
      case 13, dateChoice = 'yqmwdHMS';
      case 14, dateChoice = 'yqmwdHMS';
      case 15, dateChoice = 'yqmwdHMS';
      case 16, dateChoice = 'yqmwdHMS';
      case 17, dateChoice = 'yq';
      case 18, dateChoice = 'yq';
      case 19, dateChoice = 'yqmwd';            % same as 6  Newhall
      otherwise
        error('Date format number must be between 0 and 18.');
      end
      ticks = bestscale(vmin,vmax,dateChoice);
    else
      [ticks,dateform] = bestscale(vmin,vmax);
    end
else
    ticks = get(gca,[ax,'tick']);
end


% ..............................................
% Set axis tick labels      newhall
if dateform == 19, 
     if ax ~= 'x',
         fprintf('Option 19 can only be used with x axis... sorry\n');
         return
     end
     dateform = 6; 
     another = 1;
end
% ..............................................


labels = datestr(ticks,dateform);
set(gca,[ax,'tick'],ticks,[ax,'ticklabel'],labels, ...
        [ax,'lim'],[min(ticks) max(ticks)])


% ..............................................
% newhall
if another == 1,


        xt = get(gca,'XTick');
        yt = get(gca,'YTick');


        set(gca,'units','inches');
        yax = get(gca,'position'); 
        yaxlinch = yax(4);
        ylims = get(gca,'ylim');
        
        offset =  .25 * (ylims(2)-ylims(1)) / yaxlinch
        yy = ylims(1) - offset;


        xlen = ( xt(length(xt)) - xt(1) ) * .027;
        ypos = yy * ones(length(xt),1);
 
        labels = datestr(xt,15);
        text(xt-xlen,ypos,labels);


        set(gca,'units','normal');
end   % 19



aa = get(get(gca,'xlabel'),'position');
offset = ylims(1) - ( .4 * (ylims(2)-ylims(1)) / yaxlinch)
set(get(gca,'xlabel'),'position',[aa(1) offset 0])


%.................................................




%--------------------------------------------------
function [labels,format] = bestscale(xmin,xmax,dateChoice)
%BESTSCALE Returns ticks for "best" scale.
%   [TICKS,FORMAT] = BESTSCALE(XMIN,XMAX) returns the tick
%   locations in the vector TICKS that span the interval (XMIN,XMAX) 
%   with "nice" tick spacing.  The dateform FORMAT is also returned.


if nargin<3, dateChoice = 'yqmwdHMS'; end
penalty = 0.03;


% Compute xmin, xmax if matrices passed.
if length(xmin) > 1, xmin = min(xmin(:)); end
if length(xmax) > 1, xmax = max(xmax(:)); end


% "Good" spacing between dates
if xmin==xmax, 
    xmin = xmin-1;
    xmax = xmax+1;
end
yearDelta = 10.^(max(0,round(log10(xmax-xmin)-3)))* ...
                 [ .1 .2 .25 .5 1 2 2.5 5 10 20 25 50];
yearDelta(yearDelta<1)= []; % Make sure we use integer years.
quarterDelta = [3];
monthDelta = [1];
weekDelta = 1;
dayDelta = [1 2];
hourDelta = [1 3 6];
minuteDelta = [1 5 10 15 30 60];
secondDelta = min(1,10.^(round(log10(xmax-xmin)-1))* ...
                  [ .1 .2 .25 .5 1 2 2.5 5 10 20 25 50 ]);
secondDelta = [secondDelta 1 5 10 15 30 60];
    
x = [xmin xmax];
[y,m,d] = datevec(x);


% Compute continuous variables for the various time scales.
year = y + (m-1)/12 + (d-1)/12/32;
qtr = (y-y(1))*12 + m + d/32 - 1;
mon = (y-y(1))*12 + m + d/32; 
day = x;
week = (x-2)/7;
hour = (x-floor(x(1)))*24;
minute = (x-floor(x(1)))*24*60;
second = (x-floor(x(1)))*24*3600;


% Compute possible low, high and ticks
if any(dateChoice=='y')
    yearHigh = yearDelta.*ceil(year(2)./yearDelta);
    yearLow = yearDelta.*floor(year(1)./yearDelta);
    yrTicks = round((yearHigh-yearLow)./yearDelta);
    yrHigh = datenum(yearHigh,1,1);
    yrLow = datenum(yearLow,1,1);
    % Encode location of year tick locations in format
    yrFormat = 10 + (1:length(yearDelta))/10;
else
    yrHigh=[]; yrLow=[]; yrTicks=[]; yrFormat = 10;
end 


if any(dateChoice=='q'),
    quarterHigh = quarterDelta.*ceil(qtr(2)./quarterDelta);
    quarterLow = quarterDelta.*floor(qtr(1)./quarterDelta);
    qtrTicks = round((quarterHigh-quarterLow)./quarterDelta);
    qtrHigh = datenum(y(1),quarterHigh+1,1);
    qtrLow = datenum(y(1),quarterLow+1,1);
    % Encode location of qtr tick locations in format
    qtrFormat = 17 + (1:length(quarterDelta))/10;
else
    qtrHigh=[]; qtrLow=[]; qtrTicks=[]; qtrFormat = [];
end


if any(dateChoice=='m'),
    monthHigh = monthDelta.*ceil(mon(2)./monthDelta);
    monthLow = monthDelta.*floor(mon(1)./monthDelta);
    monTicks = round((monthHigh-monthLow)./monthDelta);
    monHigh = datenum(y(1),monthHigh,1);
    monLow = datenum(y(1),monthLow,1);
    % Encode location of month tick locations in format
    monFormat = 3 + (1:length(monthDelta))/10;
else
    monHigh=[]; monLow=[]; monTicks=[]; monFormat = [];
end


if any(dateChoice=='w')
    weekHigh = weekDelta.*ceil(week(2)./weekDelta);
    weekLow = weekDelta.*floor(week(1)./weekDelta);
    weekTicks = round((weekHigh-weekLow)./weekDelta);
    weekHigh = weekHigh*7+2;
    weekLow = weekLow*7+2;
    weekFormat = 6*ones(size(weekDelta));
else
    weekHigh=[]; weekLow=[]; weekTicks=[]; weekFormat=[];
end


if any(dateChoice=='d'),
    dayHigh = dayDelta.*ceil(day(2)./dayDelta);
    dayLow = dayDelta.*floor(day(1)./dayDelta);
    dayTicks = round((dayHigh-dayLow)./dayDelta);
    dayFormat = 6*ones(size(dayDelta));
else
    dayHigh=[]; dayLow=[]; dayTicks=[]; dayFormat = [];
end


if any(dateChoice=='H'),
    hourHigh = hourDelta.*ceil(hour(2)./hourDelta);
    hourLow = hourDelta.*floor(hour(1)./hourDelta);
    hourTicks = round((hourHigh-hourLow)./hourDelta);
    hourHigh = datenum(y(1),m(1),d(1),hourHigh,0,0);
    hourLow = datenum(y(1),m(1),d(1),hourLow,0,0);
    hourFormat = 15*ones(size(hourDelta));
else
    hourHigh=[]; hourLow=[]; hourTicks=[]; hourFormat=[];
end


if any(dateChoice=='M')
    minHigh = minuteDelta.*ceil(minute(2)./minuteDelta);
    minLow = minuteDelta.*floor(minute(1)./minuteDelta);
    minTicks = round((minHigh-minLow)./minuteDelta);
    minHigh = datenum(y(1),m(1),d(1),0,minHigh,0);
    minLow = datenum(y(1),m(1),d(1),0,minLow,0);
    minFormat = 15*ones(size(minuteDelta));
else
    minHigh=[]; minLow=[]; minTicks=[]; minFormat=[];
end


if any(dateChoice=='S'),
    secHigh = secondDelta.*ceil(second(2)./secondDelta);
    secLow = secondDelta.*floor(second(1)./secondDelta);
    secTicks = round((secHigh-secLow)./secondDelta);
    secHigh = datenum(y(1),m(1),d(1),0,0,secHigh);
    secLow = datenum(y(1),m(1),d(1),0,0,secLow);
    secFormat = 13*ones(size(secondDelta));
else
    secHigh=[]; secLow=[]; secTicks=[]; secFormat=[];
end


% Concatenate all the date formats together to determine
% the best spacing.
high =  [yrHigh   qtrHigh   monHigh   dayHigh   weekHigh   hourHigh   minHigh   secHigh];
low =   [yrLow    qtrLow    monLow    dayLow    weekLow    hourLow    minLow    secLow];
ticks = [yrTicks  qtrTicks  monTicks  dayTicks  weekTicks  hourTicks  minTicks  secTicks];
format =[yrFormat qtrFormat monFormat dayFormat weekFormat hourFormat minFormat secFormat];


% sort the formats by number of ticks.
[ticks,ndx] = sort(ticks);
high = high(ndx);
low = low(ndx);
format = format(ndx);


% Chose the best fit
fit = (abs(xmin-low) + abs(high-xmax))./(high-low) + penalty*((ticks-5).^2);
i = find(fit == min(fit)); i=i(1);
low = low(i); high = high(i); ticks = ticks(i); format = format(i);


if floor(format) == 3, % Month format
  i = round(rem(format,1)*10); % Retrieve encoded value
  labels = datenum(y(1),linspace(monthLow(i),monthHigh(i),ticks+1),1);
  format = floor(format);
elseif floor(format) == 17, % Quarter format
  i = round(rem(format,1)*10); % Retrieve encoded value
  labels = datenum(y(1),linspace(quarterLow(i)+1,quarterHigh(i)+1,ticks+1),1);
  format = floor(format);
elseif floor(format) == 10, % Year format
  i = round(rem(format,1)*10); % Retrieve encoded value
  labels = datenum(linspace(yearLow(i),yearHigh(i),ticks+1),1,1);
  format = floor(format);
else
  labels = linspace(low,high,ticks+1);
end 