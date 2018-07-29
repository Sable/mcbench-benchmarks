%% Transform Compression JPEG

% JPEG Baseline Encoder

% Jorge Calderon <calderonjorge9@gmail.com>
% University Of Antioquia
% Created: November 2012
% Modified: January 2013
% Copyright 2012
% All rights reserved

%% Clean Workplace

clear all;
close all;
clc;

%% Initialize Variables

check = 0;
stream=[];

DCTQ=[...
    16 11 10 16 24 40 51 61;...
    12 12 14 19 26 58 60 55;...
    14 13 16 24 40 57 69 56;...
    14 17 22 29 51 87 80 62;...
    18 22 37 56 68 109 103 77;...
    24 36 55 64 81 194 113 92;...
    49 64 78 87 103 121 120 101;...
    72 92 95 98 112 100 103 99];

z=[...
    9 2 3 10 17 25 18 11 4 5 12 19 26 ...
    33 41 34 27 20 13 6 7 14 21 28 35 ...
    42 49 57 50 43 36 29 22 15 8 16 23 ...
    30 37 44 51 58 59 52 45 38 31 24 32 ...
    39 46 53 60 61 54 47 40 48 55 62 63 56 64];

%% Read Image

while check<1
    [img_in pathname]=uigetfile({'*.bmp;*.tif','Image(*.bmp,*.tif)'},'Select Uncompressed Image','Multiselect','off');
    if img_in>0
        cd(pathname)
        image = double(imread(img_in));
        [row, col, dim] = size(image);
        if col<row
            disp('Error: The image must be horizontal');
            disp('Press any key to continue...');
            pause;
        else
            if (row<720 && col<1280)
                check=1;
            else
                disp('Error: The image size is too large');
                disp('Press any key to continue...');
                pause;
            end
        end
    else
        if img_in==0
            return;
        end
    end
end

%% Check Size

if mod(row,2)~=0
    row = row-1;
end
if mod(col,2)~=0
    col = col-1;
end
image = imresize(image, [row col]);

%% Convert Image To YCBCR

img = rgb2ycbcr(image);

%% Adjust Aspect Ratio

if mod(row,72)~=0
    row_aspect = row+(72-mod(row,72));
else
    row_aspect = row;
end
col_aspect = (row_aspect/9)*16;
image_aspect = zeros(row_aspect, col_aspect, dim);
zig_zag_ac = zeros(row_aspect*col_aspect/64, 63);
zig_zag_dc = zeros(row_aspect*col_aspect/64, 1);

for i=1:col
    for j=1:row
        for k=1:dim
            image_aspect(j+abs(row_aspect-row)/2,i+abs(col_aspect-col)/2,k)=img(j,i,k);
        end
    end
end

% figure(1)
% imshow(uint8(image_aspect));

%% Digitization Scheme 420

comp_blue = image_aspect(:,:,2);
comp_red = image_aspect(:,:,3);
luminance = double(image_aspect(:,:,1))-128;
imgcb_420 = double(comp_blue(1:2:size(comp_blue,1),1:2:size(comp_blue,2)))-128;
imgcr_420 = double(comp_red(1:2:size(comp_red,1),1:2:size(comp_red,2)))-128;

%% Segmenting Image Blocks Of 8x8

k=0;
for i=1:8:row_aspect
    for j=1:8:col_aspect
        f=luminance(i:i+7,j:j+7);
        T=dct2(f);
        TQ=round(T./DCTQ);
        k=k+1;
        zig_zag_dc(k,1) = TQ(1,1);
        zig_zag_ac(k,1:63) = TQ(z);
    end
end

%% Huffman Compression

dpcm(1,1)=zig_zag_dc(1,1);
stream=cat(2,stream,huffman_dc(dpcm(1,1)),huffman_ac(zig_zag_ac(1,1:63)));
for m=2:k
    dpcm(m,1)=zig_zag_dc(m,1)-zig_zag_dc(m-1,1);
    stream=cat(2,stream,huffman_dc(dpcm(m,1)),huffman_ac(zig_zag_ac(m,1:63)));
end

%% Byte Stuffing

p=0;
G=size(stream,2);
for i=1:8:size(stream,2)
    bit_val(1,1:8)=stream(1,i:i+7);
    if strcmp(bit_val(1,1:8),'11111111')==1
        tempbitstream = stream(1,i+8:G+p);
        stream(1,i+8:i+15)='00000000';
        p=p+8;
        temp2_bitstream=stream(1,1:i+15);
        stream(1,1:G+p)=cat(2,temp2_bitstream,tempbitstream);
    end
end

%% Convert String To Decimal

numbytes=floor(length(stream)/8);
diff_stream=length(stream)-numbytes*8;
if diff_stream==0
    matrix_code_decimal= zeros(numbytes+2,8);
else
    matrix_code_decimal= zeros(numbytes+3,8);
end
s=0;
for count2=1:8:numbytes*8
    s=s+1;
    matrix_code_decimal(s,1)=bin2dec(stream(1,count2:count2+7));
end

if diff_stream~=0
    s=s+1;
    matrix_code_decimal(s,1)=bin2dec(stream(1,numbytes*8+1:length(stream)));
end

%% Final Marker

matrix_code_decimal(s+1,1)=255;
matrix_code_decimal(s+2,1)=217;

%% Header JFIF

