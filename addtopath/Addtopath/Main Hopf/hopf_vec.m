function [y,xs_last]=hopf_vec(x,group,SC,FEmp,fx_obs,fx_metric,Cfg,Hopf,long_Total,w,val)
%ahora todo esta vectorizado (las filas son cada individuo de la
%generación)
N=size(x,1);%Número de sujetos.

TRsec=Cfg.filt.TRsec;
nNodes=Cfg.nNodes;
Bpass=Cfg.filt.bpass;
lb=Cfg.filt.lb;
ub=Cfg.filt.ub;

%long_Total=Hopf.long_Total;
a_Ini=Hopf.a_Ini;
G_Ini=Hopf.G_Ini;
Parcell=Hopf.Parcell;
%w=Hopf.w;
%val=Hopf.val;
Prom=Hopf.Prom;
Gmethod=Hopf.Gmethod;


y=zeros(N,1);

xs=zeros(nNodes,long_Total);

if Cfg.ga.parallel
    parfor i=1:N

        y_temp=zeros(Prom,1);

        for j=1:Prom

            [new_a,new_G,~]=armaraesG(x(i,:),group,a_Ini,G_Ini,Parcell);

            xs=resim_Hopf(new_a,new_G,SC,TRsec,nNodes,long_Total,w,val,Gmethod);

            if Bpass==1 

                [xs]=filtroign(xs,TRsec,lb,ub); 

            end

            FSim = fx_obs(xs);

            y_temp(j)=fx_metric(FSim,FEmp);

        end

        y(i)=mean(y_temp);

    end
    
else
    
        for i=1:N

        y_temp=zeros(Prom,1);

        for j=1:Prom

            [new_a,new_G,~]=armaraesG(x(i,:),group,a_Ini,G_Ini,Parcell);


            xs=resim_Hopf(new_a,new_G,SC,TRsec,nNodes,long_Total,w,val,Gmethod);
            
            if Bpass==1 

                [xs]=filtroign(xs,TRsec,lb,ub); 

            end

            FSim = fx_obs(xs);
            

            y_temp(j)=fx_metric(FSim,FEmp);

        end

        y(i)=mean(y_temp);

        end
end


%{
subplot(2,1,1);
imagesc(FC_simul_Temp)
subplot(2,1,2);
stem(x);
title(['Dist optim. : ',num2str(y)]);
drawnow
%}

