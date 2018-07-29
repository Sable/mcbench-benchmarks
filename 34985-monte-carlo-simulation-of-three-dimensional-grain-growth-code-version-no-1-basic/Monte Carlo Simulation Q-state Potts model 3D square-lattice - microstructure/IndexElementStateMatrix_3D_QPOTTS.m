function IESM = IndexElementStateMatrix_3D_QPOTTS(x,caseis,state,i,j,k)
I=size(x,1);J=size(x,1);K=size(x,1);IESM=zeros(3,3,3);
if caseis==1 % BSV 1
    IESM(:,:,1)=[state(I,J,K) state(I,1,K) state(I,2,K);state(1,J,K) state(1,1,K) state(1,2,K);state(2,J,K) state(2,1,K) state(2,2,K)];
    IESM(:,:,2)=[state(I,J,1) state(I,1,1) state(I,2,1);state(1,J,1) state(1,1,1) state(1,2,1);state(2,J,1) state(2,1,1) state(2,2,1)];
    IESM(:,:,3)=[state(I,J,2) state(I,1,2) state(I,2,2);state(1,J,2) state(1,1,2) state(1,2,2);state(2,J,2) state(2,1,2) state(2,2,2)];
elseif caseis==3 % BSV 2
    IESM(:,:,1)=[state(I-1,J,K) state(I-1,1,K) state(I-1,2,K);state(I,J,K) state(I,1,K) state(I,2,K);state(1,J,K) state(1,1,K) state(1,2,K)];
    IESM(:,:,2)=[state(I-1,J,1) state(I-1,1,1) state(I-1,2,1);state(I,J,1) state(I,1,1) state(I,2,1);state(1,J,1) state(1,1,1) state(1,2,1)];
    IESM(:,:,3)=[state(I-1,J,2) state(I-1,1,2) state(I-1,2,2);state(I,J,2) state(I,1,2) state(I,2,2);state(1,J,2) state(1,1,2) state(1,2,2)];
elseif caseis==5 % BSV 3
    IESM(:,:,1)=[state(I-1,J-1,K) state(I-1,J,K) state(I-1,1,K);state(I,J-1,K) state(I,J,K) state(I,1,K);state(I,1,K) state(1,J,K) state(1,1,K)];
    IESM(:,:,2)=[state(I-1,J-1,1) state(I-1,J,1) state(I-1,1,1);state(I,J-1,1) state(I,J,1) state(I,1,1);state(I,1,1) state(1,J,1) state(1,1,1)];
    IESM(:,:,3)=[state(I-1,J-1,2) state(I-1,J,2) state(I-1,1,2);state(I,J-1,2) state(I,J,2) state(I,1,2);state(I,1,2) state(1,J,2) state(1,1,2)];
elseif caseis==7 % BSV 4
    IESM(:,:,1)=[state(I,J-1,K) state(I,J,K) state(I,1,K);state(1,J-1,K) state(1,J,K) state(1,1,K);state(2,J-1,K) state(2,J,K) state(2,1,K)];
    IESM(:,:,2)=[state(I,J-1,1) state(I,J,1) state(I,1,1);state(1,J-1,1) state(1,J,1) state(1,1,1);state(2,J-1,1) state(2,J,1) state(2,1,1)];
    IESM(:,:,3)=[state(I,J-1,2) state(I,J,2) state(I,1,2);state(1,J-1,2) state(1,J,2) state(1,1,2);state(2,J-1,2) state(2,J,2) state(2,1,2)];
elseif caseis==9 % BSV 5
    IESM(:,:,1)=[state(I,J,K-1) state(I,1,K-1) state(I,2,K-1);state(1,J,K-1) state(1,1,K-1) state(1,2,K-1);state(2,J,K-1) state(2,1,K-1) state(2,2,K-1)];
    IESM(:,:,2)=[state(I,J,K) state(I,1,K) state(I,2,K);state(1,J,K) state(1,1,K) state(1,2,K);state(2,J,K) state(2,1,K) state(2,2,K)];
    IESM(:,:,3)=[state(I,J,1) state(I,1,1) state(I,2,1);state(1,J,1) state(1,1,1) state(1,2,1);state(2,J,1) state(2,1,1) state(2,2,1)];
