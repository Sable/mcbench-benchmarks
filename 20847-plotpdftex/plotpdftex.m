% PLOTPDFTEX prints a PDF figure for inclusion in LaTeX documents, with
%    LaTeX fonts. It creates a complete pdf-file with annotation of the 
%    figure (titles, labels and texts) and graphics (lines,arrows,markers,
%    ...). This function uses the LAPRINT function and makes simply a
%    concatenation of the text part and the graphical part in a single PDF
%    file. It requires:
%
%                  MATLAB        |      OTHER
%               -----------------|----------------------------
%                 laprint.m      |      latex
%                                |      dvips
%                                |      ps2epsi or eps2eps
%                                |      epstopdf
%                                |      GhostScript
%
%    The diference between ps2epsi and eps2eps is that the first is a 
%    standard EPS converter, but creates very large file size. The commande
%    eps2eps can be replace by ps2epsi at line 191
%    
%    USAGE:
%    ------------------------
%
%    PLOTPDFTEX creates the PDF file of the current graphical figure (CGF) 
%    named LaTeXfile.pdf
% 
%    PLOTPDFTEX(H) creates the PDF file from the graphical figure with 
%    handle H, named LaTeXfile.pdf
%    
%    PLOTPDFTEX(H,FILENAME) creates the PDF file from the graphical figure 
%    with handle H, named FILENAME.PDF (FILENAME is a character array of
%    the filename, with or without the extension .PDF)
%    
%    PLOTPDFTEX(H,FILENAME,[FONTSCALING LINESCALING]) scales the font and
%    line sizes relative to the figure size (values greater than 1 scale
%    up, less than 1 scale down).  If nan, the default of 1 is used.
%
%    PLOTPDFTEX(H,FILENAME,[FONTSCALING LINESCALING],PACKAGES) to adding
%    packages such as fonts, mathfont,...
%    ex: PACKAGES = 'amssymb, times'
%
% See also LAPRINT:
%          http://www.uni-kassel.de/fb16/rat/matlab/laprint/laprintdoc.ps 
% 
%_______________________________
% Adjusted from PLOTEPSTEX by
% J.C. Olivier                                    09/2007
% http://www.jc-olivier.2007.fr
%
%_______________________________
%
% Emmett Lalish                                   06/2008

function plotpdftex(h,FileName,FontLineSize,Packages)


if nargin >= 3
    fontsize=FontLineSize(1);
    linesize=FontLineSize(2);
    
    id=find(isnan(FontLineSize));
    if length(find(id==1))==1
        fontsize=1;
    end

    if length(find(id==2))==1
        linesize=1;
    end
end
    

if nargin < 3
   fontsize=1; linesize=1; 
end

if nargin < 2
    FileName='LaTeXfile';
end

if nargin < 1
    h=gcf;
end

TempName = strcat('TEMP',num2str(round(rand*10000))); %Generate random file name


DTI = get(0,'defaulttextinterpreter');   %Backup of the text interpreter
set(0,'defaulttextinterpreter','none');  %Delete the TeX interpreter


id=findstr(FileName,'.');
if ~isempty(id)
    FileName(id:end)=[];
end

if ~exist('laprint.m')
    disp('Laprint M-file does not exist or is not in the MATLAB''s search path.');
    disp('This file can be downloaded at: http://www.mathworks.com/matlabcentral/fileexchange');
    disp('                                                         Try again...');
    return;
end

laprint(h,TempName,'width',12/fontsize,'factor',linesize/fontsize,'scalefonts','off','asonscreen','on'); % Generate the EPS/LaTeX file

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

fprintf(fid,'\\documentclass[11pt, oneside]{article}\n');
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
    error('Error %d -- LATEX:\n%s',hdos ,wdos);
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
    error('Error %d -- DVIPS:\n%s', hdos , wdos);
    return;
end

%-------------------------------------------------------
% eps2eps Command (can be changed with PS2EPSI)
%-------------------------------------------------------
Str = sprintf('eps2eps -dNOCACHE %s2.ps %s.eps',TempName,FileName);
disp(sprintf('[EPS2EPS Command] %s',Str));
[hdos,wdos]=system(Str);
if hdos ~=0
    if isunix
        dos(sprintf('rm %s*',TempName));
    else
        dos(sprintf('del %s*',TempName));
    end
    error('Error %d -- PS2EPSI:\n%s',hdos ,wdos);
    return;
end

%-------------------------------------------------------
% epstopdf Command
%-------------------------------------------------------
Str = sprintf('epstopdf %s.eps',FileName);
disp(sprintf('[EPSTOPDF Command] %s',Str));
[hdos,wdos]=system(Str);
if hdos ~=0
    if isunix
        dos(sprintf('rm %s*',TempName));
        dos(sprintf('rm %s.eps',FileName));
    else
        dos(sprintf('del %s*',TempName));
        dos(sprintf('del %s.eps',FileName));
    end
    error('Error %d -- EPSTOPDF:\n%s',hdos ,wdos);
    return;
end

disp(sprintf('... OK!\nPDF file [%s.pdf] has been created in the current directory\n',FileName));
%-------------------------------------------------------
% Delete all the temporary files
%-------------------------------------------------------
if isunix
    dos(sprintf('rm %s*',TempName));
    dos(sprintf('rm %s.eps',FileName));
else
    dos(sprintf('del %s*',TempName));
    dos(sprintf('del %s.eps',FileName));
end

set(0,'defaulttextinterpreter',DTI);

return;