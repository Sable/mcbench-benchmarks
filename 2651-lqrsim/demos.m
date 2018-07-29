function tbxStruct  = demos

%DEMOS Demo list for the LqrSim Library.

% Version 2.1
% Giampiero Campa, Jason Hall, Riccardo Bevilacqua
% 1-Jan-2009

if nargout == 0, demo blockset; return; end

tbxStruct.Name='LqrSim';
tbxStruct.Type='Blockset';

tbxStruct.Help={
   
   'The block lqrysim solves Algebraic Riccati Equations'
   'without calling the matlab interpreter.'
   
};

 tbxStruct.DemoList = { ' Main Demo',  'sfcndemo_lqry' };