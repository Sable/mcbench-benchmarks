function  [ DAG, K2Score ] = k2( LGObj,Order,u )
%Input: a set of variables x1,...xn; a given order among them, an upper limit u on the number of parents for a node; a database on x1 ... xn.
%Output: a DAG with oriented arcs, K2Score saves the maximum score upon each node.
%For i := 1 to n do
%1.  Pai(xi) = null; Ok := true;
%2. Pold := g(xi; Pai(xi));
%3. While Ok and |pai(xi)| <= u do
%3.1. Let z be the node in the set of predecessors of xi that does not belong to Pai(xi) which maximizes g(xi; Pai(xi)) + {z} );
%3.2. Pnew := g(xi; Pai(xi) + {z});
%3.3. If Pnew > Pold. Then Pold := Pnew;  Pai(xi) := Pai(xi)+{z} Else Ok := false. 

% This code is written by Lowell Guangdi, Email: lowellli121@gmail.com

LG = struct( LGObj );
Dim = LG.VarNumber;
DAG = zeros( Dim );
K2Score = zeros( 1,Dim );

  for p = 2:Dim  % the first node have no parents
      Parent = zeros( Dim,1 ); OKToProcced = 1;
      Pold = -Inf;  %  the initiate stage 
      while OKToProcced == 1 && sum( Parent )<= u 
          %3.1.maximizes g(xi; Pai(xi)) + {z} )
          LocalMax = -Inf; LocalNode = 0;
          for q = ( p-1):( -1 ):1
              if Parent( Order( q ) )==0
                 Parent( Order( q ) ) = 1;                 
                 LocalScore = GClosedFun( LGObj, Order( p ), find( Parent' == 1 ) );
                 if LocalScore > LocalMax
                     LocalMax = LocalScore ;
                     LocalNode = Order( q );
                 end
                 Parent( Order( q ) ) = 0;
              end
          end
         %3.2. Pnew := g(xi; Pai(xi)+{z});
         Pnew = LocalMax;
         %3.3. If Pnew > Pold. Then Pold := Pnew;  Pai(xi) := Pai(xi)+{z}
         %Else Ok := false.
         if Pnew > Pold
             Pold = Pnew;
             Parent( LocalNode ) = 1;
         else
             OKToProcced = 0;
         end
      end
      % Save the local resutl upon node Order( p )
      K2Score( Order( p ) ) = Pold;
      DAG( :,Order( p ) ) = Parent;
  end
end
