% Image index Analysis
% imanalysis

% 10/08/2011 - Version 1.0
% 22/08/2011 - Version 1.2 /Fixed a compatibility issue for older versions.
% 08/08/2011 - Version 1.7 /Made the filenames input easier with uigetfile,
%                          /dealt with invalid inputs.

% Author: Aristidis D. Vaiopoulos

% Acknowledgement: This program uses progressbar.m to display the estimated 
% time left. Author of progressbar.m, is Steve Hoelzer.

% -------------------------------------------------------------------------
% ====================
% Program Description:
% ====================
% This is a program which utilizes the included functions in order to
% calculate 8 image indices (Bias, Correlation coefficient, DIV, Entropy, 
% ERGAS, Q, RASE and RMSE). The purpose of the program is to produce the 
% results fast, easily and in a convenient way for the user (see Outputs). 
% Initially, its purpose was to perform index analysis in hyperspectral and 
% multispectral satellite imagery. It has been used and tested in fused 
% hyperspectral products for quality assessment of the spectral fidelity. 
% However, it is estimated that it can be used for image comparison of 
% similar or processed images, of completely different origin. Every
% included function can be used separately.
%
% Program Structure:
% ------------------
% 0) User runs the program by typing 'imanalysis' in the command window.
%
% Inputs:
% 1) User must provide the program with the number (nin) of the test images 
% (test) he desires to compare, with the original image (orig). 
% *** All images must have the exact same resolution ***
% 2) After image inputs, user is being asked for the h/l ERGAS ratio.
% 3) Then, the user has to input the filenames, first that of the original 
% image and afterwards, those of the (nin) test images declared in step 1.
%
% Index analysis:
% 4) Program performs computation of all eight indices for every image and 
% for every band, by using seven independent functions. The average value 
% is calculated for every index. Total values are also computed for 
% Entropy, ERGAS and RASE indices.
%
% Outputs:
% 5) Program outputs an Excel file, containing each index analysis results 
% in a homonymous spreadsheet. For ease, or later statistical operations, 
% a column has been added to the left, numbering the bands of the tested 
% imagery and a row above, containing the filename. User of course, can 
% examine and plot the index results from Matlab command window. By typing
% before the index 'c' and after the index 's', the cell array containing
% the certain index is shown. For example, to display ERGAS index, we must
% type 'cergass'. See lines 326-333, for every index (2nd arg in xlswrite).
%
% -Compatibility-
% -Oldest Matlab version tested: 7.0.1 (R14SP1). Bear in mind that you will
% not be able to analyze hyperspectral images with this version.
% -Oldest Matlab version known to have full functionallity: 7.6 (R2008a). 
%
% *This program does NOT use sliding windows in index computations.*
%--------------------------------------------------------------------------

% -Uncomment the line below, if your Matlab version has clearvars function-
% clearvars -except p excel_name 

format short g;
format compact;

disp(' ');
disp('Image index Analysis');
disp('--------------------');
disp(' ');

% Try counter
tr_c        = 0;
nin         = 0;
resratio    = 0;

% Inputs...
% 1. Number of test datasets
while nin <= 0 | ~isreal(nin) | ischar(nin) | numel(nin)~=1  %#ok<*OR2>
    
    nin = input('How many images will you use?...                  ');
    disp(' ')
    if (nin <= 0 | ~isreal(nin) | ischar(nin) | numel(nin)~=1) 
        
        tr_c = tr_c + 1;
        if tr_c < 3
        disp('-Invalid input. Please try again.')
        disp(' ')
        end
        if tr_c == 3
            disp('-Invalid input.')
            disp(' ')
        return;
        end
    end

end
nin = round(nin);
% 2. ERGAS ratio       
while resratio <= 0 | ~isreal(resratio) | ...
        ischar(resratio) | numel(resratio)~=1 
    
    resratio = input('Please enter resolution ratio (H/L) for ERGAS...  ');
    disp(' ')
    
    if (resratio <= 0 | ~isreal(resratio) | ...
        ischar(resratio) | numel(resratio)~=1)
        
        tr_c = tr_c + 1;
        if tr_c < 3
        disp('-Invalid input. Please try again.')
        disp(' ')
        end
        if tr_c == 3
            disp('-Invalid input.')
            disp(' ')
        return;
        end
    end
