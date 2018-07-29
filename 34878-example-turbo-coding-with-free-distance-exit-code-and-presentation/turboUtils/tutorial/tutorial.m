% Copyright Colin O'Flynn, 2011. All rights reserved.
% http://www.newae.com
%
% This file demonstrates how turbo encoding & decoding work by working
% through a simple example. You should really look at the powerpoint
% presentation also part of this project to understand what is happening.
%

close all

%% Parameters

%SNR in dB to run channel at, play around with this to get a good number
%which uses a few turbo iterations. On my system this causes the code to do
%3 iterations to correct all the errors
SNR = -7.3;

%Length of data, don't make this too long!
frame_length = 9;

% The generator polynomials we are using
feedback_polynomial = [1 0 1 1]
feedforward_polynomial = [1 1 0 0]

%Keep all tail bits
tail_pattern = [1 1 1  %Encoder 1 Systematic Part
                1 1 1  %Encoder 1 Parity Part
                1 1 1  %Encoder 2 Systemtic Part
                1 1 1];%Encoder 2 Parity Part

%Puncture systematic part from encoder 2
pun_pattern = [ 1 1  %Encoder 1 Systematic Part
                1 1  %Encoder 1 Parity Part
                0 0  %Encoder 2 Systemtic Part
                1 1];%Encoder 2 Parity Part

%Max number of iterations to display
turbo_iterations = 5;

%Automatically stop when no more errors
autostop = 1;
            
%% Data Generation

%Seed the random number generator so we always get the same random data
rand('state', 0);
randn('state', 0);

%Generate some random data
data = round( rand( 1, frame_length ) );
fprintf('Information Data = ');
fprintf('%d ', data);
fprintf('\n');

%% Encoding

%Make polynomial
genPoly = [feedback_polynomial; feedforward_polynomial];

%How many rows in polynomial?
[N, K] = size(genPoly);

upper_data = data;
upper_output = ConvEncode( upper_data, genPoly, 0);

%lower input data is interleaved version of upper
lower_data = interleave(data, 1);
lower_output = ConvEncode( lower_data, genPoly, 0);

% convert to matrices (each row is from one row of the generator)
upper_reshaped = [ reshape( upper_output, N, length(upper_output)/N ) ];
lower_reshaped = [ reshape( lower_output, N, length(lower_output)/N ) ];

fprintf('Upper Code Input      = ');
fprintf('%d ', upper_data);
fprintf('\n');
fprintf('Upper Code Systematic = ');
fprintf('%d ', upper_reshaped(1,:));
fprintf('\n');
fprintf('Upper Code Parity     = ');
fprintf('%d ', upper_reshaped(2,:));
fprintf('\n\n');
fprintf('Lower Code Input      = ');
fprintf('%d ', lower_data);
fprintf('\n');
fprintf('Lower Code Systematic = ');
fprintf('%d ', lower_reshaped(1,:));
fprintf('\n');
fprintf('Lower Code Parity     = ');
fprintf('%d ', lower_reshaped(2,:));
fprintf('\n');

% parallel concatenate
unpunctured_word = [upper_reshaped
        lower_reshaped];

fprintf('\n\nUnpunctured = ');
fprintf('%d ', unpunctured_word);
fprintf('\n');
    
%Puncture Codeword
codeword = Puncture( unpunctured_word, pun_pattern, tail_pattern );  
fprintf('Punctured   = ');
fprintf('%d ', codeword);
fprintf('\n');

%% Modulate, Channel, and Demodulate

fprintf('\n\nSending data over AWGN channel, SNR=%f\n', SNR);

%Turn into +/- 1 for BPSK modulation example
tx = -2*(codeword-0.5);

EsNo = 10^(SNR/10.0);
variance = 1/(2*EsNo);

%Generate AWGN of correct length
noise = sqrt(variance)*randn(1, length(tx) );

%Add AWGN
rx = tx + noise;     

%Demodulate
symbol_likelihood = -2*rx./variance;

%Plot
figure
plot(symbol_likelihood, zeros(1, length(symbol_likelihood)), '.')
title('LLR of Received Signal');

fprintf('Received log-liklihood ratio (LLR): mean(abs(LLR)) = %f\n', mean(abs(symbol_likelihood)));

%% Decoding

% intialize error counter
errors = zeros( turbo_iterations, 1 );   

% depuncture and split into format used in each decoder
depunctured_output = Depuncture(symbol_likelihood, pun_pattern, tail_pattern );

fprintf('LLR After Channel      = ');
fprintf('%4.1f ', symbol_likelihood);
fprintf('\n');
fprintf('LLR After Depuncturing = ');
fprintf('%4.1f ', depunctured_output);
fprintf('\n');

input_upper_c = reshape( depunctured_output(1:N,:), 1, N*length(depunctured_output) );
input_lower_c = reshape( depunctured_output(N+1:N+N,:), 1, N*length(depunctured_output) );

fprintf('Upper Input = ');
fprintf('%4.1f ', input_upper_c);
fprintf('\n');
fprintf('Lower Input = ');
fprintf('%4.1f ', input_lower_c);
fprintf('\n');

% No estimate of original data
input_upper_u = zeros( 1, frame_length );

saved_outLLR = [];
saved_outExt = [];
saved_interLLR = [];
saved_interExt = [];

totalIts = 0;

traj = zeros(1,2);

figure;
axis square;
title('Turbo Decoder Trajectory');
ylabel('I_E');
xlabel('I_A');
xlim([0,1]);
ylim([0,1]);
hold on;

IA = 0;
IE = 0;

