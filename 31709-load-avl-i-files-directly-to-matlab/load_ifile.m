%Load AVL I-File combustion data
%   LOAD_IFILE loads the specified AVL I-File into a MATLAB structure.
%
%   input = LOAD_IFILE(filename,offset_correction)
%   
%   Set offset_correction = 1 to perform cylinder pressure offset
%   correction as specified in the AVL I-File itself.

function result = load_ifile(filename,offset_correction)

if (nargin == 0)
	disp('You must specify the filename of the AVL I-File to load');
	return;
end

if (nargin == 1)
	disp('Not performing pressure offset correction');
	offset_correction = 0;
end

% Generate unique script name

temp_script = [ tempname '.ccf'];
temp_matfile = [ tempname '.mat'];

[fid,msg] = fopen(temp_script, 'w+');

if (fid < 0)
    disp(msg);
else
    %   Create script
    fprintf(fid,'debug-level WARNING\n');
    fprintf(fid,'input-file-type AVL_IFILE\n');
    fprintf(fid,'input-file %s\n',filename);
    fprintf(fid,'load-channels all\n');
    fprintf(fid,'load-file\n');
    if (offset_correction)
        fprintf(fid,'channel-offset offset_type IFILE\n');
        fprintf(fid,'analyse none\n');
        fprintf(fid,'run-analysis\n');
    end
    fprintf(fid,'output-file %s\n',temp_matfile);
    fprintf(fid,'output-data CA_RAW RESULTS\n');
    fprintf(fid,'output-file-type MATLAB\n');
    fprintf(fid,'output\n');

    fclose(fid);

    % Run script

    result = system(['catool ' temp_script]);

    % Delete temporary config file

    delete(temp_script);
    
    if (result == 0)
        % Check if catool generated a MAT file

        fid = fopen(temp_matfile, 'r');
        
        if (fid < 0)
            disp('catool has not generated a MAT file');
            result = -1;
        else
            fclose(fid);
            
            % Load IFile MAT file
            disp(['Loading ' temp_matfile]);
            result = load(temp_matfile);
            
            % Delete temporary MAT file
            delete(temp_matfile);
        end
    end
end

end