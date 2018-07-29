function signStr = doHMAC_SHA1(str, key)
% DOHMAC_SHA1 Return the base64-encoded HMAC-SHA1 signature of the STR
% using the KEY.
%
% Taken by K. Karapetyan without modifications from the TWIT.M function of
% "Update twitter status" by Navan Ruthramoorthy of (c) Mathworks, 2008-2010.
%
% EXAMPLE:  
%   doHMAC_SHA1('The quick brown fox jumps over the lazy dog','key')
% returns 
%   3nybhbi3iqa8ino29wqQcBydtNk=
% Using base64toHex, this can be converted to a hex string:
%   base64toHex('3nybhbi3iqa8ino29wqQcBydtNk=')
% returns
%   de7c9b85b8b78aa6bc8a7a36f70a90701c9db4d9
% Compare to http://en.wikipedia.org/wiki/HMAC#Examples_of_HMAC_.28MD5.2C_SHA1.2C_SHA256_.29
%
% 

import java.net.*;
import javax.crypto.*;
import javax.crypto.spec.*;
import org.apache.commons.codec.binary.*

algorithm = 'HmacSHA1';
keyStr = java.lang.String(key);
key = SecretKeySpec(keyStr.getBytes(), algorithm);
mac = Mac.getInstance(algorithm);
mac.init(key);
toSignStr = java.lang.String(str);
bytes = toSignStr.getBytes();
signStr = java.lang.String(Base64.encodeBase64(mac.doFinal(bytes)));
signStr = (signStr.toCharArray())';
signStr = strrep(signStr, '\n', '');
signStr = strrep(signStr, '\r', '');
