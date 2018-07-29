function [freq, data, freq_noise, data_noise, Zo] = SXPParse(DataFileName, fid_log)

% reads .sxp file data in MDIF (a.k.a. Touchstone / HPEEsof format)
%
% EXAMPLE :
% [freq, data, freq_noise, data_noise, Zo] = SXPParse(DataFileName, fid_log);
%
% freq, freq_noise  - 1xF arrays
% data              - PxPxF matrix, P- number of ports, F- number of freq points
% data_noise        - Fn x 3 matrix, complex, Fn is size(freq_noise), columns are :
%                     1. NFmin <dB>, 2. Gamma_opt<complex), 3. Rn <normalized>
%                     (in order to use NFmin and Rn you have to take the real part)
% Zo                - impedance used in normalization of data
%
% type SXPParse('info') for info on MDIF/Touchstone/HPEESof file format
%
% written by Tudor Dima, last rev. 29.05.2012, tudima at zahoo dot com
%                                              (change the z into y...)

% ver 1.42: 2012.05.29, close the parsed file, thanks Julien Hillairet
% ver 1.41: 2009.09.05, more separators, Phrase2Word out as cell, include as subfunc
% ver 1.4 : 2008.10.25, fix nPort>4 (when lines get split) 
%                       allow comments on lines
%                       better parsing, subfunctions introduced
%                       limited protection for non-standard files
% ver 1.33: 26.01.2008, small bug fixed (again!) in 'db' conversion
%                       better help, info on MDIF standard
% ver 1.32: 08.03.2006, handle comment lines anywhere inside body
% ver 1.31: 15.12.2005, switch by type (S,Y,Z);
% ver 1.3 : 13.03.2003, rescris tot, read line by line, Y,Z, not yet
% ver 1.21: 24.04.2002, max. nr of ports increased from 9 to 99
% ver 1.2 : 04.03.1999, added noise reading (4martie99)
% ver 1.1 : 26.02.1999, data in complex format(26feb99)

if strcmp(DataFileName, 'info') || strcmp(DataFileName, 'help') || strcmp(DataFileName, '?')
    dispHelp % show extended help
    return
end

%------- read from file DataFileName -------
format compact;
if nargin<2
    fid_log = 1; % no log ? to screen (to check fid_log before passing it...)
end

fid = fopen(DataFileName, 'rt');

if fid < 1
    fprintf(fid_log, '%s \n %s', ' ... exiting...', ...
        ['Error : requested parameter file ' DataFileName ' not found ! ']);
    return
end
% --- start parsing ---
fprintf(fid_log, '\n %s \n %s', 'reading parameter data from file ', [ DataFileName ' ...']);

% --- find out matrix order ---
fnl = size(DataFileName,2);
NoOfPorts = str2double(DataFileName(fnl-1) );
candidate_zeci = str2double(DataFileName(fnl-2) );
if ~isempty(candidate_zeci) && ~isnan(candidate_zeci) 
    % some early matlab versions return empty for str2double(non-numbers)
    NoOfPorts = NoOfPorts + 10*candidate_zeci;
end % works up to 99 ports, should be ok ... :-)

% --- init default options ---
opt.multiplier = 1e6;
opt.param = 's';
opt.format = 'ma';
opt.Zo = 50;
% -> use MA in noise line, irespective of specifier in #-line
opt.Touchstone = 'old'; % to change this uncomment next line
% opt.Touchstone = 'new';

% - initialise defaults, in case file is corrupted
freq = []; data = []; Zo = 0;
data_noise = [];  freq_noise = [];

% - init parsing flags
flagDataStarted = 0; % assuming spec.line first !
flagNoiseStarted = 0;
flagGotOptions = 0;

FreqPoint = 0;
LastFrequency = 0;
thisFreqTerms = 2*NoOfPorts.^2; % like you have just finished a line

% --- incepe si citeste linie cu linie ---
phrase = lower(fgets(fid));

