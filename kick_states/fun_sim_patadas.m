%para iterar la cosa
function [FC_sim_kick, S, nodo_kicked]=fun_sim_patadas(aes,omega,Cfg,SC,val);


nodo_kick = zeros(90,1);
if Cfg.parallel==1
for ii=1:Cfg.nodos_kick; % va paseando de a pares de patadas
    nodo_kick = zeros(90,1);
    if Cfg.nodos_kick==90
    nodo_kick(ii)=1;
    else
    nodo_kick(ii)=1;
    nodo_kick(91-ii)=1;
    end
    ii
for j=1:Cfg.amplitud; %barre el valor de la amplitud del forzado (S)
    S(j)= 0+0.1*j;
    parfor i=1:Cfg.Repe %iteradas por cada valor de amplitud , statistic para el ruido
        tic
        xs = simulAG_transtion_loop(aes,S(j),SC,Cfg.nSub,Cfg.Tmax,omega,Cfg.TRsec,nodo_kick,val);
        if Cfg.filt.bpass==1; xs = filtroign(xs,Cfg.TRsec,Cfg.filt.lb,Cfg.filt.ub); end
     
        toc
       FC_sim_2(:,:,i,j,ii)=corr(xs');
       
    end
    FC_sim_av_2(:,:,j,ii) = mean(FC_sim_2(:,:,:,j,ii),3);
    %figure
    %imagesc(FC_sim_av(:,:,j,ii));title(num2str(ii));
    %S(j) = S;
end
%FC_sim_av_nod(:,:,ii) = FC_sim_av(:,:,j);
nodo_kicked(:,ii) = nodo_kick;
end
FC_sim_kick = FC_sim_av_2;

% sin paralelizar

else
    
for ii=1:Cfg.nodos_kick; % va paseando de a pares de patadas
    nodo_kick = zeros(90,1);
    if Cfg.nodos_kick==90
    nodo_kick(ii)=1;
    else
    nodo_kick(ii)=1;
    nodo_kick(91-ii)=1;
    end
    ii
for j=1:Cfg.amplitud; %barre el valor de la amplitud del forzado (S)
    S(j)= 0+0.1*j;
    for i=1:Cfg.Repe %iteradas por cada valor de amplitud , statistic para el ruido
        tic
        xs = simulAG_transtion_loop(aes,S(j),SC,Cfg.nSub,Cfg.Tmax,omega,Cfg.TRsec,nodo_kick,val);
        if Cfg.filt.bpass==1; xs = filtroign(xs,Cfg.TRsec,Cfg.filt.lb,Cfg.filt.ub); end
     
        toc
       FC_sim_2(:,:,i,j,ii)=corr(xs');
       
    end
    FC_sim_av_2(:,:,j,ii) = mean(FC_sim_2(:,:,:,j,ii),3);
    %figure
    %imagesc(FC_sim_av(:,:,j,ii));title(num2str(ii));
    %S(j) = S;
end
%FC_sim_av_nod(:,:,ii) = FC_sim_av(:,:,j);
nodo_kicked(:,ii) = nodo_kick;
end
FC_sim_kick = FC_sim_av_2;
end