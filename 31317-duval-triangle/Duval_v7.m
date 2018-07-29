function Duval_v7
% Duval's Triangle 

% F. Andrianasy, Mercredi 04 Mai 2011
% F. Andrianasy, Vendredi 13 Aout 2010

%clc
clear
whos

% -----------------------------------------------
% Initialisations
% -----------------------------------------------
global TRG_SCALE
global S_TRG 
global A
global B
global UserData

TRG_SCALE = 100;
S_TRG = [];

% Matrices de transformation Ternaire [a b c]' vers Orthogonal [x y]'
% A(2 X 3), B(2 X 1)
A = [ -1  -cos(pi/3)  0   
       0   sin(pi/3)  0 ];
B = [TRG_SCALE  
     0       ];


% -----------------------------------------------
% -----------------------------------------------
h_TRG = figure;                                 % Handle de la Figure
set(h_TRG, 'Name', 'Duval Triangle   [c] F. Andrianasy, 08/2010')
%set(h_TRG, 'Name', 'Duval Triangle')
set(h_TRG, 'NumberTitle', 'off')
set(h_TRG, 'ToolBar', 'none')                   % Masque ToolBar
set(h_TRG, 'MenuBar', 'none')                   % Masque barre de Menu
defaultBackground = get(0,'defaultUicontrolBackgroundColor');
%set(gcf, 'Color', defaultBackground )
set(gcf, 'Color', 'w')
set(gcf, 'Color', [.8 .8 .8])

hold on


% -----------------------------------------------
% -----------------------------------------------
% Triangle de fond
% Les extremums sont en coordonnees Ternaires
TRG = [
0, 0, TRG_SCALE
TRG_SCALE, 0, 0
0, TRG_SCALE, 0]';

xy = to_XY(TRG, A, B);
%h_pTRG = patch( xy(1, :),  xy(2, :), 'y');
h_pTRG = patch( xy(1, :),  xy(2, :), [.3 .3 .3]);
set(h_pTRG, 'EdgeColor', 'k')
set(h_pTRG, 'LineWidth', 1)

xy_TRG = xy;
s_xy.id = 1;
s_xy.name = 'TRG';
s_xy.handle = h_pTRG;
s_xy.polygon = xy_TRG;
s_xy.comment = 'Real-Time Diagnostic \fontsize{7} [Left-clic inside the triangle]';
s_xy.Color = get(h_pTRG, 'FaceColor');

s_xy.data{1, 1} = 'TRG_SCALE';
s_xy.data{1, 2} =  TRG_SCALE ;
s_xy.data{2, 1} = 'A';
s_xy.data{2, 2} =  A ;
s_xy.data{3, 1} = 'B';
s_xy.data{3, 2} =  B ;
S_TRG = [S_TRG  s_xy];


% Zone D1 (polygone)
D1 = [
TRG_SCALE, 0, 0
13, 87, 0
13, TRG_SCALE-(13+23), 23
TRG_SCALE-23, 0, 23
]';                                             % Polygone D1 en a,b,c
xy = to_XY(D1, A, B);
h_pD1 = patch( xy(1, :),  xy(2, :), 'c');       % Affichage du patch, recup handle
set(h_pD1, 'EdgeAlpha', 0)

xy_D1 = xy;                                     % Polygone D1 en x,y
s_xy.name = 'D1';
s_xy.handle = h_pD1;
s_xy.polygon = xy_D1;
s_xy.comment = 'D1 Discharges of Low Energy ';
s_xy.Color = get(h_pD1, 'FaceColor');
S_TRG = [S_TRG  s_xy];
S_TRG(end).id = 1 + S_TRG(end-1).id;


% Zone D2 (polygone)
D2 = [
TRG_SCALE-23, 0, 23
13, TRG_SCALE-(13+23), 23
13, TRG_SCALE-(13+40), 40
29, TRG_SCALE-(29+40), 40
29, 0, TRG_SCALE-29
]';
xy = to_XY(D2, A, B);
h_pD2 = patch( xy(1, :),  xy(2, :), 'b');
set(h_pD2, 'EdgeAlpha', 0)

