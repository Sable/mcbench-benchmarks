function permutations = generate_permutations(ranges)

% This function takes as an input an array containing the maximum value of
% each participating in the permutation element. It returns an array,
% containing the permutations of these elements. Each element changes its
% value from 1 to the maximum value of the element defined in
% ranges(element).
%
% It is called as follows:
%
% [permutations] = generate_permutations(ranges)

% © Nedyalko Petrov, University of Portsmouth, UK
% email: nedyalko.petrov@port.ac.uk

numberOfElements = length(ranges);
change_every(numberOfElements) = 1;

% Find the overall count of permutations and the count of permutations
% after which the value of the current element changes.
for i = numberOfElements : -1 : 1
    if i>1
        change_every(i-1) = change_every(i) * ranges(i);
    else
        permutationsCount = change_every(i) * ranges(i);
    end
end

% Generate the current permutation
currentValues = ones(numberOfElements,1);
for i = 1 : permutationsCount
    currentPermutation = [];
    for j = 1 : numberOfElements
        currentPermutation(1,j) = currentValues(j);
    end
    permutations{i} = currentPermutation;

    % Change the element values for the next permutation
    loop = true;
    currentElement = numberOfElements;

    while loop
        if currentValues(currentElement) >= ranges(currentElement) && i < permutationsCount
            currentValues(currentElement) = 1;
            currentElement = currentElement - 1;
        else
            currentValues(currentElement) = currentValues(currentElement) + 1;
            loop = false;
        end
    end
end




