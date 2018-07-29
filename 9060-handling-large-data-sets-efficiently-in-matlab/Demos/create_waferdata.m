%% Load original data
load waferdata.mat
filename='waferdata.csv';

%% Num blocks
NumBlocks = 300000; %300,000 for 2.6GB

%% Convert
Data=X';
[NumSamples,NumRuns]=size(Data);
FormatString=['%d,%d' repmat(',%d',1,18) '\n' ];
CharsPerElement=11;

disp(['Text file will be ' num2str(NumBlocks*NumSamples*NumRuns*CharsPerElement) 'Bytes']);

%% Open
fid=fopen(filename,'w');

Header1='Wafer Number, Process Type, seg, MF, 1)Middle, 2)Middle Top, 3)Middle Left, 4)Middle Bottom, 5)Middle Right, 6)Top Left, 7)Lower Left, 8)Lower Right, 9)Top Right,Ai,Bi,X7,Hold,Out1,Out2,Blank';
Header2='xcoord,,,, 0, 0, -1,  0, 1, -1.3, -1.3, 1.3, 1.3,,,,,,,';
Header3='ycoord,,,, 0, 1,  0, -1, 0, 1.3, -1.3, -1.3, 1.3,,,,,,,';

%% Write Header
% str='Wafer Number';
% for i=1:9, str=[str ', Location ' num2str(i)]; end

fprintf(fid,'%s\n',Header1);
fprintf(fid,'%s\n',Header2);
fprintf(fid,'%s\n',Header3);

tic
%% Build and write
for Block=1:NumBlocks
    if (rem(Block,100)==0)
	disp(['Block ' num2str(Block)]);
    end

    indexes=ceil(NumRuns*rand(1,NumRuns));

    n1=0.001*randn(NumSamples,39);
    n2=0.002*randn(NumSamples,39);
    n3=0.001*randn(NumSamples,38)-10;

    n=[n1 n2 n3];
    NewData=Data(:,indexes(1:NumRuns))+ n; 
    processtype=[repmat(1,1,39) repmat(2,1,39) repmat(2,1,38)];
    IntData=round(((NewData-70)/40)*(2^8-1)); % 70  to 110
    Chunk=[(Block-1)*NumRuns+(1:NumRuns);processtype; repmat(0,1,116); repmat(1,1,116); IntData; repmat(1,1,116);repmat(0,1,116);repmat(255,1,116);repmat(69,1,116);repmat(67,1,116);repmat(100,1,116);repmat(5,1,116)];
    fprintf(fid,FormatString, Chunk );
end
toc
%% Close
fclose(fid);
disp('Finished');