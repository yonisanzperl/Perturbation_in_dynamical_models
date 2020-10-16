function MIF=observable_MIF(Temporal)

fisher=1;
Tmax=0;
norm=3;

if iscell(Temporal)

    nSubs=size(Temporal,2);
    nNodes=size(Temporal{1},1);

    each_Tmax=zeros(1,nSubs);

    %chequeo si hay que cortar o estan libres.

    for i=1:nSubs
        each_Tmax(i)=size(Temporal{i},2);
    end
        


    %todas las tseries

    for i = 1:nSubs
        
        ts = zeros(nNodes, each_Tmax(i));
        ts(:,:) = Temporal{i}(:,1:each_Tmax(i));
        mi(:,:,i) = compute_gc_mutual_info(ts(:,:)');
        %mi(:,:,i)=mi(:,:,i)/log(sqrt(2*pi*exp(1)));
        mi(:,:,i)=mi(:,:,i)/norm;
        %max(max(mi(:,:,i)))
    end

    if fisher==1 

        for i=1:nSubs
            
            z(:,:,i)=atanh(mi(:,:,i));
            
        end

        z_final=mean(z,3);    
        MIF=tanh(z_final);

    else

        MIF=mean(mi,3);

    end
    
else
    
    nSubs=size(Temporal,3);
    nNodes=size(Temporal,1);
    
    each_Tmax=zeros(1,nSubs);

    %chequeo si hay que cortar o estan libres.

    
    for i=1:nSubs
        each_Tmax(i)=size(Temporal,2);
    end
        
    for i = 1:nSubs
        
        ts = zeros(nNodes, each_Tmax(i));
        ts(:,:) = Temporal(:,1:each_Tmax(i),i);
        mi(:,:,i) = compute_gc_mutual_info(ts(:,:)');
        %mi(:,:,i)=mi(:,:,i)/log(sqrt(2*pi*exp(1)));
        mi(:,:,i)=mi(:,:,i)/norm;
        %max(mi(:,:,i))
    end

    if fisher==1 

        for i=1:nSubs
            
            z(:,:,i)=atanh(mi(:,:,i));
            
        end

        z_final=mean(z,3);    
        MIF=tanh(z_final);

    else

        MIF=mean(mi,3);

    end
    
    
    
    
end

