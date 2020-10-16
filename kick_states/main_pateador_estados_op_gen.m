%% Cargar datos
clearvars -except Answer0
close all
%%
[Answer,Answer0,Cancelled]=IN_kick_states();
%Answer =Answer0;

% para adaptar la salida de las simulaciones de distintas epocas
current =pwd;

[name_out, path]=adaptout_Hopf(Answer.TSDir);

load(strcat(path{1},name_out));

cd(current)

%load(Answer.TSDir,Answer.TSCh{1});
%load(Answer.SCDir,Answer.SCCh{1});
%load(Answer.WDir,Answer.WCh{1});
%load(Answer.WDir,Answer.emp{1});

%omega=Hopf.w;

% nNodes=length(omega);
% carga cosas de configuracion
Cfg.TRsec = Answer.TRsec; %para los datos de propo es 2.46, para sueno es 2
Cfg.Tmax = Answer.Tsim; %para los datos de propo es 194 para sueno 200
Cfg.nSub = Answer.Suj; %son 14 para los datos de propo, 15 para los de sueno
Cfg.Repe = Answer.Repe; % cuantas veces se repite la sim
Cfg.nodos_kick = Answer.Nodes;% cuantos nodos pateo
Cfg.amplitud = Answer.Forz; % hasta donde pateo

%del filtro
Cfg.filt.bpass =Answer.EnableFilterMode;  %1: filtra la tseries entrante (DFLT=1)
Cfg.filt.lb= Answer.BPlb;
Cfg.filt.ub = Answer.BPub;
%paraleliza
Cfg.parallel = Answer.EnableParallelMode;


% le pasa los datos de la simulacion

FC_inicial = FSim_best;
FEmp = FEmp_best;
SC = SC_best;
Rta = Rta_best;
RtG = RtG_best;
omega = w_best{1}; % para algunos funciona sin celda y otros con
val = val_best;


currentFolder = pwd;
out_Dir=[currentFolder '\Simulaciones\' Answer.saveFile];
mkdir (out_Dir);


[FC_sim_kick, S, nodo_kicked]=fun_sim_patadas(Rta,omega,Cfg,SC,val);

cd(out_Dir)
save patada_estado