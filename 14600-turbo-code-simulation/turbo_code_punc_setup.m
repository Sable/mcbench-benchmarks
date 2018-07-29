function turbo_code_punc_setup

% Get parameter names and values from mask
mask_ws_vars = get_param([gcs '/Global Parameters'],'maskwsvariables');

if ~isempty(mask_ws_vars)
    for i = 1:length(mask_ws_vars),
        curr_var = mask_ws_vars(i).Name;
        evalin('base',[curr_var ' = ' num2str(mask_ws_vars(i).Value) ';']);
    end
    
    % Set up other parameters in the MATLAB workspace as needed
    evalin('base', 'trellis = poly2trellis(5, [37 21],37);');  % code rate 1/2
    evalin('base', 'code_rate = 1/2;');               % Overall code rate = 1/2    
    evalin('base', 'Ps = 1;');                        % Signal power is 1         
    evalin('base', 'EbNo = 10.0.^(0.1*EbNodB);');     % Convert from dB to linear EbNo
    evalin('base', 'EsNo = EbNo/code_rate;')          % 
    evalin('base', 'multiplier = 1/code_rate;')       % multiplier = symbol_period/sample_time
    evalin('base', 'Variance = Ps*multiplier/EsNo;'); % Calculate channel noise variance. See Help of AWGN
    evalin('base', 'clear code_rate Ps EbNo EsNo multiplier;');
    
else
    evalin('base','Len = 1024;');
    evalin('base','Iter = 11;');
end