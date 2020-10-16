function [new_a,new_G]=armarGammas(start,base_a,amp_a,k_a,s_a,base_G,amp_G,k_G,s_G,dt,TRsec,T_Total,nWind,binding)

    t_integ=1:dt:T_Total*TRsec;
    
    [~, id_start]=min(abs(t_integ-start));
    
    t_integ(id_start);
    
    L=length(t_integ);
    
    a(1:id_start)=0;
    
    a(id_start:L)=amp_a*gampdf(t_integ(id_start:L)-t_integ(id_start),k_a,s_a);
    
    G(1:id_start)=0;
   
    G(id_start:L)=amp_G*gampdf(t_integ(id_start:L)-t_integ(id_start),k_G,s_G);
   
    t_new=linspace(1,T_Total*TRsec,nWind);
    
    new_a=interp1(t_integ,a,t_new);
    new_G=interp1(t_integ,G,t_new);

    new_a=repmat(new_a,90,1);
    new_G=repmat(new_G,90,1);
    
    binding_vec=repmat(binding,1,size(new_a,2));
    
    basetotal_a=repmat(base_a,1,nWind);
    basetotal_G=repmat(base_G,1,nWind);
    
    new_a=basetotal_a+binding_vec.*new_a;
    new_G=basetotal_G+new_G;
    
end