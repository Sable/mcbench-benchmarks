%  Function that Simulates Block Encoder/Decoder wriiten by Yogesh Bhole for Blekinge Tekniska Högskolan,Sweden
%  Digital Transmission Laboration,March,2004


function [encoded,received,corrected,decoded] = block_code_sim(G,n,k,information_bits,to_flip)


Pt=[ G(:,1) G(:,2) G(:,3)]'; %Generates P' Matrix from given Generator matrix G
H=[eye(n-k) Pt];      % Formation of H matrix

fprintf('   Information Bits --> Code Word Pairs \n');
fprintf('\n');
m=de2bi(0:15,4,'left-msb');

for count=1:16
x(count,:)=m(count,:)*G;   % Generation of code words
x(count,:)=x(count,:)>2|x(count,:)==1;
end

for count=1:16
    fprintf('  %d',m(count,:)) ,fprintf('        -->  '),fprintf('  %d',x(count,:));
    fprintf('\n');
end


fprintf('\n');
fprintf('   Bit Errors              --> Syndrome Pairs \n');
fprintf('\n');
e=de2bi(0:127,7,'left-msb');

for count=1:128
s(count,:)=e(count,:)*H';  % Generation of code words
s(count,:)=s(count,:)>2|s(count,:)==1;
end

for count=1:128
    fprintf('  %d',e(count,:)) ,fprintf('      -->  '),fprintf('  %d',s(count,:));
    fprintf('\n');
end



rightpart=information_bits(1,5:8);
leftpart=information_bits(1,1:4);

p=leftpart*G;
p=p>2|p==1;
q=rightpart*G;
q=q>2|q==1;

encoded=[p q]     % Encoded Signal Generation

t=~encoded(to_flip(1:end)); % Complemeted bits

encoded(to_flip(1:end))=t;
received=encoded   % Received Signal with bits fliped at position as given by to_flip matrix

i1=received(1,1:7);
dleftpart=i1*H';
i2=received(1,8:14);
drightpart=i2*H';

dleftpart=dleftpart>2|dleftpart==1;    % Gets Syndrom Vector
drightpart=drightpart>2|drightpart==1;    % Gets Syndrom Vector

for count=1:n
    if dleftpart==H(:,count)';
        answer1=count;
    end
      
end

errors1=[0 0 0 0 0 0 0];
errors1(answer1)=1;


for count=1:n
    if drightpart==H(:,count)';
        answer2=count;
    end
      
end

errors2=[0 0 0 0 0 0 0];
errors2(answer2)=1;


corrected=[i1+errors1 i2+errors2];
corrected=corrected>2|corrected==1  % Displays Corrected Signal
decoded=[corrected(1,4:7) corrected(1,11:14)]  %Displays Decoded Signal
        

