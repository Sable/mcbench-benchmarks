function plaintext = decrypt(ciphertext, key)
    v = vigenere;
    
    % Convert the key and the ciphertext to one-based numeric values;
    % A=1, B=2, etc. SPACE=27
    key = lower(key) - double('a') + 1;
    key(key < 0) = 27;
    ciphertext = lower(ciphertext) - double('a') + 1;
    ciphertext(ciphertext < 0) = 27;

    % Replicate the key so that it is as long as the ciphertext. 
    keyIndex = mod(0:(numel(ciphertext)-1), numel(key))+1;
    k = key(keyIndex);
    
    % Decrypt. Each letter of the key determines a row in the Vigenere
    % square. In that row, find the column index of the corresponding
    % ciphertext letter. Convert the index back to a letter to determine
    % the decrypted character (1=A, 2=B, etc.).
    plaintext = arrayfun(@(m,n) find(v(m,:) == n), k, ciphertext) - 1;
    plaintext(plaintext == 26) = double(' ') - double('a');
    plaintext = upper(char(plaintext + double('a')));