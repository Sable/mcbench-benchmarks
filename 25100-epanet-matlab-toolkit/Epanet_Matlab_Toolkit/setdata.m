function [errorcode] = setdata(code, value, id)
%SETDATA - Sets the coefficiends of certain parameters in the network
%
% Syntax:  [errorcode] = setdata(code, value, id)
%
% Inputs:
%    code   - the code according to EPANET specifications
%    value  - the value to be set
%    id     - the id the the item to be set

%
% Outputs:
%    errorcode - Fault code according to EPANET.
%
% Example: 
%    [errorcode] = setdata('EN_KBULK',-0.5) 
%           set bulk reaction rate with -0.5
%    [errorcode] = setdata('SET_PATTERN', [1,1.1,1.2,1.3], 2);
%           set pattern with id=2 as [1,1.1,1.2,1.3]

% Original version
% Author: Philip Jonkergouw
% Email:  pjonkergouw@gmail.com
% Date:   July 2007

% Modified by
% Author: Demetrios Eliades
% University of Cyprus, KIOS Research Center for Intelligent Systems and Networks
% email: eldemet@gmail.com
% Website: http://eldemet.wordpress.com
% August 2009; Last revision: 21-August-2009

%------------- BEGIN CODE --------------



% Initialise a few variables ...
code = upper(code);
errorcode = 0;
if (nargin < 3) id = []; end

s= 'SET_PATTERN';
if ~isempty(findstr(s, code))
    patternpointer = libpointer('singlePtr',value);
    lengthpattern=length(value);
    [errorcode]=calllib('epanet2','ENsetpattern',id,patternpointer,lengthpattern);
    return
end


s = 'EN_DURATIONEN_HYDSTEPEN_QUALSTEPEN_PATTERNSTEPEN_PATTERNSTARTEN_REPORTSTEPEN_REPORTSTARTEN_RULESTEPEN_STATISTIC';
if ~isempty(findstr(s, code))
    epanetcode = getenconstant(code);
    [errorcode]=calllib('epanet2','ENsettimeparam', epanetcode , value);
    return
end


location = 'node';
s='EN_DIAMETEREN_LENGTHEN_ROUGHNESSEN_MINORLOSSEN_INITSTATUSEN_INITSETTINGEN_KBULKEN_KWALLEN_STATUSEN_SETTING';
if ~isempty(findstr(s, code))
    location = 'link';
end

s= 'SET_CONTROLS'; %setdata('SET_CONTROLS',{'EN_LOWLEVEL','P110','OPEN',14,'T1'},7) %setdata('SET_CONTROLS',{'EN_TIMER','10','OPEN',20000})
if ~isempty(findstr(s, code))
    if (nargin < 3)
        % to use the last control rule (EPANET cannot add rules!!!)
        lc=getdata('EN_CONTROLCOUNT');
        cindex=lc;
    end
    ctype=getenconstant(value{1})
    lindex=0
    [errorcode, value{2}, lindex] = calllib('epanet2', 'ENgetlinkindex', value{2}, lindex)
    
    setting=value{3}; % numerical 
    if value{3}=='OPEN'
        setting=1;
    elseif value{3}=='CLOSED'
        setting=0;
    end
    nindex=0;
    level=value{4};
    if ctype<2
        nindex=0
        [errorcode, value{5}, nindex] = calllib('epanet2', 'ENgetlinkindex', value{5}, nindex)
    end
    setting=single(setting);level=single(level);nindex=int32(nindex);ctype=int32(ctype);
    [errorcode]=calllib('epanet2','ENsetcontrol',cindex, ctype, lindex, setting, nindex, level);
    return
end


% Retrieve the indices ...
nlocations = length(id);
if ~nlocations
    % Retrieve data for all nodes/links
    countcode = getenconstant(['EN_', upper(location), 'COUNT']);
    [errorcode, nlocations] = calllib('epanet2', 'ENgetcount', countcode, nlocations);
    if (errorcode)
        fprintf(['Problem retrieving number of ', location, 's.\n']);
        [errorcode] = calllib('epanet2', 'ENclose');
        unloadlibrary('epanet2');
        return;
    end
    nlocations = double(nlocations);
    index = 1:nlocations;
else
    getindexfunc = ['ENget', location, 'index'];
    for n = 1:nlocations
        index(1,n) = 0;
        [errorcode, id{n}, index(1,n)] = calllib('epanet2', getindexfunc, id{n}, index(1,n));
        if (errorcode)
            fprintf(['Problem retrieving index for ', location, ' ''', id{n}, '''.\n']);
            [errorcode] = calllib('epanet2', 'ENclose');
            unloadlibrary('epanet2');
            return;
        end
    end
end


s='EN_DIAMETEREN_LENGTHEN_ROUGHNESSEN_MINORLOSSEN_INITSTATUSEN_INITSETTINGEN_KBULKEN_KWALLEN_STATUSEN_SETTING';
if ~isempty(findstr(s, code))
    epanetcode = getenconstant(code);
    if length(index)==length(value)
        for i=1:length(index)
            [errorcode]=calllib('epanet2','ENsetlinkvalue', index(i) ,epanetcode, value(i));
        end
    elseif length(value)==1
        for i=1:length(index)
            [errorcode]=calllib('epanet2','ENsetlinkvalue', index(i) ,epanetcode, value);
        end
    else
        disp('ENsetlinkvalue: Index and value dimensions do not match')
    end
    return
end

if ~isempty(findstr(s, code))
    epanetcode = getenconstant(code);
    [errorcode]=calllib('epanet2','ENsetlinkvalue', index , epanetcode ,value);
    return
end


s='EN_ELEVATIONEN_BASEDEMANDEN_PATTERNEN_EMITTEREN_INITQUALEN_SOURCEQUALEN_SOURCEPATEN_SOURCETYPEEN_TANKLEVEL';
if ~isempty(findstr(s, code))
    epanetcode = getenconstant(code);
    if length(index)==length(value)
        for i=1:length(index)
            [errorcode]=calllib('epanet2','ENsetnodevalue', index(i) ,epanetcode, value(i));
        end
    elseif length(value)==1
        for i=1:length(index)
            [errorcode]=calllib('epanet2','ENsetnodevalue', index(i) ,epanetcode, value);
        end
    else
        disp('ENsetnodevalue: Index and value dimensions do not match');
    end
    return
end


%------------- END OF CODE --------------
%Please send suggestions for improvement of the above code 
%to Demetrios Eliades at this email address: eldemet@gmail.com.
