%% Load original data
load waferdata.mat
filename='waferdata_uint8.bin';

%% Num blocks
NumBlocks = 2e4; %Set to 1.5e6 for ~3GB, 2e4 for 45MB file 

%% Convert
Data=X';
[NumSamples,NumRuns]=size(Data);

%% Open
fid=fopen(filename,'wb');

%% Write Header
tic
%% Build and write
for Block=1:NumBlocks
    if (rem(Block,1000)==0)
	disp(['Block ' num2str(Block)]);
    end

    indexes=ceil(NumRuns*rand(1,NumRuns));

    n1=0.001*randn(NumSamples,39);
    n2=0.002*randn(NumSamples,39);
    n3=0.001*randn(NumSamples,38)+10;

    n=[n1 n2 n3];
    NewData=Data(:,indexes(1:NumRuns))+ n; 
    processtype=[repmat(1,1,39) repmat(2,1,39) repmat(3,1,38)];
    IntData=round(((NewData-70)/40)*2^8);
    Chunk=[(Block-1)*NumRuns+(1:NumRuns);processtype; repmat(0,1,116); repmat(-1,1,116); IntData; repmat(-1,1,116);repmat(0,1,116);repmat(0,1,116);repmat(69,1,116);repmat(67,1,116);repmat(100,1,116);repmat(5,1,116)];
    fwrite(fid,Chunk,'uint8' );
end
toc
%% Close
fclose(fid);
disp('Finished');