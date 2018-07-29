function dec_encipheredText = caesarCipher( inText, cipherMode )
%CAESARCIPHER Summary of this function goes here
%   Detailed explanation goes here

cipherModeChoices = {'ENC', 'DEC'};
caesarShiftDefault = 3;
whiteSpaceValue = 32;
offsetAsciiCharValue = 65;

charContents = upper(inText);       % with whitespace
charContents = regexprep(charContents,'[^\w'']',''); % without whitespace
numberOfChar = length(charContents);  

% convert to decimal value
for i = 1:numberOfChar
    charContentsInDec(i) = charContents(i) - 0 - offsetAsciiCharValue;  % ascii to number
end

if (strcmp(upper(cipherMode), char(cipherModeChoices(1))))
    % Encrypt
    charContentsInDec = mod((charContentsInDec + caesarShiftDefault), 26);
else
    % Decrypt
    charContentsInDec = mod((charContentsInDec - caesarShiftDefault), 26);    
end

dec_encipheredText = char(charContentsInDec + offsetAsciiCharValue);

end
