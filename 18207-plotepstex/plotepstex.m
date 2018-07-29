% PLOTEPSTEX prints an EPS figure for inclusion in LaTeX documents, with
%    LaTeX fonts. It creates a complet eps-file with annotation of the 
%    figure (titles, labels and texts) and graphics (lines,arrows,markers,
%    ...). This function uses the LAPRINT function and makes simply a
%    concatenation of the text part and the graphical part in a single EPS
%    file. It requires:
%
%                  MATLAB        |      OTHER
%               -----------------|----------------------------
%                 laprint.m      |      latex
%                                |      dvips
%                                |      ps2epsi or eps2eps
%                                |      GhostScript
%
%    The diference between ps2epsi and eps2eps is that the first is a 
%    standard EPS converter, but creates very large file size. The commande
%    eps2eps can be replace by ps2epsi at line 191
%    
%    USAGE:
%    ------------------------
%
%    PLOTEPSTEX create the EPS file of the current graphical figure (CGF) 
%    named LaTeXfile.eps
% 
%    PLOTEPSTEX(H) create the EPS file from the graphical figure with 
%    handle H, named LaTeXfile.eps
%    
%    PLOTEPSTEX(H,FILENAME) create the EPS file from the graphical figure 
%    with handle H, named FILENAME.EPS (FILENAME is a character array of
%    the filename, with or without the extension .EPS)
%    
%    PLOTEPSTEX(H,FILENAME,[WIDTH RATIO FONTSIZE]) to impose the width (in 
%    cm), the Ratio length/weigth and the font size of the exported figure.
%    If one of the fields is not to fill, just put the nan value.
%    Example: [10 nan 10] produce a figure with 10cm length with the 
%    ratio as screen desplayed and with a Font size of 10 pts.
%
%    PLOTEPSTEX(H,FILENAME,[WIDTH RATIO FONTSIZE],PACKAGES) to adding
%    packages such as fonts, mathfont,...
%    ex: PACKAGES = 'amsmath, amssymb, times, color'
%
% See also LAPRINT:
%          http://www.uni-kassel.de/fb16/rat/matlab/laprint/laprintdoc.ps 
% 
%_______________________________
%
% J.C. Olivier                                    09/2007
% http://www.jc-olivier.2007.fr
%
function plotepstex(h,FileName,WidthRatioFontSize,Packages)


if nargin >= 3
    Width=WidthRatioFontSize(1);
    Ratio=WidthRatioFontSize(2);
    FontSize=WidthRatioFontSize(1);
    
    id=find(isnan(WidthRatioFontSize));
    if length(find(id==1))==1
        Width=-1;
    end

    if length(find(id==2))==1
        Ratio=-1;
    end

    if length(find(id==3))==1
        FontSize=10;                
    end
end
    

if nargin < 3
   Width=-1; Ratio=-1; FontSize=10; %Default font size is 10 and the 
                                    %dimenssions of the figure are taken
                                    %just as they are
end

if nargin < 2
    FileName='LaTeXfile';
end

if nargin < 1
    h=gcf;
end


if Ratio>0
    fpos=get(h,'Position');
    set(h,'Position',[fpos(1) fpos(2) ,420 420/Ratio]);
end

TempName = strcat('TEMP',num2str(round(rand*10000))); %Generate random file name


DTI = get(0,'defaulttextinterpreter');   %Backup of the text interpreter
Str=version;
set(0,'defaulttextinterpreter','none');  %Delete the TeX interpreter


id=findstr(FileName,'.');
if length(id)~=0
    FileName(id:end)=[];
end

if ~exist('laprint.m')
    disp('Laprint M-file does not exist or is not in the MATLAB''s search path.');
    disp('This file can be downloaded at: http://www.mathworks.com/matlabcentral/fileexchange');
    disp('                                                         Try again...');
    return;
end

if Width>0
    laprint(h,TempName,'width',Width); % Generate the EPS/LaTeX file