% Iterate over a number of times
for turbo_iter=1:turbo_iterations
    fprintf( '\n*** Turbo iteration = %d\n', turbo_iter );
    % Pass through upper decoder
    [output_upper_u output_upper_c] = SisoDecode( input_upper_u, input_upper_c, genPoly, 0, 0 );
    
    % Save LLR - not part of turbo algorith, just for stats
    saved_interLLR = [saved_interLLR; output_upper_u];
    
    % Extract Extrinsic information
    ext = output_upper_u - input_upper_u;

    % Measure IE - not part of turbo algorithm, just for stats
    IE = measure_mutual_information(ext, data);
    traj(2*turbo_iter,:) = [IA,IE];    
    
    % Interleave this information, which organizes it in the same manner
    % which the lower decoder sees bits
    input_lower_u = interleave(ext, 0);    
    
    saved_interExt = [saved_interExt; ext];

    % Pass through lower decoder
    [output_lower_u output_lower_c] = SisoDecode( input_lower_u, input_lower_c, genPoly, 0, 0 );
    
    % Interleave LLR - not part of turbo algorithm, we interleave it so we
    % can measure the mutual information, since it needs to match the order
    % of bits in data. 
    interleaved_output_lower_u = interleave(output_lower_u, 0);    
       
    % Save LLR - not part of turbo algorith, just for stats
    saved_outLLR = [saved_outLLR; interleaved_output_lower_u];
    
    % Interleave and extract Extrinsic information
    input_upper_u = interleave( output_lower_u - input_lower_u, 0 );  
    saved_outExt = [saved_outExt; input_upper_u];
    
    % Save IA - not part of turbo algorithm, just for stats
    IA = measure_mutual_information(input_upper_u, data);
    traj(2*turbo_iter+1,:) = [IA,IE];
    
    % Hard decision based on LLR: if < 0 bit is 0, if > 0 bit is 1
    detected_data = (sign(interleaved_output_lower_u) + 1) / 2;
    error_positions = xor( detected_data, data);
    
    %This error vector is not part of the turbo algorith, but printed for
    %your convience. It is based on the known send data compared to what we
    %are receiving
    fprintf('Error Vector = ');
    fprintf('%d ', xor(detected_data, data));
    fprintf('\n');

    % exit if all the errors are corrected
    temp_errors = sum(error_positions);
    
    fprintf('Errors = %d, mean(abs(output LLR)) = %f\n', temp_errors, mean(abs(output_lower_u)));
    totalIts = turbo_iter;   
    
    plot(traj(:,1),traj(:,2));
    
    if (temp_errors==0) && (autostop)
        break;
    else
        errors(turbo_iter) = temp_errors + errors(turbo_iter);              
    end        
end         

figure
plot(saved_interLLR', '*-')
legend('toggle')
title('Intermediate LLR after Each Turbo Iteration vs Bit Position')
xlabel('Bit Number')

figure
plot(saved_interExt', '*--')
legend('toggle')
title('Intermediate Extrinsic Information after Each Turbo Iteration vs Bit Position')
xlabel('Bit Number')

figure
plot(saved_outLLR', '*-')
legend('toggle')
title('LLR after Each Turbo Iteration vs Bit Position')
xlabel('Bit Number')

figure
plot(saved_outExt', '*--')
legend('toggle')
title('Extrinsic Information after Each Turbo Iteration vs Bit Position')
xlabel('Bit Number')

% Combine output_c and puncture
% convert to matrices (each row is from one row of the generator)
upper_reshaped = [ reshape( output_upper_c, N, length(output_upper_c)/N ) ];
lower_reshaped = [ reshape( output_lower_c, N, length(output_lower_c)/N ) ];

fprintf('\n\n');

fprintf('Upper Code Output            = ');
fprintf('%d ', (sign(output_upper_c) + 1)/2);
fprintf('\n');
fprintf('Upper Code Output Systematic = ');
fprintf('%d ', (sign(upper_reshaped(1,:))+1)/2);
fprintf('\n');
fprintf('Upper Code Output Parity     = ');
fprintf('%d ', (sign(upper_reshaped(2,:))+1)/2);
fprintf('\n\n');
fprintf('Lower Code Output            = ');
fprintf('%d ', (sign(output_lower_c)+1)/2);
fprintf('\n');
fprintf('Lower Code Output Systematic = ');
fprintf('%d ', (sign(lower_reshaped(1,:))+1)/2);
fprintf('\n');
fprintf('Lower Code Output Parity     = ');
fprintf('%d ', (sign(lower_reshaped(2,:))+1)/2);
fprintf('\n');

% parallel concatenate
unpunctured_word = [upper_reshaped
    lower_reshaped];

% repuncture
output_decoder_c = Puncture( unpunctured_word, pun_pattern, tail_pattern ); 

detected_data = reshape( detected_data', 1, frame_length);

fprintf('\n\nUnpunctured = ');
fprintf('%d ', (sign(unpunctured_word)+1)/2);
fprintf('\n');

fprintf('Punctured   = ');
fprintf('%d ', detected_data);
fprintf('\n');

offsetV = ones(size(saved_outLLR));
figure
minx = floor(min(min(saved_outLLR)));
maxx = ceil(max(max(saved_outLLR)));
for i = 1:totalIts
    subplot(totalIts, 1, i);
    plot(saved_outLLR(i,:)', zeros(length(saved_outLLR(1,:)')), '.');
    str = sprintf('LLR After Turbo Decoding Iteration %d',i);
    title(str);
    axis([minx maxx -1 1]);
end


