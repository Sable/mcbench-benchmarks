function [Ex f u v Alfa EtaInf itrs] = FalknerSkanSolver(b0, b, eps1, eps2, Alfa0, EtaInf0, hObject, trace)
    global SOL;
    global ETA_INF;
    global BETA0;
    global BETA;
    global EX;
    t1 = cputime;
    handles = guidata(hObject);
    Ex_span = 0:0.05:1;
    %
    % Allocation memory
	%
	Alfa = []; 
	EtaInf = [];
	J = zeros(2); 
	F = zeros(2,1);
	% Input values
	Alfa(1) = Alfa0;
	EtaInf(1) = EtaInf0;
    BETA0 = b0;
    BETA = b;
	% Initial Conditions
	p = eps1*10;
	q = eps2*10;
	k = 0;
    if (trace == 1)
        [msg err] = sprintf('  i      Alfa           Eta Inf         q(alfa, eta Inf)');
        set(handles.Info_LstBx, 'String', msg);
        [msg1 err] = sprintf('|-------------------------------------------------------------');
        msg = strcat(msg, msg1);
        set(handles.Info_LstBx, 'String', msg);
        [msg1 err] = sprintf('|%3d  %1.11f      %1.5f    ', k+1, ...
                         Alfa(k+1),EtaInf(k+1));
        msg = strcat(msg, msg1);
        set(handles.Info_LstBx, 'String', msg);             
    end
	while ((abs(p) > eps1) || (abs(q) > eps2))
    	k = k + 1;
    	p = eps1*10;
    	ETA_INF = EtaInf(k);
    	while (abs(p) > eps1)
        	IC = [0 0 Alfa(k)]';
       		[EX SOL] = myode45(@FalknerSkanSys, Ex_span, IC,[],0);
            f = SOL(:,1)';
            u = SOL(:,2)';
            v = SOL(:,3)';
            [nodes c] = size(EX);
            p = u(nodes)-1;
            q = v(nodes);
            IC = [0 0 1]';
            [Ex_ d_dalfa] = myode45(@JacobianAlfa, Ex_span, IC,[],0);
            [nodes1 c] = size(Ex_);
            dpdalfa =  d_dalfa(nodes1,2);
            DeltaAlfa = -p/dpdalfa;
            Alfa(k) = Alfa(k) + DeltaAlfa;
        end
        IC = [0 0 0]';
        [Ex_ d_dEtaInf] = myode45(@JacobianEtaInf, Ex_span,IC,[],0);
        [nodes2 c] = size(Ex_);
        % Jacobian matrix
        J (1,1) = d_dalfa(nodes1, 2);
        J (1,2) = d_dEtaInf(nodes2, 2);
        J (2,1) = d_dalfa(nodes1, 3);
        J (2,2) = d_dEtaInf(nodes2, 3);
        F(1) = p;
        F(2) = q;
        Delta = -J\F;
        Alfa(k+1) = Alfa(k)+Delta(1);
        EtaInf(k+1) = EtaInf(k)+Delta(2);
        if (trace == 1)
             [msg1 err] = sprintf('|%3d  %1.11f      %1.5f          %1.4e', k+1, Alfa(k+1),EtaInf(k+1), abs(q) );
             msg = strcat(msg, msg1);
             set(handles.Info_LstBx, 'String', msg);
        end
    end
    % output values
    Ex = EX;
    itrs = k+1;
    t2 = cputime - t1;
    if (trace == 1)
        [msg1 err] = sprintf('| ');
        msg = strcat(msg, msg1);
        set(handles.Info_LstBx, 'String', msg);
        [msg1 err] = sprintf('|Computational time: %d s', t2);
        msg = strcat(msg, msg1);
        set(handles.Info_LstBx, 'String', msg);
    end
    
    