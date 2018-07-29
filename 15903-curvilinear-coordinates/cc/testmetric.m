% This script runs program clear, runmetric
% for nine coordinate systems and puts
% the output in runmetric.tst
if exist('runmetric.tst','file')==2
  delete runmetric.tst
end
diary  runmetric.tst
clear, runmetric(@cylin);
clear, runmetric(@sphr);
clear, runmetric(@cone);
clear, runmetric(@elipcyl);
clear, runmetric(@notort);
clear, runmetric(@oblate);
clear, runmetric(@parab);
clear, runmetric(@toroid);
clear, runmetric(@elipsod);
diary off