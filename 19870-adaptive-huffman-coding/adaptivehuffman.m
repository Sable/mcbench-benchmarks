function huffstream = adaptivehuffman(stream,type)
%
%==========================================================================
%                    Matt Clarkson - University of Bath
%
%                             Copyleft 2008
%==========================================================================
%
% huffstream = adaptivehuffman(stream,type)
%
% Adaptively encodes or decodes an integer stream.  If type is not defined
% the program inspects the input stream and failing to find a suitable
% adaptively encoded huffman stream the program defaults to compression.
%
% The stream has a two bit header containing the bit depth of the symbols.
% This is easily removed if a constant bit depth is always going to be
% used.
%
% To help visualise the huffman tree a function "treedetails" can be called
% at any point to display the values of each node.
% 
% Examples:
%
% huffstream = adaptivehuffman(stream) returns a adaptively huffman encoded
% stream or a decompressed string depending on the input.  For compression 
% the input must be a one dimensional horizontal unsigned integer  
% array.  8 and 16 bit depths are accepted.  For decompression the
% input must be a previously encoded string
%
% huffstream = adaptivehuffman(stream,'enc') returns compressed stream.
% Also the compression percentage is printed.
%
% huffstream  = adaptivehuffman(stream,'dec') returns the result of
% decompressing a previously compressed huffman stream.
%
%==========================================================================

%==========================================================================
%Insect input stream
%==========================================================================
if nargin < 2;    %Inspects input stream
    if isinteger(stream)...    %If integer...
       && (size((unique(stream)),2) == 2)...     %and has two symbols...
       && isa(stream,'uint8')...    %and a usigned 8 bit integer stream...
       && ~(size(size(stream),2)~=2)...     %and is 2D...
       && (size(stream,1) == 1 && size(stream,2) > 0)...    %and is 1D horizontal...
       && sum(unique(stream)) == 1     %and is binary stream   
        type = 'dec';
    else
        type = 'enc';
    end
end
if ~strcmp(type,'dec')     %If not decoding, encode
    
%==========================================================================
%Adaptive Huffman Encoding
%==========================================================================
clear type
%--------------------------------------------------------------------------
%Check stream structure
%--------------------------------------------------------------------------
    if ~isinteger(stream);error('Input must be unsigned integer stream');end
    for i = 3:6;if isa(stream, num2str(2^i,'int%i'));error('Input must be unsigned integer stream');end;end
    if size(size(stream),2)~=2 || ~(size(stream,1) == 1 && size(stream,2) > 0)
        error('Input must be a one dimensional horizontal stream');
    end
%--------------------------------------------------------------------------
%Find bit depth of stream and check for accepted bit depths
%--------------------------------------------------------------------------
    for i = 3:6
        if isa(stream, num2str(2^i,'uint%i'));bitdepth = 2^i;end;
    end
    if ~exist('bitdepth','var');error('Input stream must be a unsigned integer');end;
    if bitdepth == 64 || bitdepth == 32;error('Bit depth must be 8 or 16');end;
%--------------------------------------------------------------------------
%Set up the Not Yet Transmitted (NYT) Node and Tree Structure
%--------------------------------------------------------------------------
    huffstream = uint8([]);     %Initialise outputstream
    NYT = unique(stream);     %Find unique symbols and create NYT list
    NYTlocation = double(max(NYT))+2;     %Set the NYT location
    n = length(stream);     %Find length of stream
    nodenumber = (2*n);     %Find the amount of nodes
    tree(1).number = nodenumber;     %Total number of nodes
    tree(1).parent = 0;     %Node parent
    tree(1).left = 0;     %Node left child
    tree(1).right = 0;     %Node right child
    tree(1).symbol = NYTlocation;     %Node symbol
    tree(1).weight = 0;     %Node Weight
    location = zeros(1,NYTlocation);     %Location of the symbols in the tree
    location(NYTlocation) = 1;     %Location of the NYT node
%--------------------------------------------------------------------------
%Add a one bit header to the huffman stream where 0 and 1 represent
%8 and 16 bit depths respectively.  If the function is going to be used
%with only one bit depth the following line can be commented out.  Make
%sure, the bit depth in the decoding section is changed accordingly
%--------------------------------------------------------------------------
    huffstream = [huffstream uint8(bitget((log2(bitdepth)-3),1))];
%--------------------------------------------------------------------------
%Huffman Tree loop
%--------------------------------------------------------------------------
    wb = waitbar(0,'Please Wait...','Name','Encoding');     %Creates progress bar
    for index = 1:n     %For whole stream
        symbol = stream(index);     %Read in symbol
        if sum(NYT == symbol)     %Symbol seen before?
            nodecode(NYTlocation-1)     %Add NYT code to the output stream
            treeloop(symbol);      %Start the huffman tree loop for symbol
            huffstream(length(huffstream)+1:length(huffstream)+bitdepth) = uint8(bitget(symbol,bitdepth:-1:1));     %Output symbol
        else        
            nodecode(symbol);     %Add NYT code to the output stream
            treeloop(symbol);      %Start the huffman tree loop for symbol
        end
        waitbar(index/n,wb);     %Update progress bar
    end
    close(wb)     %Close progress bar
    if nargin==2;fprintf(['Compressed: ' num2str((length(huffstream)/(length(stream)*bitdepth))*100,'%6.2f') '%%\n']);end;
