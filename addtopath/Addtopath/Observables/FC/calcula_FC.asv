

function [FC,r] =calcula_FC(Temporal,fisher)

%funcion gralizada para calcular la FC de la celda que entre en Temporal
%Los datos tienen que llegar como una celda con todos los sujetos que se
%quieren considerar, la seleccion debería suceder afuera

%Temporal deberia ser una celda con un sujeto en cada celda de la primer
%fila, y dentro deberia ser nodos x tiempo

%Si desea cortar Tmax, debe ingresarse como una variable
%si no se introduce una Tmax este algoritmo va a tomar las tseries a su
%longitud maxima, y no calculara correlaciones entre tseries de longitudes
%distintas

%recordar que fisher controla no solo si se aplica el filtrado deco, sino
%tambien la transformada de fisher.

% ts las series temporales de los fmri procesados 
% cantidad de nodos de las imagenes (90 normalmente en AAL)
% nSubs cantidad de sujetos a trabajar
% Tmax tiempo maximo de las series temporales
% TRsec tiempo entre volumenes
% fisher si es 0 no filtra si es 1 si a la deco en sueño
% reorder , reordena los nodos a la deco si es 1 y sino 0

if iscell(Temporal)

    %chequea que ninguno de los datos sea una celda vacía
    mm=1;
    for rr=1:size(Temporal,2)
        
        if ~isequal(Temporal{1,rr},[])
            Temporal_temp(1,mm)=Temporal(1,rr);
            mm=mm+1;
        end
        
    end

    Temporal=Temporal_temp;
    
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
        r(:,:,i) = corrcoef(ts(:,:)');

    end

    if fisher==1 

        for i=1:nSubs
            
            z(:,:,i)=atanh(r(:,:,i));

        end

        z_final=mean(z,3);    
        FC=tanh(z_final);

    else

        FC=mean(r,3);

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
        r(:,:,i) = corrcoef(ts(:,:)');

    end

    if fisher==1 

        for i=1:nSubs
            z(:,:,i)=atanh(r(:,:,i));

        end

        z_final=mean(z,3);    
        FC=tanh(z_final);

    else

        FC=mean(r,3);

    end
    
    
end
    