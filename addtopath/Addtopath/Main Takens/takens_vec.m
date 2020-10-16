function [y,xs_last]=takens_vec(x,group,C,FEmp,fx_obs,fx_metric,Cfg,Takens,long_Total,w,val)
                               

N=size(x,1);


TRsec=Cfg.filt.TRsec;
nNodes=Cfg.nNodes;
Bpass=Cfg.filt.bpass;
lb=Cfg.filt.lb;
ub=Cfg.filt.ub;

%long_Total=Hopf.long_Total;
alpha_Ini=Takens.alpha_Ini;
beta_Ini=Takens.beta_Ini;
G_Ini=Takens.G_Ini;
Parcell=Takens.Parcell;

Prom=Takens.Prom;
Gmethod=Takens.Gmethod;


 
            
if Cfg.ga.parallel
    parfor i=1:N
        
        y_temp=zeros(Prom,1);

        for j=1:Prom

            
%esto cumple funcion de armaraesG, FUTURO armar función

            alpha=alpha_Ini+group*comp_Group(:,1);
            beta=beta_Ini;
            new_G=G_Ini;
            
%fin armaraesG
        
        xs=resim_Takens(alpha,beta,new_G,C,1,long_Total,TRsec,Gmethod,val);
        
        
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
        
            
%esto cumple funcion de armaraesG, FUTURO armar función
            comp_Group(:,1)=x(i,:);
            size(comp_Group)
            size(x(i,:))
            alpha=alpha_Ini+group*comp_Group(:,1);
            beta=beta_Ini;
            new_G=G_Ini;
            
%fin armaraesG

            xs=resim_Takens(alpha,beta,new_G,C,1,long_Total,TRsec,Gmethod,val);


            if Bpass==1 

                [xs]=filtroign(xs,TRsec,lb,ub); 

            end

            FSim = fx_obs(xs);

            y_temp(j)=fx_metric(FSim,FEmp);

        end

        y(i)=mean(y_temp);

        end
    
end
