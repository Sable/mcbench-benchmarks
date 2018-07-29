function [output_stack, IRR, ORR, ARR] = evalfisx(input_stack, fis)
%EVALFISX Evaluation of a fuzzy inference system.
%   
%   See evalfis1 for syntax and explanation.
% 
%   It is completely based on MATLAB's evalfis1 
%   with some modifications, so it's compatible
%   with extendent fuzzy rule structure.
% 
%   Compare also code of this function
%   with code of original the evalfis1.
% 
%   Example:
%   load carsmall;
%   fis = genfis4([Weight, Displacement], Acceleration, 'mamdani');
%   out = evalfisx([2000 100; 2000 200; 2000 300], fis);

%   Per Konstantin A. Sidelnikov, 2009.

persistent CURRENT_FIS;
persistent FIS_NAME FIS_TYPE IN_N OUT_N IN_MF_N OUT_MF_N RULE_N;
persistent AND_METHOD OR_METHOD IMP_METHOD AGG_METHOD DEFUZZ_METHOD;
persistent BOUND IN_MF_TYPE OUT_MF_TYPE;
persistent IN_RULE_LIST OUT_RULE_LIST AND_OR RULE_WEIGHT;
persistent IN_PARAM OUT_PARAM;
persistent OUT_TEMPLATE_MF OUT_MF QUALIFIED_OUT_MF OVERALL_OUT_MF;

point_n = 101;
mf_para_n = 4;

initialization = 1;
% Check if initialization necessary.
if isequal(fis, CURRENT_FIS)
    initialization = 0;
end

