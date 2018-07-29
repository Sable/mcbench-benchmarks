function  message=read_text(file_name)
      % Copyright 2002-2010 The MathWorks, Inc.
      fid=fopen(file_name,'rt');
      message=char(fread(fid))';
      fclose(fid);
      
      
