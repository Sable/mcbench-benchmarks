% findInstrument - Finds an instrument by model name, vendor name or VISA resource
%   
%    obj = findInstrument('STR') returns an interface object to an
%       instrument whose model name, vendor name or VISA resource matches
%       any part of the string STR. If there is no unique match, obj is []
%       and a list of available instruments is displayed.
%
%       findInstrument currently only works with USB and GPIB instruments
%       and requires a VISA adaptor.  
%
%       STR is first compared to the model and vendor names. If none of
%       these match, STR is then compared to the VISA resource names. The
%       matching ignores the case of the strings (i.e., upper/lower case) 
%
%    obj = findInstrument('STR', 'ADAPTOR') uses the specified VISA
%       adaptor. This is only applicable if you have multiple VISA
%       installations (by default, findInstrument picks one of the VISA
%       adaptors). 
%
%    Examples:
%      % see a list of all the available instruments
%      findInstrument;
%          
%      % find an instrument by model number 
%      obj = findInstrument('34405');
%      fopen(obj)
%      query(obj,'*IDN?')
%      fclose(obj)
%
%      % find an instrument by model number, using Agilent VISA 
%      obj = findInstrument('34405', 'agilent');
%
%      % find an instrument by matching a manufacturer name
%      obj = findInstrument('tek');
%
%      % find an instrument by the model code in the VISA resource
%      obj = findInstrument('0x0618')
%
%    If your instrument doesn't show up with findInstrument, use 
%    this <a href="matlab:findInstrument('##troubleshoot')">Troubleshooting checklist</a>
%
%   Related Functions:  
%     <a href="matlab:help instrfindall">instrfindall</a> (Find existing interface objects)
%     <a href="matlab:help instrreset">instrreset</a>   (Close and delete all interface objects)
%     <a href="matlab:help instrument/obj2mfile">obj2mfile</a>    (Generate MATLAB code for re-creating an interface object)

% Copyright 2009, The MathWorks, Inc.

function out = findInstrument(searchstr, adaptor)

if exist('instrhwinfo', 'file') ~= 2
    error('This function requires Instrument Control Toolbox');
end

if ~exist('searchstr', 'var')
    searchstr = '';
end
searchstr = strtrim(lower(searchstr));

if strcmp(searchstr, '##troubleshoot')
    helpstr = troubleshootHelp;
    disp(helpstr);
    return;
end

visainfo = instrhwinfo('visa');

if numel(visainfo.InstalledAdaptors) == 0
    error('No VISA adaptors found\n');
end

if ~exist('adaptor', 'var')
    adaptor = visainfo.InstalledAdaptors{end};
end

try
    instr = instrhwinfo('visa', adaptor);
catch %#ok<CTCH>
    error('VISA Adaptor ''%s'' is not installed on this system', adaptor);
end

out = [];

%% Scan over all the instruments returned by the VISA adaptor
% For each instrument: match its VISA resource; try to get its
% ID string; match its vendor or model name 

info = []; cnt = 0;  
for j=1:numel(instr.ObjectConstructorName)
    constructor = instr.ObjectConstructorName{j};
    
    res = regexpi(constructor, '[a-z]*\(''[a-z]+''[ ]*,[ ]*''(?<resource>[A-Z0-9:]+)''', 'names');
    if (numel(res) == 0) || strcmpi(res.resource(1:4),'ASRL')
        % serial port, ignore
        continue;
    end
    
    cnt = cnt + 1;
    info(cnt).resource = res.resource; %#ok<*AGROW>
    info(cnt).constructor = constructor;    
    info(cnt).resourceMatched = ~isempty(findstr(searchstr, lower(res.resource)));
    info(cnt).idMatched = false;
    
    obj = eval(constructor);    
    
    % visa resource strings have "::". For ICT objects, this is replaced
    % by "-". Get the ICT resource name so that we can search for other
    % interface objects for the same resource
    info(cnt).ICT_resource = get(obj, 'RsrcName');
    
    try
        fopen(obj);
        idString = query(obj, '*IDN?');
        fclose(obj);
        delete(obj);        
        info(cnt).connectStatus = true;
    catch %#ok<CTCH>
        % open failed, probably because the connection is already
        % open from within MATLAB or another program        
        delete(obj);
        info(cnt).connectStatus = false;
        continue;
    end    
    
    % idString will have the following format
    %   <manufacturer>, <model name>, <serial number>, <firmware revision>
    % we only care about manufacturer and model name
    strs = regexp(idString, '[ ]*,[ ]*', 'split');
    if numel(strs) < 4
        strs{4} = '';
    end    
    id.vendor = strs{1};
    id.model = strs{2};
        
    modelMatched = ~isempty(findstr(searchstr, lower(id.model)));
    vendorMatched = ~isempty(findstr(searchstr, lower(id.vendor)));
    info(cnt).idMatched = modelMatched || vendorMatched;
    
    info(cnt).id = id;
end % loop over each instrument

if numel(info) == 0
    out = [];
    fprintf('No USB or GPIB instruments found using ''%s'' VISA\n', adaptor);
    return;
end

%% Collate the match information. 
% Only create an interface object if there is a unique match

idMatches = find( [info.idMatched] );
numIdMatches = numel(idMatches);

