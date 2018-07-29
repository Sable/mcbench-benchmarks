function [out_val] = per_graph(in_vec)
% per_graph.m - draws PER graph
global numPkts PER_snr PER_exp PER_bitPayload;

% PER graph settings (actual values are user-selected (GUI))
%%%%% numPkts = 200;
%%%%% PER_snr = 29:33;

% Input parameters
Clk        = in_vec(1);
bitsPerBlk = in_vec(2:9);
bmode      = in_vec(10);
dbits      = in_vec(11:end);
txbits     = dbits(1:end/2);
rxbits     = dbits(end/2+1:end);

% Viterbi trace-back depth (hard-coded for now)
link_delay = 128; %%34;

% Reset PER graph data
if (Clk==0)  PER_exp = zeros(size(PER_snr));  end

% Count number of error packets
if (floor(Clk/numPkts)<length(PER_snr))
    idx = floor(Clk/numPkts)+1;
    % Compare tx, rx bits
    txb = txbits( 1 : PER_bitPayload-link_delay );
    rxb = rxbits( link_delay+1 : PER_bitPayload );

    if (1) % for PER
        if ~all(txb==rxb)  PER_exp(idx) = PER_exp(idx) + 1;  end
    else   % for BER
        PER_exp(idx) = PER_exp(idx) + sum(xor(txb,rxb))/(PER_bitPayload-link_delay);
    end
    
    % Display PER information
    disp( ['Pkt:' num2str(mod(Clk,numPkts)+1) ', Idx=' num2str(idx) ...
           ', PER_list: ' num2str(PER_exp)] );
end
    
if (Clk==length(PER_snr)*numPkts)
    PER_fig = figure;
    % Draw PER Curves
    PER_exp = PER_exp/numPkts;
    semilogy(PER_snr, PER_exp, 'g');
    %axis([0 25 1/1000 1]);
    axis([0 50 1/1000 1]);
    
    % Label graph...
    title('PER Curve');
    xlabel('SNR (dB)');
    ylabel('PER');
    legend('Simulation Result');
    grid on;

    % Display end message
    disp('PER test complete.');
end

% Output percentage done
out_val = min([100 100*Clk/(length(PER_snr)*numPkts)]);
