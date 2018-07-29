function [condvects] = getcondvects(i)
    % GETCONDVECTS returns a matrix of binary condition vectors.
    % GETCONDVECTS(I) returns a matrix of all possible binary condition
    % vectors for a logical system with (I) inputs.
    % INPUT: (I) shall be an integer >= 1
    % OUTPUT: CONDVECTS is a binary matrix of size [2^I,I]
    % METHOD: The method uses three nested FOR loops that work to target
    % only those cells whose value should be true (which of course is 50%
    % of the matrix).  Therefore, the algorithm scales as [0.5*i*2^i]
    % which is optimal.  Furthermore, the algorithm has low memory
    % footprint and overhead.
    % Copyright 2011, Paul Metcalf
    % Acknowledgements: James Tursa and Nico Schlömer
    
    g = 2;
    i2 = 2^i;
    condvects = false(i2,i);
    for m = 1 : 1 : i
        m2 = 2^m;
        m3 = (m2/2)-1;
        i3 = i-m+1;
        for g = g : m2 : i2
            for k = 0 : 1 : m3
                condvects(g+k,i3) = true;
            end
        end
        g = m2+1;
    end
end