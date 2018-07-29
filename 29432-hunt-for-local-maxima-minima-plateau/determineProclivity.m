function proclivity = determineProclivity( currentInput, previousInput )
%DETERMINEPROCLIVITY determine plateau, acclivity, declivity

proclivityModes = {'plateau', 'ascent', 'descent'};

if (currentInput == previousInput)
    proclivity = proclivityModes(1);
elseif (currentInput > previousInput)
    proclivity = proclivityModes(2);
else % 
    proclivity = proclivityModes(3);
end

proclivity = char(proclivity);

end