signal=[255	216	255	224	000	016	074	070	073	070	000	001	002	000	000	096	000	096	000	000	...
        255	219	000	067	000	016	011	012	014	012	010	016	014	013	014	018	017	016	019	024	...
        040	026	024	022	022	024	049	036	037	029	040	058	051	061	060	057	051	056	055	064	...
        072	092	078	064	068	087	069	055	056	080	109	081	087	095	098	103	194	103	062	077	...
        113	121	112	100	120	092	101	103	099	255	219	000	067	001	017	018	018	024	021	024	...
        047	026	026	047	099	066	056	066	099	099	099	099	099	099	099	099	099	099	099	099	...
        099	099	099	099	099	099	099	099	099	099	099	099	099	099	099	099	099	099	099	099	...
        099	099	099	099	099	099	099	099	099	099	099	099	099	099	099	099	099	099	255	192	...
        000	011	008	000	000	000	000	001	001	034	000	255	196	000	031	000	000	001	005	001	...
        001	001	001	001	001	000	000	000	000	000	000	000	000	001	002	003	004	005	006	007	...
        008	009	010	011	255	196	000	181	016	000	002	001	003	003	002	004	003	005 	005	004	...
        004	000	000	001	125	001	002	003	000	004	017	005	018	033	049	065	006	019	081	097	...
        007	034	113	020	050	129	145	161	008	035	066	177	193	021	082	209	240	036	051	098	...
        114	130	009	010	022	023	024	025	026	037	038	039	040	041	042	052	053	054	055	056	...
        057	058	067	068	069	070	071	072	073	074	083	084	085	086	087	088	089	090	099	100	...
        101	102	103	104	105	106	115	116	117	118	119	120	121	122	131	132	133	134	135	136	...
        137	138	146	147	148	149	150	151	152	153	154	162	163	164	165	166	167	168	169	170	...
        178	179	180	181	182	183	184	185	186	194	195	196	197	198	199	200	201	202	210	211	...
        212	213	214	215	216	217	218	225	226	227	228	229	230	231	232	233	234	241	242	243	...
        244	245	246	247	248	249	250	255	218	000	008	001	001	000	000	063	000];

% Start of Image (SOI) marker:FFD8=255,216
% JFIF marker:FFE0=255,224
%        Length=000,016
%        Identifier:4A46494600=074,070,073,070,000
%        Version=001,002
%        Units=000
%        Xdensity=000,096
%        Ydensity=000,096
%        Xthumbnail=000
%        Ythumbnail=000
%        (RGB)n, n=Xthumbnail*Ythumbnail required 3*n bytes=null

% Define Quantization table marker (luma):FFDB=255,219
%         Length:two bytes that indicate the number of bytes, including the two length bytes, that this header contains=000,067
%         Precision=000 (baseline)
%         Quantization values=016,011,012,014,012,010,016,...,101,103,099 (zigzag)

% Define Quantization table marker (Chroma):FFDB=255,219
%         Length:two bytes that indicate the number of bytes, including the two length bytes, that this header contains=000,067
%         Precision=000 (baseline)
%         Quantization values=017,018,018,024,021,024,047,...,099,099,099 (zigzag)

% Start of frame marker:FFC0=255,192
%         Length:two bytes that indicate the number of bytes, including the two length bytes, that this header contains=000,011
%         Sample precision=008
%         X=000,000 (This will be defined later)
%         Y=000,000 (This will be defined later)
%         Number of components in the image=001
%             * 3 for color baseline
%             * 1 for grayscale baseline
%         Component ID=001
%         H and V sampling factors=034
%         Quantization table number=000

% Define Huffman table marker (DC):FFC4=255,196
%        Length:two bytes that indicate the number of bytes, including the two length bytes, that this header contains=000,031
%        Index=000 (Huffman DC)
%        Bits=The next 16 bytes from an array of unsigned 1-byte integers whose elements give the number of Huffman codes for each possible code length (1-16).
%        Huffman values=000,001,002,...,010,011

% Define Huffman table marker (AC):FFC4=255,196
%        Length:two bytes that indicate the number of bytes, including the two length bytes, that this header contains=000,181
%        Index=016 (Huffman AC)
%        Bits=The next 16 bytes from an array of unsigned 1-byte integers whose elements give the number of Huffman codes for each possible code length (1-16).
%        Huffman values=001,002,003,...,249,250

% Start of Scan marker:FFDA=255,218
%        Length:two bytes that indicate the number of bytes, including the two length bytes, that this header contains=000,008
%        Number of components=001
%        Component ID=001
%        DC and AC table numbers=000
%        Ss=000
%        Se=063
%        Ah and Al=000

%% Define Size Image

Y = dec2hex(row_aspect,4);
X = dec2hex(col_aspect,4);
signal(1,164) = hex2dec(Y(1,1:2));
signal(1,165) = hex2dec(Y(1,3:4));
signal(1,166) = hex2dec(X(1,1:2));
signal(1,167) = hex2dec(X(1,3:4));

%% Concatenate Coding + Header

JP_STREAM(1,1:size(signal,2))=signal(1,1:size(signal,2));
for j=1:1:size(matrix_code_decimal,1)
    JP_STREAM(1,size(signal,2)+j)=matrix_code_decimal(j,1);
end

%% JPG Data Store

JP_STREAM=JP_STREAM';
img_name = regexp(img_in,'\.','split');
img_name = img_name{1};
fid = fopen([img_name '.jpg'], 'wb');
if fid < 0
    error('Failed to open data file for write');
end
fwrite(fid,JP_STREAM,'uint8'); 
fclose(fid);
