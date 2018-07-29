function out = tasklist(extended)
% out = tasklist([extended])
%
% Read the current tasklist (-> TaskManager), only for Windows XP!!!
% 
% 
% The list is returned with the fields
% 	.name                       Name of process
% 	.pid                        Process ID (PID)
% 	.session                    Session ID
% 	.session_no                 Number of Session
% 	.ram                        Memory used by process (string)
%  .status (extended)          
%	.user (extended)            
%	.cpu_time (extended)        
%  .window_title (extended)    

% extended=1: extended Tasklist (~10x slower than non extended).

    if nargin==0; extended=0; end
    username=getenv('USERNAME');

    if ~ispc; error('tasklist works only under Windows XP'); end

    if extended;    [status, task]=dos('tasklist /fo "csv" /nh /v');
    else            [status, task]=dos('tasklist /fo "csv" /nh');
    end
    
    if status; disp('Error reading tasklist. Tasklist will only work on Windows XP !!!'); return; end

    task=strread(task,'%s','whitespace','\n');
    for i=1:length(task)
        str=regexprep(task{i}(2:end-1), '","', '; ');
        str=regexprep(str, '; ;', ';_;');
        str = strread(str,'%s','whitespace',';');
        out(i).name = str{1};
        out(i).pid = str2num(str{2});
        out(i).session = str{3};
        out(i).session_no = str2num(str{4});
        out(i).ram = str{5};
        
        % Only needed for extended task-information
        if extended
            out(i).status = str{6};
            out(i).user = str{7};
            out(i).cpu_time = str{8};
            out(i).window_title = str{9};
        end
    end

