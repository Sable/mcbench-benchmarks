function s = make_sa_input(sarr,arrname)

% s = make_sa_input(sarr,arrname)
%
% Usage:
% s = make_sa_input(sarr,arrname) converts the input array of 
% structs 'sarr' to a cell array of strings that can be printed to 
% file and then be used as part of a matlab script.
% The name of the generated array definition is given in 'arrname'.
% Calling make_sa_input with no output arguments displays the
% generated structure in the matlab command window.
%
% Limitations:
% sarr must be 1D (i.e. 1xN or Nx1).
% Each field of sarr must be either a string, a 1D numeric array, 
% or a 1D cell array of strings.
%
% example:
%
%   a(1).xx = 'cars';
%   a(1).yy = { 'porsche' 'bmw' 'mercedes' };
%   a(1).zz = [ 1 2 pi 4];
%   a(2).xx = 'flowers';
%   a(2).yy = {'tulips' 'roses'};
%   a(2).zz = [ 1 0 0 1 0];
%   make_sa_input(a,'array')
%
% yields (printed in the command window)
%
%   n = 1
%   array(n).xx = 'cars';
%   array(n).yy = { 'porsche' 'bmw' 'mercedes' };
%   array(n).zz = [ 1 2 3.1416 4 ];
%
%   n = n+1;
%   array(n).xx = 'flowers';
%   array(n).yy = { 'tulips' 'roses' };
%   array(n).zz = [ 1 0 0 1 0 ];

% Magnus Sundberg (msu@telia.com), 2001-09-13

if min(size(sarr)) > 1
    error('make_sa_input handles only 1D arrays of structs');
end

num_structs = length(sarr);

names = fieldnames(sarr);
num_names = length(names);

s = {}; k = 1; 
s{k} = 'n = 1'; k = k+1;
for n = 1:num_structs
    for m = 1:num_names
        sline = [arrname '(n).' names{m} ' = '];
        val = getfield(sarr(n),names{m});
        num_val = length(val);
        if ischar(val)
            sline = [sline '''' val ''';'];
        elseif isnumeric(val)
            if num_val > 1, sline = [sline '[']; end
            for p = 1:length(val), sline = [sline ' ' num2str(val(p))]; end
            if num_val > 1, sline = [sline ' ]']; end
            sline = [sline ';'];
        elseif iscellstr(val)
            if num_val > 1, sline = [sline '{']; end
            for p = 1:length(val), sline = [sline ' ' '''' val{p} '''']; end
            if num_val > 1, sline = [sline ' }']; end
            sline = [sline ';'];
        else
            error(['each field must be either a string, a 1D numeric array '...
                    'or a 1D cell array of strings']);
        end
        s{k} = sline; k = k+1;
    end
    if n < num_structs
        s{k} = ' '; k = k+1;
        s{k} = 'n = n+1;'; k = k+1;
    end    
end

s = s.';

if nargout == 0
    disp(' ')
    for k = 1:length(s)
        disp(s{k})
    end
    disp(' ')
    clear s
end