while ~flagDataStarted  % get options line
    if ~isempty(phrase)
        if strcmp(phrase(1),'#')    % read specifier line
            word = opPhrase2Word(deblank(phrase(2:end)));
            opt = opFigureOptions(word, opt);
            flagGotOptions = 1;
            flagDataStarted = 1;
        end
    end
    phrase = fgets(fid);
    if ~ischar(phrase), break; end;
    phrase = lower(phrase);
end

% --- read data, one frequency at a time ---
while ~flagNoiseStarted && flagGotOptions
    word = opPhrase2Word(phrase, {}, {','});
    data_row = str2double(word); % sweet ! cell 2 double array !
    if ~isempty(word) % && ~strcmp(word(1,1),'!')
        % read freq data; assume that new_freq is always on new line !
        
        if thisFreqTerms == 2*NoOfPorts.^2
            % got all current freq data, increment FreqPoint
            if data_row(1) < LastFrequency %
                flagNoiseStarted = 1; % noise data detected !
                FreqPoint = 0;
                break
            end
            FreqPoint = FreqPoint+1;
            freq(FreqPoint) = data_row(1);
            thisFreqTerms = 0;
            LastFrequency = freq(FreqPoint);
            data_row = data_row(2:end); % remove frequency
        end;
        
        % append data
        raw_data(FreqPoint,thisFreqTerms+1:thisFreqTerms+size(data_row,2)) = data_row;
        thisFreqTerms = thisFreqTerms + size(data_row,2);
    end
    
    phrase = fgets(fid);
    if ~ischar(phrase), break; end;
    phrase = lower(phrase);
end % finished reading S-data

while flagGotOptions && flagNoiseStarted
    % --- start reading noise data ---
    %     store all, including freq
    FreqPoint = FreqPoint+1;
    raw_data_noise(FreqPoint,(1:size(data_row,2))) = data_row;
    phrase = fgets(fid);
    if ~ischar(phrase), break; end;
    phrase = deblank(lower(phrase));
    word = opPhrase2Word(phrase);
    data_row = str2double(word); % store next round
end % while phrase contine ceva

if ~flagGotOptions
    fprintf('\n%s', ' > SPXParse : no options line found in file')
    fprintf('\n%s\n', ' did not assign any return values !');
    return
end
% --- now we have all the raw data ---
freq = freq * opt.multiplier;   % will arrange(slice) it as needed
Zo = opt.Zo;                    % function of format(s/z/y/a/g/h)
data = opAdjFreqData(raw_data, NoOfPorts, opt);% f(NoOfPorts),

if flagNoiseStarted % --- arrange noise data
    %freq_noise = freq_noise * opt.multiplier;
    [freq_noise, data_noise] = opAdjNoizData(raw_data_noise, opt);
end;
fprintf(fid_log, '\n%s\n', '... done.');

% don't forget to close the file :-)
fclose(fid);
end

function word = opPhrase2Word(phrase, comment_list, separator_list)
% WORD = opPhrase2Word(PHRASE, separator_list, comment_list);
%
% gets one raw ASCII line, turns it into a word cell array
%   uses default chars + separator_list to separe, ingnores all after comment signs

% 09.05.2003    - ver 0.0 : , noua (pt ParseSXP in printzip)
% 30.07.2009    - ver. 1.41, included in ParseSXP, cell output !
%                 hunt comment lines here

if nargin < 2, comment_list = {'!'}; end;
if isempty(comment_list), comment_list = {'!'}; end

if nargin < 3, separator_list = {}; end; % just standard ones :
% space, newline, CR, tab, vert. tab, or formfeed characters.

% > inspect phrase, discard commented part, if any
phrase = deblank(phrase);
for iC = 1:size(comment_list,2)
    tCheckCommentChar = phrase == comment_list{iC};
    if any(tCheckCommentChar)
        % shorten the phrase upto the comment sign
        ixComm = find(tCheckCommentChar);
        phrase = phrase(1:ixComm(1)-1);
    end
end

