function done = mission6(occupiers, player)

total = 0;
for i = 1:6
    total = total + sum(occupiers{i} == player);
end

done = total >= 24;