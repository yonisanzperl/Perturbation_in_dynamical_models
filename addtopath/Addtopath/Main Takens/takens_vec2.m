function [y,xs_last]=takens_vec2(x,Cfg,Takens)
                               

N=size(x,1);

% %crear todas estas variables puede ser ineficiente, corregir cuando
% %eficiencia es importante
% Cfg.filt.TRsec=Cfg.filt.Cfg.filt.TRsec;
% Cfg.nNodes=Cfg.Cfg.nNodes;
% Cfg.filt.bpass=Cfg.filt.Cfg.filt.bpass;
% Cfg.filt.lb=Cfg.filt.Cfg.filt.lb;
% Cfg.filt.ub=Cfg.filt.Cfg.filt.ub;
% 
% 
% Takens.group=Takens.Takens.group;
% Takens.SC=Takens.SC;
% Takens.FEmp=Takens.Takens.FEmp;
% Takens.fx_obs=Takens.Takens.fx_obs;
% Takens.fx_metric=Takens.Takens.fx_metric;
% Takens.alpha_Ini=Takens.Takens.alpha_Ini;
% Takens.beta_Ini=Takens.Takens.beta_Ini;
% Takens.G_Ini=Takens.Takens.G_Ini;
% Takens.Parcell=Takens.Takens.Parcell;
% 
% Takens.Prom=Takens.Takens.Prom;
% Takens.Gmethod=Takens.Takens.Gmethod;
% Takens.long_Total=Takens.Takens.long_Total;
% Takens.w=Takens.Takens.w;
% Takens.val=Takens.Takens.val;

%Comp_group=x';
 
            
if Cfg.ga.parallel
    parfor i=1:N
        
        y_temp=zeros(Takens.Prom,1);

        

%esto cumple funcion de armaraesG, FUTURO armar función
            
    [new_alpha,new_beta,new_G,~,~,~]=armarTakens(x(i,:),Takens);

            
%fin armaraesG
        for j=1:Takens.Prom
            
        xs=resim_Takens(new_alpha,new_beta,new_G,Takens.SC,1,Takens.long_Total,Cfg.filt.TRsec,Takens.Gmethod,Takens.val);
        
        
            if Cfg.filt.bpass==1 

                [xs]=filtroign(xs,Cfg.filt.TRsec,Cfg.filt.lb,Cfg.filt.ub); 

            end

            FSim = Takens.fx_obs(xs);

            y_temp(j)=Takens.fx_metric(FSim,Takens.FEmp);

        end

        y(i)=mean(y_temp);

    end
    
else
    
        for i=1:N

        y_temp=zeros(Takens.Prom,1);

        for j=1:Takens.Prom
        

    %esto cumple funcion de armaraesG, FUTURO armar función

            [new_alpha,new_beta,new_G,~,~,~]=armarTakens(x(i,:),Takens);


    %fin armaraesG

                xs=resim_Takens(new_alpha,new_beta,new_G,Takens.SC,1,Takens.long_Total,Cfg.filt.TRsec,Takens.Gmethod,Takens.val);


                if Cfg.filt.bpass==1 

                    [xs]=filtroign(xs,Cfg.filt.TRsec,Cfg.filt.lb,Cfg.filt.ub); 

                end

                FSim = Takens.fx_obs(xs);

                y_temp(j)=Takens.fx_metric(FSim,Takens.FEmp);

            end

            y(i)=mean(y_temp);

        end
    
end
