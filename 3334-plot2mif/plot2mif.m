function varargout=plot2mif(param1,id)
%  Matlab to MIF converter
%  Only 2D plots are currently supported
%
%  Usage: plot2mif(filename,graphic handle)
%                  optional     optional
%         or
%
%         plot2mif(figuresize,graphic handle)
%                   optional    optional
%
%  Juerg Schwizer 24-April-2005
%  converter@juergschwizer.de
%
%  06.09.2002 - fixed, if no input parameter...
%  08.10.2002 - fixed plot2patch error of empty arrays due to NaN arrays
%  24.04.2005 - improvement of axes without a box, spect ratio, grid lines, exponent
%  values, text color, colorbars, patches
%
global colorname
global fixcolorptr
progversion='24-Apr-2005';
if nargout==1
    varargout={0};
end
disp(['   Matlab to MIF converter version ' progversion ', Juerg Schwizer (converter@juergschwizer.de).'])
matversion=version;
if str2num(matversion(1))<6 % Check for matlab version and print warning if matlab version lower than version 6.0 (R.12)
    disp('   Warning: Future versions may no more support older versions than MATLAB R12.')
end
if nargout > 1
    error('Function returns only one return value.')
end
if nargin<2 % Check if handle was included into function call, otherwise take current figure
    id=gcf;
end
if nargin==0
    [filename, pathname] = uiputfile( {'*.mif', 'MIF File (*.mif)'},'Save Figure as MIF File');  
    if ~( isequal( filename, 0) | isequal( pathname, 0))    
        % yes. add backslash to path (if not already there)
        pathname = addBackSlash( pathname); 
        % check, if ectension is allrigth
        if ( ~strcmpi( getFileExtension( filename), '.mif'))
            filename = [ filename, '.mif'];
        end
        finalname=[pathname filename];
    else
        error('Incorrect file or path name.')
    end
else
    if isnumeric(param1)
        [filename, pathname] = uiputfile( {'*.mif', 'MIF File (*.mif)'},'Save Figure as MIF File');  
        if ~( isequal( filename, 0) | isequal( pathname, 0))    
            % yes. add backslash to path (if not already there)
            pathname = addBackSlash( pathname); 
            % check, if ectension is allrigth
            if ( ~strcmpi( getFileExtension( filename), '.mif'))
                filename = [ filename, '.mif'];
            end
            finalname=[pathname filename];
        else
            error('Incorrect file or path name.')
        end     
    else
        finalname=param1;   
    end
end
originalFigureUnits=get(id,'Units');
set(id,'Units','inches');   % All data in the mif-file is saved in inches
% Open MIF-file
fid=fopen(finalname,'wt');   % Create a new text file
fprintf(fid,'<MIFFile 5.00>\n');    % Insert file header
group=1;
groups=[];
axfound=0;
fprintf(fid,'<Font <FSize 10><FFamily Times New Roman><FSize 10><FPlain Yes><FBold No><FDX 0><FDY 0><FDAX 0><FNoAdvance No>>\n');
fprintf(fid,'<ColorCatalog ');
% Insert ColorMap
cmap=get(id,'Colormap');
colorname='';
fixcolorptr=[];
for i=1:size(cmap,1)
    colorname(i,:)=[num2str((1-cmap(i,1))*100,'%03.0f') num2str((1-cmap(i,2))*100,'%03.0f') num2str((1-cmap(i,3))*100,'%03.0f')];
    fprintf(fid,'<Color <ColorTag Matlab%s>',colorname(i,:));
    fprintf(fid,'<ColorCyan %0.0f><ColorMagenta %0.0f><ColorYellow %0.0f><ColorBlack 0>>',(1-cmap(i,1))*100,(1-cmap(i,2))*100,(1-cmap(i,3))*100);
end
% Insert FixedColors
fixmap=get(id,'FixedColor');
for i=1:size(fixmap,1)
    pos=size(colorname,1)+1;
    fixcolorptr(i)=pos;
    colorname(pos,:)=[num2str((1-fixmap(i,1))*100,'%03.0f') num2str((1-fixmap(i,2))*100,'%03.0f') num2str((1-fixmap(i,3))*100,'%03.0f')];
    fprintf(fid,'<Color <ColorTag Matlab%s>',colorname(pos,:));
    fprintf(fid,'<ColorCyan %0.0f><ColorMagenta %0.0f><ColorYellow %0.0f><ColorBlack 0>>',(1-fixmap(i,1))*100,(1-fixmap(i,2))*100,(1-fixmap(i,3))*100);
end
fprintf(fid,'>\n');
% Frame of figure
paperpos=get(id,'Position');


if ( nargin>0)
    if isnumeric(param1)
        paperpos(3)=param1(1);
        paperpos(4)=param1(2);
    end
end


fprintf(fid,'<Rectangle <Fill 0><Pen 15><ObColor White><GroupID 1>',group); % Draw white rectangle in the background of the graphic frame to cover all other graphic elements
fprintf(fid,'<ShapeRect 0" 0" %0.3f" %0.3f">>\n',paperpos(3),paperpos(4));
fprintf(fid,'<Font <FSize 10><FFamily Times New Roman><FSize 10><FColor `Black''>>\n');
% Search all axes
ax=get(id,'Children');
for j=length(ax):-1:1
    if strcmp(get(ax(j),'Type'),'axes')
        group=group+1;
        groups=[groups group];
        group=axes2mif(fid,id,ax(j),group,paperpos);
        axfound=1;
    end
    if strcmp(get(ax(j),'Type'),'uicontrol')
        if strcmp(get(ax(j),'Visible'),'on')
            control2mif(fid,id,ax(j),group,paperpos);
            axfound=1;
        end
    end
end
if axfound==0
    error('No axes & controls in figure or figure does not exist.')
end
% Text frame below figure
fprintf(fid,'<TextRect <ID 2><GroupID 1><Fill 15><Pen 15><Separation 2>');
fprintf(fid,'<ShapeRect 0" %0.3f" %0.3f" 0.5">',paperpos(4),paperpos(3));
fprintf(fid,'<BRect  0.25 cm 8.5 cm 8.75 cm 1.25 cm><TRNumColumns 1><TRColumnGap  0.5 cm>');
fprintf(fid,'<TRColumnBalance No><TRSideheadWidth  3.0 cm><TRSideheadGap  0.5 cm><TRSideheadPlacement Left><TRNext 0>>\n');
% Print source file information
fprintf(fid,'<Font <FFamily Times New Roman><FSize 5><FPlain Yes><FBold No><FNoAdvance No><FPosition FNormal>>');
fprintf(fid,'<TextLine <GroupID 1><TLOrigin %0.3f" %0.3f"><TLAlignment Right><String `%s''>>',paperpos(3),paperpos(4)-0.05,finalname);
for i=1:length(groups); % Define all groups in the mif-file
    fprintf(fid,'<Group <GroupID 1><ID %0.0f>>',groups(i));
end
fprintf(fid,'<Group <ID 1>>');
% Paragraph of the text frame
fprintf(fid,'<TextFlow <Para <PgfTag `jsFigure''><ParaLine <TextRectID 2><String `''>>>>');

fclose(fid);    % close text file
if nargout==1
    varargout={0};
end
set(id,'Units',originalFigureUnits);


