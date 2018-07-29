function varargout = notifier(recipients, fh, varargin)
% notifier - Notifies you via email when a function finishes.
%
% USAGE:
%   varargout = notifier(recipients, fh, varargin)
%
% notifier is a wrapper for a sub function. It takes as input a list of
% recipients, a function handle, and arguments for the sub function. It
% then calls the sub function, passing in all the arguments, and notifies
% the recipients via email when the sub function completes. In the event of
% an error, the text of the error message is sent to the recipients via
% email. This is designed for long running functions, so you can leave the
% computer and be notified when to come back. This function uses sendmail
% to send notices, so make sure that sendmail is working properly before
% attempting to use this function. Sendmail accepts email addreses, but if
% your phone/carrier supports this feature, you can often use specially
% fomatted email addresses to send TXT messages to your mobile phone. For
% example, for Verizon Wireless, you can use the email address
% <phonenumber>vtext.com, such as 6175551212@vtext.com.
%
% INPUT:
%   recipients - E-mail addresses to notify. Passed directly to sendmail,
%                so see the documentation for sendmail for formatting.
%   fh         - Function handle for the sub function to run.
%   varargin   - Input arguments passed directly to the sub function.
%
% OUTPUT:
%   varargout  - Output from the sub funtion is passed directly as output
%                from this function.
%
% EXAMPLE:
%   Without notifier:
%       output = myfunc(arg1, arg2, arg3)
%   With notifier:
%       output = notifier('email@address.com', @myfunc, arg1, arg2, arg3)
%
% See also sendmail
%
% AUTHOR: Benjamin Kraus (bkraus@bu.edu, ben@benkraus.com)
% Copyright (c) 2010, Benjamin Kraus
% $Id: notifier.m 1788 2010-09-17 01:41:46Z bkraus $

% Send a message. This is to test that sendmail is working *before*
% running a really long script and *then* finding sendmail isn't
% configured properly. If you know sendmail is working, then you can
% comment this line out.
sendmail(recipients,['Starting ' func2str(fh) '.']);

% Put the actual function call in a try-catch block, so you are
% notified in case of errors.
try
    [varargout{1:nargout}] = fh(varargin{:});
catch ME1
    % Put sendmail in a try-catch block, so that you don't lose the results
    % of the function call if sendmail throws an error.
    try
        sendmail(recipients,ME1.identifier,ME1.message);
    catch ME2
        warning('Notifier:SendmailError','Sendmail threw an error. Check sendmail before running again.');
        warning('Nofifier:SendmailError',ME2.message);
    end
    rethrow(ME1);
end

% Put sendmail in a try-catch block, so that you don't lose the results
% of the function call if sendmail throws an error.
try
    sendmail(recipients,[func2str(fh) ' finished successfully.']);
catch ME3
    warning('Notifier:SendmailError','Sendmail threw an error. Check sendmail before running again.');
    warning('Nofifier:SendmailError',ME3.message);
end

end
