function biascorr = gaussian_ent_biascorr(N,T)
% Computes the bias corrector for the Total Correlation estimator based on covariance
% matrix of gaussians
%
% INPUTS
% N = Number of dimensions
% T = Sample size
%
% OUTPUT
% biascorr = bias corrector value
psiterms = psi((T - (1:N))/2);
biascorr=  0.5.*(N.*log(2/(T-1)) + sum(psiterms));