% ************************ SUBFUNCTIONS ***********************************************
% Create axis frame and insert all children of this axis frame
function group=axes2mif(fid,id,ax,group,paperpos)
global fixcolorptr
global colorname
originalAxesUnits=get(ax,'Units');
set(ax,'Units','normalized');
groupax=group;
axlimx=get(ax,'XLim');
axlimy=get(ax,'YLim');
axlimxori=axlimx;
axlimyori=axlimy;
if strcmp(get(ax,'XScale'),'log')
    axlimx=log10(axlimx);
    axlimx(find(isinf(axlimx)))=0;
end
if strcmp(get(ax,'YScale'),'log')
    axlimy=log10(axlimy);
    axlimy(find(isinf(axlimy)))=0;
end
axlimori=[axlimxori(1) axlimyori(1) axlimxori(2)-axlimxori(1) axlimyori(2)-axlimyori(1)];
axlim=[axlimx(1) axlimy(1) axlimx(2)-axlimx(1) axlimy(2)-axlimy(1)];
axpos=get(ax,'Position');
if strcmp(get(ax,'PlotBoxAspectRatioMode'),'manual')
    aspect_ratio = get(ax,'PlotBoxAspectRatio');
    if axpos(3)*aspect_ratio(2)*paperpos(3)/paperpos(4) < axpos(4)*aspect_ratio(1)*paperpos(4)/paperpos(3)
        old_width = axpos(4);
        axpos(4) = axpos(3)*paperpos(3)/paperpos(4)*aspect_ratio(1)/aspect_ratio(2);
        axpos(2) = axpos(2) + (old_width-axpos(4))/2;
    else
        old_height = axpos(3);
        axpos(3) = axpos(4)*paperpos(4)/paperpos(3)*aspect_ratio(1)/aspect_ratio(2);
        axpos(1) = axpos(1) + (old_height-axpos(3))/2;
    end
end
if strcmp(get(ax,'Visible'),'on')
    group=group+1;
    grouplabel=group;
    linewidth=get(ax,'LineWidth');
    if ~strcmp(get(ax,'Color'),'none')
        scolorname=searchcolor(id,get(ax,'Color'));
        fprintf(fid,'%s',['<Rectangle <ObColor ' scolorname '><Fill 0><Pen 15><PenWidth ' num2str(linewidth) 'pt><GroupID ' num2str(grouplabel) '> ']);
        fprintf(fid,'%s',['<ShapeRect ' num2str(axpos(1)*paperpos(3)) '" ' num2str((1-(axpos(2)+axpos(4)))*paperpos(4)) '" ' num2str(axpos(3)*paperpos(3)) '" ' num2str(axpos(4)*paperpos(4)) '"> ']);
        fprintf(fid,'%s\n','>');
    end
