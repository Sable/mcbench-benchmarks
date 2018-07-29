% MLF2PDF prints a PDF figure for inclusion in LaTeX documents, with
%    LaTeX fonts. It creates a complete pdf-file with annotation of the 
%    figure (titles, labels and texts) and graphics (lines,arrows,markers,
%    ...). This function uses the matlabfrag function and makes simply a
%    concatenation of the text part and the graphical part in a single PDF
%    file. It requires:
%
%                  MATLAB        |      OTHER
%               -----------------|----------------------------
%                 matlabfrag.m   |      pdflatex
%
%    
%    USAGE:
%    ------------------------
%
%    mlf2pdf creates the PDF file of the current graphical figure (CGF) 
%    named LaTeXfile.pdf
% 
%    mlf2pdf(H) creates the PDF file from the graphical figure with 
%    handle H, named LaTeXfile.pdf
%    
%    mlf2pdf(H,FILENAME) creates the PDF file from the graphical figure 
%    with handle H, named FILENAME.PDF (FILENAME is a character array of
%    the filename, with or without the extension .PDF)
%   
%    mlf2pdf(H,FILENAME,PACKAGES) to adding
%    packages such as fonts, mathfont,...
%    ex: PACKAGES = 'amssymb, times'
% 

function mlf2pdf(h,FileName,Packages)

if nargin < 2
    FileName='LaTeXfile';
end

if nargin < 1
    h=gcf;
end

TempName = strcat('TEMP',num2str(round(rand*10000))); %Generate random file name

if ~exist('matlabfrag.m')
    disp('MatLabFrag M-file does not exist or is not in the MATLAB''s search path.');
    disp('This file can be downloaded at: http://www.mathworks.com/matlabcentral/fileexchange');
    disp('                                                         Try again...');
    return;
end

 matlabfrag(TempName,'handle',h);  %call matlabfrag to export figure to .eps and .tex file.

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
fprintf(fid,'\\usepackage{pstool}\n');

if nargin==3
    fprintf(fid,'\\usepackage{%s}\n',Packages); % Suplementary packages
end
fprintf(fid,'\\pagestyle{empty}\n');
fprintf(fid,' \n');
fprintf(fid,'\\begin{document}\n');
fprintf(fid,'    \\begin{figure}\n');
fprintf(fid,'        \\centering\n');
fprintf(fid,'        \\psfragfig{%s}\n',TempName);
fprintf(fid,'    \\end{figure}\n');
fprintf(fid,' \n');
fprintf(fid,'\\end{document}\n');
fclose(fid);

%-------------------------------------------------------
% LaTeX Command
%-------------------------------------------------------
Str=sprintf('pdflatex -shell-escape --src -interaction=nonstopmode %s2.tex',TempName);
disp(sprintf('\n[LaTeX Command] %s',Str));
[hdos,wdos]=system(Str);

if hdos ~=0
   if isunix==0
     dos(sprintf('del %s*',TempName));  
   else
     unix(sprintf('rm %s*',TempName));
   end
   error('Error %d -- LATEX:\n%s',hdos ,wdos);
   return;
end

%-------------------------------------------------------
% Rename TempFile to FileName and delete FileName before (if it exists)
%-------------------------------------------------------
if isunix==0
   dos(sprintf('del %s.pdf',FileName));
   dos(sprintf('ren %s.pdf %s.pdf',TempName,FileName)); 
else 
   unix(sprintf('rm %s.pdf',FileName));
   unix(sprintf('mv %s.pdf %s.pdf',TempName,FileName));
end
%-------------------------------------------------------
% Success
%------------------------------------------------------- 
  disp(sprintf('... OK!\nPDF file [%s.pdf] has been created in the current directory\n',FileName));
 %-------------------------------------------------------
% Delete all the temporary files
%-------------------------------------------------------
if isunix==0
  dos(sprintf('del %s*',TempName));
else
  unix(sprintf('rm %s*',TempName));
end
return;
