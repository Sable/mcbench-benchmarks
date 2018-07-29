function weights = update_weight_fcn(step_size, err_sig, delayed_signal, filter_coefficients, reset_weights)
% This function updates the adaptive filter weights based on LMS algorithm

% NOTE: To instruct Embedded MATLAB to compile an external function, 
% add the following compilation directive or pragma to the function code
%#eml

fm = fimath(step_size);

step_sig = fi(step_size .* err_sig, 1, 32, 20, fm);
correction_factor = fi(delayed_signal .* step_sig, 1, 32, 20, fm);
updated_weight = fi(correction_factor + filter_coefficients, 1, 16, 16, fm);

if reset_weights
    weights = fi(zeros(1,40), 1, 16, 16, fm);
else    
    weights = updated_weight;
end