end
axchild=get(ax,'Child');
for i=length(axchild):-1:1
    if strcmp(get(axchild(i),'Type'),'line')
        scolorname=searchcolor(id,get(axchild(i),'Color'));
        linestyle=get(axchild(i),'LineStyle');
        linewidth=get(axchild(i),'LineWidth');
        marker=get(axchild(i),'Marker');
        markeredgecolor=get(axchild(i),'MarkerEdgeColor');
        if ischar(markeredgecolor)
            switch markeredgecolor
                case 'none',markeredgecolorname='none';
                otherwise,markeredgecolorname=scolorname;  % if markeredgecolorname is 'auto' or something else set the markeredgecolorname to the line color
            end    
        else    
            markeredgecolorname=searchcolor(id,markeredgecolor);
        end
        markerfacecolor=get(axchild(i),'MarkerFaceColor');
        if ischar(markerfacecolor)
            switch markerfacecolor
                case 'none',markerfacecolorname='none';
                otherwise,markerfacecolorname=scolorname;  % if markerfacecolorname is 'auto' or something else set the markerfacecolorname to the line color
            end
        else
            markerfacecolorname=searchcolor(id,markerfacecolor);
        end
        markersize=get(axchild(i),'MarkerSize');
        linex=get(axchild(i),'XData');
        if strcmp(get(ax,'XScale'),'log')
            linex(find(linex<=0))=NaN;
            linex=log10(linex);
        end
        liney=get(axchild(i),'YData');
        if strcmp(get(ax,'YScale'),'log')
            liney(find(liney<=0))=NaN;
            liney=log10(liney);
        end
        if ~strcmp(get(ax,'XDir'),'reverse')
            x=((linex-axlim(1))/axlim(3)*axpos(3)+axpos(1))*paperpos(3);
        else
            x=((axlim(3)-(linex-axlim(1)))/axlim(3)*axpos(3)+axpos(1))*paperpos(3);
        end
        if ~strcmp(get(ax,'YDir'),'reverse')
            y=(1-((liney-axlim(2))/axlim(4)*axpos(4)+axpos(2)))*paperpos(4);
        else
            y=(1-((axlim(4)-(liney-axlim(2)))/axlim(4)*axpos(4)+axpos(2)))*paperpos(4);
        end
        line2mif(fid,groupax,axpos,x,y,scolorname,linestyle,linewidth)
        switch marker
            case 'none';
            case '.',group=group+1;,circle2mif(fid,group,axpos,x,y,markersize/360,'none',markeredgecolorname,linewidth);
            case 'o',group=group+1;,circle2mif(fid,group,axpos,x,y,markersize/144,markeredgecolorname,markerfacecolorname,linewidth);
            case '+',group=group+1;,patch2mif(fid,group,axpos,x'*ones(1,5)+ones(length(linex),1)*[-1 1 NaN 0 0]*markersize/144,y'*ones(1,5)+ones(length(liney),1)*[0 0 NaN -1 1]*markersize/144,markeredgecolorname,'-',linewidth,markeredgecolorname);   
            case '*',group=group+1;,patch2mif(fid,group,axpos,x'*ones(1,11)+ones(length(linex),1)*[-1 1 NaN 0 0 NaN -0.7 0.7 NaN -0.7 0.7]*markersize/144,y'*ones(1,11)+ones(length(liney),1)*[0 0 NaN -1 1 NaN 0.7 -0.7 NaN -0.7 0.7]*markersize/144,markeredgecolorname,'-',linewidth,markeredgecolorname);   
            case 'x',group=group+1;,patch2mif(fid,group,axpos,x'*ones(1,5)+ones(length(linex),1)*[-0.7 0.7 NaN -0.7 0.7]*markersize/144,y'*ones(1,5)+ones(length(liney),1)*[0.7 -0.7 NaN -0.7 0.7]*markersize/144,markeredgecolorname,'-',linewidth,markeredgecolorname);   
            case 'square',group=group+1;,patch2mif(fid,group,axpos,x'*ones(1,5)+ones(length(linex),1)*[-1 -1 1 1 -1]*markersize/144,y'*ones(1,5)+ones(length(liney),1)*[-1 1 1 -1 -1]*markersize/144,markerfacecolorname,'-',linewidth,markeredgecolorname);   
            case '^',group=group+1;,patch2mif(fid,group,axpos,x'*ones(1,4)+ones(length(linex),1)*[-1 1 0 -1]*markersize/144,y'*ones(1,4)+ones(length(liney),1)*[0.577 0.577 -0.837 0.577]*markersize/144,markerfacecolorname,'-',linewidth,markeredgecolorname);   
            case 'v',group=group+1;,patch2mif(fid,group,axpos,x'*ones(1,4)+ones(length(linex),1)*[-1 1 0 -1]*markersize/144,y'*ones(1,4)+ones(length(liney),1)*[-0.577 -0.577 0.837 -0.577]*markersize/144,markerfacecolorname,'-',linewidth,markeredgecolorname);   
            case '<',group=group+1;,patch2mif(fid,group,axpos,x'*ones(1,4)+ones(length(linex),1)*[0.577 0.577 -0.837 0.577]*markersize/144,y'*ones(1,4)+ones(length(liney),1)*[-1 1 0 -1]*markersize/144,markerfacecolorname,'-',linewidth,markeredgecolorname);   
            case '>',group=group+1;,patch2mif(fid,group,axpos,x'*ones(1,4)+ones(length(linex),1)*[-0.577 -0.577 0.837 -0.577]*markersize/144,y'*ones(1,4)+ones(length(liney),1)*[-1 1 0 -1]*markersize/144,markerfacecolorname,'-',linewidth,markeredgecolorname);   
        end
    end
    if strcmp(get(axchild(i),'Type'),'patch')
        cmap=get(id,'Colormap');
        pointc=get(axchild(i),'CData');
        if strcmp(get(axchild(i),'CDataMapping'),'scaled')
            clim=get(ax,'CLim');
            pointc=(pointc-clim(1))/(clim(2)-clim(1))*(size(cmap,1)-1)+1;
        end
        valid_pointc_index = find(~isnan(pointc));
        if ischar(get(axchild(i),'FaceColor'))
            if ~isempty(valid_pointc_index)
                if strcmp(get(axchild(i),'FaceColor'),'flat')
                    scolorname = ['Matlab' colorname(ceil(pointc(valid_pointc_index(1))),:)];
                else
                    scolorname = 'none';
                end
            else
                scolorname='none';
            end
        else
            scolorname = searchcolor(id,get(axchild(i),'EdgeColor'));       
        end
        if ischar(get(axchild(i),'EdgeColor'))
            if ~isempty(valid_pointc_index)
                if strcmp(get(axchild(i),'EdgeColor'),'flat')
                    edgecolorname = ['Matlab' colorname(ceil(pointc(valid_pointc_index(1))),:)];
                else
                    edgecolorname = 'none';
                end
            else
                edgecolorname = 'none';
            end
        else
            edgecolorname = searchcolor(id,get(axchild(i),'EdgeColor'));       
        end
        linestyle=get(axchild(i),'LineStyle');
        linewidth=get(axchild(i),'LineWidth');
        points=get(axchild(i),'Vertices')';
        if strcmp(get(ax,'XScale'),'log')
            points(1,:)=log10(points(1,:));
        end
        liney=get(axchild(i),'YData');
        if strcmp(get(ax,'YScale'),'log')
            points(2,:)=log10(points(2,:));
        end
        if ~strcmp(get(ax,'XDir'),'reverse')
            x=((points(1,:)-axlim(1))/axlim(3)*axpos(3)+axpos(1))*paperpos(3);
        else
            x=((axlim(3)-(points(1,:)-axlim(1)))/axlim(3)*axpos(3)+axpos(1))*paperpos(3);
        end
        if ~strcmp(get(ax,'YDir'),'reverse')
            y=(1-((points(2,:)-axlim(2))/axlim(4)*axpos(4)+axpos(2)))*paperpos(4);
        else
            y=(1-((axlim(4)-(points(2,:)-axlim(2)))/axlim(4)*axpos(4)+axpos(2)))*paperpos(4);
        end
        patch2mif(fid,group,axpos,x,y,scolorname,linestyle,linewidth,edgecolorname)
    end
    if strcmp(get(axchild(i),'Type'),'text')
        text2mif(fid,1,axpos,axlim,paperpos,axchild(i),ax)
    end
    if strcmp(get(axchild(i),'Type'),'image')
        cmap=get(id,'Colormap');
        pointx=get(axchild(i),'XData');
        pointy=get(axchild(i),'YData');
        pointc=get(axchild(i),'CData');
        if strcmp(get(axchild(i),'CDataMapping'),'scaled')
            clim=get(ax,'CLim');
            pointc=(pointc-clim(1))/(clim(2)-clim(1))*size(cmap,1);
        end
        data_aspect_ratio = get(ax,'DataAspectRatio');
        if length(pointx)==2
            if size(pointc,2)==1
                halfwidthx = (pointx(2) - pointx(1)) * data_aspect_ratio(1);
            else
                halfwidthx = (pointx(2)-pointx(1))/(size(pointc,2)-1);   
            end
        else
            halfwidthx = data_aspect_ratio(1);
        end
        if length(pointy)==2
            if size(pointc,1)==1
                halfwidthy = (pointy(2)-pointy(1)) * data_aspect_ratio(2);
            else
                halfwidthy = (pointy(2)-pointy(1))/(size(pointc,1)-1);   
            end
        else
            halfwidthy = data_aspect_ratio(2);
        end
        if strcmp(get(ax,'YDir'),'reverse')
            pointc=flipud(pointc);
        end
        pointc = max(min(round(double(pointc)),size(cmap,1)),1);
        CameraUpVector=get(ax,'CameraUpVector');
        %if CameraUpVector(2)==1
        imwrite(flipud(pointc),cmap,'test.tif','tif');
        %else
        %imwrite(pointc,cmap,'test.tif','tif');
        %end
        lx=num2str((size(pointc,2)*halfwidthx)/axlim(3)*axpos(3)*paperpos(3));
        ly=num2str((size(pointc,1)*halfwidthy)/axlim(4)*axpos(4)*paperpos(4));
        pointsx=num2str((axpos(1))*paperpos(3));
        pointsy=num2str((1-(axpos(4)+axpos(2)))*paperpos(4));
        fprintf(fid,'<ImportObject <ObColor Black><ImportObFixedSize Yes><GroupID %0.0f><ShapeRect %s" %s" %s" %s">\n',group,pointsx,pointsy,lx,ly);
        dummy=fopen('test.tif','r');
        dummy1=fread(dummy);
        fprintf(fid,'%s\n',['=TIFF']);
        fprintf(fid,'%s\n',['&%v']);
        fprintf(fid,'%s\n',['&\x']);
        for l=1:30:length(dummy1)
            fprintf(fid,'%s','&');
            fprintf(fid,'%02X',dummy1(l:min(l+29,length(dummy1))));
            fprintf(fid,'\n');
        end
        fclose(dummy);
        fprintf(fid,'%s\n',['&\x']);
        fprintf(fid,'%s\n',['=EndInset']);
        fprintf(fid,'%s\n',['<ImportObFile `2.0 internal inset''>>']);
    end