end

% 3. Data inputs
impaths = cell(nin+1,1);
flnames = cell(nin+1,1);
i       = 1;

% Original data
disp('Please input the ORIGINAL image.....')
[filename, pathname] = uigetfile(...
{'*.bmp;*.gif*.jpg;*.png;*.tif',...
'Image Files (*.bmp *.gif *.jpg *.png *.tif )';
'*.*',  'All Files'}, ...
'Select the ORIGINAL Dataset');
impaths(i) = {[pathname filename]};
flnames(i) = {filename};
if filename == 0
    disp('-Program exits: Data input was canceled by user.')
    disp(' ')
    return;
end
disp(['                                    ', '''',filename,'''']);
disp(' ')

% Test data
for i = 1:nin
    
disp(['Please input the TEST image No. ', num2str(i),'...   ']); 
[filename, pathname] = uigetfile(...
{'*.bmp;*.gif*.jpg;*.png;*.tif',...
'Image Files (*.bmp *.gif *.jpg *.png *.tif )';
'*.*',  'All Files'}, ...
'Select a TEST Dataset');
disp(['                                       ', '''',filename,'''']);
impaths(i+1) = {[pathname filename]};
flnames(i+1) = {filename};
if filename == 0
    disp('-Program exits: Data input was canceled by user.')
    disp(' ')
    return;
end

end
disp(' ')

%%
tic;

disp('=========================')
disp('Please wait. Working.....')
disp('=========================')
disp(' ')

disp('Parsing Original image...') 
orig = importdata(char(impaths(1)));
disp('Original image parsed.')
disp(' ')
% Find number of bands
sizi = size(orig);
if max(size(size(orig))) == 2
    bands = 1;
else
    bands = sizi(1,3);
end

% Preallocation
% Indices per band
bias        = zeros(bands,nin+1);
cc          = ones(bands,nin+1);
div         = zeros(bands,nin+1);
Epb         = zeros(bands,nin+1);
ergas_pb    = zeros(bands,nin+1);
qs          = ones(bands,nin+1);
rase_pb     = zeros(bands,nin+1);
rmses       = zeros(bands,nin+1);
% Average indices
av_bias     = zeros(1,nin+1);
av_cc       = ones(1,nin+1);
av_div      = zeros(1,nin+1);
Eav         = zeros(1,nin+1);
av_ergas    = zeros(1,nin+1);
av_q        = ones(1,nin+1);
av_rase     = zeros(1,nin+1);
av_rmse     = zeros(1,nin+1);
% Total indices (whole image)
Etl         = zeros(1,nin+1);
ergas_tl    = zeros(1,nin+1);
rase_tl     = zeros(1,nin+1);

% Find if the function progressbar exists, if the user wishes to use it
fp = 0;
p_ex = 0;
if ~exist('p') || p ~= 0 %#ok<EXIST>
    p = 1;
    p_ex = exist('progressbar.m'); %#ok<EXIST>
end
if p_ex == 2
    fp = 1;
end

if p ~= 0 && fp == 0 
    disp('*Cannot find progressbar.m')
    disp('*Estimated time left will not be shown.')
    disp(' ')
end

if p == 1 && fp == 1 
    progressbar
end

for m = 2:nin+1
    
    disp(['Parsing Test image # ', num2str(m-1),'...']) 
    test = importdata(char(impaths(m)));
    disp(['Test image # ', num2str(m-1), ' parsed.'])
    disp(['Analysing Test image # ', num2str(m-1), '....'])  
    disp(' ')
    disp('-Calculating index 1 of 8: Bias...')
    [bias(:,m) av_bias(m)]                  = bias_f(orig,test);
    disp('-Bias has been computed.')
    disp('-Calculating index 2 of 8: DIV...')
    [div(:,m) av_div(m)]                    = div_f(orig,test);
    disp('-DIV has been computed.')
    disp('-Calculating index 3 of 8: Entropy...')
    [Epb(:,m) Eav(m) Etl(m)]                = entropia_f(test);
    disp('-Entropy has been computed.')
    disp('-Calculating index 4 of 8: ERGAS...') 
    [ergas_pb(:,m) av_ergas(m) ergas_tl(m)] = ergas_f(orig,test,resratio);
    disp('-ERGAS has been computed.')
    disp('-Calculating indices 5 + 6 of 8: CC + Q...') 
    [qs(:,m) av_q(m) cc(:,m) av_cc(m)]      = q_f(orig,test);
    disp('-CC and Q have been computed.')
    disp('-Calculating index 7 of 8: RASE...') 
    [rase_pb(:,m) av_rase(m) rase_tl(m)]    = rase_f(orig,test);
    disp('-RASE has been calculated.')
    disp('-Calculating index 8 of 8: RMSE...') 
    [rmses(:,m), av_rmse(m)]                = rmse_f(orig,test);
    disp('-RMSE has been calculated.');
    disp(' ')
    % Since nin is relatively small, this check does not decrease
    % significantly the execution time.
    if p == 1 && fp == 1
        progressbar((m-1)/nin)
    end
    
end

disp('-Calculating Entropy of Original image...')
[Epb(:,1) Eav(1) Etl(1)]                = entropia_f(orig);
disp('-Entropy of Original image computed.')
disp(' ')

disp('-Image index analysis completed.')
disp(' ')

ttime = toc;
%%
% Write excel file with all index analysis results

disp('-Preparing Excel Output...')
% Disable AddSheet Warning
warning off MATLAB:xlswrite:AddSheet
% Band count
cbnd    = num2cell(1:bands)';
cbnda   = [ {'BAND #'}; cbnd ; cell(1,1) ; {'AVERAGE'} ];
cbndt   = [ cbnda; cell(1,1) ; {'TOTAL'} ];
e_line =  cell(1,nin+1);
% Prepare cell per index
% Bias
cbiass = [ flnames' ; num2cell(bias); e_line; num2cell(av_bias)];
cbiass = [ cbnda, cbiass ];
% DIV
cdivs = [ flnames' ; num2cell(div); e_line; num2cell(av_div)];
cdivs = [ cbnda, cdivs ];
% Entropy
centropys = [ flnames' ; num2cell(Epb); e_line; num2cell(Eav);...
             e_line   ; num2cell(Etl)                      ];
centropys = [ cbndt, centropys ];
% ERGAS
cergass = [ flnames' ; num2cell(ergas_pb); e_line; num2cell(av_ergas);...
            e_line  ; num2cell(ergas_tl)                    ];
cergass = [ cbndt, cergass ];
% CC
cccs = [ flnames' ; num2cell(cc); e_line; num2cell(av_cc)];
cccs = [ cbnda, cccs ];
% Q
cqss = [ flnames' ; num2cell(qs); e_line; num2cell(av_q)];
cqss = [ cbnda, cqss ];
% RASE
crases = [ flnames' ; num2cell(rase_pb); e_line; num2cell(av_rase);...
            e_line ; num2cell(rase_tl)                  ];
crases = [ cbndt, crases ];
% RMSE
crmses = [ flnames' ; num2cell(rmses); e_line; num2cell(av_rmse)];
crmses = [ cbnda, crmses ];

% Check if there is a prefered name for excel output, else use default
if ~exist( 'excel_name' ) %#ok<EXIST>
    excel_name = 'Image Index Analysis.xls';
end

% Write every index in the homonymous excel spreadsheet
xlswrite( excel_name, cbiass,       'Bias')
xlswrite( excel_name, cdivs,        'DIV')
xlswrite( excel_name, cccs,         'CC')
xlswrite( excel_name, centropys,    'Entropy')
xlswrite( excel_name, cergass,      'ERGAS')
xlswrite( excel_name, cqss,         'Q')
xlswrite( excel_name, crases,       'RASE')
xlswrite( excel_name, crmses,       'RMSE')

disp('-All indices have been written successfully in Excel file.')
disp(' ')


