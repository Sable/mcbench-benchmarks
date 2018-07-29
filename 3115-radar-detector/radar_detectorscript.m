function radar_detectorscript(varargin)
%RADAR_DETECTORSCRIPT Controls the Stateflow Markov Chain Demo HTML page
%   RADAR_DETECTORSCRIPT(action) executes the hyperlink callback associated with 
%   the string action.
%
%%   BUSDEMOSCRIPT(action,blockName) is used for the hiliteblock action. blockName
%%   contains the string name of the block to be highlighted using hilite_system.
%
%   The complete set of demo files is as follows.
%      1) radar_detector.mdl
%      2) radar_detector.html
%      3) radar_detectorfig1.gif
%      4) radar_detectorfig2.gif
%      5) radar_detectorfig3.gif
%      6) radar_detectorfig3a.gif
%      7) radar_detectorfig4.gif
%      8) radar_detectorfig4a.gif
%      9) radar_detectorfig4b.gif
%    10) radar_detectorfig7.gif
%    11) radar_detectorfig8.gif
%    12) radar_detectorfig9.gif
%    13) radar_detectorscript.m

%   Stacey Gage
%	Copyright 1986-2000 The MathWorks, Inc. 
%	$Revision: $  $Date: $

persistent RADAR_DETECTOR_STEP_COUNTER

ni=nargin;

if ~ni,
	step = 'initialize';
else 
	step = varargin{1};
end

% If first time running the demo, or they closed the model
if isempty(RADAR_DETECTOR_STEP_COUNTER) & ni
	radar_detector;
	% Give the radar_detector a CloseFcn so that, when it's closed, it reinitializes the flag
	set_param('radar_detector','CloseFcn','radar_detectorscript(''close'')');
	RADAR_DETECTOR_STEP_COUNTER=zeros(1,6);
end

switch step
case 'initialize',
	% Open the web browser with the html file
	fullPathName=which('radar_detectorscript');
    tok=filesep;
	indtok = findstr(fullPathName,tok);
	pathname = fullPathName(1:indtok(end));
	web([pathname,'radar_detector.html']);
	
case 'step1',
	% Open the Simulink model
	RADAR_DETECTOR_STEP_COUNTER(1)=1;

case 'step2',
	% Run the model
	RADAR_DETECTOR_STEP_COUNTER(2)=1;
	sim('radar_detector'); % Executing just this line will automatically open the model
	
case 'step3',
	RADAR_DETECTOR_STEP_COUNTER(3)=1;
	% open Stateflow chart (or bring to front)
	open_system('radar_detector/Radar Detector')
	
case 'step4',
	RADAR_DETECTOR_STEP_COUNTER(4)=1;
	% hilight and open random number block
	hilite_system(['radar_detector/Uniform Random',char(10),'Number'],'find');
	open_system(['radar_detector/Uniform Random',char(10),'Number'])
	
case 'step5',
	RADAR_DETECTOR_STEP_COUNTER(5)=1;
	% change random number seed
	set_param(['radar_detector/Uniform Random',char(10),'Number'],'Seed','20192')
	set_param('radar_detector','SimulationCommand','update'); % Needed when invoked from command line
	
case 'step6',
	RADAR_DETECTOR_STEP_COUNTER(6)=1;
	% change random number seed
	set_param(['radar_detector/Uniform Random',char(10),'Number'],'Seed','598345')
	set_param('radar_detector','SimulationCommand','update'); % Needed when invoked from command line
 
case 'hiliteblock'
	%---hilite appropriate blocks
	blockName = varargin{2};
	b=find_system('radar_detector','Type','block');
	
	% First make sure everything else is turned off
	hilite_system(b,'none');
	
	% Hilite the specific block
	hilite_system(['radar_detector/',blockName],'find')
	
case 'close',
	RADAR_DETECTOR_STEP_COUNTER=[];
	set_param('radar_detector','CloseFcn','');
	
otherwise
	warning('The requested action could not be taken.')
	
end	 % switch action

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function modArray = StripSelection(inArray)

modArray = strrep(inArray, '??? ', '');