end
if strcmp(get(ax,'Visible'),'on')
    axxtick=get(ax,'XTick');
    axytick=get(ax,'YTick');
    axxindex=find((axxtick<axlimori(1))|(axxtick>(axlimori(1)+axlimori(3))));
    axyindex=find((axytick<axlimori(2))|(axytick>(axlimori(2)+axlimori(4))));
    % remove sticks outside of the axes (-1 of legends)
    for i=1:length(axxindex)
        axxtick=[axxtick(1:(axxindex(i)-1)) axxtick((axxindex(i)+1):end)];   
    end
    for i=1:length(axyindex)
        axytick=[axytick(1:(axyindex(i)-1)) axytick((axyindex(i)+1):end)];
    end
    axxindex_inner = find((axxtick > axlimori(1)) & (axxtick < (axlimori(1)+axlimori(3))));
    axyindex_inner = find((axytick > axlimori(2)) & (axytick < (axlimori(2)+axlimori(4))));
    if ~strcmp(get(ax,'XDir'),'reverse')
        axxtick=((axxtick-axlim(1))/axlim(3)*axpos(3)+axpos(1))*paperpos(3);
    else
        axxtick=((axlim(3)-(axxtick-axlim(1)))/axlim(3)*axpos(3)+axpos(1))*paperpos(3);
    end
    if ~strcmp(get(ax,'YDir'),'reverse')
        axytick=(1-((axytick-axlim(2))/axlim(4)*axpos(4)+axpos(2)))*paperpos(4);
    else    
        axytick=(1-((axlim(4)-(axytick-axlim(2)))/axlim(4)*axpos(4)+axpos(2)))*paperpos(4);    
    end
    if strcmp(get(ax,'XScale'),'log')
        axxtick=((log10(get(ax,'XTick'))-axlim(1))/axlim(3)*axpos(3)+axpos(1))*paperpos(3);
    end
    if strcmp(get(ax,'YScale'),'log')
        axytick=(1-(((log10(get(ax,'YTick'))-axlim(2)))/axlim(4)*axpos(4)+axpos(2)))*paperpos(4);
    end
    axlabelx=get(ax,'XTickLabel');
    axlabely=get(ax,'YTickLabel');
    ticklength=get(ax,'TickLength');
    linewidth = get(ax,'LineWidth');
    if strcmp(get(ax,'TickDir'),'out')
        ticklength=-ticklength;
        valid_xsticks = 1:length(axxtick);
        valid_ysticks = 1:length(axytick);
    else
        valid_xsticks = axxindex_inner;
        valid_ysticks = axyindex_inner;
    end
    scolorname=searchcolor(id,get(ax,'XColor'));
    % Draw 'box' of x-axis
    if strcmp(get(ax,'Box'),'on')
        line2mif(fid,grouplabel,axpos,[axpos(1)*paperpos(3) (axpos(1)+axpos(3))*paperpos(3)],[(1-(axpos(2)+axpos(4)))*paperpos(4) (1-(axpos(2)+axpos(4)))*paperpos(4)],scolorname,'-',linewidth)
        line2mif(fid,grouplabel,axpos,[axpos(1)*paperpos(3) (axpos(1)+axpos(3))*paperpos(3)],[(1-axpos(2))*paperpos(4) (1-axpos(2))*paperpos(4)],scolorname,'-',linewidth)
    else
        if strcmp(get(ax,'XAxisLocation'),'top')
            line2mif(fid,grouplabel,axpos,[axpos(1)*paperpos(3) (axpos(1)+axpos(3))*paperpos(3)],[(1-(axpos(2)+axpos(4)))*paperpos(4) (1-(axpos(2)+axpos(4)))*paperpos(4)],scolorname,'-',linewidth)
        else
            line2mif(fid,grouplabel,axpos,[axpos(1)*paperpos(3) (axpos(1)+axpos(3))*paperpos(3)],[(1-axpos(2))*paperpos(4) (1-axpos(2))*paperpos(4)],scolorname,'-',linewidth)
        end
    end
    % Draw x-grid
    if strcmp(get(ax,'XGrid'),'on')
        gridlinestyle=get(ax,'GridLineStyle');
        for i = axxindex_inner
            line2mif(fid,grouplabel,axpos,[axxtick(i) axxtick(i)],[(1-((axlimy(1)-axlim(2))/axlim(4)*axpos(4)+axpos(2)))*paperpos(4) (1-((axlimy(2)-axlim(2))/axlim(4)*axpos(4)+axpos(2)))*paperpos(4)],scolorname,gridlinestyle,linewidth)
        end
    end
    % Draw x-tick marks
    for i = valid_xsticks
        line2mif(fid,grouplabel,axpos,[axxtick(i) axxtick(i)],[(1-((axlimy(1)-axlim(2))/axlim(4)*axpos(4)+axpos(2)))*paperpos(4) paperpos(4)-ticklength(1)*paperpos(3)-((axlimy(1)-axlim(2))/axlim(4)*axpos(4)+axpos(2))*paperpos(4)],scolorname,'-',linewidth)
        line2mif(fid,grouplabel,axpos,[axxtick(i) axxtick(i)],[(1-((axlimy(2)-axlim(2))/axlim(4)*axpos(4)+axpos(2)))*paperpos(4) paperpos(4)+ticklength(1)*paperpos(3)-((axlimy(2)-axlim(2))/axlim(4)*axpos(4)+axpos(2))*paperpos(4)],scolorname,'-',linewidth)
    end
    % Draw x-tick labels
    for i=1:length(axxtick)
        if ~isempty(axlabelx)
            if strcmp(get(ax,'XAxisLocation'),'top')
                label2mif(fid,grouplabel,axpos,ax,axxtick(i),(1-((axlimy(2)-axlim(2))/axlim(4)*axpos(4)+axpos(2)))*paperpos(4)-0.04,convertString(axlabelx(i,:)),'Center',0,'bottom',1,paperpos,scolorname);
            else
                label2mif(fid,grouplabel,axpos,ax,axxtick(i),(1-((axlimy(1)-axlim(2))/axlim(4)*axpos(4)+axpos(2)))*paperpos(4)+0.04,convertString(axlabelx(i,:)),'Center',0,'top',1,paperpos,scolorname);
            end
        end
    end
    scolorname=searchcolor(id,get(ax,'YColor'));
    % Draw 'box' of y-axis
    if strcmp(get(ax,'Box'),'on')
        line2mif(fid,grouplabel,axpos,[axpos(1)*paperpos(3) axpos(1)*paperpos(3)],[(1-axpos(2))*paperpos(4) (1-(axpos(2)+axpos(4)))*paperpos(4)],scolorname,'-',linewidth)
        line2mif(fid,grouplabel,axpos,[(axpos(1)+axpos(3))*paperpos(3) (axpos(1)+axpos(3))*paperpos(3)],[(1-axpos(2))*paperpos(4) (1-(axpos(2)+axpos(4)))*paperpos(4)],scolorname,'-',linewidth)
    else
        if strcmp(get(ax,'XAxisLocation'),'top')
            line2mif(fid,grouplabel,axpos,[(axpos(1)+axpos(3))*paperpos(3) (axpos(1)+axpos(3))*paperpos(3)],[(1-axpos(2))*paperpos(4) (1-(axpos(2)+axpos(4)))*paperpos(4)],scolorname,'-',linewidth)
        else
            line2mif(fid,grouplabel,axpos,[axpos(1)*paperpos(3) axpos(1)*paperpos(3)],[(1-axpos(2))*paperpos(4) (1-(axpos(2)+axpos(4)))*paperpos(4)],scolorname,'-',linewidth)
        end
    end
    % Draw y-grid
    if strcmp(get(ax,'YGrid'),'on')
        gridlinestyle=get(ax,'GridLineStyle');
        for i=axyindex_inner
            line2mif(fid,grouplabel,axpos,[((axlimx(1)-axlim(1))/axlim(3)*axpos(3)+axpos(1))*paperpos(3) ((axlimx(2)-axlim(1))/axlim(3)*axpos(3)+axpos(1))*paperpos(3)],[axytick(i) axytick(i)],scolorname,gridlinestyle,linewidth)
        end
    end
    % Draw y-tick marks
    for i = valid_ysticks
        line2mif(fid,grouplabel,axpos,[((axlimx(1)-axlim(1))/axlim(3)*axpos(3)+axpos(1))*paperpos(3) (ticklength(1)+(axlimx(1)-axlim(1))/axlim(3)*axpos(3)+axpos(1))*paperpos(3)],[axytick(i) axytick(i)],scolorname,'-',linewidth)
        line2mif(fid,grouplabel,axpos,[((axlimx(2)-axlim(1))/axlim(3)*axpos(3)+axpos(1))*paperpos(3) (-ticklength(1)+(axlimx(2)-axlim(1))/axlim(3)*axpos(3)+axpos(1))*paperpos(3)],[axytick(i) axytick(i)],scolorname,'-',linewidth)
    end
    % Draw y-tick labels
    for i=1:length(axytick)
        if ~isempty(axlabely)
            if strcmp(get(ax,'YAxisLocation'),'right')
                label2mif(fid,grouplabel,axpos,ax,((axlimx(2)-axlim(1))/axlim(3)*axpos(3)+axpos(1))*paperpos(3)+0.04,axytick(i),convertString(axlabely(i,:)),'Left',0,'middle',1,paperpos,scolorname);
            else
                label2mif(fid,grouplabel,axpos,ax,((axlimx(1)-axlim(1))/axlim(3)*axpos(3)+axpos(1))*paperpos(3)-0.04,axytick(i),convertString(axlabely(i,:)),'Right',0,'middle',1,paperpos,scolorname);
            end
        end
    end
    exponent2mif(fid,groupax,axpos,paperpos,ax)
    titleID=get(ax,'Title');
    text2mif(fid,groupax,axpos,axlim,paperpos,titleID,ax)
    xlabelID=get(ax,'XLabel');
    text2mif(fid,groupax,axpos,axlim,paperpos,xlabelID,ax)
    ylabelID=get(ax,'YLabel');
    text2mif(fid,groupax,axpos,axlim,paperpos,ylabelID,ax)
    for i=(groupax+1):group;
        fprintf(fid,'<Group <GroupID %0.0f><ID %0.0f>>',groupax,i);
    end
