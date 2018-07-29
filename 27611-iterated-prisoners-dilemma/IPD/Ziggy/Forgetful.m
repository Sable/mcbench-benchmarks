function response = Forgetful(n,p)

persistent ncount trustcount roundstore
if n==1; ncount=0; trustcount=0; roundstore=0; end
if ncount==1 && (p==1 || p==5); trustcount=trustcount+1; end

if n>5
    if isequal( roundstore(end-3:end), [5 0 5 0] );
        trustcount = 2;
        ncount = 5;
    end
end

if ( p==1 || p==5 || n==20 ) && ncount<5 && n~=1
    response = 'defect';
else
    response = 'cooperate';
    if trustcount>2; response = 'defect'; end
    ncount = 0;
end

roundstore(n) = p;

ncount = ncount + 1;