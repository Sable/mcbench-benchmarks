clear all;
close all;
clc;

% demonstrates that monoalphabetic substitution cipher does not break the frequency trend
inText = 'kisskiss';

cipherMode = 'ENC';
dec_encipheredText = caesarCipher( inText, cipherMode );
dec_encipheredText = lower(dec_encipheredText)

cipherMode = 'DEC';
dec_encipheredText = caesarCipher( dec_encipheredText, cipherMode );
dec_encipheredText = lower(dec_encipheredText)