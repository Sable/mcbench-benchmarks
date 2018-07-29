function strrepfile(filename,S1,S2)
% STRREPFILE Replace string in a file with another.
%
% Syntax
%
% strrepfile(filename,S1,S2)
%
% Description
% 
% STRREPFILE(filename,S1,S2) replaces all occurrences of the string S1 in
% the file filename with the string S2. S1, S2 may also be cell arrays of
% strings of the same size, in which case the replacement is performed for
% each pair by performing a STRREP using corresponding elements of the
% inputs. Alternatively S2 may be a string and S1 a cell array, in this
% case the single string S2 will replace all the strings in S1
% 
% filename may also be a cell array of strings, each a file name, in which
% case the replacement is perfromed for each file.
%
%   See also STRFIND, REGEXPREP.

    if ~iscellstr(filename) && ischar(filename)
        filename = {filename};
    elseif ~iscellstr(filename)
        error('filename must be a string or cell array of strings containing file locations.')
    end
    
    for i = 1:numel(filename)
        
        if exist(filename{i}, 'file') ~= 2
            error('file %s not found', filename{i});
        end
       
        if iscellstr(S1) && iscellstr(S2) 
            
            if ~samesize(S1, S2)
                error('If two cell arrays of strings are supplied, all dimensions must be the same size')
            end
            
        elseif iscellstr(S1) && ischar(S2)
            
            % replicate string in S1 to make cell array same size as S2
            S2 = repmat({S2}, size(S1));
            
        elseif ischar(S1) && iscellstr(S2)
            
            % throw an error
            error('S1 cannot be a string if S2 is a cell array of strings.')
            
        elseif ischar(S1) && ischar(S2)
            % convert strings to scalar cell arrays
            S1 = {S1};
            S2 = {S2};
            
        else
            error('S1 and S2 must be two cell arrays of strings of the same size, or a combination of cell string array and strings, or two strings')
        end
        
        [pathstr, name, ext] = fileparts(filename{i});
        
        [origfid, msg] = fopen(fullfile(pathstr, [name, ext]), 'r');
        
        % create a temporary file to write the replaced string version of
        % the file to
        tempfilename = [tempname, ext];
        
        [tempfid, msg] = fopen(tempfilename, 'w');

        % check the files were opened properly
        if tempfid == -1 && origfid == -1
            error('error opening both search and temporary file');
        elseif tempfid == -1
            origstatus = fclose(origfid);
            if origstatus == -1
                error('Error opening temporary file, and also now unable to close original file.');
            else
                error('Error opening temporary file.');
            end
        elseif origfid == -1
            error('Error opening search file.');
        end

        while 1
            tline = fgets(origfid);
            
            if tline ~= -1
                
                for ii = 1:numel(S1)
                    tline = strrep(tline, S1{ii}, S2{ii});
                end
                
                fprintf(tempfid, '%s', tline);
                
            else
                tempstatus = fclose(tempfid);
 
                origstatus = fclose(origfid);
                
                if tempstatus == -1 && origstatus == -1
                    error('error closing both search and temporary file');
                elseif tempstatus == -1
                    error('Error closing temporary file.');
                elseif origstatus == -1
                    error('Error closing search file.');
                end
                
                break;
            end
        end
        
        % now copy over the new file to the original location
        [status,message,messageid] = copyfile(tempfilename, fullfile(pathstr, [name, ext]));
        
        % if there was a problem rethrow the error
        if status == 0
            rethrow(struct('message', message, 'identifier', messageid));
        end
        
    end

end