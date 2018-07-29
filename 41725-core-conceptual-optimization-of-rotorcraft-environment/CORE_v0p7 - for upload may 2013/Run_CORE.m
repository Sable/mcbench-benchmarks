% Revision history
% V 0.0 May 2011
% V 0.1 May 2011
% V 0.3 June 2011
% V 0.5 July 2011
% V 0.6 - main menu and iter menu changed - no forced choices
% V 0.7 Nov 2011. Slightly improved plapse function provided, tested 2011b,
%                 changed some menu interfaces
clear;home;
disp('-------------------------------------------------------------------')
disp(' ')
disp('               ######   #######  ########  ######## ')
disp('              ##    ## ##     ## ##     ## ##       ')
disp('              ##       ##     ## ##     ## ##       ')
disp('              ##       ##     ## ########  ######   ')
disp('              ##       ##     ## ##   ##   ##       ')
disp('              ##    ## ##     ## ##    ##  ##       ')
disp('               ######   #######  ##     ## ######## ')
disp(' ')
disp('---------Conceptual Optimization of Rotorcraft Environment---------')
disp(' ')
disp('                                        _')
disp('                                      /;:`.')
disp('                     ______        _,-''._,''')
disp('              _,--''''''      `''-._,-''_,-'' `''')
disp('            ,''  ` - .,_  __,-'' ),-''')
disp('           (       __|-`'' . _,''/')
disp('            `--...''___,..--''  /')
disp('               /     _/,-''_,-''')
disp('              (`---'''' _,-'' |_,-')
disp('               `----''''|_,--''')
disp('               -''  _,-''')
disp(' ')
disp('                      Author: Sky Sartorius')
disp('                      Contact: sky.sartorius(at)gmail.com')
disp(' ')
disp('Version 0.7, 2011, tested on Matlab R2011b')
disp('-------------------------------------------------------------------')

disp(' ');disp(' ');
disp('adding CORE to MATLAB path...')
disp(' ');disp(' ');

global CORE_PARENT_DIR CORE_DIR
CORE_PARENT_DIR = cd;
CORE_DIR = [CORE_PARENT_DIR '\CORE'];
addpath(CORE_DIR)
addpath([CORE_DIR '\utilities'])

COREmainmenu;

disp(' ')
disp('removing CORE from MATLAB path...')
rmpath(CORE_DIR);
rmpath([CORE_DIR '\utilities']);
cd(CORE_PARENT_DIR)
disp(' ')
disp('-------------------------------------------------------------------')
disp(' ')
disp('                        \\                //')
disp('                         \\              //')
disp('                          \\            //')
disp('                           \\          //')
disp('                            \\    __  //')
disp('                             \\ [|  |//')
disp('     __                      _\\E|_ //')
disp('    |  |                    |__\\__//___m____')
disp('    |  \_______________,---''''   \''/''  _______\_')
disp('    >[====>               ( :   (O)  [   |   ] B')
disp('    |: /~~~~~~~~~~~~~~~`---..__,/,\   ~~~~~~~/~')
disp('    |__|                    |_//__\\|~~~w~~~~')
disp('                             // E| \\B')
disp('                            //  [|__\\')
disp('                           //        \\')
disp('                          //          \\')
disp('                         //            \\')
disp('                        //              \\')
disp('                       //                \\')
disp(' ')
disp('------------------------------Exiting------------------------------')