end
set(ax,'Units',originalAxesUnits);


% create a patch (filled area)
function patch2mif(fid,group,axpos,xtot,ytot,scolorname,style,width,edgecolorname)
if ~strcmp(style,'none')
    for i=1:size(xtot,1)
        x=xtot(i,:);
        y=ytot(i,:);
        switch style
            case '--',pattern='<DashedPattern <DashedStyle Dashed><NumSegments 2><DashSegment 10pt><DashSegment 4pt>>';
            case ':',pattern='<DashedPattern <DashedStyle Dashed><NumSegments 2><DashSegment 2pt><DashSegment 2pt>>';
            case '-.',pattern='<DashedPattern <DashedStyle Dashed><NumSegments 4><DashSegment 10pt><DashSegment 2pt><DashSegment 2pt><DashSegment 2pt>>';
            otherwise,pattern='<DashedPattern <DashedStyle Solid>>';   
        end
        if (isnan(x)==zeros(size(x))&isnan(y)==zeros(size(y)))
            for j=1:20000:length(x)
                xx=x(j:min(length(x),j+19999));
                yy=y(j:min(length(y),j+19999));
                if ~strcmp(scolorname,'none')
                    fprintf(fid,'<PolyLine <Fill 0><Pen 15><ObColor %s>%s',scolorname,pattern);
                    fprintf(fid,'<GroupID %0.0f>',group);
                    fprintf(fid,'<NumPoints %0.0f>',length(xx));
                    fprintf(fid,'<Point %0.3f" %0.3f">',[xx;yy]);
                    fprintf(fid,'%s\n',' > ');
                end
                if ~strcmp(edgecolorname,'none')
                    fprintf(fid,'<PolyLine <Fill 15><Pen 0><PenWidth %0.3fpt><ObColor %s>%s',width,edgecolorname,pattern);
                    fprintf(fid,'<GroupID %0.0f>',group);
                    fprintf(fid,'<NumPoints %0.0f>',length(xx));
                    fprintf(fid,'<Point %0.3f" %0.3f">',[xx;yy]);
                    fprintf(fid,'%s\n',' > ');
                end
            end
        else
            parts=find(isnan(x)+isnan(y));
            if parts(1)~=1
                parts=[0 parts];
            end
            if parts(length(parts))~=length(x)
                parts=[parts length(x)+1];
            end
            for j=1:(length(parts)-1)
                xx=x((parts(j)+1):(parts(j+1)-1));
                yy=y((parts(j)+1):(parts(j+1)-1));
                if ~strcmp(edgecolorname,'none')
                    if length(xx)~=0
                        fprintf(fid,'<PolyLine <Fill 15><Pen 0><PenWidth %0.3fpt><ObColor %s>%s',width,edgecolorname,pattern);
                        fprintf(fid,'<GroupID %0.0f>',group);
                        fprintf(fid,'<NumPoints %0.0f>',length(xx));
                        fprintf(fid,'<Point %0.3f" %0.3f">',[xx;yy]);
                        fprintf(fid,'>\n');
                    end
                end
            end
        end
    end
end

% create a line segment
% this algorthm was optimized for large segement counts
function line2mif(fid,group,axpos,x,y,scolorname,style,width)
if ~strcmp(style,'none')
    switch style
        case '--',pattern='<DashedPattern <DashedStyle Dashed><NumSegments 2><DashSegment 10pt><DashSegment 4pt>>';
        case ':',pattern='<DashedPattern <DashedStyle Dashed><NumSegments 2><DashSegment 2pt><DashSegment 2pt>>';
        case '-.',pattern='<DashedPattern <DashedStyle Dashed><NumSegments 4><DashSegment 10pt><DashSegment 2pt><DashSegment 2pt><DashSegment 2pt>>';
        otherwise,pattern='<DashedPattern <DashedStyle Solid>>';   
    end
    if (isnan(x)==zeros(size(x))&isnan(y)==zeros(size(y)))
        for j=1:20000:length(x)
            xx=x(j:min(length(x),j+19999));
            yy=y(j:min(length(y),j+19999));
            fprintf(fid,'<PolyLine <Fill 15><Pen 0><PenWidth %0.3fpt><ObColor %s>%s',width,scolorname,pattern);
            fprintf(fid,'<GroupID %0.0f>',group);
            fprintf(fid,'<NumPoints %0.0f>',length(xx));
            fprintf(fid,'<Point %0.3f" %0.3f">',[xx;yy]);
            fprintf(fid,'%s\n',' > ');
        end
    else
        parts=find(isnan(x)+isnan(y));
        if parts(1)~=1
            parts=[0 parts];
        end
        if parts(length(parts))~=length(x)
            parts=[parts length(x)+1];
        end
        for j=1:(length(parts)-1)
            xx=x((parts(j)+1):(parts(j+1)-1));
            yy=y((parts(j)+1):(parts(j+1)-1));
            if length(xx)~=0
                fprintf(fid,'<PolyLine <Fill 15><Pen 0><PenWidth %0.3fpt><ObColor %s>%s',width,scolorname,pattern);
                fprintf(fid,'<GroupID %0.0f>',group);
                fprintf(fid,'<NumPoints %0.0f>',length(xx));
                fprintf(fid,'<Point %0.3f" %0.3f">',[xx;yy]);
                fprintf(fid,'>\n');
            end
        end
    end
