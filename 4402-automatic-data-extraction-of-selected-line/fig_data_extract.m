function [x_out,y_out,z_out] = fig_data_extract
% [X_OUT,Y_OUT,Z_OUT] = FIG_DATA_EXTRACT
% This short function allows fast and easy data extraction of current select
% object in axis. 

% Instructions
% 1) Select the line object for which you need the data in workspace.
% 2) call fig_data_extract in command window.

% Philippe-Aubert Gauthier, 2004
% email adress: philippe_aubert_gauthier@hotmail.com
% URL: www3.sympatico.ca/philippe_aubert_gauthier/acoustics.html
% Suggested modifications: How to deal with two selected lines
% or more?

% Find the current object handles
obj_h = gco;
type_h = get(obj_h,'type');

% Verification
if type_h ~= 'line' % Wrong selection

    disp('The selected object is not a line. Please retry.')
    x_out=[];y_out=[];z_out=[];
    return
    
end

% Export the data to workspace
x_out = get(obj_h,'XData');
y_out = get(obj_h,'YData');
z_out = get(obj_h,'ZData');
    