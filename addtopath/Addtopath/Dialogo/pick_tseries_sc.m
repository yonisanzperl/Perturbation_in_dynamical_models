
function [TSeries,SC,TRsec,tsname,scname,pathfinal_datos,pathfinal_est]=pick_tseries_sc

[datos_name,path_emp] = uigetfile('*.mat','Elegir los datos empíricos'); %carga datos empíricos

pathfinal_datos=[path_emp datos_name];

datos_listvar = who( matfile(pathfinal_datos));

if length(datos_listvar)==1
    datos_Choice=1;
else
    datos_Choice=dialoguemos(datos_listvar');
end


if isempty((find(strcmp(datos_listvar,'TRsec'))))
    TRsec=inputdlg('Inserte el TR de sus datos (al finalizar se guardará junto a ellos con el nombre data)');
end



a1=load(pathfinal_datos,datos_listvar{datos_Choice});

a2=struct2cell(a1);

TSeries=a2{1};

[est_name,path_est] = uigetfile('*.mat','Elegir la conectividad est'); %carga conect estructural


pathfinal_est=[path_est est_name];
est_listvar = who( matfile(pathfinal_est));

if length(est_listvar)==1
    est_Choice=1;
else
    est_Choice=dialoguemos(est_listvar');
end


e1=load(pathfinal_est,est_listvar{est_Choice});

e2=struct2cell(e1);

SC=e2{1};


tsname=datos_listvar{datos_Choice};
scname=est_listvar{est_Choice};