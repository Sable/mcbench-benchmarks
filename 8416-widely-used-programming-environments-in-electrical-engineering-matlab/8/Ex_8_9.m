        % Introducerea din STAS a diametrelor conductorilor de bobinaj
d=[0.020,0.025,0.032,0.04,0.05,0.063,0.071,0.08,0.09,0.1,0.112,0.125,0.14,0.16,0.18,...
0.2,0.224,0.25,0.28,0.315,0.355,0.4,0.45,0.5,0.56,0.63,0.71,0.75,0.8,0.85,0.9,0.95,...
1,1.06,1.12,1.18,1.25,1.32,1.4,1.5,1.6,1.7,1.8,1.9,2,2.12,2.24,2.36,2.5,2.65,2.8,3,3.15,...
3.35,3.55,3.75,4,4.25,4.5,4.75,5];
        % Calcularea sectiuniilor aferente
sect=pi*d.^2/4;
        % Introducerea intr-un tabel de cautare
cond_tab=[sect',d'];
        % Cautarea conductorului pentru sectiunea de 2 mm^2
Ac=2
        % Avertizarea in situatia in care la sectiunea data nu se gaseste conductor
if Ac>cond_tab(length(d),1) disp('Nu este conductor rotund corespunzator'); break; end
        % Cautarea si gasirea conductorului cu diametrul imediat superior din tabel
d_ales=min(cond_tab(find(cond_tab(:,2)>=table1(cond_tab,Ac)),2))
        % table1(cond_tab,Ac) cauta in tabel (interpolat)
        % find(cond_tab(:,2)>=table1(cond_tab,Ac)) 
        % cauta indicii pentru care este valabila expresia logica
        % cond_tab(find(cond_tab(:,2)>=table1(cond_tab,Ac)),2))
        % cauta din a doua coloana elementele corespunzatoare indicilor determinati,
        % iar minimul acestora este primul element (primul imediat urmator)
        
        % verificarea sectiunii conductorului ales
Sect_ales=pi*d_ales.^2/4