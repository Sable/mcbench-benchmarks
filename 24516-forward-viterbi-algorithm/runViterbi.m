% Viterbi Example from http://en.wikipedia.org/wiki/Viterbi_algorithm
states = {'Rainy', 'Sunny'};

%    walk,shop,clean,walk
obs = [1,2,3,1];

%       Rainy  Sunny
start_p = [0.6,0.4];

%       Rainy  Sunny
trans_p = [0.7, 0.3; %transitions from Rainy
           0.4,0.6]; %transitions from Sunny

%      walk  shop  clean
emit_p = [0.1,0.4,0.5; %emissions from Rainy
          0.6,0.3,0.1]; %emissions from Sunny

%Pr(obs)  path   Pr(path)
[total, argmax, valmax] = forward_viterbi(obs,states,start_p,trans_p,emit_p);