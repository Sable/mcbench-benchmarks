function done = mission7(occupiers, target)

for i = 1:6
    if any(occupiers{i} == target)
        done = false;
        return
    end
end

done = true;