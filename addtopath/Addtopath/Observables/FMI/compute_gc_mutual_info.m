function [mi,gaussian_data] = compute_gc_mutual_info(data)
% data = T x N
ent_fun = @(x,y) 0.5.*log((2*pi*exp(1)).^(x).*y);
[T,N] =size(data);
[gaussian_data,covmat] = data2gaussian(data);
biascorr_2 = gaussian_ent_biascorr(2,T);
biascorr_1 = gaussian_ent_biascorr(1,T);
k_ints = combnk(1:N,2);
nints = length(k_ints);
linids = sub2ind([N,N],k_ints(:,1),k_ints(:,2));  %linear index of mi matrix
tc = zeros(nints,1);
mi = zeros(N);
for i = 1:nints
    [tc(i)] = tc_from_covmat_gpu(covmat(k_ints(i,:),k_ints(i,:)),2,biascorr_1,biascorr_2,ent_fun);    
end
mi(linids) = tc;
mi = mi + mi';
