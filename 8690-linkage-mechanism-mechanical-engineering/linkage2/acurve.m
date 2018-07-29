   function y = acurve(a1,a2,a3,a4,a5,a6,a,n)
%               ax = a(1); ay = a(2);
            for ii = 1:361
              for jj = 1:n    
              a12 = [a1(ii),a2(ii)]';
              a34 = [a3(ii),a4(ii)]';
              a56 = [a5(ii),a6(ii)]';
              m = map3t(a12,a34,a56,a(jj,1),a(jj,2));
              y(ii,2*jj-1) = m(1);
              y(ii,2*jj) = m(2);
          end;
      end; 