clear all;
clc;

textToBeCiphered = 'computinggivesinsight';
inText = textToBeCiphered;
key = 'lucky';

encodedMessage = vigenereCipher( inText, key, 'ENC' );
% encoded message: niozsecpqetpgcgymkqfe
decodedMessage = vigenereCipher( encodedMessage, key, 'DEC' );
