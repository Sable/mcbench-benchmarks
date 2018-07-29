clear all;
close all;
clc;

% demonstrates that monoalphabetic substitution cipher does not break the frequency trend
%inText = 'helloworld';
rowPlotSize = 3;
colPlotSize = 1;
plotIndex = 0;

inputFileFolder = 'inputFiles';
fileTarget = 'email2.txt';
fileTarget = strcat(inputFileFolder, '\', fileTarget);

inText = textread(fileTarget, '%s', 'whitespace', '');
inText = char(inText);

cipherMode = 'ENC';
dec_encipheredText = caesarCipher( inText, cipherMode );
dec_encipheredText = lower(dec_encipheredText);

plotIndex = plotIndex + 1;
subplot(rowPlotSize, colPlotSize, plotIndex);
plotCharDistributionFreq( dec_encipheredText, 'ENCRYPTED CONTENTS' );
title('Caesar Ciphered text');

cipherMode = 'DEC';
dec_encipheredText = caesarCipher( dec_encipheredText, cipherMode );
dec_encipheredText = lower(dec_encipheredText);

plotIndex = plotIndex + 1;
subplot(rowPlotSize, colPlotSize, plotIndex);
plotCharDistributionFreq( dec_encipheredText, 'DECRYPTED CONTENTS' );
title('Plaintext');

plotIndex = plotIndex + 1;
subplot(rowPlotSize, colPlotSize, plotIndex);
plotCharDistributionFreqDiff( dec_encipheredText );
title('Frequency difference');