end

% create a circle
function circle2mif(fid,group,axpos,x,y,radius,markeredgecolorname,markerfacecolorname,width)
for j=1:length(x)
    if ~(isnan(x(j)) | isnan(y(j)))
        if ~strcmp(markerfacecolorname,'none')    % Check if circle is filled and draw filled circle with the appropriate color
            fprintf(fid,'<Ellipse <Fill 0><Pen 15><ObColor %s>',markerfacecolorname);
            fprintf(fid,'<GroupID %0.0f>',group);
            fprintf(fid,'<ShapeRect %0.3f" %0.3f" %0.3f" %0.3f">',[x(j)-radius;y(j)-radius;2*radius;2*radius]);
            fprintf(fid,'%s\n',' > ');
        end
        if ~strcmp(markeredgecolorname,'none')    % Check if circle has a border and draw an empty circle with the appropriate line color
            fprintf(fid,'<Ellipse <Fill 15><Pen 0><PenWidth %0.3fpt><ObColor %s>',width,markeredgecolorname);
            fprintf(fid,'<GroupID %0.0f>',group);
            fprintf(fid,'<ShapeRect %0.3f" %0.3f" %0.3f" %0.3f">',[x(j)-radius;y(j)-radius;2*radius;2*radius]);
            fprintf(fid,'%s\n',' > ');
        end
    end
end

function control2mif(fid,id,ax,group,paperpos)
set(ax,'Units','pixels');
pos=get(ax,'Position');
pict=getframe(id,pos);
if isempty(pict.colormap)
    pict.colormap=colormap;
end
imwrite(pict.cdata,pict.colormap,'test.tif','tif');
set(ax,'Units','normalized');
posNorm=get(ax,'Position');
posInches(1)=posNorm(1)*paperpos(3);
posInches(2)=posNorm(2)*paperpos(4);
posInches(3)=posNorm(3)*paperpos(3);
posInches(4)=posNorm(4)*paperpos(4);
lx=num2str(posInches(3));
ly=num2str(posInches(4));
pointsx=num2str(posInches(1));
pointsy=num2str(paperpos(4)-posInches(2)-posInches(4));
fprintf(fid,'<ImportObject <ObColor Black><ImportObFixedSize Yes><GroupID %0.0f><ShapeRect %s" %s" %s" %s">\n',group,pointsx,pointsy,lx,ly);
dummy=fopen('test.tif','r');
dummy1=fread(dummy);
fprintf(fid,'%s\n',['=TIFF']);
fprintf(fid,'%s\n',['&%v']);
fprintf(fid,'%s\n',['&\x']);
for l=1:30:length(dummy1)
    fprintf(fid,'%s','&');
    fprintf(fid,'%02X',dummy1(l:min(l+29,length(dummy1))));
    fprintf(fid,'\n');
end
fclose(dummy);
fprintf(fid,'%s\n',['&\x']);
fprintf(fid,'%s\n',['=EndInset']);
fprintf(fid,'%s\n',['<ImportObFile `2.0 internal inset''>>']);

% create a text in the axis frame
% the position of the text has to be adapted to the axis scaling
function text2mif(fid,group,axpos,axlim,paperpos,id,ax)
originalTextUnits=get(id,'Units');
set(id,'Units','Data');
textpos=get(id,'Position');
set(id,'FontUnits','points');
textfontsize=get(id,'FontSize');
fontsize=convertunit(get(id,'FontSize'),get(id,'FontUnit'),'inches');   % convert fontsize to inches
paperposOriginal=get(gcf,'Position');
fontsize=fontsize*paperpos(4)/paperposOriginal(4);
font_color=searchcolor(id,get(id,'Color'));
if strcmp(get(ax,'XScale'),'log')
    textpos(1)=log10(textpos(1));
end
if strcmp(get(ax,'YScale'),'log')
    textpos(2)=log10(textpos(2));
end
if ~strcmp(get(ax,'XDir'),'reverse')
    x=((textpos(1)-axlim(1))/axlim(3)*axpos(3)+axpos(1))*paperpos(3);
else
    x=((axlim(3)-(textpos(1)-axlim(1)))/axlim(3)*axpos(3)+axpos(1))*paperpos(3);
end
if ~strcmp(get(ax,'YDir'),'reverse')
    y=(1-((textpos(2)-axlim(2))/axlim(4)*axpos(4)+axpos(2)))*paperpos(4);
else
    y=(1-((axlim(4)-(textpos(2)-axlim(2)))/axlim(4)*axpos(4)+axpos(2)))*paperpos(4);
end
textvalign=get(id,'VerticalAlignment');
textalign=get(id,'HorizontalAlignment');
texttext=get(id,'String');
textrot=get(id,'Rotation');
lines=max(size(get(id,'String'),1),1);
if size(texttext,2)~=0
    j=1;
    for i=0:1:(lines-1)
        if iscell(texttext)
            label2mif(fid,group,axpos,id,x,y+i*(fontsize*1.11),convertString(texttext{j}),textalign,textrot,textvalign,lines,paperpos,font_color)
        else
            label2mif(fid,group,axpos,id,x,y+i*(fontsize*1.11),convertString(texttext(j,:)),textalign,textrot,textvalign,lines,paperpos,font_color)
        end
        j=j+1;   
    end
else
    label2mif(fid,group,axpos,id,x,y,'',textalign,textrot,textvalign,lines,paperpos,font_color)
end
set(id,'Units',originalTextUnits);

% adds the exponents to the axis thickmarks if needed
% MATLAB itself offers no information about this exponent scaling
% the exponent have therefore to be extracted from the thickmarks
function exponent2mif(fid,group,axpos,paperpos,ax)
if strcmp(get(ax,'XTickLabelMode'),'auto') & strcmp(get(ax,'XScale'),'linear')
    fontsize=convertunit(get(ax,'FontSize'),get(ax,'FontUnit'),'inches');   % convert fontsize to inches
    font_color=searchcolor(ax,get(ax,'XColor'));
    numlabels=str2num(get(ax,'XTickLabel'));
    labelpos=get(ax,'XTick');
    numlabels=numlabels(:);
    labelpos=labelpos(:);
    indexnz=find(labelpos~=0);
    if ~isempty(indexnz)
        ratio=numlabels(indexnz)./labelpos(indexnz);
        if round(log10(ratio(1)))~=0
            exptext=['`\xb0  10''><Font <FPosition FSuperscript>><String ' num2str(-log10(ratio(1))) '><Font <FPosition FSuperscript>'];
            label2mif(fid,group,axpos,ax,(axpos(1)+axpos(3))*paperpos(3),(1-axpos(2))*paperpos(4)+2*fontsize,exptext,'right',0,'top',1,paperpos,font_color)
        end
    end
