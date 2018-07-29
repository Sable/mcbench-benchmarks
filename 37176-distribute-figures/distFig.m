function distFig(varargin)
% ===== Syntax ============================================================
%
% distFig(...,'Screen',Value)	/ distFig(...,'Scr',Value)
% distFig(...,'Position',Value) / distFig(...,'Pos',Value)
% distFig(...,'Rows',Value)
% distFig(...,'Not',Value)
% distFig(...,'Only',Value)
% distFig(...,'Offset',Value)
%
% ===== Description =======================================================
%
% distFig(...,'Screen',Value) assigns where the figures will be
% distributed. Value can be:
% 'Left' / 'L'
% 'Right' / 'R'
% 'Top' / 'T'
% 'Center' / 'C' (Default)
%
% distFig(...,'Position',Value) assigns in which part of the screen the
% figures will be distributed. Value can be:
% 'Left' / 'L'
% 'Right' / 'R'
% 'Center' / 'C' (Default)
%
% distFig(...,'Rows',Value) assigns how many rows the figures will be
% distributed on. Value must be an integer larger than zero. The default
% number of rows is 2.
%
% distFig(...,'Not',Value) excludes specified figures from the distribution
% list. Value must be an matrix with the excluded figure numbers.
%
% distFig(...,'Only',Value) does only distrubute specified figures. Value
% must be an matrix with the figure which will be destributed.
%
% distFig(...,'Offset',Value) can be used to shift all figures on the
% distribution list. Value must be an integer larger or equal to zero. The
% default offset value is 0.
%
% ===== Examples ==========================================================
%
% distFig();
% This will distribute all open figures on the primary screen in two rows.
%
% distFig('Screen','Left','Position','Right','Only',[1,2,4])
% This will only distrubute figure 1, 2 and 4 on the right part of the left
% screen.
%
% distFig('Offset',2,'Not',[1,2])
% This will distribute all figure but figure 1 and 2 in the same pattern as
% distFig(), but figure 1 and 2 will not be distributed, but instead there will
% be blank spots where they would have been distributed.
% 
% ===== Short notation ====================================================
% 
% An alternative way of using 'Screen', 'Position', 'Rows' and 'Offset' is
% to use the short notation. For example:
%
% distFig('sl');
% This will distribute all figures on the screen (s) to the left (l).
% 
% distFig('sr');
% This will distribute all figures on the screen (s) to the right (r).
% 
% distFig('pr');
% This will distribute all figures in positions (p) to the right (r).
% 
% distFig('r3');
% This will distribute the figures rows (r) - 3 rows.
% 
% distFig('o2');
% This will offset (o) the figures by 2 (2).
% 
% The short notations can be combined. For example:
% 
% distFig('slprr3o2');
% This will combine the four examples above and distribute the figures on
% the left screen (sl) in the right part (pr) in 3 rows (r3) and offset
% them by 2 figures (o2). An alternative and more clear way is to separate
% the notations with a comma which is also a valid input:
% distFig('sl,pr,r3,o2');

% =========================================================================
% ===== Default values ====================================================
% =========================================================================

Pos = 'Center';
Scr = 'Center';
Rows = 2;
Offset = 0;
Not = [];
Only = [];

% =========================================================================
% ===== Get inputs ========================================================
% =========================================================================

if (nargin > 0)
	if (mod(nargin,2) == 0)
		for i = 1:2:nargin
			switch lower(varargin{i})
				case {'position','pos'}
					switch lower(varargin{i+1})
						case {'right','r'}
							Pos = 'Right';
						case {'left','l'}
							Pos = 'Left';
					end
				case {'screen','scr'}
					switch lower(varargin{i+1})
						case {'right','r'}
							Scr = 'Right';
						case {'left','l'}
							Scr = 'Left';
						case {'top','t'}
							Scr = 'Top';
					end
				case 'rows'
					Rows = varargin{i+1};
				case 'not'
					Not = varargin{i+1};
				case 'only'
					Only = varargin{i+1};
				case 'offset'
					Offset = varargin{i+1};
			end
		end
	else
		Comma = 0;
		for j = 1:2:(length(varargin{1}) - numel(find(varargin{1} == ',')))
			jC = j + Comma;
			if (strcmpi(varargin{1}(jC),','))
				Comma = Comma + 1;
				jC = j + Comma;
			end
			
			switch lower(varargin{1}(jC))
				case 's'
					switch lower(varargin{1}(jC+1))
						case 'l'
							Scr = 'Left';
						case 'r'
							Scr = 'Right';
						case 't'
							Scr = 'Top';
					end
				case 'p'
					switch lower(varargin{1}(jC+1))
						case 'l'
							Pos = 'Left';
						case 'r'
							Pos = 'Right';
					end
				case 'r'
					Rows = str2double(varargin{1}(jC+1));
				case 'o'
					Offset = str2double(varargin{1}(jC+1));
			end
		end
	end
end

% =========================================================================
% ===== Generate figure list ==============================================
% =========================================================================

Fig_List = findall(0,'type','figure');
if (isempty(Fig_List))
	return;
end
if (~isempty(Not))
	Fig_List(ismember(Fig_List,Not)) = [];
elseif (~isempty(Only))
	Fig_List(~ismember(Fig_List,Only)) = [];
end
Fig_List = [-ones(Offset,1);Fig_List];
Fig_List = sort(Fig_List);

% =========================================================================
% ===== Calculate sizes and positions =====================================
% =========================================================================

x_Offset = 0;
y_Offset = 0;
Monitor = get(0,'ScreenSize');
Fig_n = numel(Fig_List);

% ===== Figure height =====================================================
if (rem(Rows,1) == 0)
	Height = ones(Rows,1) * floor((Monitor(4) - 40) / Rows);

	n = 0;
	while (sum(Height) ~= (Monitor(4) - 40))
		Height(rem(n,Rows)+1) = Height(rem(n,Rows)+1) + 1;
		n = n + 1;
	end
else
	Height = (Monitor(4) - 40) / Rows;
end

% ===== Figure width ======================================================
Cols = ceil(Fig_n / Rows);
Cols_Width = Monitor(3);

switch Pos
	case 'Left'
		Cols_Width = Monitor(3) / 2;
	case 'Right'
		Cols_Width = Monitor(3) / 2;
		x_Offset = Monitor(3) / 2;
end

if (strcmp(Pos,'Center'))
	Width = ones(Cols,1) * floor(Cols_Width / Cols);
else
	Width = ones(Cols,1) * floor(Cols_Width / (2 * Cols));
end

n = 0;
while (sum(Width) ~= Cols_Width)
	Width(rem(n,Cols)+1) = Width(rem(n,Cols)+1) + 1;
	n = n + 1;
end

% ===== Position ==========================================================
switch Scr
	case 'Left'
		x_Offset = x_Offset - 1920;
	case 'Right'
		x_Offset = x_Offset + 1920;
	case 'Top'
		y_Offset = 1080;
end

% =========================================================================
% ===== Move figures ======================================================
% =========================================================================

n = 0;
for i = 1:Rows
	for j = 1:Cols
		n = n + 1;
		if (n <= Fig_n)
			if (Fig_List(n) ~= (-1))
				set(figure(Fig_List(n)),'OuterPosition',[sum(Width(2:j)) + x_Offset + 1,Monitor(4) - sum(Height(1:i)) + y_Offset + 1,Width(j),Height(i)])
			end
		end
	end
end