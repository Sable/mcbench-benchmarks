function CmlToGarello(varargin)
% CmlToGarello outputs files which you can use with Garello's algorithm to
% find dfree, which is implemented at
% http://www.tlc.polito.it/garello/turbodistance/turbodistance.html
%
% The calling syntax is:
%     CmlToGarello( scenario_filename, cases )
%
%     Required inputs:
%	  scenario_filename = the name of the file containing an array of sim_param structures.
%     cases = a list of the array indices to simulate.
%
%     Note: One a SINGLE scenario from a SINGLE file can be specified,
%     since the output is written to text files.
%
%     Assumptions:
%      * No puncturing of information bits
%      * One feedforward & one feedback polynomial
%      * No puncturing of tail bits     
%
%     Example:
%     CmlToGarello( 'Scenario1', [2]);
%
%     Copyright (C) 2011, Colin P O'Flynn
%
%     This file is not part of the Iterative Solutions Coded Modulation
%     Library, and is instead part of an extension by Colin O'Flynn at
%     newae.com. It is distributed under the same terms as ISCML and can be
%     included in the official ISCML project if the authors wish
%
%     See license file with this distribution.

% setup structures and retrieve data
[sim_param, sim_state] = ReadScenario( varargin{:} );
number_cases = length( sim_param );

% determine location of CmlHome
load( 'CmlHome.mat' );

if number_cases > 1
    fprintf( '\nCan only work with one case at a time, sorry\n');
    return
end

%Maybe eventually support more cases, for now only 1
case_number = 1;

%How many minimum distances to calculate
numDists = 4;

% Fixed filenames: input.txt, punc.txt, and perm.txt
finput = fopen('input.txt', 'w');

cells = size(sim_param(case_number).g1);
cells = cells(1,2)-1;

% Write input filename
fprintf(finput, 'number_of_cells_for_E1_(nu1)\n%d\n', cells);
fprintf(finput, 'feedback_coefficients_for_E1(fb1)\n');
fprintf(finput, '%d', sim_param(case_number).g1(1,:));
fprintf(finput, '\nnumber_of_feedforward_polynomials_for_E1_(num_c1)\n1\n');
fprintf(finput, 'feedforward_coefficients_for_E1_(ff1[])\n');
fprintf(finput, '%d', sim_param(case_number).g1(2,:));
fprintf(finput, '\n');

cells = size(sim_param(case_number).g2);
cells = cells(1,2)-1;

fprintf(finput, 'number_of_cells_for_E2_(nu2)\n%d\n', cells);
fprintf(finput, 'feedback_coefficients_for_E2(fb2)\n');
fprintf(finput, '%d', sim_param(case_number).g2(1,:));
fprintf(finput, '\nnumber_of_feedforward_polynomials_for_E2_(num_c2)\n1\n');
fprintf(finput, 'feedforward_coefficients_for_E2_(ff2[])\n');
fprintf(finput, '%d', sim_param(case_number).g2(2,:));
fprintf(finput, '\n');

fprintf(finput, 'puncturing_filename_(file_punt)\n');
fprintf(finput, 'punc.txt\n');
fprintf(finput, 'interleaver_length_(N)\n%d\n', sim_param(case_number).framesize);
fprintf(finput, 'permutation_filename_(file_perm)\n');
fprintf(finput, 'perm.txt\n');

fprintf(finput, 'CRC?_(CRC=0)\n');
fprintf(finput, '0\n');
fprintf(finput, 'UMTS_(E2_termination_if_0_E2_input_bits_are_not_considered)\n');
fprintf(finput, '0\n');
fprintf(finput, 'dstar_(dstar0)\n');
fprintf(finput, '30\n');
fprintf(finput, 'number_of_distances_to_be_computed_(num_dist)\n');
fprintf(finput, '%d\n', numDists);
fprintf(finput, 'starting_values_(dist0[])\n');
for i=1:numDists
    fprintf(finput, '10000 0 0\n');
end

fprintf(finput, 'maximum_input_weight_(wu_max)\n');
fprintf(finput, '10\n');
fprintf(finput, 'step_between_succesive_computation_(p)\n');
fprintf(finput, '3\n');
fprintf(finput, 'control_filename_(file_controllo)\n');
fprintf(finput, 'controllo.txt\n');
fprintf(finput, 'output_filename_(file_output)\n');
fprintf(finput, 'out.txt\n');
fprintf(finput, 'start_again?_(yes=1/no=0)\n');
fprintf(finput, '0\n');
fprintf(finput, 'j_start_(ji)\n');
fprintf(finput, '999\n');
fprintf(finput, 'j_final_(jf)\n');
fprintf(finput, '0\n');
fprintf(finput, 'j_delta_(pj)\n');
fprintf(finput, '1\n');
fprintf(finput, '\n');
fclose(finput);

%Write interleaver / permutation file
writePerm(eval(sim_param(case_number).code_interleaver));

%Write puncturing pattern file
fpunc  = fopen('punc.txt', 'w');
%CML stores in row notation, Garello software expecting in columns
for i=1:length(sim_param(case_number).pun_pattern1)
    fprintf(fpunc, '1%d%d\n', sim_param(case_number).pun_pattern1(2, i), sim_param(case_number).pun_pattern2(2, i));
end
fclose(fpunc);

