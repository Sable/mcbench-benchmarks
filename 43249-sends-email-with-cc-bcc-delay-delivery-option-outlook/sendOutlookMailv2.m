function sendOutlookMailv2(to,cc,bcc,subject,body,attachment,sentAt)
%Sends email using MS Outlook with enhanced features such as CC, BCC option and
%Delayed Delivery option (email stays in Outbox up to the specified time)
%
%
% to : Email addresses of recipients
% cc : Email addresses of recipients under cc option
% bcc: Email addresses of recipients under bcc option
% attachment: path of attached file
% sentAt : time when the email should be sent
%
% format for input :
% 'to' :
% for single recipient   : input a string for example,'xxx@domain.com'
% for multiple recipient : input in cell format {'xxx@domain.com','yyy@domain.com','zzz@domain.com'}
%
% 'cc'
% for single recipient   : input in a string for example,'xxx@domain.com'
% for multiple recipient : input in cell format {'xxx@domain.com','yyy@domain.com','zzz@domain.com'}
% no recipient           : input empty string , ''
%
% 'bcc'
% for single recipient   : input a string for example,'xxx@domain.com'
% for multiple recipient : input in cell format {'xxx@domain.com','yyy@domain.com','zzz@domain.com'}
% no recipient           : input empty string , ''
%
% 'subject'              : input a string for example,'TESTMAIL'
%
% 'body'                 : input a string for example,'this email was sent using MATLAB'
%
% 'attachment'
% for single recipient   : input folder locaionin string format 'C:\Users7\Documents\for_file_exhange.docx'
% for multiple recipient : input in cell format {'C:\Users\Documents\for_file_exhange.docx','C:\Users\Documents\for_file_exhange2.docx'}
% no recipient           : input empty string , ''
%
%
%
% 'sentAt'               : string input in the format 'HH:MM:SS AM/PM',for example, “ 10:40:00 AM ”
%
%
%
%
%
%
% 
% Author:Suganthan 

h = actxserver('outlook.Application');
mail = h.CreateItem('olMail');
mail.Subject = subject;


if (iscell(to) == 1)
    tmpSize = size(to);
    address=[];
    for i = 1:tmpSize(2)
        tmp = cell2mat(to(i));
        address= sprintf('%s ; %s ',address,tmp);
    end
    address= address(2:end);
    mail.To=address;
    
else
    mail.Recipients.Add(to);
end

if (iscell(cc) == 1)
    tmpSize = size(cc);
    address=[];
    for i = 1:tmpSize(2)
        tmp = cell2mat(cc(i));
        address= sprintf('%s ; %s ',address,tmp);
        
    end
    address= address(2:end);
    mail.Cc =address;
    
else
    mail.Cc =cc;
end


if (iscell(bcc) == 1)
    tmpSize = size(bcc);
    address=[];
    for i = 1:tmpSize(2)
        tmp = cell2mat(bcc(i));
        address= sprintf('%s ; %s ',address,tmp);
    end
    address= address(2:end);
    mail.Cc =address;
else
    mail.Bcc=bcc;
end

mail.Subject = subject;
mail.Body = body;

% Add attachments, if specified.
if nargin == 6
    if (iscell(attachment) == 1)
        tmpSize = size(attachment);
        for i = 1:tmpSize(2)
            tmp = cell2mat(attachment(i));
            mail.Attachments.Add(tmp);
        end
    else
        if (attachment ~= 0)
            mail.Attachments.Add(attachment);
        end
    end
end


if nargin == 7
    mail.DeferredDeliveryTime= [datestr(now,'dd/mm/yyyy') ' ' sentAt];
end
% Send message and release object.

mail.Send;
h.release;
end