else
    
%==========================================================================
%Adaptive Huffman Decoding
%==========================================================================
clear type
%--------------------------------------------------------------------------
%Finds bitdepth.  If the function is going to be used with only one bit
%depth alter the commenting of the following three assignments.  Make sure
%that, if a constant bit rate is going to be used, the header assignment in
%the encoding part of the function is commented out.
%--------------------------------------------------------------------------
    bitdepth = 2^((bits2dec(stream(1)))+3);stream(1)=[];
    %bitdepth = 8;
    %bitdepth = 16;
%--------------------------------------------------------------------------
%Set up the Not Yet Transmitted (NYT) Node and Tree Structure
%--------------------------------------------------------------------------
    huffstream = eval(num2str(bitdepth,'uint%i([])'));     %Initialise outputstream
    NYT = 0:(2^bitdepth)-1;     %Find unique symbols and create NYT list
    NYTlocation = max(NYT)+2;     %Set the NYT location
    n = length(stream);     %Find length of stream
    nodenumber = max(2*NYT)+1;     %Find the amount of nodes
    tree(1).number = nodenumber;     %Total number of nodes
    tree(1).parent = 0;     %Node parent
    tree(1).left = 0;     %Node left child
    tree(1).right = 0;     %Node right child
    tree(1).symbol = NYTlocation;     %Node symbol
    tree(1).weight = 0;     %Node Weight
    location = zeros(1,NYTlocation);     %Location of the symbols in the tree
    location(NYTlocation) = 1;     %Location of the NYT node
%--------------------------------------------------------------------------
%Perform Decoding
%--------------------------------------------------------------------------
    wb = waitbar(0,'Please Wait...','Name','Decoding');     %Creates progress bar
    progress = length(stream);     %Value to update progress bar
    while ~isempty(stream);     %While stream is not empty
        position = 1;      %Go to root node
        while isempty(tree(position).symbol);     %If position is not a leaf
            if stream(1)     %If bit is 1
                position = tree(position).right;     %Go right
                stream(1) = [];     %Remove bit from stream
            else     %If bit is 0
                position = tree(position).left;     %Go left
                stream(1) = [];     %Remove bit from stream
            end                
        end
        if tree(position).symbol == NYTlocation     %If node is NYT
            symbol = bits2dec(stream(1:bitdepth));     %Finds first symbol
            stream(1:bitdepth) = [];     %Removes symbol from bit stream
            huffstream = [huffstream symbol];    %Adds to output stream
        else
            symbol = tree(position).symbol;     %Output known symbol
            huffstream = [huffstream symbol];    %Adds to output stream
        end
        treeloop(symbol)    %Updates the tree
        waitbar((progress-length(stream))/progress,wb);     %Update progress bar        
    end
    close(wb)     %Close progress bar
end
%==========================================================================
%End of Adaptive Huffman Coding, Sub Functions follow
%==========================================================================

function treeloop(symbol)
%==========================================================================
%Performs loop for putting symbols into the tree
%==========================================================================
    if sum(NYT == symbol)     %Has symbol been seen before
        newsymbol(symbol);     %Expand NYT Node
        updatetree(symbol,1);     %Update tree
    else
        updatetree(symbol,0);     %Update tree, do not go to parent node
    end
end

function newsymbol(symbol)
%==========================================================================
%Inserts a new symbol into the tree
%==========================================================================
    parent = location(NYTlocation);     %Find the location of the NYT node
    nyt = length(tree)+1;     %Find the next available tree space
    right = length(tree)+2;     %Find another available tree space
%--------------------------------------------------------------------------
%Insert the new symbol
%--------------------------------------------------------------------------
    nodenumber = nodenumber - 1;    %Decrease node number
    tree(right) = tree(parent);     %Copy structure to the right child
    tree(right).number = nodenumber;     %Assign node a number
    tree(right).parent = parent;     %Assign Parent Node
    tree(right).symbol = symbol;     %Assign New Symbol
    tree(right).weight = 1;     %Weight of one
    location(symbol+1) = right;     %Update location of node
%--------------------------------------------------------------------------
%Move the Not Yet Transmitted Node
%--------------------------------------------------------------------------
    nodenumber = nodenumber - 1;    %Decrease node number    
    tree(nyt) = tree(parent);     %Copy NYT node to the left child
    tree(nyt).number = nodenumber;     %Assign node a number
    tree(nyt).parent = parent;     %Assign parent node
    tree(nyt).symbol = NYTlocation;     %Assign NYT symbol
    location(NYTlocation) = nyt;     %Update location of NYT node
%--------------------------------------------------------------------------
%Update Parent
%--------------------------------------------------------------------------
    tree(parent).left = nyt;     %Assign child node
    tree(parent).right = right;     %Assign child node
    tree(parent).symbol = [];     %Blank symbol as branch
    tree(parent).weight = 1;     %Set weight