elseif caseis==11 % BSV 6
    IESM(:,:,1)=[state(I-1,J,K-1) state(I-1,1,K-1) state(I-1,2,K-1);state(I,J,K-1) state(I,1,K-1) state(I,2,K-1);state(1,J,K-1) state(1,1,K-1) state(1,2,K-1)];
    IESM(:,:,2)=[state(I-1,J,K) state(I-1,1,K) state(I-1,2,K);state(I,J,K) state(I,1,K) state(I,2,K);state(1,J,K) state(1,1,K) state(1,2,K)];
    IESM(:,:,3)=[state(I-1,J,1) state(I-1,1,1) state(I-1,2,1);state(I,J,1) state(I,1,1) state(I,2,1);state(1,J,1) state(1,1,1) state(1,2,1)];
elseif caseis==13 % BSV 7
    IESM(:,:,1)=[state(I-1,J-1,K-1) state(I-1,J,K-1) state(I-1,1,K-1);state(I,J-1,K-1) state(I,J,K-1) state(I,1,K-1);state(I,1,K-1) state(1,J,K-1) state(1,1,K-1)];
    IESM(:,:,2)=[state(I-1,J-1,K) state(I-1,J,K) state(I-1,1,K);state(I,J-1,K) state(I,J,K) state(I,1,K);state(I,1,K) state(1,J,K) state(1,1,K)];
    IESM(:,:,3)=[state(I-1,J-1,1) state(I-1,J,1) state(I-1,1,1);state(I,J-1,1) state(I,J,1) state(I,1,1);state(I,1,1) state(1,J,1) state(1,1,1)];
elseif caseis==15 % BSV 8
    IESM(:,:,1)=[state(I-1,J,K-1) state(I-1,1,K-1) state(I-1,2,K-1);state(I,J,K-1) state(I,1,K-1) state(I,2,K-1);state(1,J,K-1) state(1,1,K-1) state(1,2,K-1)];
    IESM(:,:,2)=[state(I-1,J,K) state(I-1,1,K) state(I-1,2,K);state(I,J,K) state(I,1,K) state(I,2,K);state(1,J,K) state(1,1,K) state(1,2,K)];
    IESM(:,:,3)=[state(I-1,J,1) state(I-1,1,1) state(I-1,2,1);state(I,J,1) state(I,1,1) state(I,2,1);state(1,J,1) state(1,1,1) state(1,2,1)];
elseif caseis==2 % BSL 1 [ 1<i<I ]
    IESM(:,:,1)=[state(i-1,J,2) state(i-1,1,2) state(i-1,2,2);state(i-1,J,1) state(i-1,1,1) state(i-1,2,1);state(i-1,J,K) state(i-1,1,K) state(i-1,2,K)];
    IESM(:,:,2)=[state(i,J,2) state(i,1,2) state(i,2,2);state(i,J,1) state(i,1,1) state(i,2,1);state(i,J,K) state(i,1,K) state(i,2,K)];
    IESM(:,:,3)=[state(i+1,J,2) state(i+1,1,2) state(i+1,2,2);state(i+1,J,1) state(i+1,1,1) state(i+1,2,1);state(i+1,J,K) state(i+1,1,K) state(i+1,2,K)];
elseif caseis==6 % BSL 3 [ 1<i<I ]
    IESM(:,:,1)=[state(i-1,J-1,2) state(i-1,J,2) state(i-1,1,2);state(i-1,J-1,1) state(i-1,J,1) state(i-1,1,1);state(i-1,J-1,K) state(i-1,J,K) state(i-1,1,K)];
    IESM(:,:,2)=[state(i,J-1,2) state(i,J,2) state(i,1,2);state(i,J-1,1) state(i,J,1) state(i,1,1);state(i,J-1,K) state(i,J,K) state(i,1,K)];
    IESM(:,:,3)=[state(i+1,J-1,2) state(i+1,J,2) state(i+1,1,2);state(i+1,J-1,1) state(i+1,J,1) state(i+1,1,1);state(i+1,J-1,K) state(i+1,J,K) state(i+1,1,K)];
