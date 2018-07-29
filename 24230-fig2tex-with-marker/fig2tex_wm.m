function fig2tex_wm(fignum,fname,plotwidth,legendwhere,blsorder,figshift)
%FIG2TEX Convert figure to a TeX file representation
%   FIG2TEX(FIGNUM,FNAME,PLOTWIDTH) produces a tex file named
%   FNAME for the figure number FIGNUM.
%   PLOTWIDTH is used for the width of the plot area.
%
%   Documentation at
%   http://www.isikun.edu.tr/~ercan/fig2tex
%
%
%   Copyright 2005 Ercan Solak
%   Version: 0.7 Date: 2005/6/27
%   This script is free software; you may redistribute it
%   and/or modify it under the conditions of the
%   LaTeX Project Public License, version 1.2 or later.
%
%==========================================================================
%
%   Marker Part added by M.M.Altug Bicak, for any questions please contact
%   bicakme@gmail.com
%   Deleted lines are stated as '% ===== DELETED ' 
%   Comment : I changed the original filename to ~_wm : (means with marker)   
%   in order not to confuse with original file 'fig2tex'.
%   
%   function tex_out = matlab_marker_to_latex(mkr_in)
%   is Copied from David Krause's file figure2latex.m.
%   Please give credit for his work. Thanks.
%
%==========================================================================
%  v1.1 : legendwhere,blsorder,figshift added.
% blsorder : bottom_legend_string_order 
% number of strings per line  ::: only effective if legendwhere == 'bottom'
% e.g.
% the plot you intend to put latex file includes 10 different lines at
% legend, in order to control spacing etc. you should specify the number of
% items per line e.g., blsorder = [4,2,3,1]; this input will specify first 4
% legend items to be at first line, 5th and 6th ones to the second line and
% 7-9th to the third line and 10th to the fourth line. I didnt put precise
% control to length on legend strings yet. ('Possibly it will appear at
% next version')
%==========================================================================
% legendwhere : if you want to plate the legend under the figure with
% multiple elements per line,please use with blsorder.
% If you want to use regular legend, use legendwhere == 'none'
% figshift = [dx,dy]  dx,dy are the shift for all graphic
% Usage : [0.1,-2.6]
%==========================================================================
%  USAGE EXAMPLE :
% 
%  x = 0:0.01:0.5;
%  y1 = sin(2*pi*0.2*x);
%  y2 = x.^2;
%  y3 = sqrt(x);
%  figure(1);
%  plot(x,y1,'rd',x,y2,'b-o',x,y3,'k--<');
%  legend sin $x^{2}$ $\sqrt{x}$
%  fig2tex_wm(1,'myfig.tex',9,'bottom',[3],[0 -2])
%   
%  By mmab : 
%  please send an email if you find a bug
%==========================================================================
%
%  Known bug : Log axis is not working so far, 
%  I am converting entire data to Log10(data) and replotting on the figure.
%  Please be aware of this and save your figure first in order not to face
%  with difficulties
%
%==========================================================================
if nargin == 3
    legendwhere = 'none';
    blsorder = 0;
    figshift = [0 0];
end;
    
figure(fignum);

fh = gcf;
ah = gca;
% IS AXIS LOG ?
    Xlin = strcmp(get(ah,'XScale'),'linear');
    Ylin = strcmp(get(ah,'YScale'),'linear'); 
    if Xlin == 0
        set(ah,'XScale','linear');
        lshandles = get(ah,'Children');
        lshandles = double(find(handle(lshandles),'-class','graph2d.lineseries'));
        for lsh=lshandles'
            xd = get(lsh,'XData');
            set(lsh,'XData',log10(xd));
        end;
        axis tight;
        ah = gca;
    end;
    if Ylin == 0
        set(ah,'YScale','linear');
        lshandles = get(ah,'Children');
        lshandles = double(find(handle(lshandles),'-class','graph2d.lineseries'));
        for lsh=lshandles'
            yd = get(lsh,'YData');
            set(lsh,'YData',log10(yd));
        end;     
        axis tight;
        ah = gca;
    end;
    
%% Extract the aspect ratio
set(ah,'Units','pixels');
ap=get(ah,'Position');
ar=ap(4)/ap(3);
set(ah,'Units','normalized');
ap=get(ah,'Position');

%% Extract the axes limits
xlim = get(ah,'XLim');
ylim = get(ah,'YLim');

xlabelsep = 1;
ylabelsep = 1.5;
labelsep = 1;

%% Open the output file
filename = strrep(fname,'.tex','');
filename = strcat(filename,'.tex');

fid = fopen(filename,'w');


%% Set the plot width and determine the proper units in x and y

xunit = plotwidth/(xlim(2)-xlim(1));
yunit = plotwidth*ar/(ylim(2)-ylim(1));

%% Set the figure width and height

pp=get(ah,'Position');

figx1 = xlim(1)-pp(1)*(xlim(2)-xlim(1))/pp(3);
figy1 = ylim(1)-pp(2)*(ylim(2)-ylim(1))/pp(4);
figx2 = (1-pp(1))*(xlim(2)-xlim(1))/pp(3)+xlim(1);
figy2 = (1-pp(2))*(ylim(2)-ylim(1))/pp(4)+ylim(1);

tmpstr = '\psset{xunit=#1#cm,yunit=#2#cm}';
wrstr = strfill(tmpstr,{xunit,yunit});
fprintf(fid,'%s\n',wrstr);

tmpstr = '\begin{pspicture*}(#1#,#2#)(#3#,#4#)';
wrstr = strfill(tmpstr,{figx1*(1-figshift(1)),figy1*(1-figshift(2)),figx2,figy2});
%wrstr = strfill(tmpstr,{figx1,figy1,figx2,figy2}); ----- DELETED
fprintf(fid,'%s\n',wrstr);


%% Determine the Tick separation
xticks = get(ah,'xtick');
Dx = xticks(2)-xticks(1);
yticks = get(ah,'ytick');
Dy = yticks(2)-yticks(1);

tmpstr = '\psaxes[Ox=#1#,Oy=#2#,Dx=#5#,Dy=#6#,axesstyle=frame]{-}(#1#,#2#)(#1#,#2#)(#3#,#4#)';
wrstr = strfill(tmpstr,{xlim(1),ylim(1),xlim(2),ylim(2),Dx,Dy});
fprintf(fid,'%s\n',wrstr);

%% XLabel
xlh = get(ah,'XLabel');
wrstr={};
linestr = '\rput[t](#1#,#2#){';
xlabelX = sum(xlim)/2;
xlabelY = ylim(1)-xlabelsep/yunit/1.4;
linestr = strfill(linestr,{xlabelX,xlabelY});
wrstr = [wrstr,{linestr}];
wrstr = [wrstr,{'\begin{tabular}{c}'}];
xlab = get(xlh,'String');
if xlab
    for labstr = xlab'
        wrstr = [wrstr,{strcat((labstr(:,1))','\\')}];
    end;
    wrstr = [wrstr,{'\end{tabular}','}'}];
    for linestr=wrstr
        fprintf(fid,'\n%s',linestr{1});
    end;
    fprintf(fid,'\n');
end;

%% YLabel
ylh = get(ah,'YLabel');
wrstr={};
linestr = '\rput[b]{90}(#1#,#2#){';
ylabelX = xlim(1)-ylabelsep/xunit/1.5;
ylabelY = sum(ylim)/2;
linestr = strfill(linestr,{ylabelX,ylabelY});
wrstr = [wrstr,{linestr}];
wrstr = [wrstr,{'\begin{tabular}{c}'}];
ylab = get(ylh,'String');
if ylab;
    for labstr = ylab'
        wrstr = [wrstr,{strcat((labstr(:,1))','\\')}];
    end;
    wrstr = [wrstr,{'\end{tabular}'},{'}'}];
    for linestr=wrstr
        fprintf(fid,'\n%s',linestr{1});
    end;
    fprintf(fid,'\n');
end;

%% Title
th = get(ah,'Title');
wrstr={};
linestr = '\rput[b](#1#,#2#){';
titleX = sum(xlim)/2;
titleY = ylim(2)+labelsep/yunit/4;
linestr = strfill(linestr,{titleX,titleY});
wrstr = [wrstr,{linestr}];
wrstr = [wrstr,{'\begin{tabular}{c}'}];
titlab = get(th,'String');
if titlab
    for labstr = titlab'        
        wrstr = [wrstr,{strcat((labstr(:,1))','\\')}];
    end;
    wrstr = [wrstr,{'\end{tabular}'},{'}'}];
    for linestr=wrstr
        fprintf(fid,'\n%s',linestr{1});
    end;
    fprintf(fid,'\n');
end;

%% Get and plot the data
lshandles = get(ah,'Children');
lshandles = double(find(handle(lshandles),'-class','graph2d.lineseries'));
for lsh=lshandles'
    xd = get(lsh,'XData');
    yd = get(lsh,'YData');

    %% Get the line style
    dontplotline = 0;
    lsty = get(lsh,'LineStyle');
    if strcmp(lsty,'-')
        linestyle='solid';
    elseif strcmp(lsty,':')
        linestyle='dotted';
    elseif strcmp(lsty,'--')
        linestyle='dashed';
    elseif strcmp(lsty,'-.')
        linestyle='dashed,dash=3pt 1pt 1pt 1pt';
    elseif strcmp(lsty,'none')
        dontplotline = 1;
    else
        linestyle = 'solid';
    end;

    %% Get the line color
    lcol = get (lsh,'Color');
    cname=['color',num2str(lsh)];
    colstr=['\newrgbcolor{',cname,'}{',num2str(lcol),'}'];
    fprintf(fid,'%s\n',colstr);
    if dontplotline == 0
        if length(xd)>1
            fprintf(fid,'%s\n','\savedata{\mydata}[{');
            for i=1:length(xd)-1
                if (mod(i,6)==0)
                    fprintf(fid,'%s\n','');
                end;
                tmpstr = '{#1#,#2#}';
                if Xlin == 1
                    x_ploted = xd(i);
                else
                    x_ploted = log10(xd(i));
                end;
                if Ylin == 1
                    y_ploted = yd(i);
                else
                    y_ploted = log10(yd(i));
                end;
                %        wrstr = strfill(tmpstr,{xd(i),yd(i)});
                wrstr = strfill(tmpstr,{x_ploted,y_ploted});
            %    wrstr = strfill(tmpstr,{xd(i),yd(i)});
                fprintf(fid,'%s',wrstr);
            end;
            wrstr = strfill(tmpstr,{xd(end),yd(end)});
            fprintf(fid,'%s\n',[',', wrstr]);

            fprintf(fid,'%s\n','}]');
            tmpstr = ['\dataplot[plotstyle=line,linestyle=#1#,linecolor=#2#]{\mydata}'];
            wrstr = strfill(tmpstr,{linestyle,cname});
            fprintf(fid,'%s\n',wrstr);
        end;
    end;
    %----------- MARKER PART ------
    markersty = get(lsh,'Marker');
    tex_markersty = matlab_marker_to_latex(markersty);
    if strcmp(tex_markersty,'none')==0        
        fprintf(fid,'%----- MARKER PART ----\n');
        for ii = 1:length(xd)
            the_str = ['\rput(',sprintf('%12.5f',xd(ii)),',',sprintf('%12.5f',yd(ii)),'){\textcolor{',cname,'}{',tex_markersty,'}}'];
            fprintf(fid,'%s\n',the_str);
        end;
        fprintf(fid,'%----- MARKER PART END----\n');
    end;
    %------------------------------
end;


%% Place the legend
if isempty(legendwhere) == 1
    legendwhere = 'none';
end;
if strcmp(legendwhere,'bottom') == 0
    [legh,object_h,plot_h,text_strings] = legend;
    if ~isempty(legh)
        ts={'\psframebox[framesep=0]{\psframebox*{\begin{tabular}{l}'};
        % rowstr='\Rnode{a#1#}{\hspace*{0.0ex}} \hspace*{0.7cm}  \Rnode{a#2#}{~~#3#} \\';  % ===== DELETED
        ncstr='\ncline[linestyle=#1#,linecolor=#4#]{a#2#}{a#3#}';
        llstr={};
        for k=1:length(plot_h)
            cname=['color',num2str(plot_h(k))];
            %----------- MARKER PART ------
            markersty = get(plot_h(k),'Marker');
            tex_markersty = matlab_marker_to_latex(markersty);
            if strcmp(markersty,'none')==0
                if strcmp(markersty,'square')==1
                    the_str = ['\rput(',sprintf('%12.5f',0.39),'cm,',sprintf('%12.5f',0.08),'cm){\textcolor{',cname,'}{',tex_markersty,'}}'];
                elseif strcmp(markersty,'diamond')==1
                    the_str = ['\rput(',sprintf('%12.5f',0.39),'cm,',sprintf('%12.5f',0.08),'cm){\textcolor{',cname,'}{',tex_markersty,'}}'];
                else
                    the_str = ['\rput(',sprintf('%12.5f',0.39),'cm,',sprintf('%12.5f',0.1),'cm){\textcolor{',cname,'}{',tex_markersty,'}}'];
                end;
                rowstr=['\Rnode{a#1#}{\hspace*{0.0ex}}',the_str,' \hspace*{0.7cm} \Rnode{a#2#}{~~#3#} \\'];
            else
                rowstr=['\Rnode{a#1#}{\hspace*{0.0ex}} \hspace*{0.7cm} \Rnode{a#2#}{~~#3#} \\'];
            end;
            %------------------------------
            tabstr = strfill(rowstr,{num2str(2*k-1),num2str(2*k),text_strings(k)});
            ts=[ts,tabstr];
            lsty = get(plot_h(k),'LineStyle');
            if strcmp(lsty,'-')
                linestyle='solid';
            elseif strcmp(lsty,':')
                linestyle='dotted';
            elseif strcmp(lsty,'--')
                linestyle='dashed';
            elseif strcmp(lsty,'-.')
                linestyle='dashed,dash=3pt 1pt 1pt 1pt';
            else
                linestyle = 'solid';
            end;
            %   cname=['color',num2str(plot_h(k))];  % ===== DELETED
            leglinestr = strfill(ncstr,{linestyle,num2str(2*k-1),num2str(2*k),cname});
            llstr = [llstr,{leglinestr}];
        end;
        ts=[ts,{'\end{tabular}}'}];

        %% legend bottom-left
        lp = get(legh,'Position');
        legendposX = (lp(1)-ap(1))/ap(3)*(xlim(2)-xlim(1))+xlim(1);
        legendposY = (lp(2)-ap(2))/ap(4)*(ylim(2)-ylim(1))+ylim(1);

        tmpstr = '\rput[bl](#1#,#2#)';
        wrstr = strfill(tmpstr,{legendposX,legendposY});
        fprintf(fid,'%s',wrstr);

        tmpstr2 = [{'{'},ts,llstr,{'}'},{'}'}];
        for i=1:length(tmpstr2)
            fprintf(fid,'\n%s',tmpstr2{i});
        end;
    end;
else % else of legendwhere, if legedwhere to bottom
    [legh,object_h,plot_h,text_strings] = legend;
    if ~isempty(legh)
        ts={'\psframebox[framesep=0,linecolor=white]{\psframebox*{\begin{tabular}{l}'};
        % rowstr='\Rnode{a#1#}{\hspace*{0.0ex}} \hspace*{0.7cm}  \Rnode{a#2#}{~~#3#} \\';  % ===== DELETED
        ncstr='\ncline[linestyle=#1#,linecolor=#4#]{a#2#}{a#3#}';
        llstr={};
        blsorder_line = 1;
        blsorder_id = 1;
        if sum(blsorder)~=length(plot_h) == 1
            error('Number of Legend entries is not equal to number of inputs');
        end;
        for k=1:length(plot_h)
            cname=['color',num2str(plot_h(k))];
            %----------- MARKER PART ------
            markersty = get(plot_h(k),'Marker');
            tex_markersty = matlab_marker_to_latex(markersty);
            if strcmp(markersty,'none')==0
                if strcmp(markersty,'square')==1
                    the_str = ['\rput(',sprintf('%12.5f',0.39),'cm,',sprintf('%12.5f',0.08),'cm){\textcolor{',cname,'}{',tex_markersty,'}}'];
                elseif strcmp(markersty,'diamond')==1
                    the_str = ['\rput(',sprintf('%12.5f',0.39),'cm,',sprintf('%12.5f',0.08),'cm){\textcolor{',cname,'}{',tex_markersty,'}}'];
                else
                    the_str = ['\rput(',sprintf('%12.5f',0.39),'cm,',sprintf('%12.5f',0.1),'cm){\textcolor{',cname,'}{',tex_markersty,'}}'];
                end;
                rowstr=['\Rnode{a#1#}{\hspace*{0.0ex}}',the_str,' \hspace*{0.7cm} \Rnode{a#2#}{~~#3#} '];
            else
                rowstr=['\Rnode{a#1#}{\hspace*{0.0ex}} \hspace*{0.7cm} \Rnode{a#2#}{~~#3#} '];
            end;
            if blsorder_line == blsorder(blsorder_id)
                rowstr = [rowstr,'\\'];
                blsorder_line = 1;
                blsorder_id = blsorder_id + 1;
            else               
                blsorder_line = blsorder_line + 1;
            end;
            %------------------------------
            tabstr = strfill(rowstr,{num2str(2*k-1),num2str(2*k),text_strings(k)});
            ts=[ts,tabstr];
            lsty = get(plot_h(k),'LineStyle');
            if strcmp(lsty,'-')
                linestyle='solid';
            elseif strcmp(lsty,':')
                linestyle='dotted';
            elseif strcmp(lsty,'--')
                linestyle='dashed';
            elseif strcmp(lsty,'-.')
                linestyle='dashed,dash=3pt 1pt 1pt 1pt';
            else
                linestyle = 'solid';
            end;
            %   cname=['color',num2str(plot_h(k))];  % ===== DELETED
            leglinestr = strfill(ncstr,{linestyle,num2str(2*k-1),num2str(2*k),cname});
            llstr = [llstr,{leglinestr}];
        end;
        ts=[ts,{'\end{tabular}}'}];

        %% legend bottom-left
        lp = get(legh,'Position');
        legendposX = (lp(1)-ap(1))/ap(3)*(xlim(2)-xlim(1))+xlim(1);
        legendposY = (lp(2)-ap(2))/ap(4)*(ylim(2)-ylim(1))+ylim(1);

        tmpstr = '\rput[bl](#1#,#2#)';        
        wrstr = strfill(tmpstr,{figx1*(1-figshift(1)),figy1*(1-figshift(2))});
%       wrstr = strfill(tmpstr,{legendposX,legendposY});    =====  DELETED
        fprintf(fid,'%s',wrstr);

        tmpstr2 = [{'{'},ts,llstr,{'}'},{'}'}];
        for i=1:length(tmpstr2)
            fprintf(fid,'\n%s',tmpstr2{i});
        end;
    end;    
end; % end of legendwhere
%% Annotations

%% Textarrows
allhandles = findall(fh);
anhar = double(find(handle(allhandles),'-class','scribe.textarrow'));
anhar=anhar(1:end/2);
for anh = anhar'
    wrstr ={};
    annostr = get(anh,'String');
    annoX = get(anh,'X');
    annoY = get(anh,'Y');
    linestr = '\psline{->}(#1#,#2#)(#3#,#4#)';

    linecor1 = (annoX(1)-ap(1))/ap(3)*(xlim(2)-xlim(1))+xlim(1);
    linecor2 = (annoY(1)-ap(2))/ap(4)*(ylim(2)-ylim(1))+ylim(1);
    linecor3 = (annoX(2)-ap(1))/ap(3)*(xlim(2)-xlim(1))+xlim(1);
    linecor4 = (annoY(2)-ap(2))/ap(4)*(ylim(2)-ylim(1))+ylim(1);

    linestr = strfill(linestr,{linecor1,linecor2,linecor3,linecor4});
    wrstr = [wrstr,linestr];

    refangle = 180+180/pi*atan2(annoY(2)-annoY(1),annoX(2)-annoX(1));
    linestr = '\uput{1pt}[#1#](#2#,#3#){';
    linestr = strfill(linestr,{refangle,linecor1,linecor2});
    wrstr = [wrstr,linestr];
    wrstr = [wrstr,'\begin{tabular}{c}'];
    for labstr = annostr'
        wrstr = [wrstr,strcat(labstr,'\\')];
    end;
    wrstr = [wrstr,'\end{tabular}','}'];
    for linestr=wrstr
        fprintf(fid,'\n%s',linestr{1});
    end;
end;



fprintf(fid,'\n%s\n','\end{pspicture*}');
fclose(fid);

function resstr = strfill(genstr,fpar)
%STRFILL Replace the numbered tokens with parameters
%   STRFILL(GENSTR,FPAR) replaces the numbered token
%   #i# in the string GENSTR with the ith element
%   of the cellarray FPAR. This script is used by
%   FIG2TEX.
%
%   Copyright 2005 Ercan Solak
%   Version: 0.51 Date: 2005/6/21
%   These script is free software; you may redistribute it
%   and/or modify it under the conditions of the
%   LaTeX Project Public License, version 1.2 or later.

resstr=genstr;
for i=1:length(fpar)
    if isnumeric(fpar{i})
%         reptoken = sprintf('%12.6f',fpar{i});
        reptoken = num2str(fpar{i});        
    else
        reptoken = fpar{i};
    end;
%    resstr = strrep(resstr,['#',num2str(i),'#'],reptoken);
    resstr = strrep(resstr,['#',num2str(i),'#'],reptoken);    
end;

% =========== MARKER PART ========== 
% Copied from David Krause's file figure2latex.m 
function tex_out = matlab_marker_to_latex(mkr_in)

if strcmp(mkr_in, '+')
    tex_out = '+';
elseif strcmp(mkr_in, 'o')
    tex_out = '$\circ$';
elseif strcmp(mkr_in, '*')
    tex_out = '$\ast$';
elseif strcmp(mkr_in, '.')
    tex_out = '$\bullet$';
elseif strcmp(mkr_in, 'x')
    tex_out = '$\times$';
elseif strcmp(mkr_in, 'square')
    tex_out = '$\Box$';
elseif strcmp(mkr_in, 'diamond')
    tex_out = '$\Diamond$';
elseif strcmp(mkr_in, 'v')
    tex_out = '$\nabla$';
elseif strcmp(mkr_in, '^')
    tex_out = '$\triangle$';
elseif strcmp(mkr_in, '>')
    tex_out = '$\triangleright$';
elseif strcmp(mkr_in, '<')
    tex_out = '$\triangleleft$';
elseif strcmp(mkr_in, 'pentagram')
    tex_out = '$\star$';
elseif strcmp(mkr_in, 'hexgram')
    tex_out = '$\bowtie$';
elseif strcmp(mkr_in, 'none')
    tex_out = 'none';    
else
    tex_out = '$\otimes$';
end    
%-----------------------------------------------------------    
