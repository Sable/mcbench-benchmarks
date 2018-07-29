function [] = shut_mask(block)

set_param(block, 'LinkStatus', 'none');
v = get_param(block, 'T');
Path = get_param(block, 'Parent');
N = get_param(block, 'Name');
Path = strcat(Path, '/',N);

if strcmp(v, 'on') == 1
   %test_gui_1
   Mask_Shut_off(Path);
   %set_param(block, 'Mask','Off');
end