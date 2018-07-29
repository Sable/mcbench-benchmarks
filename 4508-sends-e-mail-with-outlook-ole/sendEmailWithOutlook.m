function sendEmailWithOutlook(emailAddress, subjectText, bodyText, Attach)
% sendEmailWithOutlook - Functions sends email to an email address,
% Microsoft Outlook has to be installed.
% emailAddress: Email address of the recipient
% subjectText: Message displayed in the subject line
% bodyText: Message displayed in the body of the email
% Attach: Path of Attachments
% Calling the function:
% sendEmailWithOutlook('xxx@domain.com', 'Testmail', 'This is a test!', 'c:\test.txt')
% It's possible to send without an attachment, then call function like this:
% sendEmailWithOutlook('xxx@domain.com', 'Testmail', 'This is a test!', 0)
% To have more than one recipient or attachment, use cell arrays like this:
% sendEmailWithOutlook({'xxx@domain.com', 'xxx@domain1.com'}, 'Testmail', 'This is a test!', {'c:\test.txt', 'D:\Test\readme.doc'} )
% Function was tested with Matlab 6.5 R13 on Windows XP Prof. 
% with Outlook 2002
% Author: Rainer F., knallkopf66@uboot.com, Feb. 2004

outlook = actxserver('Outlook.Application');
email = outlook.CreateItem(0);
if (iscell(emailAddress) == 1)
    tmpSize = size(emailAddress);
    for i = 1:tmpSize(2)
        tmp = cell2mat(emailAddress(i));
        email.Recipients.Add(tmp);
    end
else
    email.Recipients.Add(emailAddress);
end
    
email.Subject = subjectText;
email.Body = bodyText;

if (iscell(Attach) == 1)
    tmpSize = size(Attach);
    for i = 1:tmpSize(2)
        tmp = cell2mat(Attach(i));
        email.Attachments.Add(tmp);
    end
else
    if (Attach ~= 0)
        email.Attachments.Add(Attach);
    end
end

email.Send;