% > split phrase into words using separator_list
PhraseLength = size(phrase,2);
if PhraseLength % bother looking inside 
    allSeparatorChars = isspace(phrase); % false(1, PhraseLength);
    % in case more characters are used as separators >
    for iS = 1:size(separator_list,2)
        theseSeparatorChars = phrase == separator_list{iS};
        allSeparatorChars = allSeparatorChars | theseSeparatorChars;
    end

    % trim extra separators
    LookForGluedSeparators = true;
    while LookForGluedSeparators % hunt adjacent 1-s
        FoundGluedSeparators = [ allSeparatorChars(1:end-1) &...
            allSeparatorChars(2:end) false]; % not to miss last char
        if ~all(~FoundGluedSeparators) 
            % eliminate duplicated (adjacent) 1-s
            phrase = phrase(~FoundGluedSeparators);
            allSeparatorChars = allSeparatorChars(~FoundGluedSeparators);
        else % stop looking
            LookForGluedSeparators = false;                        
        end
    end
    
    if allSeparatorChars(1) % catch one leading separator !
        ixWStart = find(allSeparatorChars)+1;
        nWords = sum(allSeparatorChars);
    else % normal
        ixWStart = [1 find(allSeparatorChars)+1];
        nWords = sum(allSeparatorChars)+ 1 ;
    end
    % last word first :-) also serves as prealloc
    word{nWords} = phrase(ixWStart(nWords):end); 
    for iW=1:nWords-1
        word{iW} = phrase(ixWStart(iW):ixWStart(iW+1)-2);
    end
    
    % another catch in case extra separators removing is buggy ?... later :-)
    % eliminate empty words
else
    word = {};
end

end

% -----------------------------------------------------
function data = opAdjFreqData(raw_data, NoOfPorts, opt)
% -----------------------------------------------------
% intii exceptia 2-port :
if NoOfPorts == 1
    raw_data_A(1,1,:) = raw_data(:,1); raw_data_B(1,1,:) = raw_data(:,2);
elseif NoOfPorts == 2
    raw_data_A(1,1,:) = raw_data(:,1); raw_data_B(1,1,:) = raw_data(:,2);
    raw_data_A(2,1,:) = raw_data(:,3); raw_data_B(2,1,:) = raw_data(:,4);
    raw_data_A(1,2,:) = raw_data(:,5); raw_data_B(1,2,:) = raw_data(:,6);
    raw_data_A(2,2,:) = raw_data(:,7); raw_data_B(2,2,:) = raw_data(:,8);
