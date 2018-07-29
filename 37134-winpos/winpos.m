function winpos(pos,hfig)

% WINPOS Position figure window nicely. DB. V1.1 2012/06/20
% 
% WINPOS(pos, hfig)
% position a figure with handle hfig according to the following
% positionings. If no or wrong handle is given: gcf is used. 
% 
% position vektor:
% ____________________________________________________________
% |HL                           HC                          HR|
% |                                                           |
% |                                                           |
% |              UL                             UR            |
% |                                                           |
% |ML                           MC                          MR|
% |              LL                             LR            |
% |                                                           |
% |                                                           |
% |FL                           FC                          FR|
% |___________________________________________________________|
%
% Position a figure window on screen according to the upper display
% HL, HC, HR, FL, FC, FR, ML, MC, MR are all 1/9 of a screen
% UL, UR, LL, LR are 1/4 of a screen

% Additional files used: 
% Additional m-files used: 
% Additional classes used: 
%
%
%	Date		Version	Author	Remarks
%	2012/03/30  1.0     DB      Erstellung
%   2012/06/20  1.1     DB      Implemented suggestion to handle error
%                               case in the otherwise branch. Also reduced
%                               code length
%
% (c)  D.Brosig

% test for handle or handle input
if nargin < 2 || ~ishandle(hfig)
    hfig = gcf;
end

% get old parameters for units and restore at the end
old_units = get(hfig, 'units');
set(hfig, 'units', 'normalized');
% switch according to position parameter
switch upper(pos)
    case 'HL'
        new_pos = [0 2/3 1/3 1/3];
    case 'HC'
        new_pos = [1/3 2/3 1/3 1/3];
    case 'HR'
        new_pos = [2/3 2/3 1/3 1/3];
    case 'UL'
        new_pos = [0 .5 .5 .5];
    case 'UR'
        new_pos = [.5 .5 .5 .5];
    case 'ML'
        new_pos = [0 1/3 1/3 1/3];
    case 'MC'
        new_pos = [1/3 1/3 1/3 1/3];
    case 'MR'
        new_pos = [2/3 1/3 1/3 1/3];
    case 'LL'
        new_pos = [0 0 .5 .5];
    case 'LR'
        new_pos = [.5 0 .5 .5];
    case 'FL'
        new_pos = [0 0 1/3 1/3];
    case 'FC'
        new_pos = [1/3 0 1/3 1/3];
    case 'FR'
    	new_pos = [2/3 0 1/3 1/3];
    otherwise
        help winpos
        error('Wrong positioning!')
end
% set new position and return old paramter for units
set(hfig, 'outerposition', new_pos)
set(hfig, 'units', old_units)