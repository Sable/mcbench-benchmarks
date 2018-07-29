function [C, Ceq, activeMargins, activeNonLMargins]...
    = EVALnonlcons(X,Problem,Constraints,Spec)

X0 = Problem.x0;
active_decX = Problem.activeX;
active_constraints = Constraints.active_cons;
extra_margins = Constraints.margins;

Ceq = [];

X0(active_decX) = X;
X = X0;

AC = ACbuilder(X, Spec);

C1 = zeros(size(active_constraints));
nPPreqs = Spec.nPPrequirements;
activePPs = active_constraints(1:nPPreqs);

%% run though all the point performance requirements
for ii = 1:nPPreqs
    if active_constraints(ii);
        state = Spec.PPStates(ii);
        if Constraints.useBEA(ii)
            PrimaryMargin = PointAnalysisBEA(AC, state);
        else
            PrimaryMargin = PointAnalysisMOM(AC, state);
        end
        C1(ii) = PrimaryMargin;
    end
end

if nargout > 2
    activeMargins = C1(activePPs);
end

activeNonLMargins = [];
%% run though all the additional requirements
if Spec.nnonl
    for ii = nPPreqs+1:nPPreqs+Spec.nnonl
        if active_constraints(ii);
            margin = feval(Spec.nonlcons{ii-nPPreqs},Spec.nonlvals(ii-nPPreqs),AC);
            C1(ii) = margin;
            if nargout > 2
                activeNonLMargins(end+1,1) = margin; %#ok<AGROW>
            end
        end
    end
end

C1 = C1 - extra_margins;

% delete non-actives:
C1 = C1(active_constraints); 
C = -C1+.001;
end