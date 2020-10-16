
function [xs]=simulAGTB(alpha,beta,G,C,nSubs,Tmax,TRsec,val)

    
    % alpha en un vector de (27,1); alpha =-0.15 sirve siempre
    %F0 es la amplitud del forzante , se le pasa un numero
    % w es un vector de (27,2) que sale del saca_w donde en cada columan
    % tiene lo mismo pero con signo cambiado, para darle a las odes en
    % forma compleja
    % kick en un vector de (27,1) donde hay 1 en los nodos que queremos
    % patatear
    
    %paso integracion
    dt = 0.01;
    
    % genera el ruido
    sig = 0.0; %was 0.04
    dsig = sqrt(dt)*sig; % to avoid sqrt(dt) at each time step
    

    nNodes=length(alpha);
    
    % mapea en dos dim los parametros para ir a la forma compleja de la FN
    % de Hopf
    alpha= repmat(alpha,1,2);
    beta = repmat(beta,1,2);
   
    % para el acople entre nodos
    
   wC = C ;%aca es donde saco el G afuera de como estaba antes
    
   wintC = wC.*repmat(G',nNodes,1);
    
   G=repmat(G,1,2);
   sumC = repmat(wC*G(:,1),1,2);
        
  % condiciones iniciales

   % xs=zeros(nNodes,Tmax*nSubs);
    %z = 0.1*ones(nNodes,2); % --> x = z(:,1), y = z(:,2)
    z(:,1)=ones(nNodes,1)*0.01;
    z(:,2)=ones(nNodes,1)*0.01;


    
    %ajusta los parametros


    gamma = 10*ones(nNodes,1);
    long = Tmax*nSubs;
    t=1:dt:long;
    
     
          nn=1; % termaliza la cosa
        for t=1:dt:100 %JVS is it really necessary to swing in for 3000secs?
            
            z(:,1)=z(:,1)+dt*(z(:,2)+wintC*(z(:,1)) - sumC(:,1).*z(:,1))+dsig*randn(nNodes,1);
            z(:,2)= z(:,2) + dt*(gamma(:,1).*gamma(:,1).*alpha(:,1)-gamma(:,1).*gamma(:,1).*beta(:,1).*z(:,1)+gamma(:,1).*gamma(:,1).*z(:,1).*z(:,1)-gamma(:,1).*z(:,1).*z(:,2)-gamma(:,1).*gamma(:,1).*z(:,1).*z(:,1).*z(:,1)-gamma(:,1).*z(:,1).*z(:,1).*z(:,2));
        end
 
        t=1:dt:long;
        
        
          for i=1:length(t) %JVS: was 15000, now faster
            z(:,1)=z(:,1)+dt*(z(:,2)+wintC*(z(:,1)) - sumC(:,1).*z(:,1))+dsig*randn(nNodes,1);
             z(:,2)= z(:,2) + dt*(gamma(:,1).*gamma(:,1).*alpha(:,1)-gamma(:,1).*gamma(:,1).*beta(:,1).*z(:,1)+gamma(:,1).*gamma(:,1).*z(:,1).*z(:,1)-gamma(:,1).*z(:,1).*z(:,2)-gamma(:,1).*gamma(:,1).*z(:,1).*z(:,1).*z(:,1)-gamma(:,1).*z(:,1).*z(:,1).*z(:,2));
             
             xs(:,i)=z(:,1);
        
          if t(i)==val(nn)
                
                %RECORDAR: por alguna razon se les ocurrio poner las tseries en
                %columnas. Yo lo corrijo para no perder sanidad
                xs(:,nn)=z(:,1);
                nn=nn+1;
         end
             
             
        end
        
