%%
% Purpose: 
% 
% This algorithm decrypts and encrypts images based on keys
% 
% INPUTS:
% 
% 
% 
% imMat: If the nargin is one, imMat is the filename of the image which
% you would like to encrypt. If the nargin is 4, imMat is the encrypted
% matrix 
%
% key1, key2, key3: These are number values used to encrypt and decrypt
% images.
% key3 and key2 and key1 can be left blank if the nargin is one and  you would like
% the computer to make the keys for you. if the nargin is 4 key1 is
% a vector at baseto that is the encrypted vector of the original random numbers.
% key2 is the base of the original vector (baseKey) **Please
% read the help section of baseVecExpand.
% 
% OUTPUTS:
%
% cryptPic: If the nargin = 1, cryptPic is a matrix of encrypted
% numbers representing an encrypted image. If the nargin = 4, imMat
% is a uint8 array which is a decrypted image. This function will also
% display the decrypted image. 
%
% keyVec: If the nargin = 1, the computer will use the random number generator to
% make three keys. These three keys are then changed to a random base, baseto
% using baseVecExpand. The starting base is baseKey. 
% keyVec is a vector containing the  key vector at baseto. if nargin = 4,
% keyVec is not returned
%
% baseKey: If the nargin = 1 baseKey is the base of the
% original vector. please read the help section of baseVecExpand. baseKey
% is not returned if the nargin = 4. 
%
% COMMENTS: 
%
% Please change the formulas used to encrypt and decrypt the images into
% your own unique formulas so that nobody can see your images. 
function [cryptPic keyVec baseto baseKey] = picCrypt(imMat,key,key2,key3)
if nargin == 1
   key = rand;
   key2 = rand;
   key3 = rand;
   baseto = rand*1000;
   baseKey = max(floor(1000000*[key key2 key3])) + rand*100;
   keyVec = baseVecExpand(floor(1000000*[key key2 key3]),baseKey,baseto);
   pic = 10000*im2double(imread(imMat));
   cryptPic = ((floor(pic)/key2).^key)+key3;
   imagesc(im2uint8(cryptPic));
   axis equal;
   axis tight;
elseif nargin == 4
   key10 = baseVecExpand(key,key3,key2)/1000000;
   cryptPic = im2uint8(((imMat - key10(3)).^(1/key10(1))*key10(2))/10000); % CHANGE THIS FORMULA (this is the opposite of the formula above
   imagesc(cryptPic);
   axis equal;
   axis tight;  
else
    error('You must enter the correct number of parameters');
end