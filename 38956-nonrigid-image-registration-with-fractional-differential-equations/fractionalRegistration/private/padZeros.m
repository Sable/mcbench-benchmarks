function paddedVector = padZeros(inputVector, desiredLength)
%Pads the input vector with zeros or truncates to reach desiredLength.

    lengthDifference = round(desiredLength-numel(inputVector));
    
    if lengthDifference > 0
        paddedVector = [inputVector zeros(1, lengthDifference)];
        
    elseif lengthDifference <= 0
        paddedVector = inputVector(1:desiredLength);
        
    end

end

