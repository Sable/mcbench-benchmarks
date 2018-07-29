function done = mission3(occupiers, player)

captured = zeros(1,6);
for i = 1:6
    captured(i) = all(occupiers{i} == player);
end

done = captured(2) && captured(4);