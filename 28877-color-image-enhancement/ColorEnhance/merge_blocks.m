
%Author : Athi Narayanan S
%M.E, Embedded Systems,
%K.S.R College of Engineering
%Erode, Tamil Nadu, India.
%http://sites.google.com/site/athisnarayanan/

function mergedBlks = merge_blocks(data)

s = size(data);
mergedBlks = zeros((s(3) * s(1)), (s(4) * s(2)));

%Merging the Blocks
for i = 1 : s(3)
    for j = 1 : s(4)
        localBlk = data(:,:,i,j);
        rowStart = ((i - 1) * s(1)) + 1;
        rowEnd = i * s(1);
        colStart = ((j - 1) * s(2)) + 1;
        colEnd = j * s(2);
        mergedBlks(rowStart:rowEnd, colStart:colEnd) = localBlk;
    end
end