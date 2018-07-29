function [total,argmax,valmax] = forward_viterbi(obs,states,start_p,trans_p,emit_p)
%Translated from Python code available at:
%  http://en.wikipedia.org/wiki/Viterbi_algorithm

   T = {};
   for state = 1:length(states)
       %%          prob.           V. path  V. prob.
       T{state} = {start_p(state),states(state),start_p(state)};
   end
   for output = 1:length(obs)
       U = {};
       for next_state = 1:length(states)
           total = 0;
           argmax = [];
           valmax = 0;
           for source_state = 1:length(states)
               Ti = T{source_state};
               prob = Ti{1}; v_path = Ti{2}; v_prob = Ti{3};
               p = emit_p(source_state,obs(output)) * trans_p(source_state,next_state);
               prob = prob*p;
               v_prob = v_prob*p;
               total = total + prob;
               if v_prob > valmax
                   argmax = [v_path, states(next_state)];
                   valmax = v_prob;
               end
           end
           U{next_state} = {total,argmax,valmax};
       end
       T = U;
   end
   %% apply sum/max to the final states:
   total = 0;
   argmax = [];
   valmax = 0;
   for state = 1:length(states)
       Ti = T{state};
       prob = Ti{1}; v_path = Ti{2}; v_prob = Ti{3};
       total = total + prob;
       if v_prob > valmax
           argmax = v_path;
           valmax = v_prob;
       end
   end
end