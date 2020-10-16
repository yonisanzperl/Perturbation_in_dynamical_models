
function [xs,initial]=simulAGint_conc(a,G,C,long_total,w,TRsec,val,initial)

    
    %RECORDAR QUE ESTE RESOLVEDOR PERMITE TENER UN VECTOR DE G, Y NO ES
    %IGUALAL OTRO YA QUE SACA G Y LO INTRODUCE DIRECTO EN LA EC.
    %POR AHORA EL G ES EL G INTERNO
    dt = 0.1;
    sig = 0.04;%.04; %was 0.04
    dsig = sqrt(dt)*sig; % to avoid sqrt(dt) at each time step
    
    nNodes=length(a);
    
    a=repmat(a,1,2);
    
    wC = C ;%aca es donde saco el G afuera de como estaba antes
    
    wintC = wC.*repmat(G',nNodes,1);
    
    G=repmat(G,1,2);
        
    
    
    

    xs=zeros(nNodes,long_total);
    z = 0.1*ones(nNodes,2); % --> x = z(:,1), y = z(:,2)
    zz = z(:,end:-1:1);
    
    sumC = repmat(wC*G(:,1),1,2);

    %comienzo a simular con el a otorgado (RECORDAR QUE ACA a YA NO ES
    %HOMOGENEO Y TAMPOCO G



        nn=1;
        if initial==0
            
            for t=1:dt:1000 %Ignacio estuvo aquí, y bajo el tiempo de termalizacion.
                %suma =  wC*(z.*G) - sumC.*z; % sum(Cij*xi) - sum(Cij)*xj

                zz = z(:,end:-1:1); % flipped z, because (x.*x + y.*y)

               z = z + dt*(a.*z + zz.*w - z.*(z.*z+zz.*zz) + wintC*(z) - sumC.*z)  + dsig*randn(nNodes,2);

            end
        else
            
            z=initial;
            zz = z(:,end:-1:1);
            
        end
        
        t=1:dt:long_total*TRsec;
      
        
       
        for i=1:length(t)
            %suma = wC*(z.*G) - sumC.*z; % sum(Cij*xi) - sum(Cij)*xj
           
            zz = z(:,end:-1:1); % flipped z, because (x.*x + y.*y)
            z = z + dt*(a.*z + zz.*w - z.*(z.*z+zz.*zz) + wintC*(z) - sumC.*z)  + dsig*randn(nNodes,2); 
            
            if t(i)==val(nn)
                
                %RECORDAR: por alguna razon se les ocurrio poner las tseries en
                %columnas. Yo lo corrijo para no perder sanidad
                xs(:,nn)=z(:,1);
                nn=nn+1;
                
            end
        
        end
        
        initial=xs(:,nn-1);
        
        
        