elseif caseis==14 % BSL 7 [ 1<i<I ]
    IESM(:,:,1)=[state(i-1,J-1,1) state(i-1,J,1) state(i-1,1,1);state(i-1,J-1,K) state(i-1,J,K) state(i-1,1,K);state(i-1,J-1,K-1) state(i-1,J,K-1) state(i-1,1,K-1)];
    IESM(:,:,2)=[state(i,J-1,1) state(i,J,1) state(i,1,1);state(i,J-1,K) state(i,J,K) state(i,1,K);state(i,J-1,K-1) state(i,J,K-1) state(i,1,K-1)];
    IESM(:,:,3)=[state(i+1,J-1,1) state(i+1,J,1) state(i+1,1,1);state(i+1,J-1,K) state(i+1,J,K) state(i+1,1,K);state(i+1,J-1,K-1) state(i+1,J,K-1) state(i+1,1,K-1)];
elseif caseis==10 % BSL 5 [ 1<i<I ]
    IESM(:,:,1)=[state(i-1,J,1) state(i-1,1,1) state(i-1,2,1);state(i-1,J,K) state(i-1,1,K) state(i-1,2,K);state(i-1,J,K-1) state(i-1,1,K-1) state(i-1,2,K-1)];
    IESM(:,:,2)=[state(i,J,1) state(i,1,1) state(i,2,1);state(i,J,K) state(i,1,K) state(i,2,K);state(i,J,K-1) state(i,1,K-1) state(i,2,K-1)];
    IESM(:,:,3)=[state(i+1,J,1) state(i+1,1,1) state(i+1,2,1);state(i+1,J,K) state(i+1,1,K) state(i+1,2,K);state(i+1,J,K-1) state(i+1,1,K-1) state(i+1,2,K-1)];
elseif caseis==17 % BSL 9 [ 1<k<K ]
    IESM(:,:,1)=[state(I,J,k-1) state(I,1,k-1) state(I,2,k-1);state(1,J,k-1) state(1,1,k-1) state(1,2,k-1);state(2,J,k-1) state(2,1,k-1) state(2,2,k-1)];
    IESM(:,:,2)=[state(I,J,k) state(I,1,k) state(I,2,k);state(1,J,k) state(1,1,k) state(1,2,k);state(2,J,k) state(2,1,k) state(2,2,k)];
    IESM(:,:,3)=[state(I,J,k+1) state(I,1,k+1) state(I,2,k+1);state(1,J,k+1) state(1,1,k+1) state(1,2,k+1);state(2,J,k+1) state(2,1,k+1) state(2,2,k+1)];
elseif caseis==18 % BSL 10 [ 1<k<K ]
    IESM(:,:,1)=[state(I-1,J,k-1) state(I-1,1,k-1) state(I-1,2,k-1);state(I,J,k-1) state(I,1,k-1) state(I,2,k-1);state(1,J,k-1) state(1,1,k-1) state(1,2,k-1)];
    IESM(:,:,2)=[state(I-1,J,k) state(I-1,1,k) state(I-1,2,k);state(I,J,k) state(I,1,k) state(I,2,k);state(1,J,k) state(1,1,k) state(1,2,k)];
    IESM(:,:,3)=[state(I-1,J,k+1) state(I-1,1,k+1) state(I-1,2,k+1);state(I,J,k+1) state(I,1,k+1) state(I,2,k+1);state(1,J,k+1) state(1,1,k+1) state(1,2,k+1)];
