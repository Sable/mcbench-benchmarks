function [codeDec codeBin]=LempelZiv(A,Str)
%Lempel-Ziv coding of a String of char "Str" with an initial alphabet "A"


L=length(A);                %Length of alphabet
codebook=cell(L,1);         %Array for codebook
for j=1:L                   %Initializing codebook
    codebook{j}=A(j);
end

%some indexes
i=1;
k=1;

while i<=length(Str),       %For each char
flag=0;                     %costraint
search=Str(i);              %symbol for research

    while flag==0,
        index=search_cell(codebook,search);  %Search the symbol into the codebook
        if index~=0             %Symbol Found
            codeDec(k)=index;   %Add to code
            i=i+1;          
            if i<=length(Str)   %If the string isn't finished
                search=[search Str(i)];
            else
                flag=1;         %exit from while
            end
        else                    %Symbol ~Found
            flag=1;             %exit from while
            codebook{length(codebook)+1}=search;   %add it to codebook
        end
        
    end
    
k=k+1;    %number of symbols of code
end

codeDec=codeDec';
codeBin=dec2bin(codeDec,ceil(log2(max(codeDec))));
