%funcion para calcular la fcd en el tiempo, POR AHORA NO FUNCIONA PARA MAS
%DE 1 SUJETO, INTRODUCIR TODOS LOS SUJETOS PEGADOS

function [FCDfinal,fc_t]=fcdbuild_ssim(tSeries,tLength,tSup,Ts)
    %respeta el numero de ventanas, y la superposicion de ventanas
    %exactamente, pero la longitud de cada ventana es +-1
    wSup=floor(tSup/Ts);
    wLength=floor(tLength/Ts);
    nNodes=size(tSeries,1);
    Tmax=size(tSeries,2);
    nSubs=size(tSeries,3);

    %wLength=(Tmax-wSup+wSup*(nWind))/nWind

    nWind=floor((Tmax-wSup)/(wLength-wSup));
    
    i=1;
    j=1;%por ahora solo un sujeto
    
    realSup=(Tmax-wLength-1)/nWind;
    
    prev=1;%primer punto
    resto=Tmax;
    
    while (resto>0)

        fc_t(:,:,i)=corrcoef(tSeries(:,floor(prev):(floor(prev)+wLength))');

        fc_tril(i,:)=squareform(tril(fc_t(:,:,i),-1));

        i=i+1;
        prev=prev+realSup;
        resto=Tmax-wLength-prev;

        size(fc_tril);

    end

    FCD(:,:,j)=ssim(fc_tril');


    FCDfinal=mean(FCD,3);
    
end