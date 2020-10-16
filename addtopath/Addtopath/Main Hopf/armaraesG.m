function [new_a,new_G,dimx]=armaraesG(x,group,a_Ini,G_Ini,Parcell)

    
    nNodes=size(group,1);
   
   max_Group=size(group,2);

   comp_Group=zeros(max_Group,2);
   
   new_a=zeros(nNodes,1);
   new_G=zeros(nNodes,1);
   

    switch(Parcell)

        case 1
            
            comp_Group(:,1)=x(:);
            %no se define comp group del G
            new_a=a_Ini+group*comp_Group(:,1);
            new_G=G_Ini;
            
        case 2
            
            
            comp_Group(:,1)=x(1:end-1);

            new_a=a_Ini+group*comp_Group(:,1);
            new_G=G_Ini+x(1,end)*ones(nNodes,1);

        case 3
            
            
            comp_Group(:,1)=x(1:end/2);

            comp_Group(:,2)=x((end/2)+1:end);

            new_a=a_Ini+group*comp_Group(:,1);
            new_G=G_Ini+group*comp_Group(:,2);


        case 4
            
            
            comp_Group(:,1)=x(1);
            
            comp_Group(:,2)=x(2:end);

            new_a=a_Ini+x(1,1)*ones(nNodes,1);
            
            new_G=G_Ini+group*comp_Group(:,2);

            
    end
    
    dimx=length(x);
    
end