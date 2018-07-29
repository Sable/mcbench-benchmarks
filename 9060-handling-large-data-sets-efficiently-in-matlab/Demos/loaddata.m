%% Load original data
load waferdata.mat
X=uint8(round(((X-70)/40)*(2^8-1)));
%X(5,:)=X(5,:)+5; % add offset
X=repmat(X,100,1);

a=whos('X');
Blocksize=a.bytes; % Size of raw data

%% How many blocks
% Calculate how many block to create in order to fill half of the available
% RAM
starting=300;
NumBlocks=floor(((ramsize-starting*2^20)/2)/Blocksize);

%% Num blocks and preallocate
[BlockLines, numPositions]=size(X);
numWafers=NumBlocks*BlockLines;

%% Pre allocate
data=myzerosuint8(numWafers,numPositions);

%% Build 
for Block=1:NumBlocks
    data((Block-1)*BlockLines+(1:BlockLines),:)=...
        X + uint8(3*(Block/NumBlocks)) + uint8(10*rand); % Ensure all integers
end
clear n n1 n2 n3 processnames a X NumBlocks Blocksize Block BlockLines indexes starting numWafers numPositions
