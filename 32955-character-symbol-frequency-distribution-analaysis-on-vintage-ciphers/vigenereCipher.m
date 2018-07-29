function dec_encipheredText = vigenereCipher( inText, key, cipherMode )
%VIGENERECIPHER 
cipherModeChoices = {'ENC', 'DEC'};

% generate the vigenereTable
for i = 0:25
    charAtoZ(i+1) = char('a' + i);
end

for i = 0:25
    vigenereTable(i+1,:) = circshift(charAtoZ, [1 -i]); % -ve for left shift
end

    textToBeCiphered = inText;
    length_textToBeCiphered = length(textToBeCiphered);
    length_key = length(key);

    % pad the key to be the same length as textToBeCiphered
    for i = 1:length_textToBeCiphered
        if (mod(i, length_key) ~= 0)
            keyPadded(i) = key(mod(i, length_key));           ; % assume key is shorter than text
        else
            keyPadded(i) = key(end);
        end
    end 
    
    offsetAsciiCharValue = 65;
    charContents = textToBeCiphered;

    % convert to decimal value
    for i = 1:length_textToBeCiphered
        charContentsInDec(i) = charContents(i) - 0 - offsetAsciiCharValue;  % ascii to number
    end
    
offsetForIndexing = 31;
charContentsInDec_TextIndex = charContentsInDec - offsetForIndexing; % row-wise index

charContents = keyPadded;

for i = 1:length_textToBeCiphered % equal to key length
    charContentsInDec(i) = charContents(i) - 0 - offsetAsciiCharValue;  % ascii to number
end

charContentsInDec_KeyIndex = charContentsInDec - offsetForIndexing; % column-wise index       

if (strcmp(upper(cipherMode), char(cipherModeChoices(1))))
    % Encrypt
    
    % ENC : C(i) = (M(i) + K(i) ) mod 26
    for i = 1:length_textToBeCiphered
        encodedMessage(i) = vigenereTable(charContentsInDec_TextIndex(i), charContentsInDec_KeyIndex(i));
    end    
    
    dec_encipheredText = encodedMessage;
else
    % Decrypt
    % DEC (use key to scan downwards) : M(i) = (C(i) - K(i) ) mod 26
    encodedMessage = inText;
    for i = 1:length_textToBeCiphered
        decodedMessage(i) = findstr(vigenereTable(:, charContentsInDec_KeyIndex(i))', encodedMessage(i));
    end 
    
    recoveredText = char(decodedMessage + offsetForIndexing + offsetAsciiCharValue);
    dec_encipheredText = recoveredText;
end


end
