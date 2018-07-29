function setup_figure(fig_handle, event, varargin)
% SETUP_FIGURE  Creation callback for figures
% To use, add the following line to your startup.m script:
%    set(0,'DefaultFigureCreateFcn',@setup_figure);
% Add any code to the setup_figure.m file that should be automatically
% executed upon figure creation.

AddReorderButtons(fig_handle);
