function [tc] = tc_from_covmat_gpu(covmat,N,bc1,bcN,ent_fun)
% Computes the total correlation of gaussian data given their covariance
% matrix 'covmat'.
%
% INPUTS
% covmat = N x N covariance matrix
% all_min_1 = index of all minus one system
% bc1 = bias corrector for N=1
% bcN_min_1 = bias corrector for N-1 system
% bcN = bias corrector for N system
%
% OUTPUT
% tc = total correlation of the system with covariance matrix covmat.

% ent_fun = @(x,y) 0.5.*log((2*pi*exp(1)).^(x).*y);
detmv = det(covmat); % determinant
single_vars = diag(covmat); % variance of single variables

var_ents= ent_fun(1,single_vars) - bc1;
sys_ent = ent_fun(N,detmv) - bcN;

tc = sum(var_ents) - sys_ent;
