
%Number of decision makers k, i.e.
k=4;        
%Number of criterias to be evaluated n i.e.
n=4;        
%Information about is the given criteria cost or benefit criteria:
%Benefit=1, Cost=2, should be given as a vector of length n. i.e.
criteria=[1 1 1 2];

%Number of attributes to be ranked (suppliers in example case). i.e.
m=6; 

%Criteria for selecting Fuzzy Positive Ideal Solution FPIS and Fuzzy Negative Ideal Solution FNIS.
%Three possible option are now implemented. See [1.] for more information. i.e.

ideal=3;     
%Chosen similarity measure: Integer number within {1,2,3,4}
simi=4;

lingvar

WD1={VH H H H};
WD2={H VH VH H};
WD3={MH H H MH};
WD4={M M MH MH};
WD={WD1;WD2;WD3;WD4};

FDM1={G G G F; MG G MG G; F F G VG; F P G G; MG MP MG MG; G MP F G};
FDM2={MG G MG G; G MG G G; F F G VG; MG MP MG MG; F MP F MG; MG P F VG};
FDM3={G MG MG G; F MG G F; MG P F G; MG MP MG G; F MP F G; MG P MG VG};
FDM4={G MG G G; MG G G MG; G F MG G; F P G G; MG MP MG MG; MG MP F G};
FDM={FDM1;FDM2;FDM3;FDM4};


[CCS,Sstar,Sneg,Order]=Stopsis(WD,FDM,k,m,n,ideal,criteria,simi);

disp('Similarities w.r.t. attribute and FPIS:')
Sstar
disp('Similarities w.r.t. attribute and FNIS:')
Sneg

disp('Order of the attributes:')
Order
disp('Closeness values with similarity for choosing attributes:')
CCS