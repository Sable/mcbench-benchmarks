function varargout = spectrumscope(varargin)
% SPECTRUMSCOPE Compute and display a real-time FFT
%
% STEP 1: Initialize the scope
% SPECTRUMSCOPE(FS,NFFT) initializes a spectrum scope in the current axes.
% This spectrum scope will compute and displays the NFFT-point FFT of a vector 
% signal with sample rate FS Hz.
%
% STEP 2: Update the scope
% SPECTRUMSCOPE(S) updates the spectrum scope in the current axes with the
% FFT of vector S.  The scope should first be initialized as above with
% sample rate and FFT length.  If not, the sample rate will be 1 Hz and the FFT
% length will be the length of S.  Differences between the length of S and
% the specified FFT length are handled the same as MATLAB's built-in FFT
% function (i.e., zero-padding or truncation, as appropriate).
%
% SPECTRUMSCOPE(FS,NFFT,NTRACES) initializes a spectrum scope in the
% current axes with NTRACES traces.  A trace is a single line on the scope;
% typically one will display one trace per channel of data.  The default
% for NTRACES is 1. To update a spectrum scope with multiple traces,
% SPECTRUMSCOPE(S) must specify a matrix S with shorter dimension length =
% NTRACES.  SPECTRUMSCOPE computes the FFT along the longer dimension,
% assuming the shorter dimension corresponds to traces.  I know that this
% differs from FFT (which always defaults to applying to each column), but
% I find this deviation convenient.
%
% SPECTRUMSCOPE(HAX, ...) defines the scope in specified axes HAX instead of GCA.  i.e.,
% SPECTRUMSCOPE(HAX,FS,NFFT) initializes axes HAX as a spectrum scope, and
% SPECTRUMSCOPE(HAX,S) updates axes HAX with vector S.
%
% HAX = SPECTRUMSCOPE(...) returns a handle to the axes initialized by the
% spectrum scope.  This is useful if you allow SPECTRUMSCOPE to create an
% axes for you, and want to be able to easily reference the axes for
% updates.  The lines created by SPECTRUMSCOPE all have the tag
% 'SpectrumScope'.  If you would like to manually modify the properties of
% these lines, their handles can be found by:
%
%        HAX = SPECTRUMSCOPE(...);
%        HLINE = findobj(HAX,'Tag','SpectrumScope');
%
% Example
% 		%% Create data
% 		Fs = 1024;
% 		Nfft = 2048;
% 		t = (0:1:Nfft-1)'/Fs;
% 		fo = 100:5:300;         % Range of fundamental frequencies
% 		s1 = sin(2*pi*t*fo);
% 		
% 		%% Initialize scope
% 		spectrumscope(Fs,Nfft);
% 		
% 		%% Update scope
% 		for ii = 1:length(fo)
%             spectrumscope(s1(:,ii));
%             drawnow;pause(.01);
% 		end;

%    Scott Hirsch 2-25-04
%    shirsch@mathworks.com
%    Copyright 2004 The MathWorks, Inc.

%% Parse input arguments
% Decision tree:
% + Initialize or update?
%   o If update -> OK
%   o If initialize -> Axes specified, or use GCA?

error(nargchk(1,4,nargin))

%% Initialize or update?
% If first or second input argument is not a scalar, it must be data - i.e. we are
% updating

if prod(size(varargin{1})) > 1 | prod(size(varargin{2})) > 1 % Update
    action = 'update';
    
    if nargin==1                % Use current axes
        hAxes = gca;
        data = varargin{1};
    else
        hAxes = varargin{1};    % Axes was specified
        data = varargin{2};
    end;
    
    % If the user has not initialized this scope, do it for them
    parms = getappdata(hAxes,'SpectrumScopeParameters');
    
    % Ensure that scope has been initialized
    if isempty(parms)
        % Use default values
        Fs = 1;
        data = rowmajor(data);
        [Nfft,NTraces] = size(data);
        feval(mfilename,hAxes,Fs,Nfft,NTraces);       % This recursive call will initialize the scope
        % Get the new parameter structure
        parms = getappdata(hAxes,'SpectrumScopeParameters');
    end;
    
    
    
else                                    % Initialize  
    action = 'init';
    
    if ~isaxes(varargin{1})             % Easy mode, no handle passed in
        % Use current axes
        hAxes = gca;
        Fs = varargin{1};
        Nfft = varargin{2};
        if nargin==3
            NTraces = varargin{3};
        else
            NTraces = 1;
        end;
        
    else                                % Expert mode, passed handle in
        hAxes = varargin{1};
        Fs = varargin{2};
        Nfft = varargin{3};
        if nargin==4
            NTraces = varargin{4};
        else
            NTraces = 1;
        end;
    end;
end;

