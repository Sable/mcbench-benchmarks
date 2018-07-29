clear
clc

pro = pro_Create();

% pro = pro_AddInput(pro, @(N)pdf_Uniform(N, [0 1]), 'param1');
% pro = pro_AddInput(pro, @(N)pdf_Uniform(N, [0 1]), 'param2');
% pro = pro_AddInput(pro, @(N)pdf_Uniform(N, [0 1]), 'param3');
% pro = pro_AddInput(pro, @(N)pdf_Uniform(N, [0 1]), 'param4');
% pro = pro_AddInput(pro, @(N)pdf_Uniform(N, [0 1]), 'param5');

pro = pro_AddInput(pro, @()pdf_Sobol([0 1]), 'param1');
pro = pro_AddInput(pro, @()pdf_Sobol([0 1]), 'param2');
pro = pro_AddInput(pro, @()pdf_Sobol([0 1]), 'param3');
pro = pro_AddInput(pro, @()pdf_Sobol([0 1]), 'param4');
pro = pro_AddInput(pro, @()pdf_Sobol([0 1]), 'param5');


pro = pro_SetModel(pro, @(x)TestModel(x,[0 1 9 9 9]), 'model');
[D Si] = SATestModel([0 1 9 9 9]);

pro.N = 20000;

pro = GSA_Init(pro);
[S eS pro] = GSA_GetSy(pro, {5,3,1,2,4});
% [Stot eStot pro] = GSA_GetTotalSy(pro, {'param1', 'param5'});
