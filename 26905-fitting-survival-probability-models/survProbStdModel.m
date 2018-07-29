function prob = survProbStdModel(t,b,time)
% survProbStdModel: Computes survival probability using the standard model

prob = ones(size(t));
time0 = [0;time];
dtime = diff(time0);

for jdx=1:length(time)
   if jdx < length(time)
      tmpidx = t > time0(jdx) & t <= time0(jdx+1);
   else
      tmpidx = t > time0(jdx);
   end
   H = 0;
   if (jdx>1)
      H = dtime(1:jdx-1)'*b(1:jdx-1);
   end
   H = H + (t(tmpidx) - time0(jdx))*b(jdx);
   prob(tmpidx) = exp(-H);
end
