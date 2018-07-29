function outstring =  demorse(wavfile);

%demorse a morsed input wav file

vis_on = 0;

threshold = 0.05;

x = wavread(wavfile);

% half-wave rectify x
x2 = abs(x);

% slow-wave filter 
y = filter(ones(1,20)/20,1, x2);

% threshold (digitize) y
z = y > threshold;
% z is now effectively our morse signal

if vis_on
   figure(1);
   subplot(3,1,1);
   plot(x, 'r');
   title('original signal');
   
   subplot(3,1,2);
   plot(y);
   title('HWR + Slow-wave filter -> envelope');
   subplot(3,1,3);
   plot(z, 'o', 'MarkerSize', 2);
   title('Digitized Morse signal')
   
end

%zero pad z so we always start with an onset
z = [zeros(10,1); z];

% id tones/spaces   -----------------------
% --> find changes between 0/1 and 1/0

b = diff(z);
% figure(3); plot(b, '.');
% 1: change from 1 to 0
% 0: no change
% -1: change from 0 to 1

c = b(b~=0);
c2 = find(b~=0);

tokens = -c .* diff([0; c2]);
% value == length of token
% sign == tone/space

% id shorts/longs  -----------------------

% since short/long should be bi-modal dist, a regular average should give
% us a good cutoff point to distinguish between the two? (assuming equal
% counts of short and long...)
% use mean as simple cutoff point; smarter algorithms can get smarter about
% this classification if they want to.

% 1: short, 2: long, +: tone, -: space
tokens2 = tokens;

% cutoff tones, cutoff spaces;
cut_t = mean(tokens2(tokens2>0));
cut_s = mean(tokens2(tokens2<0));

tokens2(tokens > 0 & tokens < cut_t) = 1;
tokens2(tokens > 0 & tokens > cut_t) = 2;
tokens2(tokens < 0 & tokens > cut_s) = -1;
tokens2(tokens < 0 & tokens < cut_s) = -2;

% now tokens 2 is a string of -1s, -2s, 1s, 2s, can trim first known space;
% put final endstop at end
tokens2 = [tokens2(2:end); -2];

% can drop little spaces, b/c they don't matter when parsing;
tokens2(tokens2 == -1) = [];
tokens3 = tokens2;
tokens4 = {};
ctr = 1;
start_idx = 1;

%parse
toparse = find(tokens3(start_idx:end) == -2);

for j=1:length(toparse)
   a = toparse(j);
   temp = tokens3(start_idx:a-1);
   tokens4{j} = temp;
   % zeropad for easy comparison
   %tokens4{j} = [tokens4{j}; zeros(length(tokens4{j}), 1)];
   start_idx = a+1;

end
    
% now tokens4 is de-codeable tokens... proceed to setup lookups
% letters
code{1} = [1 2 ];
code{2} = [2 1 1 1];
code{3} = [2 1 2 1];
code{4} = [2 1 1];
code{5} = [1];
code{6} = [1 1 2 1];
code{7} = [2 2 1];
code{8} = [1 1 1 1];
code{9} = [1 1];
code{10} = [1 2 2 2];
code{11} = [2 1 2];
code{12} = [1 2 1 1];
code{13} = [2 2];
code{14} = [2 1];
code{15} = [2 2 2];
code{16} = [1 2 2 1];
code{17} = [1 2 1 2];
code{18} = [1 2 1];
code{19} = [1 1 1];
code{20} = [2];
code{21} = [1 1 2]; 
code{22} = [1 1 1 2];
code{23} = [1 2 2];
code{24} = [2 1 1 2];
code{25} = [2 1 2 2];
code{26} = [2 2 1 1];

% punct
code{27} = [1 2 1 2 1 2];
code{28} = [2 2 1 1 2 2];
code{29} = [1 1 2 2 1 1];    
code{30} = [2 1 1 2 1];

% numbers

code{31} = [1 2 2 2 2];
code{32} = [1 1 2 2 2];
code{33} = [1 1 1 2 2];
code{34} = [1 1 1 1 2];
code{35} = [1 1 1 1 1];
code{36} = [2 1 1 1 1];
code{37} = [2 2 1 1 1];
code{38} = [2 2 2 1 1];
code{39} = [2 2 2 2 1];
code{40} = [2 2 2 2 2];


decode{1} = 'A';
decode{2} = 'B';
decode{3} = 'C';
decode{4} = 'D';
decode{5} = 'E';
decode{6} = 'F';
decode{7} = 'G';
decode{8} = 'H';
decode{9} = 'I';
decode{10} = 'J';
decode{11} = 'K';
decode{12} = 'L';
decode{13} = 'M';
decode{14} = 'N';
decode{15} = 'O';
decode{16} = 'P';
decode{17} = 'Q';
decode{18} = 'R';
decode{19} = 'S';
decode{20} = 'T';
decode{21} = 'U';
decode{22} = 'V';
decode{23} = 'W';
decode{24} = 'X';
decode{25} = 'Y';
decode{26} = 'Z';
decode{27} = '.';
decode{28} = ',';
decode{29} = '?';
decode{30} = '/';
decode{31} = '1';
decode{32} = '2';
decode{33} = '3';
decode{34} = '4';
decode{35} = '5';
decode{36} = '6';
decode{37} = '7';
decode{38} = '8';
decode{39} = '9';
decode{40} = '0';



% compare tokens to tables

out1 = [];

for j = 1:length(tokens4)
    %zero pad temp_tok
    temp_tok = [tokens4{j}; zeros(6 - length(tokens4{j}), 1)];
    for k = 1:length(code)
        if (temp_tok == [code{k}'; zeros(6 - length(code{k}), 1)]);
            out1(j) = char(decode{k});
            %display(decode{k})
        end

    end

    % if didn't find a match
    if isempty(out1(j))
        out1(j) = '_';
    end
    
end

% semi-prettify
outstring = 32*ones(2*length(out1),1);
outstring(2:2:end) = out1;
outstring = char(outstring');

%display('demorsed message:')
%display(outstring);