xy_D2 = xy;
s_xy.name = 'D2';
s_xy.handle = h_pD2;
s_xy.polygon = xy_D2;
s_xy.comment = 'D2 Discharges of High Energy';
s_xy.Color = get(h_pD2, 'FaceColor');
S_TRG = [S_TRG  s_xy];
S_TRG(end).id = 1 + S_TRG(end-1).id;


% Zone DT (polygone)
DT = [
29, 0, TRG_SCALE-29
29, TRG_SCALE-(29+40), 40
13, TRG_SCALE-(13+40), 40
13, TRG_SCALE-13, 0
04, TRG_SCALE-4, 0
04, TRG_SCALE-(50+4), 50
15, TRG_SCALE-(15+50), 50
15, 0, TRG_SCALE-15
]';
xy = to_XY(DT, A, B);
h_pDT = patch( xy(1, :),  xy(2, :), 'm');
set(h_pDT, 'EdgeAlpha', 0)

xy_DT = xy;
s_xy.name = 'DT';
s_xy.handle = h_pDT;
s_xy.polygon = xy_DT;
s_xy.comment = 'DT Discharges and Thermal Faults';
s_xy.Color = get(h_pDT, 'FaceColor');
S_TRG = [S_TRG  s_xy];
S_TRG(end).id = 1 + S_TRG(end-1).id;



% Zone T3 (polygone)
T3 = [
15, 0, TRG_SCALE-15
15, TRG_SCALE-(15+50), 50
0, TRG_SCALE-50, 50
0, 0, TRG_SCALE
]';
xy = to_XY(T3, A, B);
h_pT3 = patch( xy(1, :),  xy(2, :), 'r');
set(h_pT3, 'EdgeAlpha', 0)

xy_T3 = xy;
s_xy.name = 'T3';
s_xy.handle = h_pT3;
s_xy.polygon = xy_T3;
s_xy.comment = 'T3 Thermal Faults > 700^oC';
s_xy.Color = get(h_pT3, 'FaceColor');
S_TRG = [S_TRG  s_xy];
S_TRG(end).id = 1 + S_TRG(end-1).id;



% Zone T2 (polygone)
T2 = [
0, TRG_SCALE-50, 50
4, TRG_SCALE-(4+50), 50
4, TRG_SCALE-(4+20), 20
0, TRG_SCALE-20, 20
]';
xy = to_XY(T2, A, B);
h_pT2 = patch( xy(1, :),  xy(2, :), 'g');
set(h_pT2, 'EdgeAlpha', 0)

xy_T2 = xy;
s_xy.name = 'T2';
s_xy.handle = h_pT2;
s_xy.polygon = xy_T2;
s_xy.comment = 'T2 Thermal Faults 300^oC{\fontsize{16} \rightarrow }700^oC';
s_xy.Color = get(h_pT2, 'FaceColor');
S_TRG = [S_TRG  s_xy];
S_TRG(end).id = 1 + S_TRG(end-1).id;


% Zone T1 (polygone)
T1 = [
0, TRG_SCALE-20, 20
4, TRG_SCALE-(4+20), 20
4, TRG_SCALE-(4), 0
TRG_SCALE-98, 98, 0
0, 98, TRG_SCALE-98
]';
xy = to_XY(T1, A, B);
h_pT1 = patch( xy(1, :),  xy(2, :), [.7 .7 .7]);
set(h_pT1, 'EdgeAlpha', 0)

xy_T1 = xy;
s_xy.name = 'T1';
s_xy.handle = h_pT1;
s_xy.polygon = xy_T1;
s_xy.comment = 'T1 Thermal Faults < 300^oC';
s_xy.Color = get(h_pT1, 'FaceColor');
S_TRG = [S_TRG  s_xy];
S_TRG(end).id = 1 + S_TRG(end-1).id;


