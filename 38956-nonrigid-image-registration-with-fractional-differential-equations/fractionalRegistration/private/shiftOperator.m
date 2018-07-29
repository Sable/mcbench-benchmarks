function shiftedOperator = shiftOperator(operatorVector)
%Shifts a symmetric operator by half its length so that middle -> front.
%
%Given an operator vector, this function shifts it so that all values are
%"rotated" through, causing the middle element to become the first, and the
%second element to become the last.

    %Intializers
    halfLength = round(numel((operatorVector)-1)/2);
    endLength = numel(operatorVector);
    shiftedOperator = zeros(1, endLength);

    %Constructs the shifted operator.
    firstHalf = fliplr(operatorVector(1:halfLength));
    shiftedOperator(1:halfLength) = firstHalf;

    secondHalf = fliplr(operatorVector(halfLength+1:endLength));
    shiftedOperator(halfLength+1:endLength) = secondHalf;

end