% Unpack data and initialize global variables.
if initialization
    CURRENT_FIS = fis;
    FIS_NAME = fis.name;
    FIS_TYPE = fis.type;
    IN_N = length(fis.input);
    OUT_N = length(fis.output);    
   
    for i = 1 : IN_N
        IN_MF_N(i) = length(fis.input(i).mf);
    end
    for i = 1 : OUT_N
        OUT_MF_N(i) = length(fis.output(i).mf);
    end
    
    RULE_N = length(fis.rule);
    
    AND_METHOD = fis.andMethod;
    OR_METHOD =  fis.orMethod;
    IMP_METHOD = fis.impMethod;
    AGG_METHOD = fis.aggMethod;
    DEFUZZ_METHOD = fis.defuzzMethod;    
    
    IN_MF_TYPE = [];
    for i = 1 : IN_N
        IN_MF_TYPE = [IN_MF_TYPE; {fis.input(i).mf.type}'];
    end    
    OUT_MF_TYPE = [];
    for i = 1 : OUT_N
        OUT_MF_TYPE = [OUT_MF_TYPE; {fis.output(i).mf.type}'];
    end
    
    in_bound = reshape([fis.input.range], IN_N, 2);
    out_bound = reshape([fis.output.range], OUT_N, 2);
    BOUND = [in_bound; out_bound];

    RULE_WEIGHT = [fis.rule.weight]';
    AND_OR = [fis.rule.connection]';
    IN_RULE_LIST = {fis.rule.antecedent}';
    OUT_RULE_LIST = reshape([fis.rule.consequent], RULE_N, OUT_N);

    k = 1;
    totalInputMFs = sum(IN_MF_N);
    totalOutputMFs = sum(OUT_MF_N);
    IN_PARAM = zeros(totalInputMFs, 4);
    for i = 1 : IN_N
        for j = 1 : length(fis.input(i).mf)
            tmp = fis.input(i).mf(j).params;
            IN_PARAM(k, 1 : length(tmp)) = tmp;
            k = k + 1;
        end
    end
    k = 1;
    OUT_PARAM = zeros(totalOutputMFs, 4);
    for i = 1 : OUT_N
        for j = 1 : length(fis.output(i).mf)
            tmp = fis.output(i).mf(j).params;
            OUT_PARAM(k, 1 : length(tmp)) = tmp;
            k = k + 1;
        end
    end
       
    if strcmp(FIS_TYPE, 'sugeno')
        OUT_PARAM = OUT_PARAM(:, 1 : IN_N + 1);
    elseif strcmp(FIS_TYPE, 'mamdani')
        OUT_PARAM = OUT_PARAM(:, 1 : mf_para_n);
    else
        error('Unknown FIS type!');
    end
    
    if strcmp(FIS_TYPE, 'mamdani')
        % Compute OUT_TEMPLATE_MF
        OUT_TEMPLATE_MF = zeros(sum(OUT_MF_N), point_n);
        cum_mf = cumsum(OUT_MF_N);
        for i = 1 : sum(OUT_MF_N)       
            % index for output
            output_index = find((cum_mf - i) >= 0, 1, 'first');
            tmp = linspace(BOUND(IN_N + output_index, 1), ...
                BOUND(IN_N + output_index, 2), point_n);
            OUT_TEMPLATE_MF(i, :) = ...
                evalmf(tmp, OUT_PARAM(i, :), OUT_MF_TYPE{i});
        end
        
        % Reorder to fill OUT_MF, an (RULE_N X point_n * OUT_N) matrix.
        OUT_MF = zeros(RULE_N, point_n * OUT_N);
        for i = 1 : RULE_N
            for j = 1 : OUT_N
                mf_index = OUT_RULE_LIST(i, j);
                index = sum(OUT_MF_N(1 : j - 1)) + abs(mf_index);
                tmp = (j - 1) * point_n + 1 : j * point_n;
                if mf_index > 0    % regular MF
                    OUT_MF(i, tmp) = OUT_TEMPLATE_MF(index, :);
                elseif mf_index < 0 % Linguistic hedge "NOT"
                    OUT_MF(i, tmp) = 1 - OUT_TEMPLATE_MF(index, :);
                else                % Don't care (MF index == 0)
                    OUT_MF(i, tmp) = ones(1, point_n);
                end
            end
        end
        
        % Allocate other matrices
        QUALIFIED_OUT_MF = zeros(RULE_N, point_n * OUT_N);
        OVERALL_OUT_MF = zeros(1, point_n * OUT_N);
    end
    %   fprintf('Global variables for %s FIS are initialized\n', FIS_NAME);
end
% End of initialization

% Error checking for input stack
m = size(input_stack, 1);
n = size(input_stack, 2);
if ~((n == IN_N) || ((n == 1) && (m == IN_N)))
    fprintf('The input stack is of size %dx%d,', m, n);
    fprintf('while expected input vector size is %d.\n', IN_N);
    error('Exiting ...');
end
if (n == 1) && (m == IN_N)
    data_n = 1;
    input_stack = input_stack';
else
    data_n = m;
end

% Allocate output stack
output_stack = zeros(data_n, OUT_N);

% Iteration through each row of input stack
for kkk = 1 : data_n
    input = input_stack(kkk, :);
    
    % Find in_template_mf_value
    in_template_mf_value = zeros(sum(IN_MF_N), 1);
    cum_mf = cumsum(IN_MF_N);
    for i = 1 : sum(IN_MF_N)
        input_index = find((cum_mf - i) >= 0, 1, 'first');
        in_template_mf_value(i) = ...
            evalmf(input(input_index), IN_PARAM(i, :), IN_MF_TYPE{i});
    end
    
    % Reordering to fill in_mf_value, which is an (RULE_N X 1) cell matrix.
    tmp = cumsum([0, IN_MF_N(1 : IN_N - 1)]);
    in_mf_value = cell(RULE_N, 1);
    for ind = 1 : RULE_N
        index = tmp(IN_RULE_LIST{ind}(1, :)) + abs(IN_RULE_LIST{ind}(2, :));
        in_mf_value{ind} = in_template_mf_value(index)';
        % Take care of linguistic hedge NOT (MF index is negative)
        neg_index = find(IN_RULE_LIST{ind}(2, :) < 0);
        in_mf_value{ind}(neg_index) = 1 - in_mf_value{ind}(neg_index);
    end   
    
    % Find the firing strengths
    % AND_METHOD = 'min' or 'prod'; which is used as function name too
    % OR_METHOD = 'max' or 'probor'; which is used as function name too
    firing_strength = zeros(RULE_N, 1);
    and_index = find(AND_OR == 1);
    or_index = find(AND_OR == 2);
    if IN_N ~= 1        
        firing_strength(and_index) = ...
            cellfun(@(x) feval(AND_METHOD, x'), in_mf_value(and_index, :))';
        firing_strength(or_index) = ...
            cellfun(@(x) feval(OR_METHOD, x'), in_mf_value(or_index, :))';
    else
        firing_strength = [in_mf_value{:}]';
    end
    
    % Recalculate firing strengths scaled by rule weights
    firing_strength = firing_strength .* RULE_WEIGHT;
    
    % Find output
    if strcmp(FIS_TYPE, 'sugeno')
        template_output = OUT_PARAM * [input(:); 1]; % Output for template
        
        % Reordering according to the output part of RULE_LIST;
        % Negative MF index will becomes positive
        tmp = cumsum([0, OUT_MF_N(1 : OUT_N - 1)]);
        index = repmat(tmp, RULE_N, 1) + abs(OUT_RULE_LIST);
        index(index == 0) = 1;   % temp. setting for easy indexing
        rule_output = template_output(index);
        rule_output(OUT_RULE_LIST == 0) = 0;  % take care of zero index
        sum_firing_strength = sum(firing_strength);        
                
        if sum_firing_strength == 0
            fprintf('input = [');
            for i = 1 : IN_N
                fprintf('%f ', input(i));
            end
            fprintf(']\n');
            error('Total firing strength is zero!');
        end        
        
        switch DEFUZZ_METHOD
            case 'wtaver'
                output_stack(kkk, :) = firing_strength' * rule_output / ...
                    sum_firing_strength;
            case 'wtsum'
                output_stack(kkk, :) = firing_strength' * rule_output;
            otherwise
                error('Unknown defuzzification method!');
        end        
    elseif strcmp(FIS_TYPE, 'mamdani')
        % Transform OUT_MF to QUALIFIED_OUT_MF
        % Duplicate firing_strength.
        tmp = firing_strength(:, ones(1, point_n * OUT_N));
        
        if strcmp(IMP_METHOD, 'prod')      % IMP_METHOD == 'prod'
            QUALIFIED_OUT_MF = tmp .* OUT_MF;
        elseif strcmp(IMP_METHOD, 'min')   % IMP_METHOD == 'min'
            QUALIFIED_OUT_MF = feval(IMP_METHOD, tmp, OUT_MF);
        else    % IMP_METHOD is user-defined
            tmp1 = feval(IMP_METHOD, [tmp(:)'; OUT_MF(:)']);
            QUALIFIED_OUT_MF = reshape(tmp1, RULE_N, point_n * OUT_N);
        end
        
        % AGG_METHOD = 'sum' or 'max' or 'probor' or user-defined
        OVERALL_OUT_MF = feval(AGG_METHOD, QUALIFIED_OUT_MF);
        
        for i = 1 : OUT_N
            tmp = linspace(BOUND(IN_N + i, 1), BOUND(IN_N + i, 2), point_n);
            tmp1 = (i - 1) * point_n + 1 : i * point_n;
            output_stack(kkk, i) = ...
                defuzz(tmp, OVERALL_OUT_MF(1, tmp1), DEFUZZ_METHOD);
        end
    else
        fprintf('fis_type = %d\n', FIS_TYPE);
        error('Unknown FIS type!');
    end
end

if nargout >= 2
    IRR = in_mf_value; 
end

if strcmp(FIS_TYPE, 'sugeno')
    if nargout >= 3
        ORR = rule_output;
    end
    if nargout >= 4
        ARR = firing_strength(:, ones(1, OUT_N));
    end
else
    if nargout >= 3
        ORR = [];
        for iii = 1 : OUT_N
            tmp = (iii - 1) * point_n + 1 : iii * point_n;
            ORR = [ORR; QUALIFIED_OUT_MF(:, tmp)];
        end
        ORR = ORR';
    end
    if nargout >= 4
        ARR = reshape(OVERALL_OUT_MF, point_n, OUT_N);
    end
end
