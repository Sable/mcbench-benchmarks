function [ fid, header ] = ffaopen(filename, permission);

%   function [ fid, header ] = ffaopen(filename, permission);
%
%   Will open an ffa format file, read the header information and validate
%   the file's contents.
%
%
%   Input:
%       filename    - full path and filename of the input file
%       permisson   - standard fopen permission flag
%
%
%   Return:
%       fid         - the integer file identifier
%       header      - structure containing file header information
%
%
%   See Also: ffareaddata.m, ffaread.m, ffareadsubset.m
%
%
%

%
%   Author          Date            Comment
%   S.J.Purves      28.04.04        Initial Implementation
%   S.J.Purves      04.05.04        Workaround for empty string fields in
%                                   ffa header.
%
%
%

msg = nargchk(1,2,nargin);
if ~isempty(msg)
    disp(msg);
    return
end

if nargin == 1
    permission = 'r';
end


%%%%%%%%%%%%%%%

% setup a blank header structure
header.ffaid = 0;
header.signflag = 0;
header.floatflag = 0;
header.databits = 0;
header.voxelbits = 0;
header.numdims = 0;
header.size = [];
header.origin = [0 0 0];
header.label.x = '';
header.label.y = '';
header.label.z = '';
header.scale = [1 1 1];
header.unitname.x = '';
header.unitname.y = '';
header.unitname.z = '';
header.machineformat = 'ieee-le';
header.binarytype = 'uint8';

%%%%%%%%%%%%%%%

% Open the file
fid = fopen( filename, permission, header.machineformat); % opening for little-endian (intel) architecture
if fid == -1
    disp(['Error opening file: ' filename ]);
    return;
end

%H = textread( filename, '%s', 'delimiter','\n','whitespace','\t');
[H,count] = fread(fid,600,'schar');
H = H';

% count the number of lines and their lengths
lengths = [];
n = 1;
this_length = -1;
for i=1:600
    this_length = this_length + 1;   
    A = H(i);
    if (H(i) ==  9) % knock out tabs
        H(i) = 32; % replace with whitespace
    end
    
    if (H(i) == 10) % check for new line 
        lengths(n) = this_length;
        this_length = -1;
        n = n + 1;
    end
end
num_lines = length(lengths);



% load the data into a struture on a line-by-line basis
num_valid_lines = 0;
pos = 1;
for i = 1:num_lines
    if (lengths(i))
        lines(i).binary = H( pos:(pos+lengths(i)) );
        lines(i).string = char(lines(i).binary);
        
        % Find markers
        colon_idx = findstr(lines(i).string, ':');
        
        % separate tag and value sections of the string
        if ( ~isempty(colon_idx) )
            lines(i).tag = lines(i).string(1:colon_idx);
            lines(i).colon_idx = colon_idx;
        end
                
        pos = pos + lengths(i) + 1;
        num_valid_lines = num_valid_lines + 1;
        
    end
end