elseif caseis==19 % BSL 11 [ 1<k<K ]
    IESM(:,:,1)=[state(I-1,J-1,k-1) state(I-1,J,k-1) state(I-1,1,k-1);state(I,J-1,k-1) state(I,J,k-1) state(I,1,k-1);state(1,J-1,k-1) state(1,J,k-1) state(1,1,k-1)];
    IESM(:,:,2)=[state(I-1,J-1,k) state(I-1,J,k) state(I-1,1,k);state(I,J-1,k) state(I,J,k) state(I,1,k);state(1,J-1,k) state(1,J,k) state(1,1,k)];
    IESM(:,:,3)=[state(I-1,J-1,k+1) state(I-1,J,k+1) state(I-1,1,k+1);state(I,J-1,k+1) state(I,J,k+1) state(I,1,k+1);state(1,J-1,k+1) state(1,J,k+1) state(1,1,k+1)];
elseif caseis==20 % BSL 12 [ 1<k<K ]
    IESM(:,:,1)=[state(I,J-1,k-1) state(I,J,k-1) state(I,1,k-1);state(1,J-1,k-1) state(1,J,k-1) state(1,1,k-1);state(2,J-1,k-1) state(2,J,k-1) state(2,1,k-1)];
    IESM(:,:,2)=[state(I,J-1,k) state(I,J,k) state(I,1,k);state(1,J-1,k) state(1,J,k) state(1,1,k);state(2,J-1,k) state(2,J,k) state(2,1,k)];
    IESM(:,:,3)=[state(I,J-1,k+1) state(I,J,k+1) state(I,1,k+1);state(1,J-1,k+1) state(1,J,k+1) state(1,1,k+1);state(2,J-1,k+1) state(2,J,k+1) state(2,1,k+1)];
elseif caseis==4 % BSL 2 [ 1<j<J ]
    IESM(:,:,1)=[state(I-1,j-1,2) state(I-1,j-1,1) state(I-1,j-1,K);state(I,j-1,2) state(I,j-1,1) state(I,j-1,K);state(1,j-1,2) state(1,j-1,1) state(1,j-1,K)];
    IESM(:,:,2)=[state(I-1,j,2) state(I-1,j,1) state(I-1,j,K);state(I,j,2) state(I,j,1) state(I,j,K);state(1,j,2) state(1,j,1) state(1,j,K)];
    IESM(:,:,3)=[state(I-1,j+1,2) state(I-1,j+1,1) state(I-1,j+1,K);state(I,j+1,2) state(I,j+1,1) state(I,j+1,K);state(1,j+1,2) state(1,j+1,1) state(1,j+1,K)];
elseif caseis==8 % BSL 4 [ 1<j<J ]
    IESM(:,:,1)=[state(I,j-1,2) state(I,j-1,1) state(I,j-1,K);state(1,j-1,2) state(1,j-1,1) state(1,j-1,K);state(2,j-1,2) state(2,j-1,1) state(2,j-1,K)];
    IESM(:,:,2)=[state(I,j,2) state(I,j,1) state(I,j,K);state(1,j,2) state(1,j,1) state(1,j,K);state(2,j,2) state(2,j,1) state(2,j,K)];
    IESM(:,:,3)=[state(I,j+1,2) state(I,j+1,1) state(I,j+1,K);state(1,j+1,2) state(1,j+1,1) state(1,j+1,K);state(2,j+1,2) state(2,j+1,1) state(2,j+1,K)];
elseif caseis==12 % BSL 6 [ 1<j<J ]
    IESM(:,:,1)=[state(I-1,j-1,1) state(I-1,j-1,K) state(I-1,j-1,K-1);state(I,j-1,1) state(I,j-1,K) state(I,j-1,K-1);state(1,j-1,1) state(1,j-1,K) state(1,j-1,K-1)];
    IESM(:,:,2)=[state(I-1,j,1) state(I-1,j,K) state(I-1,j,K-1);state(I,j,1) state(I,j,K) state(I,j,K-1);state(1,j,1) state(1,j,K) state(1,j,K-1)];
    IESM(:,:,3)=[state(I-1,j+1,1) state(I-1,j+1,K) state(I-1,j+1,K-1);state(I,j+1,1) state(I,j+1,K) state(I,j+1,K-1);state(1,j+1,1) state(1,j+1,K) state(1,j+1,K-1)];