end
if strcmp(get(ax,'YTickLabelMode'),'auto') & strcmp(get(ax,'YScale'),'linear')
    fontsize=convertunit(get(ax,'FontSize'),get(ax,'FontUnit'),'inches');
    font_color=searchcolor(ax,get(ax,'YColor'));
    numlabels=str2num(get(ax,'YTickLabel'));
    labelpos=get(ax,'YTick');
    numlabels=numlabels(:);
    labelpos=labelpos(:);
    indexnz=find(labelpos~=0);
    if ~isempty(indexnz)
        ratio=numlabels(indexnz)./labelpos(indexnz);
        if round(log10(ratio(1)))~=0
            exptext=['`\xb0  10''><Font <FPosition FSuperscript>><String ' num2str(-log10(ratio(1))) '><Font <FPosition FSuperscript>'];
            label2mif(fid,group,axpos,ax,axpos(1)*paperpos(3),(1-(axpos(2)+axpos(4)))*paperpos(4)-0.5*fontsize,exptext,'left',0,'bottom',1,paperpos,font_color)
        end
    end
end

% create a label in the figure
% former versions of FrameMaker supported the commands FDY and FDX to shift the text
% this commands were replaced by a shift parameter that is normed by the font size
function label2mif(fid,group,axpos,id,x,y,tex,align,angle,valign,lines,paperpos,font_color)
textfontname=get(id,'FontName');
set(id,'FontUnits','points');
textfontsize=get(id,'FontSize');
if isfield(get(id),'Interpreter')
    if strcmp(get(id,'Interpreter'),'tex')
        latex=1;
    else
        latex=0;
    end
else
    latex=1;
end
fontsize=convertunit(get(id,'FontSize'),get(id,'FontUnit'),'inches');   % convert fontsize to inches
paperposOriginal=get(gcf,'Position');
fontsize=fontsize*paperpos(4)/paperposOriginal(4);
textfontsize=textfontsize*paperpos(4)/paperposOriginal(4);
fprintf(fid,'%s',['<Font ']);
switch lower(valign)
    case 'top',shift=fontsize*0.8;
    case 'cap',shift=fontsize*0.7;
    case 'middle',shift=-((lines-1)/2*fontsize*1.11)+fontsize*0.3;
    case 'bottom',shift=-((lines-1)*fontsize*1.11)+fontsize*-0.04;
    otherwise,shift=0;
end
fprintf(fid,'<FFamily %s><FSize %0.0f><FPosition FNormal><FColor %s>>',textfontname,textfontsize,font_color);
fprintf(fid,'<TextLine <GroupID %0.0f>',group);
fprintf(fid,'<Angle %0.3f>',angle);
fprintf(fid,'<TLOrigin %0.3f" %0.3f">',x+shift*sin(angle*pi/180),y+shift*cos(angle*pi/180));    % text position shifted by values given by 'top', 'bottom', 'middle', 'cap'
switch lower(align)
    case 'right',fprintf(fid,'%s',['<TLAlignment Right>']); 
    case 'center',fprintf(fid,'%s',['<TLAlignment Center>']);
    otherwise,fprintf(fid,'%s',['<TLAlignment Left>']);