% Zone PD (polygone)
PD = [
TRG_SCALE-98, 98, 0
0, TRG_SCALE, 0
0, 98, TRG_SCALE-98 
]';
xy = to_XY(PD, A, B);
h_pPD = patch( xy(1, :),  xy(2, :), 'k');
set(h_pPD, 'EdgeAlpha', 0)

xy_PD = xy;
s_xy.name = 'PD';
s_xy.handle = h_pPD;
s_xy.polygon = xy_PD;
s_xy.comment = 'PD Partial Discharges';
s_xy.Color = get(h_pPD, 'FaceColor');
S_TRG = [S_TRG  s_xy];
S_TRG(end).id = 1 + S_TRG(end-1).id;

% TODO : 14/08/2010 - Mieux gerer S_TRG 
%       + DRY - stocker uniquement les handles des patches [OK]
%       + DRY - creer une routine de stockage de S_TRG
%       + reecrire la fonction cursor_inside_Triangle [OK]
%       + test callback [OK]
%
% Exemple d'utilisation d'un handle pre-stocke
%   figure, 
%   hp = patch([0, 1, 1, 0], [0, 0, 1, 1], 'y')
%   [x, y, button] = ginput(1); 
%   inpolygon(x, y, get(hp, 'XData'), get(hp, 'YData'))

% -----------------------------------------------
% TICKS
% -----------------------------------------------
set(gca, 'visible', 'off')                              % Masque les axes

TICK_SIZE = 1;
%Tick1 = linspace(20, 80, 4);
Tick1 = linspace(10, 90, 9);
Tick1 = [Tick1; 0*ones(1, size(Tick1, 2))];
Tick1 = [Tick1; TRG_SCALE - sum(Tick1) ];

%Tick2 = linspace(20, 80, 4);
Tick2 = linspace(10, 90, 9);
Tick2 = [Tick2; TICK_SIZE*ones(1, size(Tick2, 2))];
Tick2(2, [mod(Tick2(1, :),20) == 0]) = 1.63*TICK_SIZE;  % Modulus 20 are larger
Tick2 = [Tick2; TRG_SCALE - sum(Tick2) ];

for j = 0:2
csT1 = circshift(Tick1, j);                             % debut trace
csT2 = circshift(Tick2, j);                             % fin trace
   for i = 1 : size(csT1, 2)
      abc = [csT1(:, i)  csT2(:, i)];
      xy = to_XY(abc, A, B);
      h_L = line( xy(1, :),  xy(2, :));
      set(h_L, 'Color', 'k')
      if mod(Tick2(1, i),2) == 1, 
          set(h_L, 'LineWidth', 2.2)
      else
          set(h_L, 'LineWidth', 1)
      end
   end
end


% -----------------------------------------------
% TICK LABELS
% -----------------------------------------------
Lbl1 = linspace(20, 80, 4) + 3;                         % va devenir coordonnee a
Lbl1 = [Lbl1; -3*ones(1, size(Lbl1, 2))];               % va devenir coordonnee b
Lbl1 = [Lbl1; TRG_SCALE - sum(Lbl1) ] - cos(pi/3);      % va devenir coordonnee c

xy = to_XY(Lbl1, A, B);
for i = 1:size(Lbl1, 2),
   text(xy(1, i), xy(2, i), sprintf('%g', 2*Tick1(1, i)))
end

% Label selon l'axe b
Lbl1 = linspace(20, 80, 4) + 1;                         % va devenir coordonnee b
Lbl1 = [Lbl1; -(2/cos(pi/3))*ones(1, size(Lbl1, 2)) ];  % va devenir coordonnee c
Lbl1 = [Lbl1; TRG_SCALE - sum(Lbl1) + 1];               % va devenir coordonnee a

