function ASAtxt2help(txt_file)
%ASATXT2HELP Text file to help text
%   ASATXT2HELP(FILE.txt) converts a text file FILE.txt into a
%   text file FILE_help.txt, that has the proper format to be
%   pasted in m-files, to serve as a help text.

fid=fopen(txt_file,'rt');
txt_path=which(txt_file);
txt_path_reduced=txt_path(1:end-4);
help_file = [txt_path_reduced '_help.txt'];
fid2=fopen(help_file,'wt');

retr_line_new=fgets(fid);
retr_line=retr_line_new;
while retr_line~=-1
   fprintf(fid2,'%s',retr_line_new);
   retr_line=fgets(fid);
   retr_line_new=[37 32*ones(1,3) retr_line];
end

fclose(fid);
fclose(fid2);