%--------------------------------------------------------------------------
%Remove Symbol from NYT list
%--------------------------------------------------------------------------
    NYT(NYT==symbol) = [];
end

function updatetree(symbol,skip)
%==========================================================================
%Reorganises tree if necessary andincrease the weight of the node
%==========================================================================
    position = location(symbol+1);      %Set pointer position
    while 1     %Continue to loop
        if skip     %Skips node number checking from NYT node
%--------------------------------------------------------------------------
%Put weights and node numbers into an array
%--------------------------------------------------------------------------
            weights = [];weights = [weights tree.weight];
            numbers = [];numbers = [numbers tree.number];
%--------------------------------------------------------------------------
%Check node if is highest ranked for weight and if so the highest rank is
%not the root node or the nodes parent
%--------------------------------------------------------------------------
            if tree(position).number ~= max(numbers(weights == tree(position).weight))...
                    && find(max(numbers(weights == tree(position).weight))) ~= 1 &&...
                    find(max(numbers(weights == tree(position).weight))) ~= tree(position).parent;
%--------------------------------------------------------------------------
%Store position of node with the higher rank
%--------------------------------------------------------------------------
                bignode = find(numbers == max(numbers(weights == tree(position).weight)));
%--------------------------------------------------------------------------
%Store current nodes parent and node number
%--------------------------------------------------------------------------
                tempparent = tree(position).parent;
                tempnodenumber = tree(position).number;
%--------------------------------------------------------------------------
%Move current node
%--------------------------------------------------------------------------
                tree(position).parent = tree(bignode).parent;
                tree(position).number = tree(bignode).number;
%--------------------------------------------------------------------------
%Update parents child locator
%--------------------------------------------------------------------------
                if tree(tree(position).parent).left == tree(position).parent
                    tree(tree(position).parent).left = position;
                else
                    tree(tree(position).parent).right = position;
                end
%--------------------------------------------------------------------------
%Update old node
%--------------------------------------------------------------------------
                tree(bignode).parent = tempparent;
                tree(bignode).number = tempnodenumber;
%--------------------------------------------------------------------------
%Update parents child locator
%--------------------------------------------------------------------------
                if tree(tree(bignode).parent).left == tree(bignode).parent
                    tree(tree(bignode).parent).left = bignode;
                else
                    tree(tree(bignode).parent).right = bignode;
                end
                clear bignode tempparent tempnodenumber     %Keep workspace tidy
            end    
        tree(position).weight = tree(position).weight + 1;     %Inc Weight by 1
        end
        if skip;skip = 0;end     %Enables node number checking 
        if position == 1;break;end;
        position = tree(position).parent;
        clear weights numbers    %Keep workspace tidy
    end
    clear position
end

function nodecode(symbol)
%==========================================================================
%Finds the code from the root to the leaf
%==========================================================================
    position = location(symbol+1);      %Set pointer position
    tempcode = [];
    while position ~= 1
        if tree(tree(position).parent).left == position     %If left branch
            tempcode = [uint8(0) tempcode];    %Assign binary zero
        else     %If right branch
            tempcode = [uint8(1) tempcode];    %Assign binary one
        end
        position = tree(position).parent;     %Move up tree
    end
    huffstream = [huffstream tempcode];     %Add symbol code to Huffman stream
    clear tempcode position     %Keep workspace tidy
end

function treedetails
%==========================================================================
%Displays tree details (debug)
%==========================================================================
    fprintf('   ,------------');for n=1:length(tree);fprintf('-------');               end;    fprintf('.\n');
    fprintf('   |Tree node   ');for n=1:length(tree);fprintf('| % 4i ',n);             end;    fprintf('|\n');
    fprintf('   |------------');for n=1:length(tree);fprintf('-------');               end;    fprintf('|\n');
    fprintf('   |Node Number ');for n=1:length(tree);fprintf('| % 4i ',tree(n).number);end;    fprintf('|\n');
    fprintf('   |Node Parent ');for n=1:length(tree);fprintf('| % 4i ',tree(n).parent);end;    fprintf('|\n');
    fprintf('   |Node Left   ');for n=1:length(tree);fprintf('| % 4i ',tree(n).left);  end;    fprintf('|\n');
    fprintf('   |Node Right  ');for n=1:length(tree);fprintf('| % 4i ',tree(n).right); end;    fprintf('|\n');
    fprintf('   |Node Symbol ');for n=1:length(tree);
                          if isempty(tree(n).symbol);fprintf('|empty ',tree(n).symbol);else
                                                     fprintf('| % 4i ',tree(n).symbol);end;end;fprintf('|\n');    
    fprintf('   |Node Weight ');for n=1:length(tree);fprintf('| % 4i ',tree(n).weight);end;    fprintf('|\n');  
    fprintf('   ''------------');for n=1:length(tree);fprintf('-------');              end;    fprintf('''\n');
end

end     %End of adaptive huffman

%==========================================================================
%Seperate functions
%==========================================================================

function dec = bits2dec(bits)
%==========================================================================
%Returns a decimal value from a bit array
%==========================================================================
     dec = bin2dec(int2str(bits));
end