abc = circshift(Lbl1, 1);
xy = to_XY(abc, A, B);
for i = 1:size(Lbl1, 2),
   text(xy(1, i), xy(2, i), sprintf('%g', 2*Tick1(1, i)))
end

% Label selon l'axe c
Lbl1 = linspace(20, 80, 4);                             % va devenir coordonnee c
Lbl1 = [Lbl1; -3*cos(pi/3)*ones(1, size(Lbl1, 2))];     % va devenir coordonnee a
Lbl1 = [Lbl1; TRG_SCALE - sum(Lbl1) ] - cos(pi/3);      % va devenir coordonnee b

abc = circshift(Lbl1, 2);
xy = to_XY(abc, A, B);
for i = 1:size(Lbl1, 2),
   text(xy(1, i), xy(2, i), sprintf('%g', 2*Tick1(1, i)))
end


% -----------------------------------------------
% A_LABEL, B_LABEL, C_LABEL
% -----------------------------------------------
str_Lbla = '%C_2H_2';
str_Lblb = '%CH_4';
str_Lblc = '%C_2H_4';

abc =[58, -10, TRG_SCALE-(58-10)]';
xy = to_XY(abc, A, B);
h_Ta = text(xy(1)+3, xy(2), sprintf('%s', str_Lbla));
set(h_Ta, 'HorizontalAlignment', 'center');
%old_extent_a = get(h_Ta, 'Extent');                    % Inutile car auto-centre


abc =[TRG_SCALE-(53-10), 53, -10 ]';                    % Si alignement right
xy = to_XY(abc, A, B);
h_Tb = text(xy(1)+2, xy(2), sprintf('%s', str_Lblb));
set(h_Tb, 'HorizontalAlignment', 'right');
%old_extent_b = get(h_Tb, 'Extent');                    % inutilr, alignement right


abc =[-6, TRG_SCALE-(52-6)  , 52 ]';
xy = to_XY(abc, A, B);
h_Tc = text(xy(1), xy(2), sprintf('%s', str_Lblc));
set(h_Tc, 'HorizontalAlignment', 'left');



% -----------------------------------------------
% DIAGNOSIS (real-time)
% -----------------------------------------------
h_r = rectangle;
h_tDiag = text;

set(h_tDiag, 'Pos', [50, 94, 0])    
set(h_tDiag, 'String', S_TRG(1).comment ); 
set(h_tDiag, 'FontSize', 16)    
set(h_tDiag, 'HorizontalAlignment', 'center')

tDiagxt = get(h_tDiag, 'Extent');
set(h_r, 'Pos', [tDiagxt(1)-10, 90, 8, 8])
set(h_r, 'LineWidth', 1)

UserData.h_r = h_r ;
UserData.h_tDiag = h_tDiag ;


% -----------------------------------------------
% global UserData shared accros callback functions 
% -----------------------------------------------
%set(gcf, 'UserData', []) 
UserData.h_Ta = h_Ta ;
UserData.h_Tb = h_Tb ;
UserData.h_Tc = h_Tc ;

UserData.str_Lbla = str_Lbla ;  
UserData.str_Lblb = str_Lblb ;  
UserData.str_Lblc = str_Lblc ;  

UserData.state = 'STATE_0';
%set(gcf, 'UserData', UserData) 


% -----------------------------------------------
% Gestion des evenements souris
% Voir 
%   MouseDownCallback.m 
%   MouseMoveCallback.m
% -----------------------------------------------
%set(gcf, 'WindowButtonDown', 'MouseDownCallback')
set(gcf, 'WindowButtonDown', {@MouseDownCallback} )


% This first call force MouseMoveCallback callback function
% to run and initialize shared variables and handles
MouseMoveCallback;

% By default the mouse move callback is disabled
% The user must click INSIDE the Triangle
% to start the mouse move management
set(gcf, 'WindowButtonMotionFcn', [])



end % function version of Duval_6


