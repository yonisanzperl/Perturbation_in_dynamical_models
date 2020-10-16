function [y,FSim,FC]=hopf_t(x,SC,FEmp,fx_metric,Cfg,Hopf,long_Total,w,start,binding)
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
val=Hopf.val;
Prom=Hopf.Prom;
Gmethod=Hopf.Gmethod;
dt=Hopf.dt;


y=zeros(N,1);

%xs=zeros(nNodes,long_Total);
nWind=size(FEmp,1);

for i=1:N
    
    y_temp=zeros(Prom,1);

    for j=1:Prom

        amp_a=x(i,1);
        k_a=1;
        s_a=x(i,2);
        
        amp_G=x(i,3);
        k_G=2;
        s_G=x(i,4);
        
        
        [new_a,new_G]=armarGammas(start,a_Ini,amp_a,k_a,s_a,G_Ini,amp_G,k_G,s_G,dt,TRsec,long_Total,nWind,binding);
        

        xs=resim_t_Hopf(new_a,new_G,SC,TRsec,nNodes,long_Total,w,val,Gmethod);
        
        save('temp.mat','xs')
        if Bpass==1 

            [xs]=filtroign(xs,TRsec,lb,ub); 

        end
        
        %fx_obs(xs);
        
        FC=observable_FCsev(xs);

        FSim=observable_fctaFCD(xs);

        y_temp(j)=fx_metric(FSim,FEmp);
        
        subplot(2,2,1)
        plot(new_a(1,:))
        xlim([1 nWind])
        subplot(2,2,2)
        plot(new_G(1,:))
        xlim([1 nWind])
        subplot(2,2,3)
        imagesc(FEmp,[0,1])
        subplot(2,2,4)
        imagesc(FSim,[0,1])
        
        drawnow
        

    end
    
    
    y(i)=mean(y_temp);

end