function mcolon_install
% function mcolon_install
% installation of the package mcolon
%
% Author: Bruno Luong <brunoluong@yahoo.com>
% Date: 03-Jan-2011: fix bug with pathname having space

[pname] = fileparts(mfilename('fullpath'));

if ispc()
    cpcmd = 'COPY';
else
    cpcmd = 'cp';
end

CMD = [cpcmd ' "' ...
       pname filesep() 'mcolon_MatlabBased.m" "' ...
       pname filesep() 'mcolon.m"'];
fprintf('%s\n', CMD);
system(CMD);

CMD = [cpcmd ' "' ...
       pname filesep() 'castarrays_MatlabBased.m" "' ...
       pname filesep() 'castarrays.m"'];
fprintf('%s\n', CMD);   
system(CMD);

if strfind(computer(), '64')
    mex -v -O -largeArrayDims mcolonmex.c
    mex -v -O -largeArrayDims getclassidmex.c
else
    mex -v -O mcolonmex.c
    mex -v -O -largeArrayDims getclassidmex.c
end

CMD = [cpcmd ' "' ...
       pname filesep() 'mcolon_MexBased.m" "' ...
       pname filesep() 'mcolon.m"'];
fprintf('%s\n', CMD);   
system(CMD);

CMD = [cpcmd ' "' ...
       pname filesep() 'castarrays_MexBased.m" "' ...
       pname filesep() 'castarrays.m"'];
fprintf('%s\n', CMD);   
system(CMD);

fprintf('\n');
fprintf([repmat('-',1,100) '\n']);
fprintf(['Last step: Plase add manually "%s" \n' ...
         'in your Matlab path using (menu File -> Set Path)\n'], pname);

end
