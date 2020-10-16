%% Ejemplo de copulas gaussianas para time series
%% Definiendo datos, funciones y corrector de bias
ent_fun = @(x,y) 0.5.*log((2*pi*exp(1)).^(x).*y); % funcion de entropia para gaussiana
N=90;
T=200;
tseries = rand(T,N);
[gaussian_data,covmat] = data2gaussian(tseries);
biascorr_2 = gaussian_ent_biascorr(2,T);
biascorr_1 = gaussian_ent_biascorr(1,T);
%% 2.- Estimating Mutual Information
k_ints = combnk(1:N,2);
nints = length(k_ints);
linids = sub2ind([N,N],k_ints(:,1),k_ints(:,2));  %linear index of mi matrix
mimat = zeros(N,N);

tc = zeros(nints,1);
mi = zeros(N);
tic
for i = 1:nints
    [tc(i)] = tc_from_covmat_gpu(covmat(k_ints(i,:),k_ints(i,:)),2,biascorr_1,biascorr_2,ent_fun);    
end
mi(linids) = tc;
mi = mi + mi';
toc