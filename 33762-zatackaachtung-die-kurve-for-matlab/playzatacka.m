function playzatacka(N,M)
% N = number of players
% M = number of games (first to M)
score = zeros(1,N);

while ~any(score==M)
    winner = zatacka(N);
    score(winner) = score(winner) + 1;
end

msgbox(sprintf('Player %d wins!\nFinal Score: %s',find(score==M), num2str(score)))
