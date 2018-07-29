function tbxStruct  = demos

% DEMOS Demo list for Polybase.

if nargout==0, demo toolbox; return; end

tbxStruct.Name='Polybase';
tbxStruct.Type='toolbox';

tbxStruct.Help= ...                                             
   {'Functions for Multidimensional Polynomial' 
    'Interpolation and Approximation' };

tbxStruct.DemoList={'example', 'edit(''pexample.m'')'};
