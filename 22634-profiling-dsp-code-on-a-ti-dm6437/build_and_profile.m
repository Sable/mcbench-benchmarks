% build_and_profile.m
% 1. Run make_rtw to generate, compile, link, download, and run code for
%    a predefined amount of time. 
% 2. Collect profiling statistics while running.
% 3. Retrieve the results of the profiling.

% kick off build process
make_rtw;
% wait to allow some profiling to occur
disp('collecting results...');  
num_avg_requested = 100;
wait_time = num_avg_requested*frame_time;
pause(wait_time);
% halt the DSP
halt(CCS_Obj);
% collect and format the results
ps = profile(CCS_Obj,'execution','raw');
num_avg_taken = ps.obj(6).count;
if (num_avg_taken < num_avg_requested)
    disp('did not collect enough statistics!')
    disp(['change model callback to make frame_time longer']);
    break;
end;
len = length(ps.obj); 
p_instr_avg = ps.obj(len).avg;
p_instr_max = ps.obj(len).max;
mult_factor = ps.obj(len).pdfactor;
p_us_avg = p_instr_avg * mult_factor;
p_us_max = p_instr_max * mult_factor; 
disp('results are in workspace!');