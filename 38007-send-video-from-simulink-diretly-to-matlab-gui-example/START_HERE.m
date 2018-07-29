%% Connect Simulink Video to MATLAB GUI:
% Created by Roni Peer, 4-Sep-2012.

%% To run the example, simply open the GUI, and press Start:
simpleGUI_imaq;

%%
% The GUI loads the Simulink Model, sets up a feed of 320x240 images, and
% shows them in the GUI.
% Please note that if you don't have a camera that runs on "winvideo"
% adapter you would have to setup the block "From Video Device" in the
% Simulink model. To Open it up, run the following:
open_system('simpleModel_imaq');
open_system('simpleModel_imaq/From Video Device');
