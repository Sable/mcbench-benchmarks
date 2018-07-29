        % Lansarea utilitarului Profiler cu optiunea cea mai completa
profile on -detail operator -history
        % Secventa simpla de program de analizat
x=0:pi/1e6:2*pi;
y=funct1(x);
z=funct2(x);
        % Comandarea generarii unui raport si salvarea lui in fisierul raport
profile report raport
        % Comandarea generarii reprezentarii rezultatelor statistice
profile plot
        % Stergerea tuturor inregistrarilor
profile clear