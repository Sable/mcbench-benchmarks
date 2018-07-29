function [watermarkedImage, WATERMARK_LENGTH] = DE_Algorithm(originalImage,T,EMBED_DIRECTION)

[sx sy] = size(originalImage);

%% STEP 2B: Collect the Pixel pairs with difference & average values in vectors
if EMBED_DIRECTION == 1
    DIREC = [1 2];
else
    DIREC = [2 1];    
end

differenceFunc=inline('x(1)-x(2)');
averageFunc=inline('floor((x(1)+x(2))/2)');
d = blkproc(double(originalImage),DIREC,differenceFunc);
g = blkproc(double(originalImage),DIREC,averageFunc);
[m n]=size(d);
M = zeros(m,n);
SETID = zeros(m,n); % identifies later as to which set a particulat pair belongs

%% STEP 3: Divide Pixel Pairs into different sets
% initialize various index values
s1Index = 1;
s2Index = 1;
s21Index = 1;
s22Index = 1;
s3Index = 1;
s4Index = 1;
s5Index = 1;
S1=[]; S2=[]; S21=[]; S22=[]; S3=[]; S4=[]; S5=[];
for i=1:size(d,1)
    for j=1:size(d,2)
        if (abs(2*d(i,j)+0) <= min(2*(255-g(i,j)),2*g(i,j) + 1) ...
                | abs(2*d(i,j)+1) <= min(2*(255-g(i,j)),2*g(i,j) + 1)) & (d(i,j) == 0 | d(i,j) == -1)
            % set S1 contains all pixel pairs that satisfy the difference value condition
            S1(s1Index) = d(i,j);
            s1Index = s1Index + 1;
            M(i,j) = 1;
            SETID(i,j) = 1;
        elseif d(i,j) == 0 | d(i,j) == -1
            % not expandable zeros
            S5(s5Index) = d(i,j);
            s5Index = s5Index + 1;
            M(i,j) = 0;
            SETID(i,j) = 6;            
        elseif abs(2*d(i,j)+0) <= min(2*(255-g(i,j)),2*g(i,j) + 1) ...
                | abs(2*d(i,j)+1) <= min(2*(255-g(i,j)),2*g(i,j) + 1)
            % set S2 contains all expandable pixel pairs that are not in S1
            S2(s2Index) = d(i,j);
            s2Index = s2Index + 1;
            if abs(d(i,j)) <= T
                % set S21 contains all pixel pairs whose difference value is less than threshold
                S21(s21Index) = d(i,j);
                s21Index = s21Index + 1;
                M(i,j) = 1;
                SETID(i,j) = 2;
            else
                % set S22 contains all pixel pairs whose difference value is greater than threshold
                % embedding is performed in set S22
                S22(s22Index) = d(i,j);
                s22Index = s22Index + 1;
                M(i,j) = 0;
                SETID(i,j) = 3;
            end
        elseif abs(2*floor(d(i,j)/2)+0) <= min(2*(255-g(i,j)),2*g(i,j) + 1)...
                | abs(2*floor(d(i,j)/2)+1) <= min(2*(255-g(i,j)),2*g(i,j) + 1)
            % set S3 contains all changeable pixel pairs
            % embedding is performed in set S3
            S3(s3Index) = d(i,j);
            s3Index = s3Index + 1;
            M(i,j) = 0;
            SETID(i,j) = 4;
        else
            % set s4 contains all non changable pixel pairs
            S4(s4Index) = d(i,j);
            s4Index = s4Index + 1;
            M(i,j) = 0;
            SETID(i,j) = 5;
        end
    end
end

%figure,imshow(M,[]),title('Location Map');
B1 = reshape(M,1,size(M,1)*size(M,2));

%% STEP 4: Collect LSB's of difference values in set S22 & set S3
% Extract LSB's of coeffs in set S22
Q1=[];
for i=1:length(S22)
    Q1(i) = bitget(abs(S22(i)),1);
end
b = length(Q1);

% Extract LSB's of coeffs in set S3
Q2=[];
for i=1:length(S3)
    Q2(i) = bitget(abs(S3(i)),1);
end
c = length(Q2);

B2=[Q1 Q2];

%% STEP 5A: Compress the Location map using Arithmetic coding
% convert to 1-2 vector from 0-1
for i=1:length(B1)
    if B1(i) == 0
        seq1(i) = 1;
    else
        seq1(i) = 2;
    end
end
% find how many times 1 occurs in the binary sequence
[xx,yy,val] = find(seq1 == 1);
totalVals = length(seq1);

% code the sequence using arithmetic coding
count1 = [round((size(xx,2)/totalVals)*100) round(((totalVals - size(xx,2))/totalVals) * 100)];
encodedLM = arithenco(seq1,count1); 
str = sprintf('LMap Length = %d ------ Compressed LMap Length = %d',size(seq1,2),size(encodedLM,2));
disp(str);

