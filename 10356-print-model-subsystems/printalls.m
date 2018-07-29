function [] = printalls(a,c,b)
%
%
%     Print Simulink model as EPS-file to specified directory.
%
%     Syntax: 
%     PRINTALLS('system','output directory')
%     PRINTALLS('system','output directory','tag regexp')
%
%     Notes:
%     1) System name must be given without extension, e.g. 'MySystem'.
%     2) Output directory must exist
%     3) When output directory is '', current working directory is used
%     4) Model is scanned recursively and goes under masks
%     5) When tag regexp is specified, only those of subsystems
%        which have property 'Tag' set to some non-empty value matching
%        the regular expression are considered.
%     6) Root system is always printed.
%     7) Output filenames are generated in two ways:
%        a) When no regexp is used, it is full pathname of the subsystem
%           within the model, with slashes replaced by underscores.
%        b) With regexp specified, tag values are used as filenames.
%     8) After the printing, all subsystems are closed, root remains open.
%
%     Written by 
%     Tomas Hajek
%     tomas.hajek@st.com
%     2006
%

if nargin<2,
   % problem
   error('printalls:nargin', 'Not enough input parameters. Use ''help printalls'' to see the options.');
end

if strcmp(c,'')==1,
    c ='.';
end

% print the root system
open_system(a,'force');
print('-deps', ['-s' a], [c,'/',a]);


% print the subsystems
if nargin==2,
    % print all of them, using their names as output filenames
    subsys=find_system(a,'RegExp','On','LookUnderMasks','All','BlockType','SubSystem');
    for i=1:length(subsys),
        tag = subsys{i};
        open_system(subsys{i},'force');
        print('-deps', ['-s' subsys{i}], [c,'/',strrep(tag,'/','_')]);
        close_system(subsys{i});
    end
else
    % print only tagged ones, using the Tag values as output filenames
    subsys=find_system(a,'RegExp','On','LookUnderMasks','All','BlockType','SubSystem','Tag',b);
    for i=1:length(subsys),
        tag = get_param(subsys{i}, 'Tag');
        open_system(subsys{i},'force');
        print('-deps', ['-s' subsys{i}], [c,'/',tag]);
        close_system(subsys{i});
    end
end

end
