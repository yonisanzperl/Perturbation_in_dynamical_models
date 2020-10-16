function [new_alpha,new_beta,new_G,LBOUND,UBOUND,dimx]=armarTakens(x,Takens)

    Takens
   nNodes=size(Takens.group,1);
   
   max_Group=size(Takens.group,2);

   comp_Group=zeros(max_Group,2);
   
   new_alpha=zeros(nNodes,1);
   new_beta=zeros(nNodes,1);
   new_G=zeros(nNodes,1);
   

    switch(Parcell)

        case 1
            %este caso es alpha por grupo,beta fijo, Gfijo
            comp_Group(:,1)=x(:);
            %no se define comp group del G
            new_alpha=Takens.alpha_Ini+Takens.group*comp_Group(:,1);
            new_beta=Takens.beta_Ini;
            new_G=Takens.G_Ini;
            
            LBOUND=Takens.alphabound(1)*ones(1,max_Group);
            UBOUND=Takens.alphabound(2)*ones(1,max_Group);

        case 2
            %este caso es alpha fijo,beta por grupo, Gfijo
            
            comp_Group(:,1)=x(:);
            new_alpha=Takens.alpha_Ini;
            new_beta=Takens.beta_Ini+Takens.group*comp_Group(:,1);
            new_G=Takens.G_Ini;
            
            
            LBOUND=[ Takens.betabound(1)*ones(1,max_Group) ];
            UBOUND=[ Takens.betabound(2)*ones(1,max_Group) ];

        case 3
            %este caso es alpha por grupo,beta fijo, G homogeneo

            comp_Group(:,1)=x(1:end-1);

            new_alpha=Takens.alpha_Ini+Takens.group*comp_Group(:,1);
            new_beta=Takens.beta_Ini;
            new_G=Takens.G_Ini+x(1,end)*ones(nNodes,1);
            
            
            LBOUND=[ Takens.alphabound(1)*ones(1,max_Group) Takens.Gbound(1) ];
            UBOUND=[ Takens.alphabound(2)*ones(1,max_Group) Takens.Gbound(2) ];

            
        case 4
            
            %este caso es alpha fijo,beta por grupo, Gfijo

            comp_Group(:,1)=x(1:end-1);

            new_alpha=Takens.alpha_Ini;
            new_beta=Takens.beta_Ini+Takens.group*comp_Group(:,1);
            new_G=Takens.G_Ini+x(1,end)*ones(nNodes,1);
        
            
            LBOUND=[ Takens.betabound(1)*ones(1,max_Group) Takens.Gbound(1) ];
            UBOUND=[ Takens.betabound(2)*ones(1,max_Group) Takens.Gbound(2) ];

        case 5
            
            %este caso es alpha por grupo,beta por grupo, Gfijo
            
            comp_Group(:,1)=x(1:end/2);

            comp_Group(:,2)=x((end/2)+1:end);

            new_alpha=Takens.alpha_Ini+Takens.group*comp_Group(:,1);
            new_beta=Takens.beta_Ini+group*comp_Group(:,2);
            new_G=Takens.G_Ini;

                
            LBOUND=[ Takens.alphabound(1)*ones(1,max_Group) Takens.betabound(1)*ones(1,max_Group) ];
            UBOUND=[ Takens.alphabound(2)*ones(1,max_Group) Takens.betabound(2)*ones(1,max_Group) ];


        case 6
            %este caso es alpha por grupo,beta por grupo, G homogeneo
            
            comp_Group(:,1)=x(1:(end-1)/2);

            comp_Group(:,2)=x(((end-1)/2)+1:(end-1));

            new_alpha=Takens.alpha_Ini+Takens.group*comp_Group(:,1);
            new_beta=Takens.beta_Ini+Takens.group*comp_Group(:,2);
            new_G=Takens.G_Ini+x(1,end)*ones(nNodes,1);
            
            
            LBOUND=[ Takens.alphabound(1)*ones(1,Cfg.max_Group) Takens.betabound(1)*ones(1,Cfg.max_Group) Takens.Gbound(1) ];
            UBOUND=[ Takens.alphabound(2)*ones(1,Cfg.max_Group) Takens.betabound(2)*ones(1,Cfg.max_Group) Takens.Gbound(2) ];

            
        case 7
            %este caso es alpha por grupo,beta por grupo, G por grupo
            
            comp_Group(:,1)=x(1:(end)/3);

            comp_Group(:,2)=x(((end)/3)+1:(end*2/3));

            new_alpha=Takens.alpha_Ini+Takens.group*comp_Group(:,1);
            new_beta=Takens.beta_Ini+Takens.group*comp_Group(:,2);
            new_G=Takens.G_Ini+Takens.group*x((end*2/3)+1:end)';

            LBOUND=[ Takens.alphabound(1)*ones(1,Cfg.max_Group) Takens.betabound(1)*ones(1,Cfg.max_Group) Takens.Gbound(1)*ones(1,Cfg.max_Group) ];
            UBOUND=[ Takens.alphabound(2)*ones(1,Cfg.max_Group) Takens.betabound(2)*ones(1,Cfg.max_Group) Takens.Gbound(2)*ones(1,Cfg.max_Group) ];

    end
    
    dimx=length(x);
    
end