else
    laprint(h,TempName); % Generate the EPS/LaTeX file
end


disp(sprintf('\n-------------------------------------------------------'));
disp(sprintf('PlotEpsTeX                                      02/2008'));
disp(sprintf('-------------------------------------------------------'));
disp(sprintf('Exporting figure in EPS format, including LaTeX strings'));
disp(sprintf('This function is based on laprint.m:'));
disp(sprintf('http://www.uni-kassel.de/fb16/rat/matlab/laprint/laprintdoc.ps\n'));
%-------------------------------------------------------
% Temporary LaTeX file
%-------------------------------------------------------
fid = fopen(strcat(TempName,'2.tex'),'w');

fprintf(fid,'\\documentclass[%dpt, oneside]{article}\n',round(FontSize));
fprintf(fid,'\\usepackage{graphicx}\n');
fprintf(fid,'\\usepackage{amsmath}\n');
fprintf(fid,'\\usepackage[T1]{fontenc}\n');
fprintf(fid,'\\usepackage[latin1]{inputenc}\n');
fprintf(fid,'\\usepackage{ae}\n');
fprintf(fid,'\\usepackage{psfrag}\n');
fprintf(fid,'\\usepackage{color}\n');

if nargin==4
    fprintf(fid,'\\usepackage{%s}\n',Packages); % Suplementary packages
end
fprintf(fid,'\\pagestyle{empty}\n');
fprintf(fid,' \n');
fprintf(fid,'\\begin{document}\n');
fprintf(fid,'    \\begin{figure}\n');
fprintf(fid,'        \\centering\n');
fprintf(fid,'        \\input{%s}\n',TempName);
fprintf(fid,'    \\end{figure}\n');
fprintf(fid,' \n');
fprintf(fid,'\\end{document}\n');
fclose(fid);

%-------------------------------------------------------
% LaTeX Command
%-------------------------------------------------------
Str=sprintf('latex --src -interaction=nonstopmode %s2.tex',TempName);
disp(sprintf('\n[LaTeX Command] %s',Str));
[hdos,wdos]=system(Str);

if hdos ~=0
    if isunix
        dos(sprintf('rm %s*',TempName));
    else
        dos(sprintf('del %s*',TempName));
    end
    error(sprintf('Error %d -- LATEX:\n%s',hdos ,wdos) );
    return;
end


%-------------------------------------------------------
% DviPs Command
%-------------------------------------------------------
Str=sprintf('dvips %s2.dvi -o %s2.ps',TempName,TempName); 
disp(sprintf('[DVIPS Command] %s',Str));
[hdos,wdos]=system(Str);
if hdos ~=0
    if isunix
        dos(sprintf('rm %s*',TempName));
    else
        dos(sprintf('del %s*',TempName));
    end
    error(sprintf('Error %d -- DVIPS:\n%s', hdos , wdos) );
    return;
end

%-------------------------------------------------------
% eps2eps Command (can be changed with PS2EPSI)
%-------------------------------------------------------
Str = sprintf('eps2eps -dNOCACHE %s2.ps %s.eps',TempName,FileName);
disp(sprintf('[EPS2EPS Command] %s',Str));
[hdos,wdos]=dos(Str);
if hdos ~=0
    if isunix
        dos(sprintf('rm %s*',TempName));
    else
        dos(sprintf('del %s*',TempName));
    end
    error(sprintf('Error %d -- PS2EPSI:\n%s',hdos ,wdos) );
    return;
end

disp(sprintf('... OK!\nEPS file [%s.eps] has been created in the current directory\n',FileName));
%-------------------------------------------------------
% Delete all the temporary files
%-------------------------------------------------------
if isunix
    dos(sprintf('rm %s*',TempName));
else
    dos(sprintf('del %s*',TempName));
end

set(0,'defaulttextinterpreter',DTI);

return;