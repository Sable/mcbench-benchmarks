% simulation of uncoded MPSK
% compute SER/BER curves for uncoded MPSK
%
% Dr B. Gremont 2007
format short
clear
clc


for M=2.^(1:1:4),% M-arity

    k=log2(M);
    coderate=1; % no coding here


    % gray mapping look-up table
    jval = (0:M-1)';
    mapping = bitxor(jval,bitshift(jval,-1));
    bitmap=deci2bin(mapping',k);
    symbolmapping=[(0:M-1)' bitmap];
    si=exp(j.*2.*pi./M.*(0:M-1)'); % all the M possible symbols (complex)
    %====================================
    % Simulation Parameters
    %====================================
    NoofSymbolsPerWord=2000;

    if M<=4,
        EbNodBVals=-2:2:8;
    elseif M==8
        EbNodBVals=-2:2:12;
    else
        EbNodBVals=-2:2:16;
    end

    NoOfBitsPerWord=k.*NoofSymbolsPerWord;

    for SNR=1:length(EbNodBVals),
        TotalNoBitErrors=0;
        TotalNoSymbolErrors=0;
        TotalNoBits=0;
        TotalNoSymbols=0;

        while TotalNoBitErrors<1,
            % generate bit stream
            m=floor(rand(1,NoOfBitsPerWord).*2);
            % serial to parralel
            m1=reshape(m, k, NoofSymbolsPerWord);
            % do MPSK modulation
            s=zeros(1,length(m1));
            x1=zeros(1,length(m1)); % symbols in decimal label format
            % look-up for modulator
            for counter=1:length(m1),
                data=m1(1:k,counter)';
                for counter2=1:M,
                    if data== symbolmapping(counter2,2:end),
                        x1(counter)=symbolmapping(counter2,1);
                        s(counter)=exp(j.*2.*pi./M.*symbolmapping(counter2,1));
                    end
                end
            end
            % Create AWGN complex noise
            EbNo=10.^(EbNodBVals(SNR)./10);
            EsNo=EbNo.*coderate.*log2(M);
            Es=1;
            No=Es./EsNo;
            if M>2,
                sigma=sqrt(No./2);
            else
                sigma=sqrt(No./2);
            end
            n=sigma.*(randn(size(s))+j.*randn(size(s)));
            r=s+n; %awgn, r= received signal

            % Minimum squared Euclidean distance symbol-by-symbol demodulator
            x1_est=zeros(1,length(r)); % estimated symbols (decimal index)
            m1_est=zeros(k,length(r)); % estimated bit strean

            for counter=1:length(r),
                distances=abs(r(counter)-si).^2;
                I=find(distances==min(distances));
                x1_est(counter)=I(1)-1; % holds the symbol number 0 to M-1
                I=find(symbolmapping(:,1)==x1_est(counter));
                m1_est(:,counter)=(symbolmapping(I(1),2:end))';
            end
            % parralel to serial
            m_est=reshape(m1_est,1,k.*length(r)); % estimated bit stream
            TotalNoSymbolErrors=TotalNoSymbolErrors+length(find(x1_est~=x1));
            TotalNoBitErrors=TotalNoBitErrors+length(find(m~=m_est));
            TotalNoBits=TotalNoBits+NoOfBitsPerWord;
            TotalNoSymbols=TotalNoSymbols+NoofSymbolsPerWord;
        end
        clc
        disp(['Es/No = ' num2str(10.*log10(EsNo)) ' dB done!'])
        disp(['Eb/No = ' num2str(EbNodBVals(SNR)) ' dB done!'])
        SER(SNR)=TotalNoSymbolErrors./TotalNoSymbols;
        BER(SNR)=TotalNoBitErrors./TotalNoBits;
        disp(['SER = ' num2str(SER(SNR))])
        disp(['BER = ' num2str(BER(SNR))])
    end

    EbNo=10.^(EbNodBVals./10);
    EsNodBVals=10.*log10(EbNo.*log2(M));
    EsNo=10.^(EsNodBVals./10);
    figure(1)
    if M==2,
        if ishold, hold,end
        Pb2=q(sqrt(2.*EbNo));
        semilogy(EbNodBVals,BER,'*r',EbNodBVals,Pb2)
        hold
    elseif M==4,
        Pb4=2./k.*q(sqrt(2.*EbNo)).*(1-0.5.*q(sqrt(2.*EbNo)));
        semilogy(EbNodBVals,BER,'*b',EbNodBVals,Pb4,EbNodBVals,q(sqrt(2.*EbNo)))
    else
        Pb=2.*q(sqrt(2.*EsNo).*sin(pi./M))./log2(M);
        semilogy(EbNodBVals,BER,'*k',EbNodBVals,Pb)
    end
    figure(2)
    if M==2,
        if ishold, hold, end
        Ps2=q(sqrt(2.*EsNo));
        semilogy(EsNodBVals,SER,'*r',EsNodBVals,Ps2)
        hold
    elseif M==4,
        Ps4=2.*q(sqrt(2.*EbNo)).*(1-0.5.*q(sqrt(2.*EbNo)));
        semilogy(EsNodBVals,SER,'*b',EsNodBVals,Ps4)
    else
        Ps=2.*q(sqrt(2.*EsNo).*sin(pi./M));
        semilogy(EsNodBVals,SER,'*k',EsNodBVals,Ps)
    end

    figure(1)
    %title(['MPSK, M = ' num2str(M)])
    xlabel('Eb/No (dB)'); ylabel('BER')
    figure(2)
    %title(['MPSK, M = ' num2str(M)])
    xlabel('Es/No (dB)'); ylabel('SER')
end
