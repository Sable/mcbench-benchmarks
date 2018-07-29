function SXPWrite(freq, s, FileName, unit_adj, comment)
% SXPWrite(FREQ, S, FileName, FREQ_UNIT, COMMENT)
%
% writes multiport parameter data S to an .sxp file data 
% using the MDIF format (a.k.a. HPEEsof format); for a detailed
% description of data format see SXPParse.m
%
% FREQ is treated as Hz and adjusted by FREQ_UNIT then written to file
% FREQ_UNIT can be 'kHz', 'MHz', 'GHz' (or directly 1e-3, 1e-6, 1e-9)
% (default 1e-6, Hz -> MHz)
%
% COMMENT   - a cell of strings to be added as comments in the file header,
%             one per line in the output files; can also be one string (one line only)
%
% See also SXPParse.
%
% written by Tudor Dima, last rev. 29.05.2012, tudima@zahoo.com, change the z into y

% ver 1.42: 2012.05.29  - fix lengths to properly write long numbers in 
%                         scientific notation; new uPrintToGrid (discontinue uSXPstrfit)
%                       - accept frequency units and multi-line comments; 
%                         (new uInHandle)
% ver 1.41: 2009.09.05  - uSXPstrfit as subfunction, some cleanup

if nargin < 5, comment = ''; end
if nargin < 4, unit_adj = []; end
in = uInHandle(unit_adj, comment); %  > f_unit_str, f_unit_adj, comment

N = max(size(freq));
order = size(s,1);
if order~=1 && size(s,2) ~= order
    disp('data does not seem to be valid');
end

opt.f_digits = 8; 
opt.s_digits = 6;
opt.grid_length = 8; 
opt.grid_length_f = 12; % 3-4 tabs

fprintf(1,'\n%s', ['writing parameter data to file ' FileName '...']);

fid = fopen(FileName, 'wt');

% --- write comment line(s) ---
for iL = 1:size(in.comment, 2)
    fprintf(fid, '%s\n', ['! ' in.comment{iL}]);
end
% --- write specifier line ---
fprintf(fid, '%s\n', ['# ' in.f_unit_str ' S RI R 50']);
% ALSO! adjust frequency array
freq = freq * in.f_unit_adj;

% --- start writing the data ---
if order > 2
    opt.nLeadingTabs = round(opt.grid_length_f/4);
    for iF = 1:N % all frequencies
        for k = 1:order
            if k == 1 % on 1st row print frequency value
                uPrintToGrid(fid, freq(iF), opt.f_digits, opt.grid_length_f);
            else    % on nP-1 rows just spacers
                for iT = 1:opt.nLeadingTabs-1
                    fprintf(fid, '\t');
                end
            end
            for j = 1:order
                uPrintToGrid(fid, real(s(k,j,iF)), opt.s_digits, opt.grid_length);
                uPrintToGrid(fid, imag(s(k,j,iF)), opt.s_digits, opt.grid_length);
            end
            fprintf(fid, '\n');
        end
    end
elseif order == 2
    for i = 1:N
        % print freq, with proper spacing
        candidate = num2str(freq(i));
        fprintf(fid, '%s', candidate);
        chars2pad = opt.grid_length_f - length(candidate);
        nt = ceil(chars2pad/4); % tab is 4 spaces
        for iT = 1:nt, fprintf(fid, '\t'); end
        uPrintToGrid(fid, real(s(1,1,i)), opt.s_digits, opt.grid_length);
        uPrintToGrid(fid, imag(s(1,1,i)), opt.s_digits, opt.grid_length);
        uPrintToGrid(fid, real(s(2,1,i)), opt.s_digits, opt.grid_length);
        uPrintToGrid(fid, imag(s(2,1,i)), opt.s_digits, opt.grid_length);
        uPrintToGrid(fid, real(s(1,2,i)), opt.s_digits, opt.grid_length);
        uPrintToGrid(fid, imag(s(1,2,i)), opt.s_digits, opt.grid_length);
        uPrintToGrid(fid, real(s(2,2,i)), opt.s_digits, opt.grid_length);
        uPrintToGrid(fid, imag(s(2,2,i)), opt.s_digits, opt.grid_length);
        fprintf(fid, '\n');
    end
elseif order == 1
    for iF = 1:N
        uPrintToGrid(fid, freq(iF), opt.f_digits, opt.grid_length_f);
        uPrintToGrid(fid, real(s(iF)), opt.s_digits, opt.grid_length);
        uPrintToGrid(fid, imag(s(iF)), opt.s_digits, opt.grid_length);
        fprintf(fid, '\n');
    end
end

fclose(fid);
fprintf(1,'\n%s', '...done');

end

function uPrintToGrid(fid, s, opt_ndigits, opt_length)
candidate = num2str(s, opt_ndigits);
fprintf(fid, '%s', candidate);
% now pad with the necessary number of tabs
chars2pad = opt_length - length(candidate);
nt = ceil(chars2pad/4); % tab is 4 spaces
for iT = 1:nt
    fprintf(fid, '\t');
end
fprintf(fid, ' ');
end

function in = uInHandle(unit_adj, comment)
% returns struct in., with true cell comment, freq string&val

if isempty(unit_adj), unit_adj = 1e-6; end

if isnumeric(unit_adj)
    % constrain exponent of unit_adj to -3, -6, -9
    expu = max(min(log10(unit_adj),-3),-9); % kHz-MHz-GHz
    in.f_unit_adj =  10.^(round(expu/3)*3);
    switch unit_adj
        case 1e-6
            in.f_unit_str = 'MHz';
        case 1e-9
            in.f_unit_str = 'GHz';
        case 1e-3
            in.f_unit_str = 'kHz';
        otherwise
            in.f_unit_str = 'MHz';
            in.f_unit_adj = 1e-6;
    end
else    % a unit string
    switch lower(unit_adj)
        case 'mhz'
            in.f_unit_adj = 1e-6;
            in.f_unit_str = 'MHz';
        case 'ghz'
            in.f_unit_adj = 1e-9;
            in.f_unit_str = 'GHz';
        case 'khz'
            in.f_unit_adj = 1e-3;
            in.f_unit_str = 'kHz';
        otherwise
            in.f_unit_str = 'MHz';
            in.f_unit_adj = 1e-6;
    end
end

% handle/adjust comments

cp = 'MDIF file - written using SXPWrite.m';

if ischar(comment) % one liner, or empty
    nL = size(comment,1);
    in.comment{1} = comment;
    in.comment{nL+1} = cp;
elseif iscell(comment)
    nL = size(comment,2);
    in.comment(1:nL) = comment;
    in.comment{nL+1} = cp;
end

end