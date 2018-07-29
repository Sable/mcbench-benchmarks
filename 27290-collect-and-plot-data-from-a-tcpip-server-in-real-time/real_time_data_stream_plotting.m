%% Real Time Data Stream Plotting Example
function real_time_data_stream_plotting
%%
% This example demonstrates how to automatically read a set number of data bytes as and
% when they are available. This MATLAB(R) script also generates a real time plot of streaming 
% data collected from the TCPIP server.  
%
% The script may be updated to use any instrument/device/TCPIP server
% to collect real time data. You may need to update the IP address and
% port.
%
% To generate a report of this entire script, you may use the PUBLISH
% command at the MATLAB(R) command line as follows: 
% 
% publish(real_time_data_plot);

% Author: Ankit Desai
% Copyright 2010 - The MathWorks, Inc.

%% Create the interface object
% Create a TCPIP object listening to port 19 (Character Generator).
%
% *Note* : To enable character generator service at port 19 on a Windows platform, enable:
%
%  Control Panel > Add Remove Programs > Add/Remove Windows Component > Networking Services
%
interfaceObject = tcpip('localhost',19);

%% 
% Setup a figure window and define a callback function for close operation
figureHandle = figure('NumberTitle','off',...
    'Name','Live Data Stream Plot',...
    'Color',[0 0 0],...
    'CloseRequestFcn',{@localCloseFigure,interfaceObject});

%%
% Setup the axes 
axesHandle = axes('Parent',figureHandle,...
    'YGrid','on',...
    'YColor',[0.9725 0.9725 0.9725],...
    'XGrid','on',...
    'XColor',[0.9725 0.9725 0.9725],...
    'Color',[0 0 0]);

xlabel(axesHandle,'Number of Samples');
ylabel(axesHandle,'Value');

%%
% Initialize the plot and hold the settings on
hold on;
plotHandle = plot(axesHandle,0,'-y','LineWidth',1);

%% Setup interface object to read chunks of data
% Set the number of bytes to read at a time
bytesToRead = 500;

%%
% Define a callback function to be executed when desired number of bytes
% are available in the input buffer
interfaceObject.BytesAvailableFcn = {@localReadAndPlot,plotHandle,bytesToRead};
interfaceObject.BytesAvailableFcnMode = 'byte';
interfaceObject.BytesAvailableFcnCount = bytesToRead;

%% 
% Open the interface object
fopen(interfaceObject);
pause(3);
snapnow;
%% Implement the bytes available callback
function localReadAndPlot(interfaceObject,~,figureHandle,bytesToRead)

%% 
% Read the desired number of data bytes
data = fread(interfaceObject,bytesToRead);

%% 
% Update the plot
set(figureHandle,'Ydata',data);

%% Implement the close figure callback
function localCloseFigure(figureHandle,~,interfaceObject)

%% 
% Clean up the interface object
fclose(interfaceObject);
delete(interfaceObject);
clear interfaceObject;

%% 
% Close the figure window
delete(figureHandle);
