function print_same_line(string)

% This code has been taken from Les Schaffer on comp.soft-sys.matlab
% Hope he will not mind having this sudden fame.
% Send any comment to lerouxni@iro.umontreal.ca

% small function to print a string starting from the beginning of the
% actual line

%%  the ascii code for starting an escape sequence
esc_code = 27;

%% clear to end of line
%% ESC [2K
er = [ char(esc_code) '[' '2' 'K' ];

%% goto beginning of line
%% ESC [1G
bl = [ char(esc_code) '[' '1' 'G' ];

new_string = strcat(bl, er, string);
fprintf(1, new_string);
