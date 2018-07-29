function [sout,char_table]=load_alpha()
      % take alpha.txt and make it a cell array
      % had to add 'x' delimiters
      % Copyright 2002-2010 The MathWorks, Inc.
     fid = fopen('alpha.txt','rt');
     s=fscanf(fid,'%s \n');  % one big long string 
     sout = {};              % cell array 
     k=findstr(s,'x');
     for p=2:length(k)
        sout{p,1}=s(((k(p-1)+1)):(k(p)-1));
     end;
     sout{1,1}=s(1:(k(1)-1));
     fclose(fid);
     
     % make a table lookup for character recovery
     % this a bit reversed table
     for p=1:256
         x=sout{p};
         k=findstr(x(1:(end)),'1'); % find the ones
         n(p) = sum(2.^(k-1));      % convert to a number
     end;
     char_table(1:max(n)) = '?';    % brute force
     for p=1:256
         char_table(n(p))=char(p-1);
     end;
    
     
% end;