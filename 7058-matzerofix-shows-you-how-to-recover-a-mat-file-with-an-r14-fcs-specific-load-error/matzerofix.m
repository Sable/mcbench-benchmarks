function matzerofix(matfilename,varargin)
% MAT-File Zero Size In Tag R14FCS MATLAB 7.0.0-specific Fix Tool (MATZEROFIX)
% version 2, March 2005.
%
% This tool is intended to show you how to fix v5 MAT-Files saved ONLY with
% R14FCS MATLAB 7.0.0, which the MATCAT tool determined to have zero size in
% the tag of a variable. This tool does not modify the MAT-File unless you
% use the optional second input argument, 'fix', in which case the file is
% fixed automatically, but only for the first (most common) case shown below.
%
% The zero-size-in-tag issue has two possible causes:
%
% (1) the most likely cause is specific to MATLAB 7.0.0, which only happens
%    in rare cases, and is fixed in R14sp1, and thus can be avoided altogether
%    by using MATLAB 7.0.1 or later (R14sp1 or later). If this is the cause of
%    the zero tag in your MAT-File, then this tool (matzerofix) can either
%    show you how to fix it yourself, or fix the MAT-File automatically.
%
%    The data of such a zero-size-in-tag variable is saved correctly, only
%    the variable's tag says zero data bytes (incorrect), thus causing MATLAB
%    to be unable to load the file. Once the MAT-File is fixed by setting
%    the correct size in the tag, the file will load correctly in MATLAB.
%
% (2) the other possible cause is specific to MATLAB 7.0.0 through 7.0.4 and
%    is due to a variable that is skipped during save. In this case, an extra
%    8 byte tag which should not be there is saved in the MAT-File. This will
%    be fixed in R14sp3. This tool (matzerofix) does not fix this problem.
%
%    To fix such a file, the file must be copied to a new file, excluding the
%    8 byte tag at the offset indicated by matzerofix. For example, if you have
%    a 200 byte MAT-File with a zero tag at offset 128, copy bytes 0-127 to a
%    new file, skip bytes 128-135, then continue with bytes 136 until the end
%    of the file. If there are more such tags, you may need to repeat the
%    process until all are excluded, then it will load correctly in MATLAB.
%
% Usage:
%
%   matzerofix  mymatfile.mat
%   matzerofix('mymatfile.mat')
%   matzerofix  mymatfile.mat   fix
%   matzerofix('mymatfile.mat','fix')
%
% You should download the MATCAT tool and diagnose your MAT-File first
% to determine whether you need to use this (MATZEROFIX) tool on your file.

if ( nargin < 1 ) || ( nargin > 2 )
	error('matzerofix:incorrectInputArgs',nargchk(1,2,nargin));
end

fixfile = 0;
fixmode = 'rb';

if length(varargin) == 1 & ischar(varargin{1}) & strcmpi(varargin{1}, 'fix')
	fixfile = 1;
	fixmode = 'r+';
end

f=fopen(matfilename,fixmode); % open MAT-File

openmode = 'r+';

fseek(f,126,'bof'); % goto position of endian indicator MI [0x4d49] = native, IM [0x494d] = need to swap

a=fread(f,1,'uint16'); % read 16 bit int endian indicator

% determine if numeric data read from this file needs to be endian-swapped or not

if a == 19785 % 0x4d49 = 19785 = 'MI', 0x494d = 18765 = 'IM'

	% numeric data in this MAT-File does not need to be endian-swapped when read on this computer

