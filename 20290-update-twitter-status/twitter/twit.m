function [status, result] = twit(msg, oauth_consumer_key, ...
            oauth_consumer_secret, oauth_token, oauth_token_secret)
%TWIT Update your status at twitter.com
%   [status, result] = twit(message, consumer_key, ...
%                                    consumer_secret,...
%                                    oauth_token, ...
%                                    oauth_token_secret)
%   updates Twitter(R) status with message for the account with the given
%   credentials. In order to get the oauth credentials consumer_key,
%   consumer_secret, oauth_token and oauth_token_secret which are input to 
%   this function you need to register an application with twitter. You can
%   register a new application with twitter at
%   http://dev.twitter.com/apps/new. Register an application after logging
%   into twitter with the account you are planning to update using this
%   script. After registering an application you will be able to get
%   "Consumer key" and "Consumer secret" on your application details page.
%   You can get to this page by visiting http://dev.twitter.com and
%   choosing "Your apps" from the links at the top of the page. On the
%   right side of your application page there is a link to "My Access
%   Token". On that page you will be able to get "Access Token"
%   (oauth_token) and "Access Token Secret" (oauth_token_secret). With
%   these four tokens you will be able to update your twitter status using
%   this script. You will also be able retrieve these tokens at anytime by
%   visiting http://dev.twitter.com/apps. You should treat your access
%   tokens like password and keep them safe to avoid misuse.
%   
%   Example data for Registering an application
%   Application Name: twit MATLAB(R) Script
%   Description: twit.m is a MATLAB script to update twitter status from
%                MATLAB programming environment.
%   Application Website: http://www.mathworks.com/matlabcentral/fileexchange/20290-update-twitter-status
%   Organization: <Your organization> (You can leave this blank if not needed)
%   Application Type: Client
%   Default Access Type: Read & Write
%   Application Icon: <Upload optional image file>
%
%   The script returns status, which is true if there was no error and
%   result which is the JSON format response from twitter.com.
%
%   [status, result] = twit(message) updates the status with message for
%   the credentials which was set using the twitpref function. twitpref
%   function opens a small GUI to ask for consumer_key, consumer_secret,
%   oauth_token and oauth_token_secret and stores them as persistent
%   variables. twit function gets those values from twitpref. This avoids
%   the tokens from showing up in the console and in command history.
%
%   An example use for this function would be to update the status
%   periodically from a long, time consuming computation and follow its
%   status from anywhere.
%
%   This function and its connection may not be secure. So use it at your
%   own risk.
%
%   See also twitpref.

%   Copyright 2008-2010 The MathWorks, Inc.
%   Author: Navan Ruthramoorthy

if nargin == 1
    [oauth_consumer_key, oauth_consumer_secret, ...
          oauth_token, oauth_token_secret] = twitpref(1);
    if isempty(oauth_consumer_key)
      error('twit:credentialsnotset', ...
        ['Consumer key is not set. Use twitpref function to set ' ...
         'access tokens.']);
    end
end

if length(msg) > 140
    warning('twit:msgtruncation', ...
        'Message length is longer than 140 characters and is truncated.');
    msg = msg(1:140);
end

import java.io.*;
import java.net.*;
import javax.crypto.*;
import javax.crypto.spec.*;
import com.mathworks.mlwidgets.io.InterruptibleStreamCopier;

url = URL('http://api.twitter.com/1/statuses/update.json');
httpConn = url.openConnection();
httpConn.setUseCaches (false);
httpConn.setRequestMethod('POST');
httpConn.setRequestProperty('Content-Type', 'application/x-www-form-urlencoded');

oauth_timestamp = int2str((java.lang.System.currentTimeMillis)/1000);
oauth_nonce = getNonce();
msgEncodedStr = urlEncode(msg);
urlEncodedStr = urlEncode(url.toString());
postStr = ['oauth_consumer_key%3D' oauth_consumer_key '%26oauth_nonce%3D' ...
           oauth_nonce '%26' 'oauth_signature_method%3DHMAC-SHA1%26' ...
           'oauth_timestamp%3D' oauth_timestamp '%26oauth_token%3D' ...
           oauth_token '%26oauth_version%3D1.0%26status%3D' ...
           urlEncode(msgEncodedStr)];
signStr = ['POST&' urlEncodedStr '&' postStr];

signKey = [oauth_consumer_secret '&' oauth_token_secret];
oauth_signature = doHMAC_SHA1(signStr, signKey);

auth_str = ['OAuth oauth_nonce="' oauth_nonce '", ' ...
            'oauth_signature_method="HMAC-SHA1", ' ...
            'oauth_timestamp="' oauth_timestamp '", ' ...
            'oauth_consumer_key="' oauth_consumer_key '", ' ...
            'oauth_token="' oauth_token '", ' ...
            'oauth_signature="' urlEncode(oauth_signature) '", ' ...
            'oauth_version="1.0"'];
httpConn.setRequestProperty('Authorization', (auth_str));

msgEncodedStrforPost = ['status=' msgEncodedStr];
httpConn.setRequestProperty('CONTENT_LENGTH', num2str(length(msgEncodedStrforPost)));
httpConn.setDoOutput(true);
outputStream = httpConn.getOutputStream;
outputStream.write(java.lang.String(msgEncodedStrforPost).getBytes());
outputStream.close;

try
  inputStream = httpConn.getInputStream;
catch ME
  throwError(ME.message);
end
byteArrayOutputStream = java.io.ByteArrayOutputStream;
% This StreamCopier is unsupported and may change at any time.
isc = InterruptibleStreamCopier.getInterruptibleStreamCopier;
isc.copyStream(inputStream,byteArrayOutputStream);
inputStream.close;
byteArrayOutputStream.close;

result = byteArrayOutputStream.toString('UTF-8');
status = isempty(strfind(result, '"error"'));

end
%-------------------------------------------------------------------------------
function throwError(msg)
  if strfind(msg, '401')
    error('twit:NotAuthorized', 'Authentication details were not correct.');
  elseif strfind(msg, '400')
    error('twit:BadRequest', 'You might have possibly exceeded rate limit.');
  else
    error('twit:ConnectionError', ...
      [msg 10 ...
      'Check ' ...
      'http://dev.twitter.com/pages/responses_errors' ...
      ' for the error code.'])
  end
end
%-------------------------------------------------------------------------------
function signStr = doHMAC_SHA1(str, key)
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
end
%-------------------------------------------------------------------------------
function oauth_nonce = getNonce
 oauth_nonce = strrep([num2str(now) num2str(rand)], '.', '');
end
%-------------------------------------------------------------------------------
function encodedStr = urlEncode(str)
import java.net.*;
  encoded = URLEncoder.encode(str, 'UTF-8');
  encodedStr = (encoded.toCharArray())';
  encodedStr = strrep(encodedStr, '+', '%20');
end