resourceMatches = find( [info.resourceMatched] );
numResourceMatches = numel(resourceMatches);

if numIdMatches == 1
    % A match to vendor or model supersedes any VISA resource matches
    % i.e., from the user's perspective, we'll only examine resource
    % strings if there is no vendor or model match    
    idx = idMatches(1);    
    if ~isempty(instrfindall('RsrcName', info(idx).ICT_resource))
        warning('findInstrument:MultipleInterfaceObjects', ...
            'Preexisting interface objects for ''%s''', info(idx).resource);        
    end
    out = eval(info(idx).constructor);

elseif numIdMatches > 1
    out = [];
    fprintf('%d instruments matched ''%s''\n\n', numIdMatches, searchstr);
    showInstrumentInfo(info, idMatches);    
    noConn = find([info.connectStatus] == false);
    
    if numel(noConn) > 0
        fprintf('%d instrument(s) could not be reached\n\n', numel(noConn));
        showInstrumentInfo(info, noConn);
    end
    
elseif numIdMatches == 0 && numResourceMatches == 1
    idx = resourceMatches(1);
    if info(idx).connectStatus == false
        out = [];
        fprintf('One instrument matched ''%s'' (VISA resource), but it cannot be reached\n\n', searchstr);
        showInstrumentInfo(info, idx);
        return;
    end    
    if ~isempty(instrfindall('RsrcName', info(idx).ICT_resource))
        warning('findInstrument:MultipleInterfaceObjects', ...
            'Preexisting interface objects for ''%s''', info(idx).resource);        
    end
    out = eval(info(idx).constructor);
    
elseif numIdMatches == 0 && numResourceMatches > 0
    out = [];
    fprintf('%d instrument(s) matched ''%s'' (VISA Resource)\n\n', numResourceMatches, searchstr);    
    showInstrumentInfo(info, resourceMatches);
    
elseif numIdMatches == 0 && numResourceMatches == 0
    out = [];
    fprintf('No instruments matched ''%s''. Available instruments:\n\n', searchstr);    
    showInstrumentInfo(info, 1:numel(info));
    
end
    

end

%%
    function showInstrumentInfo(info, indexList)
        for i=1:numel(indexList)
            idx = indexList(i);
            fprintf('  VISA Resource: %s\n', info(idx).resource);
            if info(idx).connectStatus == false
                fprintf('         Unable to connect (instrument may be in use)\n');
            else
                id = info(idx).id;
                fprintf('         Vendor: %s\n', id.vendor);
                fprintf('          Model: %s\n', id.model);               
            end
            fprintf('\n');
        end    
    end

 %%
    function out = troubleshootHelp
s = {    
'    Troubleshooting:'
'      If your instrument doesn''t show up with findInstrument, use the '
'      following checklist:'
''
'      1) Is the instrument turned on and connected to your computer?'
''
'      2) Check if you have multiple VISAs installed, by typing:'
'            instrhwinfo(''visa'')'
'         If you do have multiple VISAs, explicitly specify the VISA adaptor'
'            obj = findInstrument(''34405'', ''agilent'');'
'            obj = findInstrument(''34405'', ''ni'');'
''
'      3) Does any other program have an open connection to the instrument?'
'         If yes, close that program and try again.'
''
'      4) Do you have an open connection to the instrument from MATLAB?'
'         You can verify this by typing ''instrfindall'' at the command line.'
'         Type ''instrreset'' to close and delete the existing connections'
''
'      5) If the problem persists,'
'         - type ''instrreset'' at the MATLAB command line'
'         - unplug the instrument from the PC,'
'         - wait a few seconds, and'
'         - plug the instrument back in'
};
out = char(s);
    end
    
    
% Format of a VISA resource string
% GPIB[board]::primary address[::GPIB secondary address][::INSTR]
% USB[board]::manufacturer-id::model-id::serial #[::USB interface #][::INSTR]
%
% Examples
% USB0::0x0957::0x0588::CN49140544::INSTR
% USB0::0x0957::0x0618::TW46000285::INSTR
% GPIB0::24::INSTR

% Format of an identification string returned by an instrument
% <manufacturer>, <model name>, <serial number>, <firmware revision>
%
% -- Examples
% Agilent Technologies,33210A,MY48000278,1.03-1.02-26-2 
% Agilent Technologies,34405A,TW46000285,1.40-3.08
% Agilent Technologies,DSO1014A,CN49140544,00.04.02
% HEWLETT-PACKARD,E3631A,0,2.1-5.0-1.0
% HEWLETT-PACKARD,33120A,0,2.0-2.0-1.0 
% TEKTRONIX,TDS 210,0,CF:91.1CT FV:v2.03 TDS2MM:MMV:v1.04
% TEKTRONIX,TDS 3034B,0,CF:91.1CT FV:v3.41 TDS3FFT:v1.00 TDS3TRG:v 1.00
% TEKTRONIX,TDS 3034C,0,CF:91.1CT FV:v4.01 TDS3FFT:v1.00 TDS3TRG:v1.00
% KEITHLEY INSTRUMENTS INC.,MODEL 2701,1216866,A09 /A02
% *IDN LECROY,9354AL,935408135,07.3.0
% *IDN LECROY, WM8300, WAVEMASTER00112,0.5.0 n
