  function y = map3t(a1,a2,a3,cx,cy)
          tt = [a2(1)-a1(1), a3(1)-a1(1);a2(2)-a1(2),a3(2)-a1(2)];
          c = [cx,cy]';
          y = tt*c;
          y = y+a1;
          