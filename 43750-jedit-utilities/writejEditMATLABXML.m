% writejEditMATLABXML - Write jEdit MATLAB XML mode file.

func_file = 'func_list.txt'; % list of MATLAB functions
tmp_file = 'matlab_tmp.xml'; % template MATLAB mode file
mode_file = 'matlab.xml'; % jEdit MATLAB mode file

writeFunctionList(func_file);

func_fid = fopen(func_file, 'rt');
mode_fid = fopen(mode_file, 'at');

copyfile(tmp_file, mode_file);
while 1 % not EOF
  tline = fgets(func_fid);
  if ~ischar(tline)
    break;
  end

  if strfind(tline, 'built-in') % built-in function
    func_name = sscanf(tline, '%s', 1);
    fprintf(mode_fid, '      %s%s%s\n', '<KEYWORD1>', strtrim(func_name), '</KEYWORD1>');
  else
    fprintf(mode_fid, '      %s%s%s\n', '<KEYWORD2>', strtrim(tline), '</KEYWORD2>');
  end
end

fprintf(mode_fid, '    %s\n', '</KEYWORDS>');
fprintf(mode_fid, '  %s\n', '</RULES>');
fprintf(mode_fid, '%s\n', '</MODE>');

fclose(func_fid);
fclose(mode_fid);
