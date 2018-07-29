function [num0, vec0] = mydatebod (epoch)
    if isempty(epoch),  num0 = [];  vec0 = [];  return;  end
    if (size(epoch,2) == 1)
        % epoch is in mydatenum format
        num = epoch;
        vec = mydatevec(num);
    else
        % epoch is in mydatevec format
        vec = epoch;
    end
    %% define the epoch corresponding to the beginning to that day:
    vec0 = vec(:,1:3);
    num0 = mydatenum(vec0);
end

