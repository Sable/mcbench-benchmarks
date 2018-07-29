function CmlPlotTraj( sim_param, figures)
% CmlPlot plots simulation results
%
% The calling syntax is:
%     CmlPlotTraj( sim_param, figures )
%
%     Required inputs:
%	  sim_param = Simulator parameters
%     figures = EXIT Chart figure handles onto which trajector is plotted
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
% We reload the code parameters in case upper function screwed them up (as
% EXIT chart plotting dues to the puncturing)
load( 'CmlHome.mat' );

%Initialize Code
[sim_param, code_param] = InitializeCodeParam( sim_param, cml_home );

%Set dB to plot on EXIT Graphs
if ( sim_param.SNR_type(2) == 'b' ) % Eb/No
    EbNo = 10.^(sim_param.exit_snr/10);
    EsNo = EbNo*code_param.rate;
else % Es/No
    EsNo = 10.^(sim_param.exit_snr/10);
end

%User trajectories
if isempty(sim_param.exit_trajectories)
    nframes = 5;
else
    nframes = sim_param.exit_trajectories; 
end

% Create a figure to plot the results.
for EsNoIndex = 1:length(EsNo)
    figure(figures(EsNoIndex))
    hold on;

    if sim_param.modulation ~= 'BPSK'
        error('EXIT Charting only works with BPSK Channel')
    end        

    for frame_index = 1:nframes               
        % Step 1: Generate random data
        data = round( rand( 1, code_param.data_bits_per_frame ) );

        % Step 2: Code & Modulate        
        s = CmlEncode( data, sim_param, code_param );

        % Step 3: Put through the channel
        symbol_likelihood = CmlChannel( s, sim_param, code_param, EsNo(EsNoIndex) );

         % Keeping same variable names as elsewhere in Cml
        input_decoder_c = symbol_likelihood;

        input_decoder_u = zeros(1, code_param.data_bits_per_frame );
        
         %User iterations
        if isempty(sim_param.exit_iterations)
            turbo_iterations = code_param.max_iterations;
        else
            turbo_iterations = sim_param.exit_iterations; 
        end

        % deinterleave (BICM)
        %if sim_param.bicm
        %    input_decoder_c = Deinterleave( input_decoder_c, code_param.bicm_interleaver);    
        %end

        [detected_data, turbo_errors, output_decoder_c, output_decoder_u, trajectory ] = TurboDecode( input_decoder_c, data, turbo_iterations, sim_param.decoder_type, code_param.code_interleaver, code_param.pun_pattern, code_param.tail_pattern, sim_param.g1, sim_param.nsc_flag1, sim_param.g2, sim_param.nsc_flag2, input_decoder_u, 1 );

        trajSize = size(trajectory);        
        codewordsInTraj = trajSize(1);
        %Plot each codeword saved
        for cwi=1:codewordsInTraj
            trajectory(cwi,:,:)
            plot(trajectory(cwi,:,1),trajectory(cwi,:,2), 'r');
        end
    end  
end