else % --- cut nFreq square slices of size NoOfPorts
    nFreq = size(raw_data,1);
    tAB = zeros(NoOfPorts,2*NoOfPorts,nFreq);
    for i=1:nFreq
        tAB(:,:,i) = reshape(raw_data(i,:)',2*NoOfPorts, NoOfPorts)';
    end;
    raw_data_A = tAB(:,1:2:end-1,:);
    raw_data_B = tAB(:,2:2:end,:);
    clear tAB
end

% using dual-field numbers will calculate complex numbers, f(format_specifier)
j=sqrt(-1);
switch opt.format
    case 'ri'
        data = raw_data_A + j*raw_data_B;
    case 'ma'
        data = raw_data_A .* cos(raw_data_B*pi/180) + j* raw_data_A .* sin(raw_data_B*pi/180);
    case 'db'
        t_mag = 10.^(raw_data_A/20); t_ang = raw_data_B*pi/180;
        data = t_mag .* cos(t_ang) + j* t_mag .* sin(t_ang);
end
% now adjust data f(opt.param) Z,Y,G,H,A
switch opt.param
    case 'y'
        data = y2s(data*opt.Zo); % to check in standard if Zo always or Yo
    case 'z'
        data = z2s(data/opt.Zo);
    case 'a'
        data = a2s(data); % to double check units...
    case 'g'
        data = g2s(data); % ...
    case 'h'
        data = h2s(data); % ...
end
end % function !

% -----------------------------------------------------
function [freq_noise, data_noise] = opAdjNoizData(raw_data_noise, opt)
%  one line is f NFmin Gopt-Mag  Gopt-Ang  Rn
freq_noise = raw_data_noise(:,1) *opt.multiplier;   % freq
data_noise(:,1) = raw_data_noise(:,2);              % NFmin
data_noise(:,3) = raw_data_noise(:,5);              % Rn

% find GammaOpt
Tm = raw_data_noise(:,3);
Ta = raw_data_noise(:,4);
switch opt.Touchstone    
    case 'old' % is MA anyways, old style Touchstone
        Ta = Ta*pi/180;
        data_noise(:,2) = Tm .*cos(Ta) + j* Tm .*sin(Ta);        
    case 'new'
        switch opt.format % gamma opt
            case 'ri'
                data_noise(:,2) = Tm + j*Ta;
            case 'ma'
                Ta = Ta*pi/180;
                data_noise(:,2) = Tm .*cos(Ta) + j* Tm .*sin(Ta);
            case 'db'
                Tm = 10.^(Tm(:,2)/20);
                Ta = Ta*pi/180;
                data_noise(:,2) = Tm .*cos(Ta) + j* Tm .*sin(Ta);
        end
end
end

function opt = opFigureOptions(word, opt)
% ---> crude, fara protexe yet
for i = 1:size(word,2)
    thisWord = deblank(word{i});
    switch thisWord
        case {'mhz'}
            opt.multiplier = 1e6;
        case 'ghz'
            opt.multiplier = 1e9;
        case 'khz'
            opt.multiplier = 1e3;
        case 'hz'
            opt.multiplier = 1;
        case {'s','z','y','g','h','abcd'}
            opt.param = thisWord;
        case {'ri','ma','db'}
            opt.format = thisWord;
        case 'r'
            opt.Zo = str2double(deblank(word{i+1}));
    end
end
end

function dispHelp
word = strvcat(...
    ' ',...
    'format of MDIF/Touchstone/HPEESof files :',...
    '    comment line starts with ''!''',...
    '    specifier line is :',...
    '    # <freq_unit> <param> <format> R <reference resistance value>',...
    '',...
    'examples :',...
    '    -- S-par, real and imaginary -->',...
    '    #     GHz       S         RI    R 50    ',...
    '    -- Z-par, linear mag and angle <deg> -->         ',...
    '    #     MHz       Z         MA    R 75     ',...
    '    -- Y-par, log mag (dB) and angle <deg> -->         ',...
    '    #     kHz       Y         DB    R 50    ',...
    '    -- ABCD-par, real and imaginary -->         ',...
    '    #      Hz       ABCD      RI    R 50    ',...
    '',...
    ' (defaults : # MHz S MA R 50)',...
    '',...
    ' -------------------------------------------------',...
    ' format of data in file (*.s2p) is :',...
    ' f s11.1 s11.2 s21.1 s21.2 s12.1 s12.2 s22.1 s22.2',...
    ' -------------------------------------------------',...
    '',...
    ' format of data in file (*.sxp) with x>2 is :',...
    ' -------------------------------------------------',...
    ' f s11.1 s11.2 s12.1 s12.2 ... s1x.1 s1x.2',...
    '   s21.1 s21.2 s22.2 s22.2 ... s2x.1 s2x.2',...
    '   ...',...
    '   sx1.1 sx1.2 sx2.1 sx2.2 ... sxx.1 sxx.2',...
    ' -------------------------------------------------',...
    '',...
    'noise data has some HP/Touchstone legacy stuff : ', ...
    ' - noise data will start when the frequency decreases for the',...
    '   first time; otherwise frecuency is monotonically increasing ',...
    ' - Gopt is always MA, irrespective of S data format above (to change this uncomment line 98)',...
    ' - NFmin is always in <dB>, Rn is normalized', ...
    'ex.:',...
    '! freq NFmin Gopt-Mag  Gopt-Ang  Rn(norm!)',...
    '  900   1.8   0.34      135     0.2 ');
disp(word);
end