%% Dole out the work
% 
switch action
    case 'init'     % Initialize

        % Build structure to internally pass information
        parms.Fs = Fs;                      % Sample Rate
        parms.NTraces = NTraces;            % Number of lines in plot
        parms.hAxes = hAxes;                % Handle to axes
        parms.Nfft = Nfft;                  % FFT Block size
        
        % Store parameter structure
        setappdata(hAxes,'SpectrumScopeParameters',parms);
        
        localInitScope(parms)               % Initialize scope
        
    case 'update'   % Update
        parms = getappdata(hAxes,'SpectrumScopeParameters');

        % Error checking
        % Ensure that scope has been initialized.  This shouldn't slip
        % through to here.
        if isempty(parms)
            error(['The spectrum scope must first be initialized ' ...
                    'with the sample rate: spectrumscope(hAxes,Fs)']);
        end;
        
        % Force data to be in columns.  Allow for multiple columns.  This will
        % error if data actually has more channels than samples.
        data = rowmajor(data);

        % Check that the number of columns corresponds to the number of lines
        nc = size(data,2);      % Number of columns
        if nc ~= parms.NTraces
            error(['Size mismatch.  You initialized spectrumscope with ' num2str(parms.NTraces) ...
                    ' lines, but just passed in ' num2str(nc) ' channels of data.  These' ...
                    ' numbers must be the same.']);
        end;
        
        localUpdateScope(data,parms)            % Update the scope
end;

% Return appropriate output argument
if nargout
    varargout{1} = parms.hAxes;
end;        
            

% ***********************************************************************  
% Initialize the Scope
function localInitScope(parms)

% Set axes
f = (0:parms.Nfft/2-1)*parms.Fs/parms.Nfft;
f = f(:);

% Add line(s)
parms.hLine = plot(f,NaN*ones(length(f),parms.NTraces), ...
    'Tag','SpectrumScope', ...
    'Parent',parms.hAxes);
set(parms.hAxes,'XLim',[0 parms.Fs/2]);
setappdata(parms.hAxes,'SpectrumScopeParameters',parms);

%% Get handle to the figure
% Turn doublebuffer on to eliminate flickering
hFig = get(parms.hAxes,'Parent');

% In R14, it's possible that hFig would return a handle to a panel, not a
% figure
if ~strcmp(get(hFig,'Type'),'figure')
    hFig = get(hFig,'Parent');
end;

%%
% Label the plot.
% There's a bug in R13 when creating xlabel and ylabel with direct
% parenting - the alignment gets all messed up. Instead, make hAx current
% axes
ca = gca;
set(hFig,'CurrentAxes',parms.hAxes);
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
set(hFig,'CurrentAxes',ca);

%%
% Turn doublebuffer on to eliminate flickering
set(hFig,'DoubleBuffer','on');

% ***********************************************************************  
% Update the plot.
function localUpdateScope(data,parms)

[f,mag] = localfft(data,parms);

% Dynamically modify Magnitude axis as we go.  Expand, but don't shrink.  
maxM=max(mag(:));
minM=min(mag(:));
yax2=get(parms.hAxes,'YLim');
if minM<yax2(1),
   yax2(1)=minM;
end
if maxM>yax2(2),
   yax2(2)=maxM;
end
set(parms.hAxes,'YLim',yax2)


hLine = parms.hLine;

% Update the plot
for ii=1:parms.NTraces
%     Mag{ii} = mag(:,ii);
    set(hLine(ii), 'YData', mag(:,ii));
end;
% set(parms.hLine, 'XData', f(:,1), 'YData', mag(:,1));
% set(parms.hLine, {'YData'}, Mag');

% Note: It looks like it's faster to update one line at a time
%  in a loop than to update with a cell array

% ***********************************************************************  
% Calculate the fft of the data.
function [f, mag] = localfft(data,parms)

% Calculate the fft of the data.
xfft = 2/parms.Nfft*fft(data,parms.Nfft);

% Avoid taking the log of 0.
xfft(xfft == 0) = 1e-17;

% Compute magnitude, dB
mag = 20*log10(abs(xfft(1:parms.Nfft/2,:)));

f = (0:length(mag)-1)*parms.Fs/parms.Nfft;
f = f(:);

% ***********************************************************************  
% Utility - isaxes
function truefalse = isaxes(h);
% ISAXES(H)  True if H is a handle to a valid axes

truefalse = 0;      % Start false
if ishandle(h)
    if strcmp('axes',get(h,'Type'))
        truefalse = 1;
    end;
end;

% ***********************************************************************  
% Utility - rowmajor
function data = rowmajor(data);
% Force data to be row major. i.e. more rows than columns

[nr,nc] = size(data);
if nc>nr
    data = data';
    [nr,nc] = size(data);
end;

