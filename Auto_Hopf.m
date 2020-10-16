% clear all 
% close all
clearvars -except Answer0
close all
%% ESTO ES LO ÚNICO QUE SE TOCA (sino armar una copia)
if exist('Answer0','var')
    [Answer,Answer0,Cancelled]=IN_Hopf(Answer0);
else
    [Answer,Answer0,Cancelled]=IN_Hopf;
end

metadata.saveFile = Answer.saveFile;
metadata.currentDir=pwd;

Cfg.simulID = 'Test hbif ignacio';


metadata.TSCh=Answer.TSCh{1};%Nombre de la variable de la tseries para metadata
metadata.SCCh=Answer.SCCh{1};%Nombre de la variable de la sc para metadata
TS=load(Answer.TSDir,Answer.TSCh{1}); %Cell en formato (1,Nsubs) donde cada celda tiene una matriz (nodes x T).
TS=TS.(Answer.TSCh{1}); % Este es un truco para tomar deshacer el anidado que se genera de hacer el load 
fx_TS=Answer.fx_TS;

Cfg.filt.TRsec=Answer.TRsec; %Período muestral de las tseries

SC=load(Answer.SCDir,Answer.SCCh{1}); %Matriz (nNodes x nNodes)
SC=SC.(Answer.SCCh{1}); % Este es un truco para deshacer el anidado que se genera de hacer el load 

if iscell(SC)
    nNodes=length(SC{1});
else
    nNodes=length(SC);
end
    
    


grouping=load(Answer.GroupDir,'grouping');
grouping=grouping.('grouping'); % Este es un truco para tomar deshacer el anidado que se genera de hacer el load 

Cfg.randseed='shuffle'; %Tipo de semilla para los números random

Cfg.contradiag=Answer.EnableContradiagMode;%mete la antidiagonal en la sc (DFLT=0)



Cfg.Tmax=Answer.Tmax; %Esto es el Tmax que va a cortar y que va a tener cada sujeto simulado (la tseries simulada va a ser Cfg.Tmax*nSubs) 
%si es 0 significa que va a tomar el maximo de cada sujeto
Cfg.Tsim=Answer.Tsim;
Cfg.filt.bpass =Answer.EnableFilterMode;  %1: filtra la tseries entrante (DFLT=1)
Cfg.filt.lb= Answer.BPlb; %frecuencia menor del pasabanda (DFLT=0.04)
Cfg.filt.ub= Answer.BPub; %frecuencia mayor del pasabanda (DFLT=0.07)
Cfg.filt.fisher=1; %1: usa t de fisher (DFLT=1)
Cfg.filt.enablesacawign=Answer.EnableSacawign;

Cfg.repe=Answer.Repe;  %numero de repeticiones del código a promediar (DFLT=100)

Cfg.ga.pob=Answer.N;%cantidad de individuos por gen (DFLT=10)
Cfg.ga.gens=Answer.Gens;%cantidad de generaciones (DFLT=200)
Cfg.ga.verbose=1;%Si va a producir mensajitos (DFLT=1)
Cfg.ga.parallel=Answer.EnableParallelMode;%Si va a usar proc. paralelo (DFLT=0)
Cfg.ga.vect=Answer.EnableVectorizeMode;%Si va a usar función vectorizada (DFLT=1)

Cfg.anticorrel=Answer.EnableAnticorrelMode; %Esto le agregar el signo de correlaciones negativas para corregir en histogramas corridos

metadata.groupCh=Answer.GroupCh{1}; %Label del grupo que se eligió
group=grouping.belong{find(strcmp(Answer.GroupCh{1},grouping.labels))}; % grouping.belong es (nNodes x max_Group) binario para pertenencia de cada nodo al grupo
%Si es 0 el algoritmo considera que serán grupos random

metadata.obsCh=Answer.ObsCh{1}; %label para saber que observable se usó
%funciones (ojo que si hay alguna sev o vent el empírico es diferente)
fx_emp=Answer.fx_emp;
fx_obs=Answer.fx_obs;

metadata.metricCh=Answer.MetCh{1}; %label para saber qué métrica se usó
fx_metric=Answer.fx_metric;


%--HASTA ACÁ ES GRAL, A PARTIR DE ACÁ ES PARTICULAR DE HOPF-------%

Hopf.abound=[Answer.aesLb , Answer.aesUb];%a futuro meter limites mas grandes para aes (DFLT=[-0.4 , 0.4])
Hopf.Gbound=[Answer.GesLb , Answer.GesUb];%a futuro meter limites mas grandes para aes (DFLT=[0,3])

