clear
clc

pro = pro_Create();

% pro = pro_AddInput(pro, @(N)pdf_Uniform(N, [-pi pi]), 'X1');
% pro = pro_AddInput(pro, @(N)pdf_Uniform(N, [-pi pi]), 'X2');
% pro = pro_AddInput(pro, @(N)pdf_Uniform(N, [-pi pi]), 'X3');

pro = pro_AddInput(pro, @()pdf_Sobol([-pi pi]), 'X1');
pro = pro_AddInput(pro, @()pdf_Sobol([-pi pi]), 'X2');
pro = pro_AddInput(pro, @()pdf_Sobol([-pi pi]), 'X3');


pro = pro_SetModel(pro, @(x)TestModel2(x), 'model');

pro.N = 10000;

pro = GSA_Init(pro);
[S eS pro] = GSA_GetSy(pro, {1});
[Stot eStot pro] = GSA_GetTotalSy(pro, {1});

