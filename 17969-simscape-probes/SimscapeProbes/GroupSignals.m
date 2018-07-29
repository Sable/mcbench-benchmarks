% MATLAB function to group signals when using the Simscape Probes
% Author: Tom Egel, Applications Engineer, The MathWorks
% Date: 18-Sep-2009
% Updated: 11-Mar-2010: Added ('LookUnderMasks', 'all') to find masked subsystems
% Updated: 21-Jun-2011: Added Signal Logging and support for placing inside
% subsystems
% Copyright 2009-2013, The MathWorks, Inc.
%
function varargout = GroupSignals(varargin)
% GroupSignals  

%  Callback for pushbutton
    function pb_Callback(hObject,eventdata,lbh,fh)
        idx=get(lbh, 'Value');
        sigs=get(lbh, 'String');
        selectedSigs=sigs(idx);

        % Add subsystem 
        p=get_param(gcb,'Position');
        hSubsys = add_block('built-in/Subsystem' , [gcs '/sscSignals'],...
            'MakeNameUnique', 'on', 'Position', [p(1) p(2)+50 p(3)+50 p(4)+75+length(idx)*10]);
        scopeFullPath = [get(hSubsys, 'Path') '/' get(hSubsys, 'Name')];
        close(fh); 
        % Add From and Outport blocks
        for i=1:length(selectedSigs)
            % Add From blocks
            hFromblock = add_block('built-in/From', [scopeFullPath '/From'],...
                'MakeNameUnique', 'on','Position', [20   10+(i-1)*60   110   30+(i-1)*60]);
            set_param(hFromblock,'GotoTag', selectedSigs{i});
            % Enable Signal Logging
            fromBlock=getfullname(hFromblock);
            op=get_param(fromBlock,'PortHandles');
            set_param(op.Outport(1),'DataLogging','on');
            % Add Out blocks
            fName = get(hFromblock, 'Name');
            hOutblock = add_block('built-in/Outport', [scopeFullPath '/Out'],...
                'MakeNameUnique', 'on','Position', [200  10+(i-1)*60  250  30+(i-1)*60]);
            set_param(hOutblock,'Name', selectedSigs{i}); 
            oName = get(hOutblock, 'Name');
            add_line(scopeFullPath, [fName, '/1'], [oName, '/1'],'autorouting','on');
        end
        % Add Simulink Scope
        hScope=add_block('built-in/Scope', [gcs '/Scope'], 'MakeNameUnique',...
            'on', 'Position', [p(1)+200, p(2)+50 p(3)+200 p(4)+75+length(idx)*10]);
        set_param(hScope, 'NumInputPorts', num2str(length(idx)), 'LimitDataPoints', 'off')
        subsysName = get(hSubsys, 'Name');
        scopeName = get(hScope, 'Name');
        for i=1:length(idx)
            hLine(i)=add_line(gcs, [subsysName, '/', num2str(i)], [scopeName,...
                '/', num2str(i)], 'autorouting','on');
            set_param(hLine(i), 'Name', selectedSigs{i});
        end
    end


%  Create signal list to display in GUI
sigList=get_param([find_system(bdroot(gcs), 'regexp', 'on', 'LookUnderMasks', 'all',...
    'GotoTag', '.','BlockType', 'Goto','TagVisibility','global')], 'GotoTag');
% Create figure
fh = figure('Name','GroupSignals','Menubar','none','Resize','off',...
            'NumberTitle','off','Position',[100,100,200,500]);
% Create Panel
% ph = uipanel('Title','Select signals to group','FontSize',12,...
%              'resize', 'on','Position',[100,100,200,500]);
% Create Text
th = uicontrol(fh,'Style','text',...
                'String','Select signals to group',...
                'Position',[20 460 150 20]);
% Create Listbox
lbh = uicontrol(fh,'Style','listbox',...
                'String',sigList,'Max',2,'Min',0,...
                'Position',[10 50 180 400]);
% Create Pushbutton
pbh = uicontrol(fh,'Style','pushbutton','String','Create Group',...
                 'Position',[10 10 180 30],'Callback',{@pb_Callback,lbh,fh});

end