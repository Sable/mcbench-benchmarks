%Implements an example MAP decoder, soft-input soft-output. Uses a
%brute-force algorithm, which is useful for demonstration/learning
%purposes. 
%
% Copyright Colin O'Flynn, 2011. All rights reserved.
% http://www.newae.com
%
% Redistribution and use in source and binary forms, with or without modification, are
% permitted provided that the following conditions are met:
% 
%    1. Redistributions of source code must retain the above copyright notice, this list of
%       conditions and the following disclaimer.
% 
%    2. Redistributions in binary form must reproduce the above copyright notice, this list
%       of conditions and the following disclaimer in the documentation and/or other materials
%       provided with the distribution.
% 
% THIS SOFTWARE IS PROVIDED BY COLIN O'FLYNN ''AS IS'' AND ANY EXPRESS OR IMPLIED
% WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
% FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL COLIN O'FLYNN OR
% CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
% SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
% ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
% NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
% ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

function [llrs, codeword] = brute_force_map(feedback, feedforward, input, llr_input, nbits)
    
    if nbits > 16
        error('nbits too high')
    end
    
    %Convert input LLR into pberr, this equation is:
    %D = exp(-LLR/2) / (1+exp(-LLR);
    %P1 = D * exp(LLR/2)
    %P0 = D * exp(-LLR/2)    
    %Error will be minimum of those two
    pberr = zeros(1,nbits);
    for i=1:length(llr_input)
        D = exp(-llr_input(i)/2) / (1+exp(-llr_input(i)));
        pberr(i) = min([D*exp(llr_input(i)/2) D*exp(-llr_input(i)/2) ]);
    end
       
    %Generate every possible information sequence
    D = [0:2^nbits - 1];
    B = dec2bin(D);
    
    allValidInputs = zeros(2^nbits, nbits);
    
    %Convert from string to matrix
    for i=1:nbits
        allValidInputs(:,i) = str2num(B(:,i));
    end

    len = (nbits+3)*2;
    all_codewords = zeros(2^nbits, len);
    
    %Generate every possible codeword
    for i=1:2^nbits
        codeword = rsc_encode([feedback; feedforward], allValidInputs(i,:), 1);       
        all_codewords(i,:) =  reshape(codeword, 1, len);
    end   
        
    pcodeword = zeros(2^nbits, 1);
           
    %For every possible codeword & ours: find out Pcodeword
    for i=1:2^nbits
        %Generates an error vector indicating which bits are different
        %between received codeword & codeword we are testing against
        bitsInDiff = abs(input - all_codewords(i,:));
       
        %Generates a vector with only the probabilities of bits in error
        pbErrVect = bitsInDiff .* pberr;
        
        %Get non-zero elements, multiple together, this works on previous
        %operation which got only probabilities of bits we care about
        pbCodeError = prod(pbErrVect(find(pbErrVect)));
        
        %Do same steps as above, I haven't duplicate the documentation
        %though
        bitsSame = 1-bitsInDiff;
        pbOkVect = bitsSame .* (1-pberr);
        pbCodeOk = prod(pbOkVect(find(pbOkVect)));       
        
        %Find APP Pr{X | Y}
        % X = Codeword that was transmitted
        % Y = Codeword that was receieved
        pcodeword(i) = pbCodeError * pbCodeOk;
    end
    
    %Limited valid Tx codewords, so normalize probability to add up to 1.0
    pcodeword = pcodeword ./ (sum(pcodeword));

    %Find resulting maximum likilhood codeword
    [Pmax, Imax] = max(pcodeword);
    
    %The suggested codeword
    codeword = all_codewords(Imax, :);
    
    %Reshape to make division between systematic & parity obvious
    %Now looks like: [systematic ; parity]
    codeword = reshape(codeword, 2, len/2);

    %Calculate individual probability of error
    p0Systematic = zeros(1, nbits);
    for bitindex=1:nbits
        psum = 0;
        
        %Sum over all codewords
        for i=1:2^nbits            
            %Reshape codeword to easily get systematic part out
            codewords_reshaped = reshape(all_codewords(i,:), 2, len/2);
            
            %If codeword has bit n as zero, count it in summation
            if codewords_reshaped(1, bitindex) == 0
                psum = psum + pcodeword(i);
            end
        end 
        
        %Save total probability of ALL codewords with bit 'n' is zero
        p0Systematic(bitindex) = psum; 
    end
    
    %Find probability any given bit is ONE
    p1Systematic = 1.0 - p0Systematic;    
    
    %From P1 & P0 calculate LLR
    llrs = log(p1Systematic ./ p0Systematic);