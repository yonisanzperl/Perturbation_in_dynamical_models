%% Init (sale: metadata.currentFolder)
clear all 
close all

metadata.currentFolder = pwd;



%% Carga datos (sale: TRseries , SC , Cfg.filt.TRsec , metadata.tsname , metadata.scname)

[TSeries,SC,Cfg.filt.TRsec,metadata.tsname,metadata.scname]=pick_tseries_sc;

%% Elección carpeta (sale metadata.outdir

%chequea si hay una carpeta de simulaciones donde acumular los resultados

test=1;

while test~=0
    
    carpetadatos=inputdlg('Nombre de carpeta para simulación');
    test=exist(carpetadatos{1},'dir');
    
end
out_Dir=[metadata.currentFolder '\Simulaciones\' carpetadatos{1}];
mkdir (out_Dir);

clear carpetadatos
metadata.outdir=out_Dir;

clear out_Dir

%% Define Cfg de base (SI ALGO SE CAMBIA RECORDARLO) ( De acá sale Cfg.(simulID , nNodes , randseed , repe , verbose , fcd?)


Cfg.simulID = 'Test hbif ignacio';

Cfg.nNodes=length(SC);
Cfg.randseed='shuffle';

Cfg.repe=2;  %numero de repeticiones del código a promediar (DFLT=100)

Cfg.fcd.switch=0; %si utiliza o no fcd (DFLT=0)
Cfg.fcd.tLength = 60;  %tiempo de las ventanas (DFLT=60)
Cfg.fcd.tSup=40;%tiempo de superposiciÃ³n entre ventanas (DFLT=40)

%% Define algunas opciones para el algoritmo genético (Sale Cfg.ga.(pob , gens , verbose , parallel , vect))

Cfg.ga.pob=2;%cantidad de individuos por gen (DFLT=10)
Cfg.ga.gens=100;%cantidad de generaciones (DFLT=200)
Cfg.ga.verbose=1;%Si va a producir mensajitos
Cfg.ga.parallel=1;%Si va a usar proc. paralelo (DFLT=0)
Cfg.ga.vect=1;%Si va a usar función vectorizada

%% Define parámetros de filtro y procesado de observables (Sale Cfg.filt.(TRsec , bpass , lb , ub , fisher)

Cfg.filt.bpass =1;  %1: filtra la tseries entrante (DFLT=1)
Cfg.filt.lb= 0.04; %frecuencia menor del pasabanda
Cfg.filt.ub= 0.07; %frecuencia mayor del pasabanda
Cfg.filt.fisher=1; %1: usa t de fisher (DFLT=1)

%% Preprocess TSeries: Define Cfg.Tmax,Cfg.each_Tmax , corta y filtra TSeries (Sale Cfg.Tmax , TSeries filtrada , TSeries_unfilt , Cfg.each_Tmax , metadata.Tmax
%corta las tseries (si Cfg.Tmax==0 no tendrán límite)

Tmax_str=nan;

while(isnan(str2double(Tmax_str)))
    Tmax_str=inputdlg('Introduzca Tmax (0 si quiere el máximo de cada sujeto)');
end

Cfg.Tmax=str2double(Tmax_str);

TSeries_unfilt=TSeries;

[TSeries,Cfg.each_Tmax]=cortador_ts(TSeries,Cfg.Tmax); 
TSeries=filtroign(TSeries,Cfg.filt.TRsec,Cfg.filt.lb,Cfg.filt.ub);

metadata.Tmax=Cfg.Tmax;
clear Tmax_str

%% Preprocess SC (sale SC pero modificada)

Cfg.contradiag=0;%mete la antidiagonal en la sc (DFLT=0)

SC=SC/max(max(SC))*0.2;%


if Cfg.contradiag==1
   
    ind_contra=sub2ind([Cfg.nNodes Cfg.nNodes], linspace(1,Cfg.nNodes,Cfg.nNodes), fliplr(linspace(1,Cfg.nNodes,Cfg.nNodes)));
    SC(ind_contra)=0.2;
   
end

%% Elige los grupos (Sale group , metadata.groupch
if Cfg.nNodes==90
    load('groupings.mat');
elseif Cfg.nNodes==83
    load('groupings83.mat');
end

grouping.labels=[grouping.labels 'Random'];
group_Choice=dialoguemos(grouping.labels);
if ~strcmp(grouping.labels{group_Choice},'Random')
    
    group=grouping.belong{group_Choice};

else
    
    group=0;
                

end

Cfg.max_Group=size(group,2);

metadata.groupch=grouping.labels{group_Choice};
clear grouping

%% Prepara fx_obs y FEmp



list_distChoice = {'Funct Connect','Mutual Info'};

Cfg.obs=dialoguemos(list_distChoice);

switch(Cfg.obs)
    
    case 1 
       
        fx_obs=@(tseries)calcula_FC(tseries,Cfg.filt.fisher);
        
        fprintf('Elegiste conect funcional como observable\n' );
    
    case 2 
       
        metadata.obs=list_distChoice{2};

        fx_obs=@(tseries)observable_MIF(tseries,Cfg.filt.fisher);

        fprintf('Elegiste Informacion mutua como observable\n' );
        
end

FEmp=fx_obs(TSeries);

metadata.obs=list_distChoice{Cfg.obs};

%% Prepara fx_metric

list_distChoice = {'SSIM','Frobenius (euc.)'};

Cfg.dist=dialoguemos(list_distChoice);

metadata.metric=list_distChoice{Cfg.dist};



switch(Cfg.dist)
    
    case 1 
       
        Cfg.dist=1;

        fx_metric=@(FSim,FEmp)1-ssim(FSim,FEmp);

        fprintf('Elegiste Distancia SSIM\n' );
    
    case 2 
       
        Cfg.dist=2;

        fx_metric=@(FSim,FEmp) norm(tril(FEmp,-1)-tril(FSim,-1),'fro');


        fprintf('Elegiste Distancia Frobenius (euclidea entre matrices)\n' );


        
end

%% Integrador (el que produce xs) + fx_opt + fx_resim

Hopf.abound=[-0.4 , 0.4];%a futuro meter limites mas grandes para aes (DFLT=[-0.4 , 0.4])
Hopf.Gbound=[0,3];%a futuro meter limites mas grandes para aes (DFLT=[0,3])
Hopf.permuta=0;%hace una permutación en los nodos para chequear que le hace a ssim (DFLT=0)
Hopf.Gmethod=1; %pone el array de G dependiente del nodo simulado, o dentro de la sum (DFLT=1)(interno)
Hopf.a_Ini=0.005*zeros(Cfg.nNodes,1);%Da el inicial en el a (DFLT=0.005*rand(nNodes,1))
Hopf.G_Ini=0.5*zeros(Cfg.nNodes,1);%Da el inicial en el G (DFLT=0.5*ones(nNodes,1)
Hopf.dt=0.1;%Da el paso del integrador (DFLT=0.1)


list_parcellChoice = {'aes por grupo, G=0.5','aes por grupo, G homog','a por grupo, G por grupo','a homog, G por grupo'};

Hopf.Parcell=dialoguemos(list_parcellChoice);

Hopf.long_Total=sum(Cfg.each_Tmax);%long total (suma de las long de tseries de cada sujeto

Hopf.val=resamplingID(Hopf.long_Total,Cfg.filt.TRsec,Hopf.dt);

Hopf.w=saca_w_ign(TSeries_unfilt,Cfg.filt.TRsec,Cfg.filt.lb,Cfg.filt.ub);

Hopf.Prom=str2double(inputdlg('Inserte cuantas veces por individuo se integra'));

for  irepe=1:Cfg.repe

    if group==0

            shuffleArray=linspace(1,Cfg.nNodes,Cfg.nNodes);
            shuffleArray=shuffleArray(randperm(length(shuffleArray)));
            shuffleArray=reshape(shuffleArray,floor(Cfg.nNodes/6),6);
            group=zeros(Cfg.nNodes,6);
            for i=1:6

                group(shuffleArray(:,i),i)=1;

            end
            shuffleArray=linspace(1,Cfg.nNodes,Cfg.nNodes);
            shuffleArray=shuffleArray(randperm(length(shuffleArray)));
            shuffleArray=reshape(shuffleArray,15,6);
            group=zeros(Cfg.nNodes,6);
            for i=1:6

                group(shuffleArray(:,i),i)=1;

            end

    end


    fx_opt=@(x) hopf_vec(x,group,SC,FEmp,fx_obs,fx_metric,Cfg,Hopf);

    fx_resim=@(x) resim_Hopf(x,SC,group,Cfg.filt.TRsec,Cfg.nNodes,Hopf.long_Total,Hopf.a_Ini,Hopf.G_Ini,Hopf.Parcell,Hopf.w,Hopf.val,Hopf.Gmethod);

    %% Prepara fx_fullmetric

    fx_fullmetric=@(FSim,FEmp) [1-ssim(FSim,FEmp),norm(tril(FEmp,-1)-tril(FSim,-1),'fro')];

    %% Setea Cfg.ga.dimx y bounds



    switch(Hopf.Parcell)

        case 1 

            Cfg.ga.dimx=size(group,2);

            Cfg.ga.lb=Hopf.abound(1)*ones(1,Cfg.max_Group);
            Cfg.ga.ub=Hopf.abound(2)*ones(1,Cfg.max_Group);


        case 2

            Cfg.ga.dimx=size(group,2)+1;

            %le agrega cond de contorno si son necesarias
            Cfg.ga.lb=[Hopf.abound(1)*ones(1,Cfg.max_Group) Hopf.Gbound(1)];
            Cfg.ga.ub=[Hopf.abound(2)*ones(1,Cfg.max_Group) Hopf.Gbound(2)];
        case 3

            Cfg.ga.dimx=size(group,2)*2;


            %le agrega cond de contorno si son necesarias
            Cfg.ga.lb=[Hopf.abound(1) Hopf.Gbound(1)*ones(1,Cfg.max_Group)];
            Cfg.ga.ub=[Hopf.abound(2) Hopf.Gbound(2)*ones(1,Cfg.max_Group)];

        case 4

            Cfg.ga.dimx=size(group,2)+1;

            Cfg.ga.lb=[Hopf.abound(1)*ones(1,Cfg.max_Group) Hopf.Gbound(1)];
            Cfg.ga.ub=[Hopf.abound(2)*ones(1,Cfg.max_Group) Hopf.Gbound(2)];

    end

    %% Simula y optimiza

    [out(irepe)] = opt_genetic(fx_opt,Cfg);

    %% Resaca todo

    [out(irepe).xs]=fx_resim(out.solution);

            if Cfg.filt.bpass==1 

                [out.xs]=filtroign(out.xs,Cfg.filt.TRsec,Cfg.filt.lb,Cfg.filt.ub); 

            end

    [out(irepe).Rta,out(irepe).RtG,~]=armaraesG(out.solution,group,Hopf.a_Ini,Hopf.G_Ini,Hopf.Parcell);
    out(irepe).FSim=fx_obs(out.xs);
    [temp]=fx_fullmetric(out.FSim,FEmp);
    out(irepe).ssimfinal=temp(1);
    out(irepe).frobfinal=temp(2);
    clear temp

    %% Guarda los datos (guarda corridatotal.mat , datosutilizados.mat)

        cd(metadata.outdir)

        %Aca guardar los datos periódicamente
        save('corridatotal.mat');
        save('datosutilizados.mat','TSeries','SC','TRsec');

        cd(metadata.currentFolder);
        
end