else

	if a == 18765

		% at this point there are two possibilities:

		% (a) this is a big endian computer and the MAT-File was saved on a little endian computer,
		% or (b) this is a little endian computer and the MAT-File was saved on a big endian computer,
		% we don't know which, so close the file and open it in big endian mode.

		% If the file doesn't need to be swapped anymore then (b) applies.
		% If it still needs to be swapped, then (a) applies, so close the file again and open it
		% in little endian mode.

		fclose(f);

		f=fopen(matfilename,fixmode,'b'); % open mat file using big endian format for numeric data

		openmode = 'r+'',''b';

		fseek(f,126,'bof'); % goto position of endian indicator MI [0x4d49] = native, IM [0x494d] = need to swap

		a=fread(f,1,'uint16'); % read 16 bit int endian indicator

		if a == 18765 % still need to be swapped, try little endian format for numeric data

			fclose(f);

			f=fopen(matfilename,fixmode,'l'); % open mat file using little endian format for numeric data

			openmode = 'r+'',''l';

		end
	else

		fprintf('2-byte endian indicator at zero-based offset 126 is neither ''MI'' nor ''IM'' (bad v5 MAT-File header)\n');

		fclose(f); return;

	end

end

fseek(f,128,'bof'); % skip v5 MAT-File header

founderror = 0;

while 1

a=fread(f,1,'int32');

if feof(f)
	if founderror
		founderror = 0;
		varsize = ftell(f)-4-zerotagoffset;
		if varsize > 0
			if fixfile
				fprintf('\tcorrecting tag - setting 32bit value at offset %d to the correct variable size: %d...',zerotagoffset,varsize);
				curpos = ftell(f);
				fseek(f,zerotagoffset,'bof');
				fwrite(f,varsize,'int32');
				fseek(f,curpos,'bof');
				fprintf('done.\n');
			else
				fprintf('\tcorrect this value like this:\n\tfid=fopen(''%s'',''%s'');fseek(fid,%d,''bof'');fwrite(fid,%d,''int32'');fclose(fid)\n',matfilename,openmode,zerotagoffset,varsize);
			end
		else
			fprintf('this zero tag was caused by a variable that was skipped during save.\n');
			fprintf('This is a separate issue which will be fixed in R14sp3. To fix this MAT-File,\n');
			fprintf('you have to copy this file before and after the tag, excluding the 8 byte\n');
			fprintf('tag at zero-based offset %d, to a new file.\nMATZEROFIX did not change this MAT-File.\n',zerotagoffset-4);
		end
	end
	fclose(f); break;
end % end of file reached, exit.

if 15 == a % compressed variable found

	curpos = ftell(f); % byte offset of the compressed variable (same as in MATCAT)

	if founderror
		founderror = 0;
		varsize = curpos-4-zerotagoffset-4;
		if varsize > 0
			if fixfile
				fprintf('\tcorrecting tag - setting 32bit value at offset %d to the correct variable size: %d...',zerotagoffset,varsize);
				curpos = ftell(f);
				fseek(f,zerotagoffset,'bof');
				fwrite(f,varsize,'int32');
				fseek(f,curpos,'bof');
				fprintf('done.\n');
			else
				fprintf('\tcorrect this value like this:\n\tfid=fopen(''%s'',''%s'');fseek(fid,%d,''bof'');fwrite(fid,%d,''int32'');fclose(fid)\n',matfilename,openmode,zerotagoffset,varsize);
			end
		else
			fprintf('this zero tag was caused by a variable that was skipped during save.\n');
			fprintf('This is a separate issue which will be fixed in R14sp3. To fix this MAT-File,\n');
			fprintf('you have to copy this file before and after the tag, excluding the 8 byte\n');
			fprintf('tag at zero-based offset %d, to a new file.\nMATZEROFIX did not change this MAT-File.\n',zerotagoffset-4);
		end
	end

	a=fread(f,1,'int32'); % variable data bytes

	fprintf('byte %d compressed var size offset %d data bytes %d', curpos-4,curpos,a);

	if 0 == a
		fprintf(' <-INCORRECT\n');
		founderror = 1;
		zerotagoffset = curpos;
		fseek(f,-3,'cof'); % tag is bad - look for next COMPRESSED variable tag
	else
		fprintf('\n');
		fread(f,a,'int8'); % tag is good - SKIP variable data bytes
	end
else
	fseek(f,-3,'cof');
end
end
