function configure_blenenpik
% configure_blendenpik
%
% Configures Blendenpik before compilation.
%
% 6-December 2009, Version 1.3
% Copyright (C) 2009, Haim Avron and Sivan Toledo.

pc = ispc;

[s, hostname] = system('hostname');
hostname = hostname(1:end-1);
config_file = sprintf('config/config.%s', hostname);

if (~exist('config', 'dir'))
    mkdir('config');
end

fid = fopen(config_file, 'w');

fftw_installed = get_boolean('Do you have FFTW installed? ');
if (fftw_installed)
    fprintf(fid, 'USE_FFTW = true;\n');
        
    fftw_lib = input('FFTW''s library directory: ', 's');
    fprintf(fid, 'FFTW_DIR_LIB = ''%s'';\n', fftw_lib);
    fftw_inc = input('FFTW''s include directory: ', 's');
    fprintf(fid, 'FFTW_DIR_INC = ''%s'';\n', fftw_inc);
    
    disp('FFTW library base name - ');
    disp('This is the name used by the library file.');
    disp('For Windows the library file is called BASE.dll, where BASE is the base name.');
    disp('For Unix the library file is called libBASE.a, where BASE is the base name.');
    fftw_base = input('FFTW library base name: ', 's');
    fprintf(fid, 'FFTW_NAME = ''%s'';\n', fftw_base);
    
    disp('Blendenpik pre-builds FFTW plans for sizes QUANT * n (n = 1, 2, ...). Intermediate values are padded with zero.'); 
    fftw_quant = input('Please enter QUANT (default is 1000): ');
    if (isempty(fftw_quant))
        fftw_quant = 1000;
    end
    fprintf(fid, 'FFTW_QUANT = %d;\n', fftw_quant);
    fftw_max_size = input('Please enter max size for autotunning (default is 150,000): ');
    if (isempty(fftw_max_size))
        fftw_max_size = 150000;
    end
    fftw_times = floor(fftw_max_size / fftw_quant);
    fprintf(fid, 'FFTW_TIMES = %d;\n', fftw_times);
    disp('FFTW auto-tunning level -');
    disp('Values are 0-4. Higher value - longer build time, faster running time.');
    fftw_planning_level = input('FFTW planning level (default is 0): ');
    if (isempty(fftw_planning_level))
        fftw_planning_level = 0;
    end
    fprintf(fid, 'FFTW_PLANNING_LEVEL = %d;\n', fftw_planning_level);
else
    fprintf(fid, 'USE_FFTW = false;\n');
end


swht_installed = get_boolean('Do you have SPIRAL WHT installed? ');
if (swht_installed)
    fprintf(fid, 'USE_SWHT = true;\n');
        
    swht_lib = input('SPIRAL WHT''s library directory: ', 's');
    fprintf(fid, 'SWHT_DIR_LIB = ''%s'';\n', swht_lib);
    swht_inc = input('SPIRAL WHT''s include directory: ', 's');
    fprintf(fid, 'SWHT_DIR_INC = ''%s'';\n', swht_inc);
    
    disp('SPIRAL WHT library base name - ');
    disp('This is the name used by the library file.');
    disp('For Windows the library file is called BASE.dll, where BASE is the base name.');
    disp('For Unix the library file is called libBASE.a, where BASE is the base name.');
    fftw_base = input('SPIRAL WHT library base name: ', 's');
    fprintf(fid, 'SWHT_NAME = ''%s'';\n', fftw_base);
else
    fprintf(fid, 'USE_SWHT = false;\n');
end

if (~fftw_installed && ~swht_installed)
    error('Either FFTW or SPIRAL WHT must be used!');
end

if (pc)
    obj = '.obj';
else
    obj = '.o';
end
fprintf(fid, 'OBJ_EXT = ''%s'';\n', obj);


matlab_blas = get_boolean('Use MATLAB''s BLAS and LAPACK? ');
if (matlab_blas)
    if (pc)
        underscore = 'false';
    else
        underscore = 'true';
    end
    fprintf(fid, 'BLAS_UNDERSCORE = %s;\n', underscore);
    
    if (pc)
        fprintf(fid, 'LAPACK_DIR = ''%s\\extern\\lib\\win32\\microsoft'';\n', matlabroot);
        fprintf(fid, 'LAPACK_NAME = ''mwlapack'';\n');

        fprintf(fid, 'BLAS_DIR = ''%s\\extern\\lib\\win32\\microsoft'';\n', matlabroot);
        fprintf(fid, 'BLAS_NAME = ''mwlapack'';\n');
    else
        fprintf(fid, 'LAPACK_DIR = ''%s'';\n', matlabroot);
        fprintf(fid, 'LAPACK_NAME = ''mwlapack'';\n');

        fprintf(fid, 'BLAS_DIR = ''%s'';\n', matlabroot);
        fprintf(fid, 'BLAS_NAME = ''mwblas'';\n');
    end
else
    underscore_b = get_boolean('Append underscore to function names? ');
    if (underscore_b)
        underscore = 'true';
    else
        underscore = 'false';
    end    
    fprintf(fid, 'BLAS_UNDERSCORE = %s;\n', underscore);
    
    blas_dir = input('BLAS directory: ', 's');
    fprintf(fid, 'BLAS_DIR = ''%s'';\n', blas_dir);
    blas_name = input('BLAS name: ', 's');
    fprintf(fid, 'BLAS_NAME = ''%s'';\n', blas_name);
    
    lapack_dir = input('LAPACK directory: ', 's');
    fprintf(fid, 'LAPACK_DIR = ''%s'';\n', lapack_dir);
    lapack_name = input('LAPACK name: ', 's');
    fprintf(fid, 'LAPACK_NAME = ''%s'';\n', lapack_name);
end

disp('Additonal flags - TIP: if you are on UNIX having problem with gfortran try LD="gfortran"');
add_inputs = input('Additional inputs: ', 's');
if (isempty(add_inputs))
    add_inputs = '';
end
fprintf(fid, 'ADDITIONAL_FLAGS = ''%s'';\n', add_inputs);

fclose(fid);

%% get_boolean
function bb = get_boolean(input_text)

bb_text = input(input_text, 's');
bb = strcmp(lower(bb_text), 'yes');

