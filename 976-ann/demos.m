function tbxStruct  = demos

% DEMOS Demo list for the ANN Library.

% Version 1.1
% Giampiero Campa, West Virginia University
% 1-June-2007

if nargout == 0, demo blockset; return; end

tbxStruct.Name='Adaptive Neural Networks';
tbxStruct.Type='Blockset';

tbxStruct.Help={
   
   'The Adaptive Neural Networks Library (BANN) consists in a collection'
   'of blocks that implement several adaptive neural networks in simulink.'
};

 tbxStruct.DemoList = { ' Adaptive Neural Network Library',       'ann';
                        ' Main Demo File ',          'anndemo' };