elseif caseis==16 % BSL 8 [ 1<j<J ]
    IESM(:,:,1)=[state(I,j-1,1) state(I,j-1,K) state(I,j-1,K-1);state(1,j-1,1) state(1,j-1,K) state(1,j-1,K-1);state(2,j-1,1) state(2,j-1,K) state(2,j-1,K-1)];
    IESM(:,:,2)=[state(I,j,1) state(I,j,K) state(I,j,K-1);state(1,j,1) state(1,j,K) state(1,j,K-1);state(2,j,1) state(2,j,K) state(2,j,K-1)];
    IESM(:,:,3)=[state(I,j+1,1) state(I,j+1,K) state(I,j+1,K-1);state(1,j+1,1) state(1,j+1,K) state(1,j+1,K-1);state(2,j+1,1) state(2,j+1,K) state(2,j+1,K-1)];
elseif caseis==21 % BSA 1 [ (1<i<I) & (1<j<J) ]
    IESM(:,:,1)=[state(i-1,j-1,K) state(i-1,j,K) state(i-1,j+1,K);state(i,j-1,K) state(i,j,K) state(i,j+1,K);state(i+1,j-1,K) state(i+1,j,K) state(i+1,j+1,K)];
    IESM(:,:,2)=[state(i-1,j-1,1) state(i-1,j,1) state(i-1,j+1,1);state(i,j-1,1) state(i,j,1) state(i,j+1,1);state(i+1,j-1,1) state(i+1,j,1) state(i+1,j+1,1)];
    IESM(:,:,3)=[state(i-1,j-1,2) state(i-1,j,2) state(i-1,j+1,2);state(i,j-1,2) state(i,j,2) state(i,j+1,2);state(i+1,j-1,2) state(i+1,j,2) state(i+1,j+1,2)];
elseif caseis==23 % BSA 3 [ (1<i<I) & (1<j<J) ]
    IESM(:,:,1)=[state(i-1,j-1,K-1) state(i-1,j,K-1) state(i-1,j+1,K-1);state(i,j-1,K-1) state(i,j,K-1) state(i,j+1,K-1);state(i+1,j-1,K-1) state(i+1,j,K-1) state(i+1,j+1,K-1)];
    IESM(:,:,2)=[state(i-1,j-1,K) state(i-1,j,K) state(i-1,j+1,K);state(i,j-1,K) state(i,j,K) state(i,j+1,K);state(i+1,j-1,K) state(i+1,j,K) state(i+1,j+1,K)];
    IESM(:,:,3)=[state(i-1,j-1,1) state(i-1,j,1) state(i-1,j+1,1);state(i,j-1,1) state(i,j,1) state(i,j+1,1);state(i+1,j-1,1) state(i+1,j,1) state(i+1,j+1,1)];
elseif caseis==22 % BSA 2 [ (1<i<I) & (1<k<K) ]
    IESM(:,:,1)=[state(i-1,J-1,k+1) state(i-1,J-1,k) state(i-1,J-1,k-1);state(i,J-1,k+1) state(i,J-1,k) state(i,J-1,k-1);state(i+1,J-1,k+1) state(i+1,J-1,k) state(i+1,J-1,k-1)];
    IESM(:,:,2)=[state(i-1,J,k+1) state(i-1,J,k) state(i-1,J,k-1);state(i,J,k+1) state(i,J,k) state(i,J,k-1);state(i+1,J,k+1) state(i+1,J,k) state(i+1,J,k-1)];
    IESM(:,:,3)=[state(i-1,1,k+1) state(i-1,1,k) state(i-1,1,k-1);state(i,1,k+1) state(i,1,k) state(i,1,k-1);state(i+1,1,k+1) state(i+1,1,k) state(i+1,1,k-1)];
