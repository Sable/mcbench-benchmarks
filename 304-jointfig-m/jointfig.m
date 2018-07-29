function jointfig(hfig,no_row,no_col)

%   jointfig(hfig,no_row,no_col)
%	--> joint subplots without any space between them
%   hfig : figure handler, if none, keyin gcf instead
%   no_row    : No. of row subplots
%   no_col    : No. of column subplots
%
%                 DO-SIG GONG,
%				  mail: D.Gong@soton.ac.uk
%				  HFRU/ISVR, University of Southampton, UK
%				  latest modified at 99-03-01 7:27PM

% All the movement of subplots should be done in unit of points
figure(hfig), hsubplot = get(hfig,'Children');
% convert the position unit from pixel into points : should be restored)
set(hfig,'unit','point')

% BEWARE! hsubplot has different order from the original subplot sequence
% for instance,
%
%  -----------------------         -----------------------
%  |     1    |     2     |        |     4    |     3     |
%  |----------+-----------|        |----------+-----------|
%  |     3    |     4     |        |     2    |     1     |
%  -----------------------         -----------------------
%       subplot(22i)                  get(gcf,'Children')
%
% THEREFORE, transpose hsubplot into the one in original subplot sequence, like this..

hsubplot = hsubplot(length(hsubplot):-1:1);

no_subplot1 = length(hsubplot);
no_space  = no_row*no_col;
no_delta = no_space - no_subplot1;

% in case of the odd number of subplots
if no_delta,
	for i = 1:no_delta
		addsubplot = subplot(no_row,no_col,no_subplot1+i);
		hsubplot = [hsubplot; addsubplot];
	end
end

no_subplot = length(hsubplot);

% Default position of figure in a window in point coord

for i=1:no_subplot,
	set(hsubplot(i),'unit','point'),
	tmp_ylab_pos = get(get(hsubplot(i),'ylabel'),'position');
	ylab_pos(i) = tmp_ylab_pos(1);
end

new_ylab_pos = min(ylab_pos);

coner1 = get(hsubplot(1),'position');
coner2 = get(hsubplot(length(hsubplot)),'position');

% position of lowest-left coner
inix = coner1(1);
iniy = coner2(2)*1.13;

% axis line width
alinewidth = get(hsubplot(1),'linewidth');

% total lengths
total_xlength = (coner2(1) + coner2(3) - coner1(1)) + (no_col-1) * alinewidth;
total_ylength = (coner1(2) + coner1(4) - coner2(2)) + (no_row-1) * alinewidth;

% width of each subplot
delx = 1.0 * total_xlength / no_col;  

% height of each subplot
dely = 0.97 * total_ylength / no_row;  

%index_loop = 0;                   % total subplots index
%for index_row = 1:no_row,         % loop for row index
%    for index_col = 1:no_col          % loop for column index
%        index_loop = index_loop+1;
%
%        startx = inix + (index_col - 1) * delx;
%        starty = iniy + (no_row - index_row) * dely;
%
%%.......It's kind of bug of MATLAB
%        if alinewidth < 1.0
%           set(hsubplot(index_loop),'position',...
%              [ startx - 0.5 * alinewidth * (index_col-1), ...
%                starty - 0.5 * alinewidth * (index_row-1), delx ,dely]);
%%              [startx-1.0*alinewidth*(index_col-1), starty+1.5*alinewidth*(index_row-1), delx ,dely]);
%        else
%           set(hsubplot(index_loop),'position',[startx, starty, delx ,dely]);
%        end
%
%        subplot(hsubplot(index_loop));

index_loop = no_subplot+1;              % total subplots index (reverse order)
for index_row = no_row:-1:1,             % loop for row index
    for index_col = no_col:-1:1          % loop for column index
        index_loop = index_loop - 1;

        startx = inix + (index_col - 1) * delx;
        starty = iniy + (no_row - index_row) * dely;
        POSITION = [startx, starty, delx ,dely];

%.......It's kind of bug of MATLAB
        if alinewidth < 1.0
           POSITION =  [ startx - 0.5 * alinewidth * (index_col-1), ...
                         starty + 0.9 * alinewidth * (index_row-1), delx ,dely];
%          POSITION =  [startx-1.0*alinewidth*(index_col-1), starty+1.5*alinewidth*(index_row-1), delx ,dely]);
        end

        set(hsubplot(index_loop),'position',POSITION);
		
        subplot(hsubplot(index_loop));

        iscale = size(get(gca,'yscale'),2);  % 3:log, 6:linear

        % remove xlabels & xticklabels of subplots located in upper rows other than lowest row

        if index_row ~= no_row,
        	if ~(no_delta & index_row == (no_row - 1) & index_col == no_col),
            	set(get(gca,'xlabel'),'String',[])
            	set(gca,'xticklabel',[]);  %remove xticklabel
            end
        end

        % remove ylabels & yticklabels of subplots located in right columns other than leftmost column
        if index_col ~= 1,
           set(get(gca,'ylabel'),'String',[])
           set(gca,'yticklabel',[]);  %remove yticklabel
        end

        % remove first yticklabel of subplots located in lower rows other than highest row, linear yscale only
		% .... only linear scale
        if index_row ~= 1 & iscale == 6
           	a = get(gca,'ytick'); b = get(gca,'ylim');
			if a(length(a)) == b(length(b)), 
           		a = a(1:length(a)-1); 
           		set(gca,'ytick',a); 
           	end
        end

        % remove first xticklabel of subplots located in left columns other than rightmost column
		% .... only linear scale
		
		if ~no_delta,
  	      	if index_col ~= no_col & iscale == 6
       	       	a = get(gca,'xtick'); b = get(gca,'xlim');
           	   	if a(length(a)) == b(length(b)), 
          			a = a(1:length(a)-1); 
           			set(gca,'xtick',a); 
           		end
        	end
        else
	   	    if index_col == no_col & index_row == no_row - 1 & iscale == 6,
       	       	a = get(gca,'xtick'); 
          		a = a(2:length(a)); 
           		set(gca,'xtick',a); 
           	end	
        end	

   end
end

% get back to initial unit
set(hfig,'unit','default')
for i=1:no_subplot,	set(hsubplot(i),'unit','default'),end

% delete dummy subplots
if no_delta, for i = 1:no_delta, delete(hsubplot(no_subplot1+i)); end, end