%% STEP 5B: Compress the Original LSB's using Arithmetic coding
% convert to 1-2 vector from 0-1
for i=1:length(B2)
    if B2(i) == 0
        seq2(i) = 1;
    else
        seq2(i) = 2;
    end
end
% find how many times 1 occurs in the binary sequence
[xx,yy,val] = find(seq2 == 1);
totalVals = length(seq2);

% code the sequence using arithmetic coding
count2 = [round((size(xx,2)/totalVals)*100) round(((totalVals - size(xx,2))/totalVals) * 100)];
encodedS22_S23 = arithenco(seq2,count2); 
str = sprintf('Original Bits Length = %d ------ Compressed Bits Length = %d',size(seq2,2),size(encodedS22_S23,2));
disp(str);

%% STEP 6: Calculate Available embedding capacity
% Calculate total Available Embedding Capacity
totalCapacity = length(S1) + length(S21) + length(S22) + length(S3);

% Calculate payload size
HEADERLEN = 112;
totalPayload = length(encodedLM) + length(encodedS22_S23);
WATERMARK_LENGTH = totalCapacity - totalPayload - HEADERLEN;
totalPayload = length(encodedLM) + length(encodedS22_S23) + WATERMARK_LENGTH;

str = sprintf('Total Capacity = %d ------ Watermark Length = %d',totalCapacity,WATERMARK_LENGTH);
disp(str);

% Convert header info into bit stream
hbinSeq = dec2bin(count1(1,1),8);
hbinSeq = strcat(hbinSeq,dec2bin(count1(1,2),8));
hbinSeq = strcat(hbinSeq,dec2bin(count2(1,1),8));
hbinSeq = strcat(hbinSeq,dec2bin(count2(1,2),8));
hbinSeq = strcat(hbinSeq,dec2bin(length(seq1),16));
hbinSeq = strcat(hbinSeq,dec2bin(length(encodedLM),16));
hbinSeq = strcat(hbinSeq,dec2bin(length(seq2),16));
hbinSeq = strcat(hbinSeq,dec2bin(length(encodedS22_S23),16));
hbinSeq = strcat(hbinSeq,dec2bin(WATERMARK_LENGTH,16));

BH = zeros(1,length(hbinSeq));
for i=1:length(hbinSeq)
    BH(i) = str2num(hbinSeq(i));
end
%% STEP 7: Generate Random Watermark (Payload)
B3=randint(1,WATERMARK_LENGTH,[0 1],100);

% concatenate all bitstream to obtain the embedding stream
%B = [BH B1 B2 B3];
B = [BH encodedLM encodedS22_S23 B3];

%% STEP 8: Embedd Watermark in image
index = 1;
wIndex = 1;
exitLoop = 0;
watermarkedImage = zeros(sx,sy);
for i=1:size(d,1)
    if EMBED_DIRECTION == 1
        index = 1;
    end
    for j=1:size(d,2)
        if SETID(i,j) ~= 5 | SETID(i,j) ~= 6
            neg = 0;
            if d(i,j) < 0
                neg = 1;
            end

            if SETID(i,j) == 1 | SETID(i,j) == 2
                % Embedd watermark by shifting
                val = bitshift(abs(d(i,j)),1);                               
            elseif SETID(i,j) == 3 | SETID(i,j) == 4
                % Embedd watermark by replacement
                val = abs(d(i,j));
            end

            binSeq = dec2bin(val,8);
            if B(1,wIndex) == 1
                binSeq(8) = '1';
            else
                binSeq(8) = '0';
            end

            val = bin2dec(binSeq);
            
            if neg == 1
                d(i,j) = -val;
            else
                d(i,j) = val;
            end
            
            if EMBED_DIRECTION == 1
                watermarkedImage(i,index) = g(i,j) + floor((d(i,j) + 1)/2);
                watermarkedImage(i,index + 1) = g(i,j) - floor(d(i,j)/2);
                index = index + 2;                
            else
                watermarkedImage(index,j) = g(i,j) + floor((d(i,j) + 1)/2);
                watermarkedImage(index + 1,j) = g(i,j) - floor(d(i,j)/2);                
            end
            if wIndex < totalCapacity
                wIndex = wIndex + 1;
            else
                exitLoop = 1;
                break;
            end
        else
            if EMBED_DIRECTION == 1                
                watermarkedImage(i,index) = originalImage(i,index);
                watermarkedImage(i,index + 1) = originalImage(i,index + 1);
                index = index + 2;                            
            else
                watermarkedImage(index,j) = originalImage(index,j);
                watermarkedImage(index + 1,j) = originalImage(index + 1,j);
            end
        end
    end
    if exitLoop == 1
        break;
    end
    if EMBED_DIRECTION ~= 1
        index = index + 2;
    end
end

%figure,imshow(watermarkedImage,[])

str = sprintf('Payload(bpp) = %f',WATERMARK_LENGTH/(size(originalImage,1)*size(originalImage,2)));
disp(str);

[PSNR_OUT,Z] = psnr(originalImage,watermarkedImage);
str = sprintf('PSNR = %f',PSNR_OUT);
disp(str);
