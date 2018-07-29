function Viterbi_dec(Eb_No, G_d)

global parent_states
global ordered_outputs
global corres_info
global num_states

% This decoder and encoder is designed only for rate 1/2 codes, and can
% be used with any rate 1/2 feed forward convolution code with 2 delay
% elements
if min(size(G_d)) > 1,
    disp('This decoder/encodor not designed for higher rates than 1/2');
    return;
end

num_states = 4;
parent_states = {[1,3], [1,3], [2,4], [2,4]}; % structure of TRELLIS
ordered_outputs = zeros(num_states*2,2);
req_dumm = conv_encoder([0,0,0,0,0,1,0,1,0,0,1,1,1,0,0,1,0,1,1,1,0,1,1,1],G_d);
ind = 5;
for i = 1:num_states*2
    ordered_outputs(i,:) = 2*req_dumm(ind:ind+1)-1;
    ind = ind + 6;
end

corres_info = [0,0;1,1;0,0;1,1]; % structure of TRELLIS

n_sim = 1e3;
block_len = 1000;
len_Eb_No = length(Eb_No);
BER_vit_sim_word = zeros(1,len_Eb_No);
BER_vit_sim_bit = zeros(1,len_Eb_No);
BER_vit_the_word = zeros(1,len_Eb_No);
BER_vit_the_bit = zeros(1,len_Eb_No);
for i = 1:len_Eb_No
    tic
    error = 0;
    n_err = 0;
    for j = 1:n_sim
        info_word = rand(1,block_len)>0.5;
        conv_bits = conv_encoder(info_word, {[1,0,1], [1,1,1]});
        len_code = length(conv_bits);
        BPSK_encoded_bits = 2*conv_bits - 1;
        received_word = BPSK_encoded_bits + randn(1, len_code) * sqrt(1/(2*10^(Eb_No(i)/10)));
        decoded_info_word = viterbi_decoder(received_word);
        number_of_err = sum(abs(decoded_info_word - info_word));
        n_err = n_err + number_of_err;
        if number_of_err > 0, error = error + 1;end
    end   
    BER_vit_sim_word(i) = error / n_sim;
    BER_vit_sim_bit(i) = n_err / n_sim / block_len;
    for the = 0:20
        BER_vit_the_word(i) = BER_vit_the_word(i) + block_len*(2^the) * ...
            qfunc(sqrt(2*(the+5)*10^(Eb_No(i)/10)));
        BER_vit_the_bit(i) = BER_vit_the_bit(i) + (the+1)*(2^the) * ...
            qfunc(sqrt(2*(the+5)*10^(Eb_No(i)/10)));
    end
    fprintf('Simulation done for SNR = %f and time taken = %f\n', Eb_No(i), toc);
end
assignin('base', 'BER_the_w', BER_vit_the_word);
assignin('base', 'BER_the_b', BER_vit_the_bit);
assignin('base', 'BER_sim_w', BER_vit_sim_word);
assignin('base', 'BER_sim_b', BER_vit_sim_bit);


function info_decoded = viterbi_decoder(x)

global parent_states
global ordered_outputs
global corres_info
global net_weight_at_each_state
global dist_P1
global dist_P2

len_info = length(x)/2;

net_weight_at_each_state = [0;Inf;Inf;Inf]; % Initialization
d1 = (repmat(ordered_outputs(1:4,1),1,len_info) - repmat(x(1:2:end),4,1)).^2;
d2 = (repmat(ordered_outputs(1:4,2),1,len_info) - repmat(x(2:2:end),4,1)).^2;
dist_P1 = d1 + d2;
d1 = (repmat(ordered_outputs(5:8,1),1,len_info) - repmat(x(1:2:end),4,1)).^2;
d2 = (repmat(ordered_outputs(5:8,2),1,len_info) - repmat(x(2:2:end),4,1)).^2;
dist_P2 = d1 + d2;
sec_info = zeros(4, len_info+1);

for i = 1:len_info
    [sec_info_colm] = compute_min_distance(i);
    sec_info(:,i+1) = sec_info_colm;
end

info_decoded = zeros(1,len_info);

min_wt = min(net_weight_at_each_state);
min_state = find(net_weight_at_each_state == min_wt);
if length(min_state) > 1, 
    disp('error_gg');
    return;
end

for i = len_info:-1:1
    
    parents = parent_states{min_state};
    parent_ind = sec_info(min_state, i+1);
    required_parent = parents(parent_ind);
    info_decoded(i) = corres_info(min_state,parent_ind);
    min_state = required_parent;
end


function [sec_info_colm] = compute_min_distance(current_ind)

global net_weight_at_each_state
global dist_P1
global dist_P2

T1 = [1,1,2,2];
T2 = [3,3,4,4];
A1 = net_weight_at_each_state(T1) + dist_P1(:,current_ind);
A2 = net_weight_at_each_state(T2) + dist_P2(:,current_ind);
[net_weight_at_each_state,sec_info_colm] = min([A1,A2],[],2);


function code = conv_encoder(x, G_d)
size_G_d = size(G_d);
len_x = length(x);
if min(size_G_d) > 1
    fprintf('The encoder is not designed for higher rates than 1/2\n');
    return;
end
code = zeros(1,size_G_d(2)*len_x);
index = 1;
for i = 1:len_x
    for j = 1:size_G_d(2)
        xor_output = [];
        for k = 1:length(G_d{j})
            if G_d{j}(k) == 0, continue;end
            if i-k < 0, 
                xor_input = 0;
            else
                xor_input = x(i-k+1);
            end
            if isempty(xor_output),
                xor_output = xor_input;
            else
                xor_output = xor(xor_output, xor_input);
            end
        end
        code(index) = xor_output;
        index = index + 1;
    end
end