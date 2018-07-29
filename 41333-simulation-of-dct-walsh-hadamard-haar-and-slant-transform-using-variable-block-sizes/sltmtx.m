function T = sltmtx(L)
%  sltmtx    slantlet matrix.
%
%  T = sltmtx(L) is the slantlet matrix of size 2^L by 2^L.
%
%  See also slantlt, islantlt, sislet, isislet.
%
%  % example
%  l = 4;
%  x = sin(sin([1:2^l]/3));
%  T = sltmtx(l);
%  q = T*x(:);
%  s = slantlt(x);
%  max(abs(q-s(:)))

%  Ivan Selesnick, 1997
%  subprograms: getg.m, gethf.m


m = 2^L;
T = zeros(m);

[a0,a1,b0,b1,c0,c1,d0,d1] = gethf(L);
h = [a0+a1*(0:m-1), b0+b1*(0:m-1)];
f = [c0+c1*(0:m-1), d0+d1*(0:m-1)];

T(1,1:m) = h(1:m) + h(m+1:2*m); 
T(2,1:m) = f(1:m) + f(m+1:2*m);

for i = L-1:-1:1
   for k = 1:2^(L-i-1)
      m = 2^i;
      [a0,a1,b0,b1] = getg(i);
      g = [a0+a1*(0:m-1), b0+b1*(0:m-1)];
      gr = g(2*m:-1:1);
	le = 2^(i+1);
	q = 2^(L-i)+2*(k-1)+1;
      T(q,[1:le]+le*(k-1)) = g; 
      T(q+1,[1:le]+le*(k-1)) = gr; 
   end
end



