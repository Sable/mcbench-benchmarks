
%Email: samira_ebrahimi@hotmail.com ,please contact me if you could improve
%this code, Thanks.

function [timeC,timeDC,sourcestr,decoded]=mainLZ77(sourcestr)

searchWindowLen=31;
lookAheadWindowLen=31;
tic
      fprintf('LZ77-Compression is started.');
      
      sourcestr=[sourcestr '$'];
      coded=encode(sourcestr,searchWindowLen,lookAheadWindowLen);
      
      fprintf('\n LZ77-Compression is finished.');
timeC=toc;
tic
    fprintf('\n LZ77-Decompression is started.');
    
    decoded=decode(coded,searchWindowLen,lookAheadWindowLen);
    
    fprintf('\n LZ77-Decompression is finished.');
timeDC=toc;
ok=isequal(sourcestr,decoded)
end
%--------------------------------------------------------------------------
function result=returnPartOfString(str,startindex,endindex)
result=str(startindex:endindex);
end
%--------------------------------------------------------------------------
function decompressed=decode(binaryStr,searchWindowLen,lookAheadWindowLen)

decompressed='';
bytenumSW=length(dec2bin(searchWindowLen));
bytenumLA=length(dec2bin(lookAheadWindowLen));
i=1;

while i<length(binaryStr)
    SW=returnPartOfString(binaryStr,i,i-1+bytenumSW);
    SWdec=bin2dec(SW);
    i=i+bytenumSW;    
    if(SWdec~=0)
        LA=returnPartOfString(binaryStr,i,i-1+bytenumLA);
        LAdec=bin2dec(LA);
        i=i+bytenumLA;
    else
        LAdec=0;
    end
    
    Chr=returnPartOfString(binaryStr,i,i-1+8);
    Chrch=char(bin2dec(Chr));
    i=i+8;

    if(SWdec==0)
        decompressed=strcatNew(decompressed,Chrch);
 
    else
        location=length(decompressed)-SWdec;
        
        for j=1:LAdec
        decompressed=strcatNew(decompressed,decompressed(location+j));
                
        end
        decompressed=strcatNew(decompressed,Chrch);

    end    
end
end
%--------------------------------------------------------------------------
function compressed=encode(str,searchWindowLen,lookAheadWindowLen)

compressed='';
i=1; %codeindex

while i<=length(str)
    startindex=i-searchWindowLen;
    if(startindex)<1
        startindex=1;
    end
    
    if(i==1)
        searchBuffer='';
    else
    searchBuffer= returnPartOfString(str,startindex,i-1);
    end   
    %searchBuffer
     
    endindex=i+lookAheadWindowLen-1;

    if(endindex)>length(str)
        endindex=length(str);
    end
    lookAheadBuffer=returnPartOfString(str,i,endindex);
    %lookAheadBuffer
    j=1;
    tobesearched=returnPartOfString(lookAheadBuffer,1,j);
    searchresult=strfind(searchBuffer,tobesearched);

    if(numel(lookAheadBuffer) > j)

        while (size(searchresult)~=0)
            j=j+1;
            if(j<=numel(lookAheadBuffer))
            %if(numel(lookAheadBuffer)<j)
            %lookAheadBuffer=strcat(lookAheadBuffer,'$');
            %end            
            tobesearched=returnPartOfString(lookAheadBuffer,1,j);
            searchresult=strfind(searchBuffer,tobesearched);
            else
                break;
            end
        end
    end

    if (j>1)
    tobesearched=returnPartOfString(lookAheadBuffer,1,j-1);
    searchresult=strfind(searchBuffer,tobesearched);
    end

    dim=size(searchresult);

    if(dim>0)
        occur=length(searchBuffer)-searchresult(dim(2))+1;
    else
        occur=0;
    end
    
        
    bytenum=length(dec2bin(searchWindowLen));

    if(occur~=0)
        compressed=strcatNew(compressed,addZeros(dec2bin(occur),bytenum));
        compressed=strcatNew(compressed,addZeros(dec2bin(j-1),bytenum));
        if(j>searchWindowLen)
            compressed=strcatNew(compressed,addZeros(dec2bin(str(i+j)-0),8));
        else
            compressed=strcatNew(compressed,addZeros(dec2bin(lookAheadBuffer(j)-0),8));
        end
        
    else
        %ignoring 2nd zero in compressed string
        compressed=strcatNew(compressed,addZeros(dec2bin(occur),bytenum));
        %compressed=strcat(compressed,addZeros(dec2bin(j-1),bytenum));
        if(j>searchWindowLen)
            compressed=strcatNew(compressed,addZeros(dec2bin(str(i+j)-0),8));
        else
            compressed=strcatNew(compressed,addZeros(dec2bin(lookAheadBuffer(j)-0),8));
        end
        
    end

    fprintf('\n<%d,%d,C(%c)>',occur,j-1,lookAheadBuffer(j));
    %fprintf('\n search result');
    %searchresult
    %fprintf('\n searchbuffer');
    %searchBuffer
    %fprintf('\n looAheadBuffer');
    %lookAheadBuffer
    pause
    i=i+j;
end
end
%--------------------------------------------------------------------------
function str=addZeros(str,num)

for i=1:(num-length(str))
    str=strcatNew('0',str);
end
end
%--------------------------------------------------------------------------
function str=strcatNew(first,second)
str=[first second];
end