%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  out.m           1993-12-28  %       FORMATED OUTPUT OF MATRICES 
%%    (c)           M. Balda    %          updated on 2005-12-18
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%          updated on 2006-02-10
%
% The function out.m outputs its first argument to screen or a file in a
% default or required format. The argument can be either empty or a string,
% integer, real or complex numbers or matrices. The format can be either
% user defined or from a previous call of the function, or a default one.
%
% Prerequisity:
% ~~~~~~~~~~~~~
%   function inp.m from  http://www.mathworks.com/matlabcentral/
%
% Forms of calls:
% ~~~~~~~~~~~~~~
%
%   out;        %   Clear the format and close output file if any
%
%   out(arg);   %   Display arg in formats '%s or '%e' or '%d' 
%               %   or any other used in the last call of out.m
%       arg   = an argument 
%
%   out(arg,form);      %   Display arg in the format form
%       form  = required format of the output (see help to fprintf).
%               A format for complex numbers is generated internally using
%               format for real numbers,
%       fid   = file identifier - handle of the output file
%
%   out(arg,fid);       %   Append arg to the open file of fid handle
%
%   fid = out(arg,form,fname);  % Open file, get handle fid, and write arg 
%       fname = name of output file
%       fid   = handle of the file if successfully opened,
%              -1 if not opened,
%               0 if closed.
%
%   out(arg,form,fid);  %   Append arg to fid file
%
% Examples:
% ~~~~~~~~
%  out(rand(2,3));              % display matrix in the '%15.6e' format
%  Z = rand(3,2)+i*rand(3,2);   % create complex matrix Z
%  h = out(Z,'','cmplxZ.dat');  % write Z in '%15.6e' format to the file
%  out('','%s\n',h);            % append new line into the file
%  out(Z,'%8.4f',h);            % append Z once more in '%8.4f' format
%  out;                         % close the file 'cmplxZ.dat'
%  lf = char(10);               % new line character
%  out(['This is a string' lf]);% display a string ending with new line
%  out(1:5,'%4i\n');            % display a column of integers
%  out(char('='*ones(1,50)),'%s\n');% display a line of 50 characters '='
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function fid = out(arg,form,fname)
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
persistent fid_ frm_ 

if nargin<1                     %   Close file & return
    fid = 0;
    if ~isempty(fid_) && fid_~=1
        fid  = fclose(fid_); 
    end
    frm_ = [];
    return
end

%                               %   Format test & reconstruction
S = isempty(findstr('s',frm_));
if (ischar(arg) && S) || (isnumeric(arg) && ~S)
    frm_ = []; 
end

%                               %   OUTPUT DESTINATION
fid_ = 1;                       %   screen
if nargin>2                     %   write in a file?
    if ischar(fname)             %   file name
        if exist(fname,'file')
            if strcmp(inp(['Overwrite ' fname '?'],'no'),'no')
                fid=-1; 
                return          %   without overwriting
            end
        end
        fid_ = fopen(fname, 'w+');% open file
        fid  = fid_;
        if fid_<0, return, end
    else
        if isreal(fname)        %   file identifier
            fid_ = fname;
        end
    end
end

%                               %   OUTPUT FORMAT
if nargin>1
    if isempty(form)
        frm_ = [];
    elseif ischar(form)          %   format
        if isnumeric(arg)       %   for numeric arg
            if isempty(findstr(form,'-') + findstr(form,'+'))
                frmR_ = ['% ' form(2:end)]; %   real
                frmI_ = ['%+' form(2:end)]; %   imag
            else
                frmR_ = ['% ' form(3:end)]; %   real
                frmI_ = ['%+' form(3:end)]; %   imag
            end
            if ~isreal(arg)
                frm_ = [frmR_ frmI_ 'i  '];  %  complex
            else
                frm_ = frmR_;
            end
        else
            frm_ = form;        %   for string arg
        end
    else
        fid_ = form;            %   file identifier
    end
end

if isempty(frm_)
    if ischar(arg),        frm_ = '%s  '; 
    elseif isinteger(arg), frm_ = '% d  ';
    elseif isreal(arg),    frm_ = '% e  ';
    else                   frm_ = '% e %+ei  ';
    end
end
%   disp({arg, frm_, fid_})


%                               %   OUTPUT arg
if ischar(arg)
    fprintf(fid_,frm_,arg);     %   text argument
else
    [m,n] = size(arg);
    if isreal(arg)              %   integer or real arg
        for k = 1:m
            for j = 1:n
                fprintf(fid_, frm_, arg(k,j));
            end
            fprintf(fid_,'\n');
        end
    else                        %   complex arg
        for k = 1:m
            Rc = real(arg(k,:));
            Ic = imag(arg(k,:));
            for j = 1:n
                fprintf(fid_, frm_, Rc(j), Ic(j));
            end
            fprintf(fid_,'\n');
        end
    end
end
fid = fid_;
