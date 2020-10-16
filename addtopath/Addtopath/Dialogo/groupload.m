function groupload(h,k)

%load(get(handles(k),'String'))

%set(handles(k+2),'items', {'a';'b'})

% 


[datos_name,path_emp] = uigetfile('*.mat','Elegir los datos empíricos'); %carga datos empíricos

pathfinal_datos=[path_emp datos_name];

load(pathfinal_datos);

datos_listvar = grouping.labels;


set(h(k+1),'String',datos_listvar );

set(h(k+2),'String',pathfinal_datos);

end