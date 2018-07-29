function fourier_gui
% Fourier series calculator
% FOURIER_GUI initiates a GUI that graphs a function against the nth
% partial sum of its Fourier series. fourier_gui used fourier_comp to
% calculate Fourier series coefficient from -L to L.
% f(x): Function handle or name of M-function, should accept a vector
% argument x and return a vector result y
% n: Number of Fourier series term
% 2L: Function period
% fourier_gui add Fourier series menus on figure windows consist of
% this submenus:
% Export: export Fourier series coefficient
% Help: displays fourier_gui help
% About: displays copyright and contact information.
%
%   Example
%   Find the Fourier series of the below function [1]
%          |  0   -pi < x <= 0
%   f(x) = |
%          |  x   0 <= x < pi
%
% function y = fx(x)
% i = find((x > -pi) & (x <= 0));
% y = 2*x;
% y(i) = 0;
% y(1) = y(end);
%
% [1] Dean G. Duffy, Advanced engineering mathematic, CRS Press LCC,
% Boca Raton, Florida, 1998, pp. 54-57
%
%   See also
%   fourier_comp
%
% Author: Amin Bashi
% Created: Jul 2009
% Copyright 2009
if findall(0,'tag','fourier')
    figure(findall(0,'tag','fourier'));
else
    figure('units','pixel','position',[100 80 600 600],'tag','fourier');
end
informpanelH = uipanel('units','pixel','position',[20 450 560 140],...
    'BackgroundColor','white');
uicontrol('unit','pixel','position',[75 107 30 16],...
    'parent',informpanelH,'style','text','string','f(x)')
fH = uicontrol('unit','pixel','position',[110 100 200 30],...
    'parent',informpanelH,'style','edit','string','@(x)x.*cos(x)');
uicontrol('unit','pixel','position',[315 107 20 16],...
    'parent',informpanelH,'style','text','string','n')
nH = uicontrol('unit','pixel','position',[340 100 30 30],...
    'parent',informpanelH,'style','edit','string','3');
uicontrol('unit','pixel','position',[375 107 20 16],...
    'parent',informpanelH,'style','text','string','L')
LH = uicontrol('unit','pixel','position',[400 100 30 30],...
    'parent',informpanelH,'style','edit','string','pi');
fmenu = uimenu('Label','Fourier series');
uimenu(fmenu,'Label','Export','Callback',@export);
uimenu(fmenu,'Label','Help','Callback',@help);
uimenu(fmenu,'Label','About','Callback',@about);
uicontrol('unit','pixel','position',[435 100 50 30],'parent',...
    informpanelH,'style','pushbutton','string','plot','Callback',@fplot)
plotpanelH = uipanel('units','pixel','position',[20 20 560 420],...
    'BackgroundColor','white');
axes('parent',plotpanelH);
    function fplot(h,e)
        try
            func =  evalin('base',get(fH,'string'));
        catch
            func = str2func(get(fH,'string'));
        end
        m = str2num(get(nH,'string'));
        L = str2num(get(LH,'string'));
        y = fourier_comp(func,m,L);
        set(gcf,'UserData',y)
        a0 = y.a0;
        an = y.an;
        bn = y.bn;
        dx = 2*L/50;
        xspan = -L:dx:L;
        fx = [];
        for x = xspan
            fx = [fx a0/2+sum(an(1:m).*sin(pi*(1:m)*x/L)...
                +bn(1:m).*cos(pi*(1:m)*x/L))];
        end
        plot(xspan,fx,'b',xspan,func(xspan),'r','LineWidth',2)
        grid on
        legend('Fourier series','User function',0)
    end
    function export(h,e)
        y = get(gcf,'UserData');
        assignin('base', 'an', y.an)
        assignin('base', 'bn', y.bn)
        assignin('base', 'a0', y.a0)
    end
    function help(h,e)
        doc fourier_gui
    end
    function about(h,e)
        msgbox({'   Fourier series calculator Version 1.0 ';...
            '   Copyright 2009, Amin Bashi';...
            '      http://www.matlabedu.ir'})
    end
end