end
if latex==1 
    tex=strrep(tex,'\\alpha',['''><Font <FFamily Symbol>><String a><Font <FFamily ' textfontname '>><String `']);
    tex=strrep(tex,'\\beta',['''><Font <FFamily Symbol>><String b><Font <FFamily ' textfontname '>><String `']);
    tex=strrep(tex,'\\gamma',['''><Font <FFamily Symbol>><String g><Font <FFamily ' textfontname '>><String `']);
    tex=strrep(tex,'\\delta',['''><Font <FFamily Symbol>><String d><Font <FFamily ' textfontname '>><String `']);
    tex=strrep(tex,'\\epsilon',['''><Font <FFamily Symbol>><String e><Font <FFamily ' textfontname '>><String `']);
    tex=strrep(tex,'\\zeta',['''><Font <FFamily Symbol>><String z><Font <FFamily ' textfontname '>><String `']);
    tex=strrep(tex,'\\eta',['''><Font <FFamily Symbol>><String e><Font <FFamily ' textfontname '>><String `']);
    tex=strrep(tex,'\\theta',['''><Font <FFamily Symbol>><String q><Font <FFamily ' textfontname '>><String `']);
    tex=strrep(tex,'\\vartheta',['''><Font <FFamily Symbol>><String J><Font <FFamily ' textfontname '>><String `']);
    tex=strrep(tex,'\\iota',['''><Font <FFamily Symbol>><String i><Font <FFamily ' textfontname '>><String `']);
    tex=strrep(tex,'\\kappa',['''><Font <FFamily Symbol>><String k><Font <FFamily ' textfontname '>><String `']);
    tex=strrep(tex,'\\lambda',['''><Font <FFamily Symbol>><String l><Font <FFamily ' textfontname '>><String `']);
    tex=strrep(tex,'\\mu','µ');
    tex=strrep(tex,'\\nu',['''><Font <FFamily Symbol>><String n><Font <FFamily ' textfontname '>><String `']);
    tex=strrep(tex,'\\xi',['''><Font <FFamily Symbol>><String x><Font <FFamily ' textfontname '>><String `']);
    tex=strrep(tex,'\\pi',['''><Font <FFamily Symbol>><String p><Font <FFamily ' textfontname '>><String `']);
    tex=strrep(tex,'\\roh',['''><Font <FFamily Symbol>><String r><Font <FFamily ' textfontname '>><String `']);
    tex=strrep(tex,'\\sigma',['''><Font <FFamily Symbol>><String s><Font <FFamily ' textfontname '>><String `']);
    tex=strrep(tex,'\\varsigma',['''><Font <FFamily Symbol>><String v><Font <FFamily ' textfontname '>><String `']);
    tex=strrep(tex,'\\tau',['''><Font <FFamily Symbol>><String t><Font <FFamily ' textfontname '>><String `']);
    tex=strrep(tex,'\\upsilon',['''><Font <FFamily Symbol>><String u><Font <FFamily ' textfontname '>><String `']);
    tex=strrep(tex,'\\phi',['''><Font <FFamily Symbol>><String f><Font <FFamily ' textfontname '>><String `']);
    tex=strrep(tex,'\\chi',['''><Font <FFamily Symbol>><String c><Font <FFamily ' textfontname '>><String `']);
    tex=strrep(tex,'\\psi',['''><Font <FFamily Symbol>><String y><Font <FFamily ' textfontname '>><String `']);
    tex=strrep(tex,'\\omega',['''><Font <FFamily Symbol>><String o><Font <FFamily ' textfontname '>><String `']);
    tex=strrep(tex,'\\Gamma',['''><Font <FFamily Symbol>><String G><Font <FFamily ' textfontname '>><String `']);
    tex=strrep(tex,'\\Delta',['''><Font <FFamily Symbol>><String D><Font <FFamily ' textfontname '>><String `']);
    tex=strrep(tex,'\\Theta',['''><Font <FFamily Symbol>><String Q><Font <FFamily ' textfontname '>><String `']);
    tex=strrep(tex,'\\Lambda',['''><Font <FFamily Symbol>><String L><Font <FFamily ' textfontname '>><String `']);
    tex=strrep(tex,'\\Xi',['''><Font <FFamily Symbol>><String X><Font <FFamily ' textfontname '>><String `']);
    tex=strrep(tex,'\\Pi',['''><Font <FFamily Symbol>><String P><Font <FFamily ' textfontname '>><String `']);
    tex=strrep(tex,'\\Sigma',['''><Font <FFamily Symbol>><String S><Font <FFamily ' textfontname '>><String `']);
    tex=strrep(tex,'\\Tau',['''><Font <FFamily Symbol>><String T><Font <FFamily ' textfontname '>><String `']);
    tex=strrep(tex,'\\Upsilon',['''><Font <FFamily Symbol>><String U><Font <FFamily ' textfontname '>><String `']);
    tex=strrep(tex,'\\Phi',['''><Font <FFamily Symbol>><String F><Font <FFamily ' textfontname '>><String `']);
    tex=strrep(tex,'\\Psi',['''><Font <FFamily Symbol>><String Y><Font <FFamily ' textfontname '>><String `']);
    tex=strrep(tex,'\\Omega',['''><Font <FFamily Symbol>><String O><Font <FFamily ' textfontname '>><String `']);
    tex=strrep(tex,'\\infty',['''><Font <FFamily Symbol>><String ¥><Font <FFamily ' textfontname '>><String `']);
    tex=strrep(tex,'\\pm','±');
    tex=strrep(tex,'\\Im',['''><Font <FFamily Symbol>><String Á><Font <FFamily ' textfontname '>><String `']);
    tex=strrep(tex,'\\Re',['''><Font <FFamily Symbol>><String Â><Font <FFamily ' textfontname '>><String `']);
    tex=strrep(tex,'\\approx',['''><Font <FFamily Symbol>><String »><Font <FFamily ' textfontname '>><String `']);
    tex=strrep(tex,'\\leq',['''><Font <FFamily Symbol>><String £><Font <FFamily ' textfontname '>><String `']);
    tex=strrep(tex,'\\geq',['''><Font <FFamily Symbol>><String ³><Font <FFamily ' textfontname '>><String `']);
    tex=strrep(tex,'\\times','\xb0 ');
    tex=strrep(tex,'\\leftrightarrow',['''><Font <FFamily Symbol>><String «><Font <FFamily ' textfontname '>><String `']);
    tex=strrep(tex,'\\leftarrow',['''><Font <FFamily Symbol>><String ¬><Font <FFamily ' textfontname '>><String `']);
    tex=strrep(tex,'\\uparrow',['''><Font <FFamily Symbol>><String ­><Font <FFamily ' textfontname '>><String `']);
    tex=strrep(tex,'\\rightarrow',['''><Font <FFamily Symbol>><String ®><Font <FFamily ' textfontname '>><String `']);
    tex=strrep(tex,'\\downarrow',['''><Font <FFamily Symbol>><String ¯><Font <FFamily ' textfontname '>><String `']);
    tex=strrep(tex,'\\circ',['''><Font <FFamily Symbol>><String °><Font <FFamily ' textfontname '>><String `']);
    tex=strrep(tex,'\\propto',['''><Font <FFamily Symbol>><String µ><Font <FFamily ' textfontname '>><String `']);
    tex=strrep(tex,'\\partial',['''><Font <FFamily Symbol>><String ¶><Font <FFamily ' textfontname '>><String `']);
    tex=strrep(tex,'\\bullet',['''><Font <FFamily Symbol>><String ·><Font <FFamily ' textfontname '>><String `']);
    tex=strrep(tex,'\\div',['''><Font <FFamily Symbol>><String ¸><Font <FFamily ' textfontname '>><String `']);
    tex=latex2mif(tex,textfontname,textfontsize,'FNormal');
end
fprintf(fid,'<String %s>',tex);
fprintf(fid,'>\n'); 

% converts LATEX strings into Framemaker strings
function returnvalue=latex2mif(StringText,font,size,style)
if isempty(StringText)
    returnvalue='';
else
    leftbracket=0;
    rightbracket=0;
    bracketcounter=0;
    leftbracketpos=[];
    rightbracketpos=[];
    returnvalue=[];
    for i=1:length(StringText)
        if rightbracket==leftbracket
            returnvalue=[returnvalue StringText(i)];    
        end
        if StringText(i)=='{'
            leftbracket=leftbracket+1;
            bracketcounter=bracketcounter+1;
            leftbracketpos=[leftbracketpos i];
        end
        if StringText(i)=='}'
            rightbracket=rightbracket+1;
            rightbracketpos=[rightbracketpos i];
            if rightbracket==leftbracket
                fontnew=font;
                sizenew=size;
                stylenew=style;
                if leftbracketpos(leftbracket-bracketcounter+1)~=1
                    switch StringText(leftbracketpos(leftbracket-bracketcounter+1)-1)   
                        case '^'
                            stylenew='FSuperscript';
                            returnvalue=returnvalue(1:(end-1));
                        case '_'
                            stylenew='FSubscript';
                            returnvalue=returnvalue(1:(end-1));
                    end
                end
                if strcmp(style,stylenew)
                    format=[];
                    formatend=[];
                else
                    format=['''><Font <FPosition ' stylenew '>><String `'];
                    formatend=['''><Font <FPosition ' style '>><String `'];
                end
                textinbrackets=StringText((leftbracketpos(leftbracket-bracketcounter+1)+1):(rightbracketpos(rightbracket)-1));
                foundpos=findstr(textinbrackets,'\bf');
                if ~isempty(foundpos)
                    textinbrackets=strrep(textinbrackets,'\\bf',['''><Font <FWeight Bold>><String `']);
                    textinbrackets=[textinbrackets '''><Font <FWeight Normal>><String `'];
                end
                foundpos=findstr(textinbrackets,'\it');
                if ~isempty(foundpos)
                    textinbrackets=strrep(textinbrackets,'\\it',['''><Font <FAngle Oblique>><String `']);
                    textinbrackets=[textinbrackets '''><Font <FAngle Normal>><String `'];
                end
                returnvalue=[returnvalue(1:(end-1)) format latex2mif(textinbrackets,fontnew,sizenew,stylenew) formatend];
                bracketcounter=0;
            end
        end
    end
end

function name=searchcolor(id,value)
global colorname
global fixcolorptr
name='';
scolorname=[num2str((1-value(1))*100,'%03.0f') num2str((1-value(2))*100,'%03.0f') num2str((1-value(3))*100,'%03.0f')];
for i=1:size(colorname,1)
    if strcmp(scolorname,colorname(i,:))
        name=['Matlab' colorname(i,:)];
        break
    end
end
if isempty(name)
    name=['Matlab' colorname(fixcolorptr(1),:)];   
end

function rvalue=convertunit(value,from,to)
switch lower(from)  % convert from input unit to points
    case 'points', rvalue=value;
    case 'centimeters', rvalue=value/2.54*72;
    case 'inches', rvalue=value*72; % 72 points = 1 inch
    otherwise, error(['Unknown unit ' from '.']);
end
switch lower(to)    % convert from points to specified unit
    case 'points', rvalue=rvalue;
    case 'centimeters', rvalue=rvalue*2.54/72;
    case 'inches', rvalue=rvalue/72;    % 72 points = 1 inch
    otherwise, error(['Unknown unit ' to '.']);
end

function strString=addBackSlash( strSlash)
% adds a backslash at the last position of the string (if not already there)
if ( strSlash(end) ~= '\')
    strString = [ strSlash '\'];
else
    strString = strSlash;
end

function strExt=getFileExtension( strFileName)
% returns the file extension of a filename
[path, name, strExt] = fileparts( strFileName);

function StringText=convertString(StringText)
if ~isempty(StringText)
    StringText=strrep(StringText,'\','\\');
    StringText=strrep(StringText,'`','\Q');
    StringText=strrep(StringText,'''','\q');
    StringText=strrep(StringText,'>','\>');
    StringText=['`' deblank(StringText) ''''];
end

