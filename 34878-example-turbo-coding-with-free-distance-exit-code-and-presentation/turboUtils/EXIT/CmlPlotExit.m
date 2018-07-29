function [sim_param, sim_state] = CmlPlotExit( varargin )
% CmlPlot plots simulation results
%
% The calling syntax is:
%     [sim_param, sim_state] = CmlPlotExit( scenario_filename, cases )
%
%     Outputs:
%     sim_param = A structure containing simulation parameters.
%     sim_state = A structure containing the simulation state.
%     Note: See readme.txt for a description of the structure formats.
%
%     Required inputs:
%	  scenario_filename = the name of the file containing an array of sim_param structures.
%     cases = a list of the array indices to plot.
%
%     Note: Multiple scenario files can be specified.  In this case, the argument list
%     should contain each scenario file to be used followed by the list of array indices
%     to read from that file.
%     
%     Example:
%     [sim_param, sim_state] = CmlPlot( 'Scenario1', [1 2 5], 'Scenario2', [1 4 6] );
%
%     This code owes lots to Rob Maunder's example EXIT Plotting from
%     http://users.ecs.soton.ac.uk/rm/resources/matlabexit/
%
%     (C) Colin O'Flynn 2011
%
%     This file is not part of the Iterative Solutions Coded Modulation
%     Library, and is instead part of an extension by Colin O'Flynn at
%     newae.com. It is distributed under the same terms as ISCML and can be
%     included in the official ISCML project if the authors wish
%
%     See license file with this distribution.

% determine location of CmlHome
load( 'CmlHome.mat' );

% setup structures are retrieve data
% give an extra argument to force sim_param.reset = 0
[sim_param, sim_state] = ReadScenario( varargin{:}, [] );
number_cases = length( sim_param );

%Number of points to plot in EXIT Graph
ExitPoints = 8;

%Generate list of Ia from 0.0 to 1.0
Ia_matrix = 0.0:(1/(ExitPoints-1)):1.0;

%EXIT Code Plotting from "Codes and Turbo Codes", page 263. Steps 1 - 7
%correspond directly with the algorithm written there.

for case_number=1:number_cases
    
    % Don't punctuate anything (n.b.: I don't think we should do this, but 
    % the code words better...)
    sim_param(case_number).pun_pattern1 = ones(size(sim_param(case_number).pun_pattern1));
    sim_param(case_number).pun_pattern2 = ones(size(sim_param(case_number).pun_pattern2));
    sim_param(case_number).tail_pattern1 = ones(size(sim_param(case_number).tail_pattern1));
    sim_param(case_number).tail_pattern2 = ones(size(sim_param(case_number).tail_pattern2));

    %Initialize Code
    [sim_param(case_number), code_param] = InitializeCodeParam( sim_param(case_number), cml_home );

    
    %Set dB to plot on EXIT Graphs
    if ( sim_param.SNR_type(2) == 'b' ) % Eb/No
        EbNo = 10.^(sim_param.exit_snr/10);
        EsNo = EbNo*code_param.rate;
    else % Es/No
        EsNo = 10.^(sim_param.exit_snr/10);
    end
    
    nframes = sim_param.exit_nframes;    
    figures = [];
   
    SNR_Ie = zeros(length(EsNo), length(Ia_matrix));
    %SNR_Ia doesn't change with SNR, but makes plotting easier to allocate
    %in same was as Ie
    SNR_Ia = zeros(length(EsNo), length(Ia_matrix));
    
    for EsNoIndex = 1:length(EsNo)    
        if sim_param(case_number).modulation ~= 'BPSK'
            error('EXIT Charting only works with BPSK Channel')
        end        

        [N1,K1] = size( sim_param(case_number).g1 );
        [N2,K2] = size( sim_param(case_number).g2 );
        % Zero storage matricies
        Ie_mean = zeros(1,length(Ia_matrix));
        Ie_stddev = zeros(1,length(Ia_matrix));

        for Ia_index=1:length(Ia_matrix)
            %Zero Ie matrix, which is only for this Ia point
            Ie_matrix = zeros(1,nframes);

            for frame_index = 1:nframes               
                % Step 1: Generate random data
                data = round( rand( 1, code_param.data_bits_per_frame ) );

                % Step 2: Code & Modulate        
                s = CmlEncode( data, sim_param(case_number), code_param );

                % Step 3: Put through the channel, this is now LLR
                symbol_likelihood = CmlChannel( s, sim_param(case_number), code_param, EsNo(EsNoIndex) );                                   
                
                % Keeping same variable names as elsewhere in Cml
                input_decoder_c = symbol_likelihood;

                % deinterleave (BICM)
                %if sim_param(case_number).bicm
                %    input_decoder_c = Deinterleave( input_decoder_c, code_param.bicm_interleaver);    
                %end

                depunctured_output = Depuncture( input_decoder_c, code_param.pun_pattern, code_param.tail_pattern );           
                input_upper_c = reshape( depunctured_output(1:N1,:), 1, N1*length(depunctured_output) );
                input_lower_c = reshape( depunctured_output(N1+1:N1+N2,:), 1, N2*length(depunctured_output) );

                % Step 4: Based on desired Ia, generate 'a priori'
                % extrinsic information
                input_upper_u = generateLLR(data, Ia_matrix(Ia_index)); 
                
                % Step 5: Do one round of SISO decoding with a priori LLR
                [output_upper_u output_upper_c] = SisoDecode( input_upper_u, input_upper_c, sim_param(case_number).g1, sim_param(case_number).nsc_flag1, sim_param(case_number).decoder_type );

                % Step 6: Recover LLRs at output
                % (Done in previous step)                

                % Step 7: Find Ie
                Ie_matrix(frame_index) = measure_mutual_information(output_upper_u-input_upper_u, data);              
            end
            
            Ie_mean(Ia_index) = mean(Ie_matrix);
            Ie_stddev(Ia_index) = std(Ie_matrix);        
            
            %Store Ie vs SNR
            SNR_Ie(EsNoIndex, Ia_index) = Ie_mean(Ia_index);
            SNR_Ia(EsNoIndex, Ia_index) = Ia_matrix(Ia_index);
        end

        % Create a figure to plot the results.
        figures(EsNoIndex) = figure;
        axis square;
        str = sprintf('SNR = %f', sim_param.exit_snr(EsNoIndex));
        title(str);
        ylabel('I_E');
        xlabel('I_A');
        xlim([0,1]);
        ylim([0,1]);

        hold on;

        % Plot the EXIT function for component decoder 1
        plot(Ia_matrix,Ie_mean,'-');
        plot(Ia_matrix,Ie_mean+Ie_stddev,'--');
        plot(Ia_matrix,Ie_mean-Ie_stddev,'--');

        % Plot the inverted EXIT function for component decoder 2
        plot(Ie_mean,Ia_matrix,'-');
        plot(Ie_mean+Ie_stddev,Ia_matrix,'--');
        plot(Ie_mean-Ie_stddev,Ia_matrix,'--');       
    end
    
    %Plot trajectories on each graph
    CmlPlotTraj(sim_param(case_number), figures);
    
    %Plot single component over all SNRs
    figure;
    axis square;
    title('Upper Component Decoder Mutual Information');
    ylabel('I_E');
    xlabel('I_A');
    xlim([0,1]);
    ylim([0,1]);
    hold on;
    plot(SNR_Ia', SNR_Ie');
    legs = {};
    for i=1:length(EsNo)
        legs{i} = sprintf('%.2f dB', sim_param.exit_snr(i));
    end
    legend(legs);
    
    
end
