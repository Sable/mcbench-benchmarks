function out = pslist(process, ignorecase)
% out = pslist([process], [ignorecase])
%
% Read the current tasklist (-> TaskManager)
% The list is returned with the fields
%               WINDOWS & LINUX
% 	.name                       Name of process
% 	.pid                        Process ID (PID)
%   .cpu_time
%               WINDOWS ONLY
%   .priority                   
%   .thread
%   .handle
%   .priv                       ?
%   .elapsed_time
%               LINUX ONLY
%   .TTY
%
% - Only for Windows NT or higher!!!
% - pslist.exe needs to be in the same directory with this file !!!
% - If process (p_name or pid) is specified, only the info for this process
%   is retrieved. 
% - Case-sensitivity of pslist is controled with 'ignorecase' (standard=1),
%   i.e. (pslist('matlab.exe') == pslist('MATLAB.exe')) ?!?
% - The '.exe' extension is ignored so pslist('MATLAB.exe') and pslist('MATLAB') 
%   will look for the same processes.
% - pslist strips the '.exe'-extension from processes, i.e. if you look for
%   out=pslist('MATLAB.exe') the resulting output-structure will contain the
%   field 'out(xyz).name = MATLAB' without the extension '.exe' !!!
% 

    if nargin==0; process=''; end
    if nargin<2; ignorecase=1; end
    
    if ispc && isstr(process) && length(process)>3 && strcmpi(process(end-3:end),'.exe'); process=process(1:end-4); end
    
    if ispc
        [path, dummy, dummy, dummy] = fileparts(which('pslist.m'));
        [status, task]=dos([path '\pslist ' num2str(process)]);
        if status
            disp('Error reading tasklist.')
            disp(' ')
            disp('1) Check if you have downloaded pslist.exe  ->  http://www.sysinternals.com/Utilities/PsList.html')
            disp('2) Check if pslist.exe is in the same folder with pslist.m')
            return
        end
        
    elseif isunix
        fmt = ' -o comm,pid,pri,time';
        if isempty(process); [status, task]=unix(['ps -A' fmt]);
        elseif isnumeric(process); [status, task]=unix(['ps -p ' num2str(process) fmt]);
        elseif isstr(process); [status, task]=unix(['ps -C ' process fmt]);
        end
        
    else
        error('pslist is only supported under Windows and Linux !')
    end
    
    if status; out=[]; return; end                  % task was not found

    task=strread(task,'%s','whitespace','\n');
    if ispc; task(1:5)=[];                          % remove Windows header
    else; task(1)=[]; end                           % remove Linux header
    
    for i=1:length(task)
        str = strread(task{i},'%s','whitespace',' ');
        if ispc
            out(i).name = str{1};
            out(i).pid = str2num(str{2});
            out(i).priority = str2num(str{3});
            out(i).thread = str2num(str{4});
            out(i).handle = str2num(str{5});
            out(i).priv = str2num(str{6});
            out(i).cpu_time = str{7};
            out(i).elapsed_time = str{8};
        else
            out(i).name = str{1};
            out(i).pid = str2num(str{2});
            out(i).priority = str{3};
            out(i).cpu_time = str{4};
        end
    end

    if ispc
        % Removing non matching cases (eg. process='cmd', task='CmdLi')
        if isstr(process) && ~isempty(process)
            for i=length(out):-1:1
                if ignorecase; if ~strcmpi(out(i).name, process); out(i)=[]; end;
                else; if ~strcmp(out(i).name, process); out(i)=[]; end
                end
            end
            % pslist starts a short cmd-process, which is removed to avoid confusion !!!
            if ignorecase; if strcmpi(process,'cmd'); out(end)=[]; end      
            else; if strcmp(process,'cmd'); out(end)=[]; end
            end
        end
    end
    
    
    
    
