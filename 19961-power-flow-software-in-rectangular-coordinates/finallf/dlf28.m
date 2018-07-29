clear
clc
tic;
basemva=10;
basekv=111;
% 1.bus no 2.realpower(KW) 3. Reactive Power(KVAR)
clear
clc
tic;
basemva=10;
basekv=11;
busdata=[1	0	0
2	35.28	36
3	14	14.28
4	35.28	36
5	14	14.28
6	35.28	36
7	35.28	36
8	35.28	36
9	14	14.28
10	14	14.28
11	56	57.13
12	35.28	36
13	35.28	36
14	14	14.28
15	35.28	36
16	35.28	36
17	8.96	9.14
18	8.96	9.14
19	35.28	36
20	35.28	36
21	14	14.28
22	35.28	36
23	8.96	9.14
24	56	57.13
25	8.96	9.14
26	35.28	36
27	35.28	36
28	35.28	36
];
linedata=[1	2	1.197	0.82	0	1
2	3	1.796	1.231	0	1
3	4	1.306	0.896	0	1
4	5	1.851	1.268	0	1
5	6	1.524	1.044	0	1
6	7	1.905	1.305	0	1
7	8	1.197	0.82	0	1
8	9	0.653	0.447	0	1
9	10	1.143	0.783	0	1
4	11	2.823	1.172	0	1
11	12	1.184	0.491	0	1
12	13	1.002	0.416	0	1
13	14	0.455	0.189	0	1
14	15	0.546	0.227	0	1
5	16	2.55	1.058	0	1
6	17	1.366	0.567	0	1
17	18	0.819	0.34	0	1
18	19	1.548	0.642	0	1
19	20	1.366	0.567	0	1
20	21	3.552	1.474	0	1
7	22	1.548	0.642	0	1
22	23	1.092	0.453	0	1
23	24	0.91	0.378	0	1
24	25	0.455	0.189	0	1
25	26	0.364	0.151	0	1
8	27	0.546	0.226	0	1
27	28	0.273	0.113	0	1];
BZ=(basekv^2)/basemva;
linedata(:,3)=(1/BZ)*linedata(:,3);
linedata(:,4)=(1/BZ)*linedata(:,4);
P=-(.001/basemva)*busdata(:,2)';
Q=-(.001/basemva)*busdata(:,3)';
n=length(P);
% building admittance matrix
nl = linedata(:,1); nr = linedata(:,2); R = linedata(:,3);
X = linedata(:,4); Bc = j*linedata(:,5); a = linedata(:, 6);
nbr=length(linedata(:,1)); nbus = max(max(nl), max(nr));
Z = R + j*X; y= ones(nbr,1)./Z;        %branch admittance
for n = 1:nbr
Ybus=zeros(nbus,nbus);     % initialize Ybus to zero
               % formation of the off diagonal elements
for k=1:nbr;
       Ybus(nl(k),nr(k))=Ybus(nl(k),nr(k))-y(k)/a(k);
       Ybus(nr(k),nl(k))=Ybus(nl(k),nr(k));
    end
end
              % formation of the diagonal elements
for  n=1:nbus
     for k=1:nbr
         if nl(k)==n
         Ybus(n,n) = Ybus(n,n)+y(k)/(a(k)^2) + Bc(k);
         elseif nr(k)==n
         Ybus(n,n) = Ybus(n,n)+y(k) +Bc(k);
         else, end
     end
end
PQ=P+i*Q;
V=ones(n,1);
chV=zeros(n-1,1);
accuracy=1;
iter=0;
while accuracy >1e-7;
    iter=iter+1;
    V1=V(2:n);
    V=[1;V1]+conj([0; chV]);
    cPQ=diag(V)*conj(Ybus)*conj(V);
    chPQ=PQ.'-cPQ;
    chPQ1=chPQ(2:n);
    J=diag(V)*conj(Ybus)+diag(conj(Ybus*V));
    J1=J(2:n,2:n);
    chV=(inv(J1)*chPQ1);
    accuracy=max(abs(chV));
end
   toc;
    
