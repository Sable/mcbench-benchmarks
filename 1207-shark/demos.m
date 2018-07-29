function tbxStruct  = demos

% DEMOS Demo list for Shark.

% Version 2.1
% Giampiero Campa 20-Dec-2001

if nargout == 0, demo blockset; return; end

tbxStruct.Name='Shark';
tbxStruct.Type='Blockset';

tbxStruct.Help={
   
   '6DOF Nonlinear Underwater Vehicle Model'   
};

 tbxStruct.DemoList = { ' Open Loop',                  'shark;oploop';
                        ' Linear Attitude Control',    'shark;nlksf' };
