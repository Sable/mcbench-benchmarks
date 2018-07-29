%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
%The function generates Orthogonal Variable SPreading Factor Code(OVSF)
% to know more about OVSF code refer www.wirelesscafe.wordpress.com
%Year of release: 2009
%Version : V1
%Author: Ashwini Patankar
%Email Id: ashwinispatankar@gmail.com
%HJomePage: www.ashwinipatankar.com
%Blog: www.wirelesscafe.wordpress.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Usage
% x = ovsf(y,z)
%x, the output cell array having required OVSF codes
%y, number of codes required
%z, array having length of each code to the base 2 i.e. 2.^2 = 4
%example y = 3 z = [4 2 3]
%this will give a cell array with [1x4] [1x8] [1x16]
%length = 2.^n , enter n in length of array
%The code is not optimized yet, user is free to optimize
%do not forget to leave a comment 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [code_arr] = ovsf(no_codes, len_codes)
clc;
len_codes = sort (len_codes);
code_mat = [1];
var_1 = 1;
size_mat = size(code_mat);
var_1 = size_mat(1,2);
var_3= 1;
for (var_3 = 1:1:no_codes)
    var_2 = len_codes(1,var_3);
    while (var_1 <= var_2)
        code_mat = [code_mat, code_mat;code_mat, -1.* code_mat];
        var_1 = var_1+1;
    end
    [code_mat,seq_sel] = modmat(code_mat);
    code_arr{var_3} = seq_sel;
end

function [code_mat, seq_sel] = modmat(code_mat)
seq_sel = code_mat(1,:);
code_mat(1,:) = [];

    