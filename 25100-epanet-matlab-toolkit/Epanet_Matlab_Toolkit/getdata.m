function [x, t] = getdata(code, id)
%SETDATA - Sets the coefficiends of certain parameters in the network
%
% Syntax:  [x, t] = getdata(code, id)
%
% Inputs:
%    code   - the code according to EPANET specifications
%    id     - the id the the item to be set

%
% Outputs:
%    x - Resulting Time series
%    t - Time-step
%
% Example: 
%    x = getdata('EN_PATCOUNT'); 
%       returns number of patterns
%    [x,t] = getdata('EN_DEMAND');
%       returns the demands for each time step and the time step


% Original version
% Author: Philip Jonkergouw
% Email:  pjonkergouw@gmail.com
% Date:   July 2007

% Minor changes by
% Author: Demetrios Eliades
% University of Cyprus, KIOS Research Center for Intelligent Systems and Networks
% email: eldemet@gmail.com
% Website: http://eldemet.wordpress.com
% August 2009; Last revision: 21-August-2009

%------------- BEGIN CODE --------------


% Initialise a few variables ...
code = upper(code);
errorcode = 0;
x = []; t = [];
if (nargin < 2) id = []; end

% Find out what is required ...

% Static node value?
s = 'EN_ELEVATIONEN_BASEDEMANDEN_PATTERNEN_EMITTEREN_INITQUALEN_SOURCEQUALEN_SOURCEPATEN_SOURCETYPEEN_TANKLEVEL';
if ~isempty(findstr(s, code))
    isstatic = 1;
    location = 'node';
end

% Dynamic node value?
s = 'EN_DEMANDEN_HEADEN_PRESSUREEN_QUALITYEN_SOURCEMASS';
if ~isempty(findstr(s, code))
    isstatic = 0;
    location = 'node';
end

% Static link value?
s = 'EN_DIAMETEREN_LENGTHEN_ROUGHNESSEN_MINORLOSSEN_INITSTATUSEN_INITSETTINGEN_KBULKEN_KWALL';
if ~isempty(findstr(s, code))
    isstatic = 1;
    location = 'link';
end

% Dynamic link value?
s = 'EN_FLOWEN_VELOCITYEN_HEADLOSSEN_STATUSEN_SETTINGEN_ENERGY';
if ~isempty(findstr(s, code))
    isstatic = 0;
    location = 'link';
end


%Code insertd by Demetris Eliades 7/8/07
s='EN_NODECOUNTEN_TANKCOUNTEN_LINKCOUNTEN_PATCOUNTEN_CURVECOUNTEN_CONTROLCOUNT';
if ~isempty(findstr(s, code))
    countcode = getenconstant(code);
    countpointer = libpointer('int32Ptr',0);
    calllib('epanet2','ENgetcount', countcode , countpointer);
    x=get(countpointer,'Value');
    return
end


% Water quality data?
ishydraulic = 1;
if strcmp(code, 'EN_QUALITY') ishydraulic = 0; end

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

getvaluefunc = ['ENget', location, 'value'];
% Obtain correct epanet code ...
epanetcode = getenconstant(code);

if isstatic
    % Static output required. No need to run simulation ...
    for n = 1:nlocations
        x(n) = 0;
        [errorcode, x(n)] = calllib('epanet2', getvaluefunc, index(n), epanetcode, x(n));
        if (errorcode)
            s = '                   ';
            getidfunc = ['ENget', location, 'id'];
            [errorcode, s] = calllib('epanet2', getidfunc, index(n), s);
            if (errorcode)
                fprintf(['Problem retrieving value for ', location, ' ''', x(n), ''' (index).\n']);
            else
                fprintf(['Problem retrieving value for ', location, ' ''', s, '''(id).\n']);
            end
            [errorcode] = calllib('epanet2', 'ENclose');
            unloadlibrary('epanet2');
            return;
        end
    end
else
    % Non-static output required. Run simulation ...
    nextfunc = 'ENnextH';
    initflag = 11;
    enflag = 'H';
    if ~ishydraulic
        enflag = 'Q';
        nextfunc = 'ENstepQ';
        % Solve hydraulics prior to running WQ simulation ...
        [errorcode] = calllib('epanet2', 'ENsolveH');
        initflag = 0;
    end
    
    % Assign function calls (WQ or Hydraulic) ...
    initfunc  = ['ENinit', enflag];
    openfunc  = ['ENopen', enflag];
    runfunc   = ['ENrun', enflag];
    closefunc = ['ENclose', enflag];
    
    % Open and initialise the (WQ/Hydraulic) solver ...
    [errorcode] = calllib('epanet2', openfunc);
    [errorcode] = calllib('epanet2', initfunc, initflag);
    
    % Initialise some variables ...
    tval = 0; tstep = 1; value = 0.0; pt = 0;
    
    % Loop through simulation ...
    while tstep && ~errorcode
        [errorcode, tval] = calllib('epanet2', runfunc, tval);
        pt = pt + 1;
        for n = 1:nlocations
            [errorcode, value] = calllib('epanet2', getvaluefunc, index(n), epanetcode, value);
            x(pt, n) = double(value);
        end
        t(pt) = double(tval)/3600;
        % Continue to the next time step ...
        [errorcode, tstep] = calllib('epanet2', nextfunc, tstep);
    end
    % Close the solver
    [errorcode] = calllib('epanet2', closefunc);
end

 % Convert to double precision ...
 x = double(x);