elseif caseis==24 % BSA 4 [ (1<j<J) & (1<k<K) ]
    IESM(:,:,1)=[state(i-1,J,k+1) state(i-1,J,k) state(i-1,J,k-1);state(i,J,k+1) state(i,J,k) state(i,J,k-1);state(i+1,J,k+1) state(i+1,J,k) state(i+1,J,k-1)];
    IESM(:,:,2)=[state(i-1,1,k+1) state(i-1,1,k) state(i-1,1,k-1);state(i,1,k+1) state(i,1,k) state(i,1,k-1);state(i+1,1,k+1) state(i+1,1,k) state(i+1,1,k-1)];
    IESM(:,:,3)=[state(i-1,2,k+1) state(i-1,2,k) state(i-1,2,k-1);state(i,2,k+1) state(i,2,k) state(i,2,k-1);state(i+1,2,k+1) state(i+1,2,k) state(i+1,2,k-1)];
elseif caseis==25 % BSA 5 [ (1<j<J) & (1<k<K) ]
    IESM(:,:,1)=[state(I,j-1,k+1) state(I,j,k+1) state(I,j+1,k+1);state(I,j-1,k) state(I,j,k) state(I,j+1,k);state(I,j-1,k-1) state(I,j,k-1) state(I,j+1,k-1)];
    IESM(:,:,2)=[state(1,j-1,k+1) state(1,j,k+1) state(1,j+1,k+1);state(1,j-1,k) state(1,j,k) state(1,j+1,k);state(1,j-1,k-1) state(1,j,k-1) state(1,j+1,k-1)];
    IESM(:,:,3)=[state(2,j-1,k+1) state(2,j,k+1) state(2,j+1,k+1);state(2,j-1,k) state(2,j,k) state(2,j+1,k);state(2,j-1,k-1) state(2,j,k-1) state(2,j+1,k-1)];
elseif caseis==26 % BSA 6 [ (1<j<J) & (1<k<K) ]
    IESM(:,:,1)=[state(I-1,j-1,k+1) state(I-1,j,k+1) state(I-1,j+1,k+1);state(I-1,j-1,k) state(I-1,j,k) state(I-1,j+1,k);state(I-1,j-1,k-1) state(I-1,j,k-1) state(I-1,j+1,k-1)];
    IESM(:,:,2)=[state(I,j-1,k+1) state(I,j,k+1) state(I,j+1,k+1);state(I,j-1,k) state(I,j,k) state(I,j+1,k);state(I,j-1,k-1) state(I,j,k-1) state(I,j+1,k-1)];
    IESM(:,:,3)=[state(1,j-1,k+1) state(1,j,k+1) state(1,j+1,k+1);state(1,j-1,k) state(1,j,k) state(1,j+1,k);state(1,j-1,k-1) state(1,j,k-1) state(1,j+1,k-1)];
elseif caseis==27 % Inside volume [ (1<i<I) & (1<j<J) & (1<k<K) ]
    IESM(:,:,1)=[state(i-1,j-1,k-1) state(i-1,j,k-1) state(i-1,j+1,k-1);state(i,j-1,k-1) state(i,j,k-1) state(i,j+1,k-1);state(i+1,j-1,k-1) state(i+1,j,k-1) state(i+1,j+1,k-1)];
    IESM(:,:,2)=[state(i-1,j-1,k) state(i-1,j,k) state(i-1,j+1,k);state(i,j-1,k) state(i,j,k) state(i,j+1,k);state(i+1,j-1,k) state(i+1,j,k) state(i+1,j+1,k)];
    IESM(:,:,3)=[state(i-1,j-1,k+1) state(i-1,j,k+1) state(i-1,j+1,k+1);state(i,j-1,k+1) state(i,j,k+1) state(i,j+1,k+1);state(i+1,j-1,k+1) state(i+1,j,k+1) state(i+1,j+1,k+1)];
end