Hopf.a_Ini=Answer.fx_aIni(nNodes);%Da el inicial en el a (DFLT=0.005*rand(nNodes,1))
Hopf.G_Ini=Answer.fx_GIni(nNodes);%Da el inicial en el G (DFLT=0.5*ones(nNodes,1)
Hopf.dt=Answer.dt;%Da el paso del integrador (DFLT=0.1)

Hopf.permuta=Answer.EnablePermutaMode;%hace una permutación en los nodos para chequear que le hace a ssim (DFLT=0)
Hopf.Gmethod=1; %pone el array de G dependiente del nodo simulado, o dentro de la sum (DFLT=1)(interno)

Hopf.Parcell=Answer.Parcell;%esto indica qué tipo de grupos, 1:a por grupo,G=G_Ini ; 2:a por grupo, G homog; 3:a por grupo, G por grupo, 4:a homog, G por grupo

Hopf.Prom=Answer.Prom; %cuanto va a promediar para sacar un valor promedio de distancia por sujeto de la gen.

%% Init

metadata.currentFolder = pwd;

%% Carga funciones anónimas de observable, metrica y fullmetrica.

fx_fullmetric=@(FSim,FEmp) [1-ssim(FSim,FEmp),norm(tril(FEmp,-1)-tril(FSim,-1),'fro'),metrica_KS(FSim,FEmp)];

%% Elección carpeta (sale metadata.outdir

out_Dir=[metadata.currentFolder '\Simulaciones\' metadata.saveFile];
mkdir (out_Dir);


metadata.outdir=out_Dir;

clear out_Dir

%% Define Cfg de base (SI ALGO SE CAMBIA RECORDARLO) ( De acá sale Cfg.(simulID , nNodes , randseed , repe , verbose , fcd?)

Cfg.nNodes=length(SC);


%% Preprocess TSeries: Define Cfg.Tmax,Cfg.each_Tmax , corta y filtra TSeries (Sale Cfg.Tmax , TSeries filtrada , TSeries_unfilt , Cfg.each_Tmax , metadata.Tmax



[TSeries_unfilt,Cfg.each_Tmax]=cortador_ts(TS,Cfg.Tmax);



if Cfg.filt.bpass
    TS=filtroign(TSeries_unfilt,Cfg.filt.TRsec,Cfg.filt.lb,Cfg.filt.ub);
else
    TS=TSeries_unfilt;
end

TS_forfreq=fx_TS(TS);
TS_forfreq_unfilt=fx_TS(TSeries_unfilt);

metadata.Tmax=Cfg.Tmax;

%% Prepara FEmp

FEmp=fx_emp(TS);

if iscell(FEmp) || size(FEmp,3)>1
    Several.flag=1;
    Several.size=size(FEmp,2);
    FEmp_cell=FEmp;
else
    Several.flag=0;
    Several.size=1;
    FEmp_cell=num2cell(FEmp,[1 2]);
end

%% Preprocess SC (sale SC pero modificada)
for i=1:Several.size
    
    if iscell(SC)
    
        SC_temp=SC{i}/max(max(SC{i}))*0.2;
        
    elseif size(SC,3)==Several.size
        
        SC_temp=SC(:,:,i)/max(max(SC(:,:,i)))*0.2;
        
    else
        
        SC_temp=SC/max(max(SC))*0.2;
        
    end

    if Cfg.contradiag==1

        ind_contra=sub2ind([Cfg.nNodes Cfg.nNodes], linspace(1,Cfg.nNodes,Cfg.nNodes), fliplr(linspace(1,Cfg.nNodes,Cfg.nNodes)));
        SC_temp(ind_contra)=0.2;

    end

    if Cfg.anticorrel

        SC_temp=SC_temp.*sign(observable_FC(TS));

    end
    
    SC_cell{i}=SC_temp;
    %SC=SC_temp;
end

%% Elige los grupos (Sale group , metadata.groupch)

Cfg.max_Group=size(group,2);

clear grouping

%% Integrador (el que produce xs) + fx_opt + fx_resim

if Cfg.Tsim==0
    
    if Several.flag
        Hopf.long_Total=Cfg.each_Tmax;%long total (suma de las long de tseries de cada sujeto
    else
        Hopf.long_Total=sum(Cfg.each_Tmax);
    end
    
else
        
    Hopf.long_Total(1:Several.size)=Cfg.Tsim;
        
end

metadata.Tsim=Cfg.Tsim;
metadata.long_Total=Hopf.long_Total;


if Several.flag
    
    for i=1:Several.size
        
        if Cfg.filt.enablesacawign
            Hopf.w{i}=saca_w_ign2(TS_forfreq(i),Cfg.filt.TRsec);
        else
            Hopf.w{i}=saca_w(TS_forfreq_unfilt(i),1, Cfg.each_Tmax(i), Cfg.filt.TRsec) ;
        end
        
                
        Hopf.val{i}=resamplingID(Hopf.long_Total(i),Cfg.filt.TRsec,Hopf.dt);
        
        size(Hopf.w{i})
        size(Hopf.val{i})
        
    end
    
else
    
    if Cfg.filt.enablesacawign
        Hopf.w{1}=saca_w_ign2(TS_forfreq,Cfg.filt.TRsec);
    else
        Hopf.w{1}=saca_w(TS_forfreq_unfilt,length(TS_forfreq_unfilt), Cfg.each_Tmax(i), Cfg.filt.TRsec) ;
    end
    
    %Hopf.w{1}=saca_w(cortador_ts(TSeries_unfilt,min(Cfg.each_Tmax)),size(cortador_ts(TSeries_unfilt,min(Cfg.each_Tmax)),2), min(Cfg.each_Tmax), Cfg.filt.TRsec) ;
    %Hopf.w{1}=saca_w_ign2(TS,Cfg.filt.TRsec);
    
    Hopf.val{1}=resamplingID(Hopf.long_Total,Cfg.filt.TRsec,Hopf.dt);
    
end

out_temp(Cfg.repe)=struct('solution',[],'fval',[],'exitflag',[],'output',[],'population',[],'scores',[],'xs',[],'Rta',[],'RtG',[],'FSim',[],'fullmetric',[]);

%% Define las funciones importantes
    
for i=1:Several.size

    fx_opt{i}=@(x)hopf_vec(x,group,SC_cell{i},FEmp_cell{i},fx_obs,fx_metric,Cfg,Hopf,Hopf.long_Total(i),Hopf.w{i},Hopf.val{i});

    fx_resim{i}=@(new_a,new_G)resim_Hopf(new_a,new_G,SC_cell{i},Cfg.filt.TRsec,Cfg.nNodes,Hopf.long_Total(i),Hopf.w{i},Hopf.val{i},Hopf.Gmethod);

end

    

%% Simula todo

for  irepe=1:Cfg.repe
    
    for sev=1:Several.size

    fprintf('RUN:');
    fprintf(strcat(num2str(irepe),' / ',num2str(Cfg.repe)));
    fprintf('\n');
    fprintf('Sujeto:');
    fprintf(strcat(num2str(sev),' / ',num2str(Several.size)));
    fprintf('\n');
    
    if Cfg.ga.verbose
        fprintf('Simulación: ');
        fprintf(metadata.saveFile);
        fprintf('\n');
        fprintf('Tu variable TS: ');
        fprintf(metadata.TSCh);
        fprintf('\n');
        fprintf('Tu variable SC: ');
        fprintf(metadata.SCCh);
        fprintf('\n');
        fprintf('Tu variable group: ');
        fprintf(metadata.groupCh);
        fprintf('\n');
        fprintf('Tu observable es: ');
        fprintf(metadata.obsCh);
        fprintf('\n');
        fprintf('Tu metrica que optimizás es: ');
        fprintf(metadata.metricCh);
        fprintf('\n');
        fprintf('Cortas cada TS en: ');
        fprintf(num2str(metadata.Tmax));
        fprintf('\n');
        
        if Cfg.Tsim==0
            fprintf('Simulas la concatenación de sujeto/s');
            fprintf('\n');
        else
            fprintf('Simulas hasta: ');
            fprintf(num2str(metadata.long_Total));
            fprintf('\n');
        end
    end
    
    
    
    
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
            Cfg.ga.lb=[Hopf.abound(1)*ones(1,Cfg.max_Group) Hopf.Gbound(1)*ones(1,Cfg.max_Group)];
            Cfg.ga.ub=[Hopf.abound(2)*ones(1,Cfg.max_Group) Hopf.Gbound(2)*ones(1,Cfg.max_Group)];

        case 4

            Cfg.ga.dimx=size(group,2)+1;

            
            Cfg.ga.lb=[Hopf.abound(1) Hopf.Gbound(1)*ones(1,Cfg.max_Group)];
            Cfg.ga.ub=[Hopf.abound(2) Hopf.Gbound(2)*ones(1,Cfg.max_Group)];

    end

    
    %% Simula y optimiza
    
    tic
    
    clear out_temp
    [out_temp] = opt_genetic(fx_opt{sev},Cfg);
    
    
    tiempo_1sim=toc;
   
    %% Resaca todo
    
    
    [out_temp.Rta,out_temp.RtG,~]=armaraesG(out_temp.solution,group,Hopf.a_Ini,Hopf.G_Ini,Hopf.Parcell);
    
    [out_temp.xs]=fx_resim{sev}(out_temp.Rta,out_temp.RtG);

    if Cfg.filt.bpass==1 

        [out_temp.xs]=filtroign(out_temp.xs,Cfg.filt.TRsec,Cfg.filt.lb,Cfg.filt.ub); 

    end

    out_temp.FSim=fx_obs(out_temp.xs);
    
    
    [out_temp.fullmetric]=fx_fullmetric(out_temp.FSim,FEmp_cell{sev});
        

    %% Guarda los datos (guarda corridatotal.mat , datosutilizados.mat)
        
       
        cd(metadata.outdir)
        
        out(irepe,sev)=out_temp;
        %Aca guardar los datos periódicamente
        save('corridatotal.mat');
        savefig(strcat('repe-',num2str(i),'subj-',num2str(sev)));
        cd(metadata.currentDir);
        
    end
end
