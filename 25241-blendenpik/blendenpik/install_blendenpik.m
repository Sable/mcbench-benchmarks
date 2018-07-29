function install_blendenpik
% install_blendenpik
%
% Compiles and install Blendenpik.
% Blenenpik is a library for fast solution of dense least squares problem.
%
% 6-December 2009, Version 1.3
% Copyright (C) 2009, Haim Avron and Sivan Toledo.


%% Get configuration
[s, hostname] = system('hostname');
hostname = hostname(1:end-1);
config_file = sprintf('config/config.%s', hostname);

% Generate config file?
if (exist(config_file) ~= 0)
    regen_config = input('Configuration file already exist. Regenerate? ', 's');
    if (strcmp(lower(regen_config), 'yes'))
        configure_blenenpik;
    end
else
    configure_blenenpik; 
end

% Read config file
fid = fopen(config_file);
if (fid == -1)
    error(sprintf('Config file %s not found!', CONFIG_FILE));   
end
while 1
    tline = fgetl(fid);
    if ~ischar(tline), break, end
    eval(tline);
end  

WISDOM_FILE = sprintf('%s/dat/wisdom_file.%s.%d.dat', pwd, hostname, FFTW_PLANNING_LEVEL);
if (ispc)
    WISDOM_FILE(WISDOM_FILE == '\') = '/';
end
                  
                  
%% Write config.h                  
fid = fopen('config.h', 'w');
fprintf(fid, '#define FFTW_QUANT %d\n', FFTW_QUANT);
fprintf(fid, '#define FFTW_TIMES %d\n', FFTW_TIMES);
fprintf(fid, '#define FFTW_WISDOM_FILE "%s"\n', WISDOM_FILE);
if (FFTW_PLANNING_LEVEL > 0)
    wisdom_flag = 'FFTW_WISDOM_ONLY';
else
    wisdom_flag = 'FFTW_ESTIMATE';
end
fprintf(fid, '#define FFTW_WISDOM_FLAG %s\n', wisdom_flag);
if (BLAS_UNDERSCORE)
    fprintf(fid, '#define BLAS_UNDERSCORE\n');
end

if (USE_FFTW)
    fprintf(fid, '#define USE_FFTW\n');
end
    
if (USE_SWHT)
    fprintf(fid, '#define USE_SWHT\n');
end

fclose(fid);

%% Compile
MEX_DIR = pwd;

if (~exist(MEX_DIR, 'dir'))
    mkdir(MEX_DIR);
end

incs = sprintf('-I"%s"', pwd);
libs = '';

if (USE_FFTW)
    incs = sprintf('%s -I"%s"', incs, FFTW_DIR_INC);
    libs = sprintf('%s -L"%s" -l%s', libs, FFTW_DIR_LIB, FFTW_NAME);
end

if (USE_SWHT)
    incs = sprintf('%s -I"%s"', incs, SWHT_DIR_INC);
    libs = sprintf('%s -L"%s" -l%s', libs, SWHT_DIR_LIB, SWHT_NAME);
end

prefix0 = sprintf('mex -outdir ''%s'' %s -O %s', MEX_DIR, incs, libs); 
prefix = sprintf('%s -L"%s" -l%s -L"%s" -l%s %s ', prefix0,  LAPACK_DIR, LAPACK_NAME, BLAS_DIR, BLAS_NAME, ADDITIONAL_FLAGS);


eval([prefix '-c ' 'fftw_r2r.c']);
FFTW_R2R_OBJ = sprintf('"%s/fftw_r2r%s"', MEX_DIR, OBJ_EXT);
eval([prefix 'mex_fftw_r2r.c ' FFTW_R2R_OBJ]);
eval([prefix 'fast_unitary_transform.c ' FFTW_R2R_OBJ]);
eval([prefix 'fast_unitary_transform_size.c']);
eval([prefix 'build_fftw_wisdom.c']);
eval([prefix 'wtime.c']);
eval([prefix 'mex_dtrcon.c']);
eval([prefix 'mex_dgeqrf.c']);
eval([prefix 'mex_dormqr.c']);
eval([prefix 'mex_dtrsm.c']);
eval([prefix 'mex_dlange.c']);
eval([prefix 'lapack_solve_ls.c']);
eval([prefix 'dense_overdetermined_lsqr.c']);
eval([prefix 'dense_full_overdetermined_lsqr.c']);
eval([prefix 'dense_underdetermined_lsqr.c']);
addpath(MEX_DIR);
addpath(pwd);
savepath;

if (~exist('dat', 'dir'))
    mkdir('dat');
end

if (USE_FFTW)
    if (exist(WISDOM_FILE, 'file'))
        build_wisdom_text = input('FFTW wisdom already exist. Rebuild? (yes/no) ', 's');
        build_wisdom = strcmp(lower(build_wisdom_text), 'yes');
    else
        build_wisdom = true;
    end
    if (build_wisdom)
        disp('Building FFTW''s wisdom...');
        build_fftw_wisdom(FFTW_PLANNING_LEVEL, WISDOM_FILE);
    end
end