% As some fields are multi-valued, ie. SIZE[], we need to 
% decode the information in a separate loop
for i=1:num_valid_lines
    
    comment = findstr(lines(i).string, ';');
    lines(i).value = lines(i).string( (lines(i).colon_idx + 1) : (comment-1) );
            
   
    if findstr(lines(i).tag, 'FFAID')
        header.ffaid = str2num(lines(i).value);
        
    elseif findstr(lines(i).tag, 'SIGNFLAG')
        header.signflag = str2num(lines(i).value);
        
    elseif findstr(lines(i).tag, 'FLOATFLAG')
        header.floatflag = str2num(lines(i).value);   
        
    elseif findstr(lines(i).tag, 'DATABITS')
        header.databits = str2num(lines(i).value);
        
    elseif findstr(lines(i).tag, 'VOXELBITS')
        header.voxelbits = str2num(lines(i).value);
        
    elseif findstr(lines(i).tag, 'NUMDIMS')
        header.numdims = str2num(lines(i).value);
        
    elseif findstr(lines(i).tag, 'SIZE[]')
        header.size = str2num(lines(i).value);
        
        % need values from the next two lines
        for n = 2:3
            i = i + 1;
            comment = findstr(lines(i).string, ';');
            header.size(n) = str2num( lines(i).string( 1 : (comment-1) ) );
        end    
                
    elseif findstr(lines(i).tag, 'ORIGIN[]')
       header.origin = str2num(lines(i).value);
       
       % need values from the next two lines
       for n = 2:3
           i = i + 1;
           comment = findstr(lines(i).string, ';');
           temp = str2num( lines(i).string( 1 : (comment-1) ) );
           header.origin = [header.origin temp];
       end    
       
    elseif findstr(lines(i).tag, 'UNITNAME[]')
        
      
       % CLEANUPCOMMENT hangs if string is only whitespace 
       if (isempty(regexp(lines(i).value,'[a-zA-Z0-9]')))
           str1 = ' ';
       else
           str1 = strtrim(lines(i).value);      
       end
       
       % need values from the next two lines
       i = i + 1;
       comment = findstr(lines(i).string, ';');

       if (isempty(regexp(lines(i).string,'[a-zA-Z0-9]')))
           str2 = ' ';
       else
           str2 = strtrim(lines(i).string( 1 : (comment-1) ));
       end
       
       i = i + 1;
       comment = findstr(lines(i).string, ';');
       if (isempty(regexp(lines(i).string,'[a-zA-Z0-9]')))
           str3 = ' ';
       else
           str3 = strtrim(lines(i).string( 1 : (comment-1) ));
       end
      
       header.unitname.x = str1;
       header.unitname.y = str2;
       header.unitname.z = str3;
   
    elseif findstr(lines(i).tag, 'SCALE[]')
       header.scale = str2num(lines(i).value);
       
       % need values from the next two lines
       for n = 2:3
           i = i + 1;
           comment = findstr(lines(i).string, ';');
           header.scale(n) = str2num( lines(i).string( 1 : (comment-1) ) );
       end    
       
    elseif findstr(lines(i).tag, 'LABEL[]')
       if (isempty(regexp(lines(i).value,'[a-zA-Z0-9]')))
          str1 = ' ';
       else 
          str1 = strtrim(lines(i).value);
       end
      
       % need values from the next two lines
       i = i + 1;
       comment = findstr(lines(i).string, ';');
       
       if (isempty(regexp(lines(i).string,'[a-zA-Z0-9]')))
          str2 = ' ';
       else 
           str2 = strtrim(lines(i).string( 1 : (comment-1) ) );
       end
       
       i = i + 1;
       comment = findstr(lines(i).string, ';');
       if (isempty(regexp(lines(i).string,'[a-zA-Z0-9]')))
           str3 = ' ';
       else 
           str3 = strtrim( lines(i).string( 1 : (comment-1) ) );
       end

        header.label.x = str1;
        header.label.y = str2;
        header.label.z = str3;
    end
end


%
% Determine correct binary format for the file
%
magic = 43970;
cigam = 3265986560;


% read the magic number
if (fseek(fid,600,'bof') == -1)
    disp('seek failure for byte 600')
    disp('file is not in valid ffa format');
    fclose(fid);   
    fid = -1;
    return;
end

[number, count] = fread(fid,1,'uint32');

if (count ~= 1)
    disp('could not read magic number');
    disp('file is not in valid ffa format');
    fclose(fid);
    fid = -1;
    return;
end

if (number == cigam) % bytes are swapped 
    header.machineformat = 'ieee-be';
end


if (header.floatflag == 1)
    if (header.databits == 32)
        header.binarytype = 'single';
    elseif (header.databits == 64)
        header.binarytype = 'double';
    else
        disp('Cannot determine binary data type');
        disp('file is not in valid ffa format');
        fclose(fid);
        fid = -1;
        return
    end
    
elseif (header.floatflag == 0)
    
    if (header.signflag == 1)
        
        if (header.databits == 8)
            header.binarytype = 'int8=>int8';
            
        elseif (header.databits == 16)
            header.binarytype = 'int16=>int16';
            
        elseif (header.databits == 32)
            header.binarytype = 'int32=>int32';
            
        else
            disp('Cannot determine binary data type');
            disp('file is not in valid ffa format');
            fclose(fid);
            fid = -1;            
            return
        end
        
    elseif (header.signflag == 0)
        
        if (header.databits == 8)
            header.binarytype = 'uint8=>uint8';
            
        elseif (header.databits == 16)
            header.binarytype = 'uint16=>uint16';
            
        elseif (header.databits == 32)
            header.binarytype = 'uint32=>uint32';
            
        else
            disp('Cannot determine binary data type');
            disp('file is not in valid ffa format');
            fclose(fid);
            fid = -1;
            return
        end
        
    else
        disp('invlaid signflag');
        disp('file is not in valid ffa format');
        fclose(fid);
        fid = -1; 
        return;
    end
    
    
    
else
   disp('invlaid floatflag');
   disp('file is not in valid ffa format');
   fclose(fid);
   fid = -1;
   return;   
end

