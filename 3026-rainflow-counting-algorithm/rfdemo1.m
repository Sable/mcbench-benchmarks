function rfdemo1(ext)
% function rfdemo1(ext)
%
% RFDEMO1 shows cycles extracted from signal
% using rainflow algoritm.
% 
% INPUT:  ext - option, number or vectors with turning
%               points or time history. Default ext=16.
% 
% OUTPUT: no enable.
% 
% SYNTAX:
%         >>rfdemo1
%         >>rfdemo1(10)
%         >>rfdemo1([2 3 2 4 2 5 1 6])
%

% By Adam Nies³ony
% Revised, 10-Nov-2009
% Visit the MATLAB Central File Exchange for latest version.

error(nargchk(0,2,nargin))

if nargin==0,
    % turning points from 16 random numbers
    ext=sig2ext(randn(4));
elseif length(ext(:))==1,
    % turning points from n random numbers    
    ext=sig2ext(randn(1,ext));
else
    % turning points from vector ext
    ext=sig2ext(ext);
end

a=rainflow(ext,1);
[m n]=size(a);

% if n>100,
%     button = questdlg(['Rainflow found ' num2str(sum(a(3,:))) ' cycles! Do you want to continue?'],...
%         'Continue Operation','Yes','No','No');
%     if strcmp(button,'No')
%         error('Function aborted by user.')        
%     end
% end

col='ymcrgb';
plot(0:length(ext)-1,ext,'k.:')
hold on
wyk=0:0.05:1;
for c=1:n,
    colnr=rem(c-1,6)+1;
    
    nr1=round(a(4,c)+1);
    nr2=round(a(4,c)+1+a(5,c)*a(3,c));
    if a(3,c)==1.0,
        if ext(nr1)<ext(nr1+1),
            plot(wyk.*a(5,c)+a(4,c),cos(pi+wyk.*2*pi)*a(1,c)+a(2,c),col(colnr))
            text(a(4,c),a(2,c)-a(1,c),[int2str(c) '. Cycle, up'],...
                'Color',col(colnr),'VerticalAlignment','top')
        else
            plot(wyk.*a(5,c)+a(4,c),cos(   wyk.*2*pi)*a(1,c)+a(2,c),col(colnr))
            text(a(4,c),a(2,c)+a(1,c),[int2str(c) '. Cycle, down'],...
                'Color',col(colnr),'VerticalAlignment','bottom')
        end
    else
        if ext(nr1)>ext(nr2),
            plot(wyk.*a(5,c)*0.5+a(4,c),cos(   wyk.*pi)*a(1,c)+a(2,c),col(colnr))
            text(a(4,c),a(2,c)+a(1,c),[int2str(c) '. Half-cycle, down'],...
                'Color',col(colnr),'VerticalAlignment','bottom')
        else
            plot(wyk.*a(5,c)*0.5+a(4,c),cos(pi+wyk.*pi)*a(1,c)+a(2,c),col(colnr))
            text(a(4,c),a(2,c)-a(1,c),[int2str(c) '. Half-cycle, up'],...
                'Color',col(colnr),'VerticalAlignment','top')
        end
    end
end
xlabel('peaks, counted from 0')
ylabel('value')
title('Rainflow cycles extracted from signal')
legend('peaks from signal',0)
hold off

disp('Row 1: amplitude')
disp('Row 2: mean')
disp('Row 3: number of cycles (cycle or half cycle)')
disp('Row 4: begin time of extracted cycle or half cycle')
disp('Row 5: period of a cycle')   
disp(a)