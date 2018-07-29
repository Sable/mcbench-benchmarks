%% Flickr API with OAuth-based user authentication
% Matlab implementation of Flickr-compatible OAuth 
%
% *NOTE* The |input| command necessary for this script is not compatible
% with Matlab's publishing functions. Therefore I cannot publish with code
% evaluation and give the full output in the end of the text. 
%% Introduction
% 
% OAuth (Open Authorization, http://en.wikipedia.org/wiki/OAuth) is used by
% Flickr when user authorisation is required. For example when an
% application is trying to access user's private photos. OAuth is decribed
% in http://oauth.net/core/1.0a/. The use of OAuth with Flickr is described
% in  http://www.flickr.com/services/api/auth.oauth.html. 
%
% For many programming
% languages ready-to-use implementations are available
% (http://www.flickr.com/services/api/). Here I show how to implement
% Flickr API OAuth authentication in Matlab. 
%
% This tutorial can be also used by developers in other languages since
% Matlab is very easy to read, and I concentrate on Flickr requirements to
% OAuth implementation rather than on specific programming techniques. 
%
% The Flickr explanation of the process is rather hard to understand.
% Besides in lacks some important details. This work could not 
% succeed without helpful hints from Sam Judson on
% http://www.flickr.com/groups/api/discuss/ 
%
% (cc-by) Konstantin Karapetyan, 2011. kotya.karapetyan@gmail.com

clc, clear

%% Application identification
% All programs using Flickr API should first be registered with Flickr.
% When a developer registeres an app, Flickr assigns a unique application
% key to it and a secret key to sign requests. The app key is sent to
% Flickr with each request. If some app misuses Flickr services, Flickr
% can block its key. The keys used in this 
% tutorial have been assigned by Flickr to develop the Flickr-Matlab
% interface. 
appKey = '81952f22048626bf3dbd092230d7dc2d';
appSecret = '9323f25452d2d984';
%%
% Use it to go through the tutorial but if you want to play
% further *please register an app with Flickr and use your own keys.*
% Getting keys from Flickr is fast and free. It can be done here:
% http://www.flickr.com/services/api/ > API Keys.

%% Non-authorised call
% Let's start by executing a Flickr API command without user
% authorisation. As an example we use the |flickr.photos.search| command.
cmd = ['method=flickr.photos.search'...
    '&api_key=' appKey ...
    '&min_upload_date=2011-12']; 
response = urlread(['http://api.flickr.com/services/rest/?' cmd]);
disp('NONAUTHORISED CALL, PUBLIC PHOTOS')
disp(response)
%%
% This returns some of the public photos uploaded to Flickr after 1
% December 2011, grouped into pages. Note that |ispublic| equals unity for
% all listed photos. It also shows the total number of photos found with
% this search command.
%
% Now let's request some private photos. I will use
% my personal Flickr ID.
cmd = [cmd '&user_id=59678302%40N04'];
response = urlread(['http://api.flickr.com/services/rest/?method=' cmd]);
disp('NONAUTHORISED CALL, PRIVATE PHOTOS')
disp(response)
%%
% The value of  |total| is now zero, since I do not have any public photos,
% as of December 2011.
%
%% How Flickr authorisation works
% In order to access private data on Flickr with an application using 
% Flickr API, the user should log in to Flickr and authorise the
% application.  
%
% The authorisation chain looks like this
%
% # User runs the app.
% # The app contacts Flickr and gets a request token from it.
% # Using the request token, the app sends the user to a special
% authorisation page of Flickr. In this page Flickr notifies the user that
% a particular app asks for her authorisation to access her data. If the
% user agrees, there is a string (verifier) displayed on the page, which
% the user should then copy and paste into the app.
% # The app sends the verifier pasted by the user to Flickr to confirm that
% authorisation has been granted.
% # Flickr sends an access token to the app. 
% # The access token can be stored by the app and used for all
% future interaction with Flickr on behalf of this user. If the user does
% not want the app to use her authorisation any more, she can always revoke
% it in her Flickr profile.
% # Using the access token, the app sends requests to Flickr on
% behalf of the user.
%
% Each app request sent to Flickr is stamped with UTC time in Unix epoch,
% which is equal to the number of seconds passed since 1 January 1970 00:00
% GMT, and a unique random string called  _nonce._ 
timestamp = num2str(round(java.lang.System.currentTimeMillis / 1000)); 
nonce = lower(dec2hex(round(rand*1e15))); 
%%
% Note that all parameters are passed to Flickr in the form of strings.
%
% The request, including the URL to which it is sent, all
% request parameters, timestamp, and nonce, is signed using the HMAC-SHA1
% algorithm (http://en.wikipedia.org/wiki/HMAC). This signature algorithm
% involves a key, which is composed of the app secret key (provided by
% Flickr to the app developer) and the token secret key (provided by Flickr
% to the app during the authorisation process). 
%
% Let's go through the whole process.
%% Request token
% First, the program should connect to Flickr and mention that it's about
% to receive authorisation from an authenticated user to access her private
% data. In return, Flickr gives the program a _request token_.
%
% The request string is
requestString = ['http://www.flickr.com/services/oauth/request_token' ...
    '?oauth_nonce=' nonce ... % random string to identify request
    '&oauth_timestamp=' timestamp ... % timestamp in Unix epoch
    '&oauth_consumer_key=' appKey ...
    '&oauth_callback=oob' ... % request by an application, not a web-site
    '&oauth_signature_method=HMAC-SHA1'
    ];
%%
% and there will also be a signature added to it.
%% OAuth signature
% Signing is performed using an HMAC-SHA1 algorithm. Since Flickr has to
% verify the signature, it should exactly know the string which is signed.
% Any change, even of a single character position, in the signed string
% leads to a complete change of the signature. Therefore there are strict
% rules about how to build a string to be signed, the so called  _base
% string._ The base string for a request should start with |GET| followed
% by |&| and the command URL, also followed by |&|, i.e. in our case:
baseString = ['GET&' ...
    urlencode('http://www.flickr.com/services/oauth/request_token') '&'];
%%
% Note that all unsafe strings should be url-safe encoded. 
%
% Then follow all
% parameters, ordered alphabetically and separated by &.
parameters = ['oauth_callback=oob&oauth_consumer_key=' appKey ...
    '&oauth_nonce=' nonce '&oauth_signature_method=HMAC-SHA1' ...
    '&oauth_timestamp=' timestamp];
parameters = urlencode(parameters);
parameters = strrep(parameters, '+', '%20'); % correction for url-safe
baseString = [baseString parameters];
%%
% The base string should now be signed with a key. The key is normally
% composed from the secret key of the application and the secret key
% obtained during authorisation, separated with |&|. We do not have the
% second key yet, so the encryption key is just:
key = [appSecret '&'];
signature = urlencode(doHMAC_SHA1(baseString, key));
%%
% I am using a function from Navan Ruthramoorthy's "Update Twitter Status"
% submission (http://www.mathworks.com/matlabcentral/fileexchange/20290).
% This function, in turn, is just using Java's encryption functionality,
% called directly from Matlab.
%
% Finally, we add the signature to the request string and submit it to
% Flickr:
requestString = [requestString '&oauth_signature=' signature];
response = urlread(requestString);
disp('REQUEST TOKEN')
disp(response)
%%
% If everything works fine, Flickr returns three values:
% |oauth_callback_confirmed=true|, |oauth_token| and |oauth_token_secret|.
% Let's get them out of the response string.
respSplit = regexp(response, '&', 'split');
confirmed = regexp(respSplit{1}, '=', 'split');
assert(strcmpi(confirmed{2}, 'true'));
responseToken = regexp(respSplit{2}, '=', 'split');
responseSecret = regexp(respSplit{3}, '=', 'split');
requestToken = responseToken{2};
requestSecret = responseSecret{2};
%% 
% The contact with Flickr is established. Now it's time to ask the user to
% authorise our application.
%% Authorisation
% This step is very simple. All we need to do is to show the user a special
% Flickr page. In this page, Flickr will tell the
% user that our app (which is recognised by Flickr by the just received
% request token) asks for her authorisation to access her private data. 
% If the user agrees, she will be given a secret string, which she should
% then provide back to the program.
%
% The URL to use at this step is
% |http://www.flickr.com/services/oauth/authorize| 
% and the only two parameters to pass are the just received request token
% and the permissions. Flickr will ask for authorisation and show a string
% of the form |123-456-789|. This string the user should give back to our
% app. 
disp('AUTHORISATION')
web(['http://www.flickr.com/services/oauth/authorize?', ...
    'oauth_token=' requestToken, '&perms=read'], '-browser');
userinput = input('Once authorised, enter the verification here and press Enter\n', 's');
verifier = strrep(userinput, ' ', ''); % remove possible spaces
%% Access token
% The authorisation is granted, we are ready to demand the access
% token from Flickr. The procedure is similar to the one with request
% token.
%
% New timestamp and nonce:
timestamp = num2str(round(java.lang.System.currentTimeMillis / 1000)); 
nonce = lower(dec2hex(round(rand*1e15))); 
%%
% Request url: 
addr = 'http://www.flickr.com/services/oauth/access_token';
%%
% Parameters, already sorted alphabetically:
parameters = ['oauth_consumer_key=' appKey ...
    '&oauth_nonce=' nonce '&oauth_signature_method=HMAC-SHA1' ...
    '&oauth_timestamp=' timestamp ...
    '&oauth_token=' requestToken ...
    '&oauth_verifier=' verifier];
baseString = ['GET&' urlencode(addr) '&' urlencode(parameters)];
key = [appSecret '&' requestSecret];
signature = urlencode(doHMAC_SHA1(baseString, key));
requestString = [addr '?' parameters '&oauth_signature=' signature];
response = urlread(requestString);
disp('ACCESS TOKEN')
disp(response)
%%
% The response (if it does not fail) contains: 
%
% # User's full name, if provided by the user in her Flickr account.
% # Authorisation token and token secret.
% # User's Flickr ID, |nsid|.
% # User name.
respSplit = regexp(response, '&', 'split');
responseFullname = regexp(respSplit{1}, '=', 'split');
responseToken = regexp(respSplit{2}, '=', 'split');
responseSecret = regexp(respSplit{3}, '=', 'split');
responseNsid = regexp(respSplit{4}, '=', 'split');
responseUsername = regexp(respSplit{5}, '=', 'split');
accessToken = responseToken{2};
accessSecret = responseSecret{2};
fullname = responseFullname{2};
username = responseUsername{2};
nsid = responseNsid{2};
%% 
% This information can be saved and used later as many times as needed,
% without re-asking user's authorisation. The user can at any time revoke
% the authorisation in her Flickr user account.
save flickr.mat -mat accessToken accessSecret fullname username nsid
%% Authorised call
% At last, let's get some user's private data. We search for user's own
% photos.
%
% The procedure is just the same as before. Do not forget to sort the
% parameters.
timestamp = num2str(round(java.lang.System.currentTimeMillis / 1000)); 
nonce = lower(dec2hex(round(rand*1e15))); 
addr = 'http://api.flickr.com/services/rest';
method = 'flickr.photos.search'; 
parameters = ['method=' method ...
    '&oauth_consumer_key=' appKey '&oauth_nonce=' nonce ...
    '&oauth_signature_method=HMAC-SHA1&oauth_timestamp=' timestamp ...
    '&oauth_token=' accessToken ...
    '&per_page=20&user_id=' nsid];
baseString = ['GET&' urlencode(addr) '&' urlencode(parameters)];
%%
% The signature now includes the app secret and the access token secret.
key = [appSecret '&' accessSecret];
signature = urlencode(doHMAC_SHA1(baseString, key));
requestString = [addr '?' parameters '&oauth_signature=' signature];
response = urlread(requestString);
disp('AUTHORISED CALL, PRIVATE PHOTOS')
disp(response)
%%
% This time the response is in the XML form. It can be read it using the
% Matlab's XmlDOM methods. But this is a different story.

%% Reusing access token
% Let's now pretend the user has re-run our program after having previously
% granted authorisation to it (we have saved the access token). Let's get
% some user's data without ascing for authorisation again. We first delete
% all data previously used.
clear
disp('ALL DATA CLEARED')
%%
% The app keys have not changed:
appKey = '81952f22048626bf3dbd092230d7dc2d';
appSecret = '9323f25452d2d984';
%%
% The saved access token and user's NSID can be loaded:
load flickr.mat -mat

timestamp = num2str(round(java.lang.System.currentTimeMillis / 1000)); 
nonce = lower(dec2hex(round(rand*1e15))); 
addr = 'http://api.flickr.com/services/rest';
method = 'flickr.prefs.getPrivacy'; 
parameters = ['method=' method ...
    '&oauth_consumer_key=' appKey '&oauth_nonce=' nonce ...
    '&oauth_signature_method=HMAC-SHA1&oauth_timestamp=' timestamp ...
    '&oauth_token=' accessToken ...
    '&user_id=' nsid];
baseString = ['GET&' urlencode(addr) '&' urlencode(parameters)];
key = [appSecret '&' accessSecret];
signature = urlencode(doHMAC_SHA1(baseString, key));
requestString = [addr '?' parameters '&oauth_signature=' signature];
response = urlread(requestString);
disp('AUTHORISED CALL, PRIVACY LEVEL')
disp(response)
%%
% Note that the  |flickr.prefs.getPrivacy|  only needs the read permission
% from the user. If we wanted to use some function requiring the write
% permission, the granted authorisation would not be sufficient and we'd
% have to repeat the whole procedure with  |&perms=write.|

%% Output
% Due to limitations of Matlab's publish function, I cannot provide the
% output inline. Therefore I show it here. Note that the results are
% dynamic. If you run the code, the results will be similar but different. 
% 
%
%   NONAUTHORISED CALL, PUBLIC PHOTOS
%   <?xml version="1.0" encoding="utf-8" ?>
%   <rsp stat="ok">
%   <photos page="1" pages="127979" perpage="100" total="12797824">
%     	<photo id="6487681885" owner="32271334@N04" secret="dd8c977f62" server="7173" farm="8" title="775" ispublic="1" isfriend="0" isfamily="0" />
%       <photo id="6487683541" owner="28072720@N03" secret="38dc55c535" server="7170" farm="8" title="Locksley and Will Hoge-7" ispublic="1" isfriend="0" isfamily="0" />
%       <photo id="6487685431" owner="25223017@N00" secret="95c824ff14" server="7152" farm="8" title="IMG_3918" ispublic="1" isfriend="0" isfamily="0" />
%       ...
%       <photo id="6487686639" owner="38955621@N06" secret="81d6346316" server="7150" farm="8" title="Winter Sunset, Highgate" ispublic="1" isfriend="0" isfamily="0" />
%       <photo id="6487687301" owner="29044929@N06" secret="e2027df883" server="7170" farm="8" title="Trovai" ispublic="1" isfriend="0" isfamily="0" />
%   </photos>
%   </rsp>
% 
%   NONAUTHORISED CALL, PRIVATE PHOTOS
%   <?xml version="1.0" encoding="utf-8" ?>
%   <rsp stat="ok">
%   <photos page="1" pages="0" perpage="100" total="0" />
%   </rsp>
% 
%   REQUEST TOKEN
%   oauth_callback_confirmed=true&oauth_token=72157628360622809-9f48d35f63ed2a29&oauth_token_secret=da3d43af0fe8cd0d
%
%   AUTHORISATION
%   Once authorised, enter the verification here and press Enter
%   565-261-614
%
%   ACCESS TOKEN
%   fullname=&oauth_token=72157628232410607-2f0517985b738d1a&oauth_token_secret=352819e674b1b3c0&user_nsid=59678302%40N04&username=kotya.karapetyan
%
%   AUTHORISED CALL, PRIVATE PHOTOS
%   <?xml version="1.0" encoding="utf-8" ?>
%   <rsp stat="ok">
%   <photos page="1" pages="3" perpage="20" total="55">
%       <photo id="6300354674" owner="59678302@N04" secret="89dc2c2277" server="6102" farm="7" title="54_052" ispublic="0" isfriend="0" isfamily="0" />
%       <photo id="6299820021" owner="59678302@N04" secret="de63094285" server="6049" farm="7" title="54_051" ispublic="0" isfriend="0" isfamily="0" />
%       <photo id="6300353802" owner="59678302@N04" secret="088d7e831e" server="6102" farm="7" title="54_050" ispublic="0" isfriend="0" isfamily="0" />
%       ...
%       <photo id="6299815959" owner="59678302@N04" secret="22f4eddc75" server="6117" farm="7" title="54_035" ispublic="0" isfriend="0" isfamily="0" />
%       <photo id="6299815795" owner="59678302@N04" secret="3019abf8d0" server="6214" farm="7" title="54_034" ispublic="0" isfriend="0" isfamily="0" />
%   </photos>
%   </rsp>
%
%   ALL DATA CLEARED
%   AUTHORISED CALL, PRIVACY LEVEL
%   <?xml version="1.0" encoding="utf-8" ?>
%   <rsp stat="ok">
%   <person nsid="59678302@N04" privacy="1" />
%   </rsp>

