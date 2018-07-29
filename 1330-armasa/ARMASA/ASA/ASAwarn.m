function string = ASAwarn(varargin)
%ASAWARN Warning string from numbered file
%   STRING = ASAWARN(FILE_NUMBER,SUBSTITUTE) returns the contents of a 
%   text file 'ASAid.txt', with id = FILE_NUMBER, in a character string 
%   with a convenient number of blanks in front of each line. A cell 
%   array or character array of strings SUBSTITUTE, is used to replace 
%   subsequently any occurences of the word 'ASAsubst' in the text file, 
%   with the string(s) of SUBSTTUTE.
%   
%   This function is typically used to generate a warning message string 
%   for the Matlab WARNING function. 
%   
%   When this function is called using the ASACONTROL structure variable, 
%   e.g. ASAWARN(FILE_NUMBER,SUBSTITUTE,ASACONTROL) as done in any ARMASA 
%   main function, warning messages can be suppressed by declaring 
%   'ASAcontrol.show_ASAwarn = 0' in front of the function call.
%   
%   See also: WARNING, ASAERR, ASACONTROL.

[file_number,substitute,ASAcontrol]=ASAarg(varargin, ...
{'file_number';'substitute'     ;'ASAcontrol'}, ...
{'isnumeric'  ;'iscellorcharstr';'isstruct'  }, ...
{'file_number'                               }, ...
{'file_number';'substitute'                  });

if isempty(ASAcontrol)|~isfield(ASAcontrol,'show_ASAwarn')
   ASAcontrol.show_ASAwarn = 1;
end
   
if ASAcontrol.show_ASAwarn
   txt_file=['ASA' num2str(file_number) '.txt'];
   if ~exist(txt_file,'file')
      error(['    ' txt_file ' does not exist on MATLAB''s search path.']);
   end
   
   fid=fopen(txt_file,'rt');
   retr_line_new=fgets(fid);
   retr_line=retr_line_new;
   string=[];
   while retr_line~=-1
      string=[string retr_line_new];
      retr_line=fgets(fid);
      retr_line_new=[32*ones(1,9) retr_line];
   end
   fclose(fid);
   
   subst_index=findstr(string,'ASAsubst');
   if ischar(substitute)
      substitute=cellstr(substitute);
   end   
   if lt(length(substitute),length(subst_index))
      error('    Insufficient substitutable strings entered')
   end
   for i = 1:length(subst_index)
      string(subst_index(i):subst_index(i)+7)=[];
      string=[string(1:subst_index(i)-1) substitute{i} ...
            string(subst_index(i):end)];
      subst_index=subst_index-8+length(substitute{i});
   end
else
   string='';
end

%Program history
%======================================================================
%
% Version                Programmer(s)          E-mail address
% -------                -------------          --------------
% [2000 12 30 20 0 0]    W. Wunderink           wwunderink01@freeler.nl