%% Valve Parameters Demo Script
%
% <html>
% <span style="font-family:Arial">
% <span style="font-size:10pt">
% <tr><a><b><u>Power Stage</u></b></a><br>
% <tr>1&2. Orifice Area, 4-way: <a href="matlab:open([Valve_Params_HomeDir '/Data_Sheets/V-VLDI-MC003-E1.pdf']);">Data Sheet</a> <a href="matlab:cd([Valve_Params_HomeDir '/Ex1_A_Max_Search']);open_system('valve_testrig_flow_char_4way');">Model</a><br>
% <tr>3.   Orifice Area, 3-way: <a href="matlab:open([Valve_Params_HomeDir '/Data_Sheets/F340.pdf']);">Data Sheet</a> <a href="matlab:cd([Valve_Params_HomeDir '/Ex3_3_Way_Valve']);open_system('valve_testrig_flow_char_3way');">Model</a><br>
% <tr>4.   Using Experimental Data: <a
% href="matlab:cd([Valve_Params_HomeDir '/Ex4_Experimental_Data']);open_system('valve_testrig_exp_data_4way');">Model</a><br><br>
% <tr><a><b><u>Valve Actuator</u></b></a><br>
% <tr>5.   Tuning Simulink Model: <a href="matlab:cd([Valve_Params_HomeDir '/Ex5_Simulink_Actuator']);open_system('simple_valve_driver_testrig');">Model</a><br>
% <tr>6.   Matching Transient Response (Optim. Tbx.): <a href="matlab:cd([Valve_Params_HomeDir '/Ex6_Prop_Servo_Transient_Resp']);open_system('transient_response_match_test_rig');">Model</a><br>
% <tr>6a.  Matching Transient Response (SDO): <a href="matlab:open([Valve_Params_HomeDir '/Data_Sheets/V-VLDI-MC003-E1.pdf']);">Data Sheet</a> <a href="matlab:cd([Valve_Params_HomeDir '/Ex6_Prop_Servo_Transient_Resp/SDO']);open_system('transient_response_match_test_rig_SDO');">Model</a><br>
% <tr>7.   Matching Frequency Response, FFT Method: <a href="matlab:cd([Valve_Params_HomeDir '/Ex7_Prop_Servo_Freq_Resp_Linear']);open_system('pulse_response_linear_test_rig');">Model</a><br>
% <tr>8.   Matching Frequency Response, Time Domain: <a href="matlab:cd([Valve_Params_HomeDir '/Ex8_Prop_Servo_Freq_Resp_Direct']);open_system('actuator_freq_testrig_direct_method');">Model</a><br>
% <tr>8a.  Matching Frequency Response, frestimate: <a href="matlab:open([Valve_Params_HomeDir '/Data_Sheets/654.pdf']);">Data Sheet</a> <a href="matlab:cd([Valve_Params_HomeDir '/Ex8_Prop_Servo_Freq_Resp_Direct/SH_freq_resp']);open_system('actuator_freq_resp');">Model</a><br>
% </style>
% </style>
% </html>
% 
% Copyright 2010 MathWorks(TM), Inc.
