function ciphertext = encrypt(plaintext, key)
    v = vigenere;
    
    % Squeeze out everything except letters and the space character
    exclude = regexp(plaintext, '[^a-zA-Z ]');
    plaintext(exclude) = [];
    
    % Make the key and the plaintext lower case, and convert to 
    % numeric values. 
    key = lower(key) - double('a') + 1;
    key(key < 0) = 27;
    plaintext = lower(plaintext) - double('a') + 1;
    plaintext(plaintext < 0) = 27;
    
    % Replicate the key so that it is as long as the plaintext. 
    keyIndex = mod(0:(numel(plaintext)-1), numel(key))+1;
    k = key(keyIndex);
    
    % Encrypt: C(m,n) = V(k(j), plaintext(j))
    ciphertext = arrayfun(@(m,n) v(m,n), k, plaintext) - 1;
    ciphertext(ciphertext == 26) = double(' ') - double('a');
    ciphertext = upper(char(ciphertext + double('a')));
    
    
    