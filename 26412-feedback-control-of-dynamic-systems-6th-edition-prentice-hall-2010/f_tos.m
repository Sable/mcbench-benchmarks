%  function to be used in the ptos program
function ue=f_tos(e)
N=1.00;
  ue=sign(e)*(sqrt(1.98*N*abs(e)));
