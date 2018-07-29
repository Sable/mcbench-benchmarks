function [gains]=lookup_inc_gamma_in_table(G,a_priori,a_priori_range,step);
 


a_prioridb=round(10*log10(a_priori)/step)*step;
 
[Ia_priori]=min(max(min(a_priori_range),a_prioridb), max(a_priori_range));
Ia_priori=Ia_priori-min(a_priori_range)+1;
Ia_priori=Ia_priori/step;

gains=G(Ia_priori); 


 