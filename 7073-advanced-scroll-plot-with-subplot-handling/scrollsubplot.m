function scrollsubplot(dx,x,varargin);

% Cette fonction permet l'ajout d'un curseur dynamique sur les figures
% graphique tout en permettant l'utilisation de sous-graphiques subplot.
% Cette fonction est une variation de la fonction scrollplot de Wolfgang
% Stiegmaier et de scrollplotdemo de Steven Lord, slord@mathworks.com.
%
% Syntaxe
%   scrollsubplot(dx,x,h1,h2,...hn);
%
% Description
% dx: détermine la largeur de la fenetre
% x: vecteur temps
% h1...hn: les références aux sous-graphiques
%
% exemple
% 
% temps = linspace(0,10*pi,100001);
% Y1 = sin(temps);
% Y2 = cos(temps);
% Y3 = sin(temps).^2;
%
% h1=subplot(3,1,1);
% plot(temps,Y1),grid;
% h2=subplot(3,1,2);
% plot(temps,Y2),grid;
% h3=subplot(3,1,3);
% plot(temps,Y3),grid;
% scrollsubplot(pi,temps,h1,h2,h3);
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Benoit Cantin, 7 mars 2005. %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Original message
% :Created by Steven Lord, slord@mathworks.com
% :Uploaded to MATLAB Central
% :http://www.mathworks.com/matlabcentral
% :7 May 2002
% :Permission is granted to adapt this code for your own use.
% :However, if it is reposted this message must be intact.

% get current axes
a=gca;
% This avoids flickering when updating the axis
set(gcf,'doublebuffer','on');
% Set appropriate axis limits and settings
set(a,'xlim',[0 dx]);
%set(a,'ylim',[min(y) max(y)]);

% Generate constants for use in uicontrol initialization
pos=get(a,'position');
xmax=max(x);
xmin=min(x);

% This will create a slider which is just underneath the axis
% but still leaves room for the axis labels above the slider
Newpos=[pos(1) pos(2)-0.1 pos(3) 0.05];

for i = 1:length(varargin);
    %initialize postion of plot
    set(varargin{i},'xlim',[xmin xmin+dx]);
    
    % Création des variables h1...hn
    eval(['h',num2str(i), ' = varargin{i};']);
    
    % Setting up callback string to modify XLim of axis (gca)
    % based on the position of the slider (gcbo)
    if i == 1;
        S=['set(h', num2str(i), ' ,''xlim'',get(gcbo,''value'')+[0 ' num2str(dx) '])'];
    else
        S=[S ', set(h', num2str(i), ' ,''xlim'',get(gcbo,''value'')+[0 ' num2str(dx) '])'];
    end
end

% Creating Uicontrol with initial value of the minimum of x
h=uicontrol('style','slider',...
    'units','normalized','position',Newpos,...
    'callback',S,'min',xmin,'max',xmax-dx,'value',xmin);


