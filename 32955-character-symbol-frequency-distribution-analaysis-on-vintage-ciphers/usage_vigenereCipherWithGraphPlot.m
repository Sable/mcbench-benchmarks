clear all;
close all;
clc;

% demonstrates that monoalphabetic substitution cipher does not break the frequency trend
%inText = 'helloworld';
rowPlotSize = 3;
colPlotSize = 1;
plotIndex = 0;

inputFileFolder = 'inputFiles';
fileTarget = 'email5.txt';       % caveat: for vigenere cipher, numbers, symbols is not considered.
fileTarget = strcat(inputFileFolder, '\', fileTarget);

inText = textread(fileTarget, '%s', 'whitespace', '');
inText = char(inText);
inText = regexprep(inText,'[^\w'']',''); % without whitespace
inText = lower(inText);

key = 'aaa';    % bad pass
key = 'abcd';    % shorter pass
%key = 'zxcvbnbnmlongerpassasdfghjklpoiuytreeeljhgf'; % longer pass: it shows that the distribution is flatten

cipherMode = 'ENC';
dec_encipheredText = vigenereCipher( inText, key, cipherMode );
dec_encipheredText = lower(dec_encipheredText);

plotIndex = plotIndex + 1;
subplot(rowPlotSize, colPlotSize, plotIndex);
plotCharDistributionFreq( dec_encipheredText, 'ENCRYPTED CONTENTS' );
title('Vigenere Ciphered text');

cipherMode = 'DEC';
dec_encipheredText = vigenereCipher( dec_encipheredText, key, cipherMode );
dec_encipheredText = lower(dec_encipheredText);

plotIndex = plotIndex + 1;
subplot(rowPlotSize, colPlotSize, plotIndex);
plotCharDistributionFreq( dec_encipheredText, 'DECRYPTED CONTENTS' );
title('Plaintext text');

plotIndex = plotIndex + 1;
subplot(rowPlotSize, colPlotSize, plotIndex);
plotCharDistributionFreqDiff( dec_encipheredText );
title('Distribution difference');