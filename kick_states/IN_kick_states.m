
% Si se buguea la GUI
% set(0,'ShowHiddenHandles','on')
% delete(get(0,'Children'))

function [Answer,Answer0,Cancelled]=IN_kick_states(varargin)

if nargin==1
    Answer0=varargin{1};
end
Title = 'INPUTSDLG Demo Dialog';

%%%% SETTING DIALOG OPTIONS
% Options.WindowStyle = 'modal';
Options.Resize = 'on';
Options.Interpreter = 'tex';
Options.CancelButton = 'on';
% Options.ApplyButton = 'on';
Options.ButtonNames = {'Continue','Cancel'}; %<- default names, included here just for illustration
Option.Dim = 6; % Horizontal dimension in fields
Options.AlignControls='on';
Options.FontSize=9;

size_control=[150 30];
size_control_short=[150 30];

Prompt = {};
Formats = {};
DefAns = struct([]);




% 
% 
% Prompt(1,:) = {['Aqui las opciones de la simulación se seleccionan y modifican, las últimas opciones son específicas al integrador.'],[],[]};
% Formats(1,2).type = 'text';
% Formats(1,2).size = [-1 0];
% Formats(1,2).span = [1 2]; % item is 1 field x 4 fields

Prompt(end+1,:) = {'Nombre carpeta', 'saveFile',[]};
Formats(1,3).type = 'edit';
Formats(1,3).format = 'text';
Formats(1,3).size = 100; % automatically assign the height
DefAns(1).saveFile = 'SimulTest';
% 
% Prompt(end+1,:) = {['Cargar la tseries'],[],[]};
% Formats(2,1).type = 'text';
% Formats(2,1).size = [-1 0];
% Formats(2,1).span = [1 1]; % item is 1 field x 4 fields

Prompt(end+1,:) = {'Cargar la simulacion','',''};
Formats(2,2).type = 'button';
Formats(2,2).size = [120 40]; % Tamaño
%Formats(2,1).callback = @(~,~,handles,k)msgbox(sprintf('You just pressed %s button',get(handles(k),'String')),'modal');
Formats(2,2).callback = @(~,~,h,k)dataload(h,k);
 

Prompt(end+1,:) = {'Cargar la simulacion:','TSCh',[]};
Formats(2,3).labelloc = 'leftmiddle';
Formats(2,3).type = 'list';
Formats(2,3).style = 'list';
Formats(2,3).format = 'text'; % Answer will give value shown in items, disable to get integer
Formats(2,3).items = {'TS_W' ; 'No hay nada cargado'};
Formats(2,3).limits = [1 1]; % multi-select
Formats(2,3).size = size_control;
DefAns.TSCh = {'No hay nada cargado'};


Prompt(end+1,:) = {'Directorio de la Corrida','TSDir',[]};
Formats(2,4).labelloc = 'topcenter';
Formats(2,4).type = 'edit';
Formats(2,4).format = 'text';
Formats(2,4).size = [-1 0];
Formats(2,4).span = [1 1];  % item is 1 field x 3 fields
DefAns.TSDir = pwd;


Prompt(end+1,:) = {'Tiempo de muestreo', 'TRsec',[]};
Formats(2,5).labelloc = 'topcenter';
Formats(2,5).type = 'edit';
Formats(2,5).format = 'float';
Formats(2,5).size = 80;
Formats(2,5).limits = [0 inf] ;% non-negative decimal number
DefAns.TRsec = 2;

% 
% Prompt(end+1,:) = {['Cargar la SC'],[],[]};
% Formats(3,1).labelloc = 'leftmiddle';
% Formats(3,1).type = 'text';
% Formats(3,1).size = [-1 0];
% % Formats(3,1).span = [1 1]; % item is 1 field x 4 fields
% 
% Prompt(end+1,:) = {'Cargar SC.mat','',''};
% Formats(3,2).type = 'button';
% Formats(3,2).size = [150 40]; % Tamaño
% %Formats(5,1).callback = @(~,~,handles,k)msgbox(sprintf('You just pressed %s button',get(handles(k),'String')),'modal');
% Formats(3,2).callback = @(~,~,h,k)dataload(h,k);
% 
% 
% 
% Prompt(end+1,:) = {'Elegir SC:','SCCh',[]};
% Formats(3,3).labelloc = 'leftmiddle';
% Formats(3,3).type = 'list';
% Formats(3,3).style = 'list';
% Formats(3,3).format = 'text'; % Answer will give value shown in items, disable to get integer
% Formats(3,3).items = {'SC','No hay nada cargado'};
% Formats(3,3).limits = [1 1]; % multi-select
% Formats(3,3).size =  size_control;
% DefAns.SCCh = {'No hay nada cargado'};
% 
% 
% Prompt(end+1,:) = {'Directorio de SC','SCDir',[]};
% Formats(3,4).labelloc = 'topcenter';
% Formats(3,4).type = 'edit';
% Formats(3,4).format = 'text';
% Formats(3,4).size = [-1 0];
% Formats(3,4).span = [1 1];  % item is 1 field x 3 fields
% DefAns.SCDir = pwd;
% 
% 
% Prompt(end+1,:) = {'Cargar Simulacion','',''};
% Formats(4,2).type = 'button';
% Formats(4,2).size = [150 40]; % Tamaño
% %Formats(5,1).callback = @(~,~,handles,k)msgbox(sprintf('You just pressed %s button',get(handles(k),'String')),'modal');
% Formats(4,2).callback = @(~,~,h,k)dataload(h,k);
% 
% 
% 
% Prompt(end+1,:) = {'Elegir struc hopf:','WCh',[]};
% Formats(4,3).labelloc = 'leftmiddle';
% Formats(4,3).type = 'list';
% Formats(4,3).style = 'list';
% Formats(4,3).format = 'text'; % Answer will give value shown in items, disable to get integer
% Formats(4,3).items = {'SC','No hay nada cargado'};
% Formats(4,3).limits = [1 1]; % multi-select
% Formats(4,3).size =  size_control;
% DefAns.WCh = {'No hay nada cargado'};
% 
% 
% Prompt(end+1,:) = {'Directorio de W','WDir',[]};
% Formats(4,4).labelloc = 'topcenter';
% Formats(4,4).type = 'edit';
% Formats(4,4).format = 'text';
% Formats(4,4).size = [-1 0];
% Formats(4,4).span = [1 1];  % item is 1 field x 3 fields
% DefAns.WDir = pwd;


% 

% Prompt(end+1,:) = {'Cargar FEmp','',''};
% Formats(4,5).type = 'button';
% Formats(4,5).size = [150 40]; % Tamaño
% %Formats(5,1).callback = @(~,~,handles,k)msgbox(sprintf('You just pressed %s button',get(handles(k),'String')),'modal');
% Formats(4,5).callback = @(~,~,h,k)dataload(h,k);


% % 
% Prompt(end+1,:) = {'Elegir FEmp:','GroupCh',[]};
% Formats(4,6).labelloc = 'leftmiddle';
% Formats(4,6).type = 'list';
% Formats(4,6).style = 'list';
% Formats(4,6).format = 'text'; % Answer will give value shown in items, disable to get integer
% Formats(4,6).items = {'FEmp' ; 'No hay nada cargado'};
% Formats(4,6).limits = [1 1]; % multi-select
% Formats(4,6).size =  size_control;
% DefAns.GroupCh = {'No hay nada cargado'};
% % 
% Prompt(end+1,:) = {'Directorio de FEmp','GroupDir',[]};
% Formats(5,4).labelloc = 'topcenter';
% Formats(5,4).type = 'edit';
% Formats(5,4).format = 'text';
% Formats(5,4).size = [-1 0];
% Formats(5,4).span = [1 1];  % item is 1 field x 3 fields
% DefAns.GroupDir = pwd;



Prompt(end+1,:) = {'Simular hasta Tmax...', 'Tsim','(0: igual a TSlong)'};
Formats(4,5).labelloc = 'topcenter';
Formats(4,5).type = 'edit';
Formats(4,5).format = 'integer';
Formats(4,5).limits = [0 999999999]; % 9-digits (positive #)
Formats(4,5).size = 80;
Formats(4,5).unitsloc = 'bottomleft';
DefAns.Tsim = 200;

% % 
% Prompt(end+1,:) = {['Cargar FEmp'],[],[]};
% Formats(5,2).type = 'text';
% Formats(5,2).type = 'button';
% Formats(5,2).size = [150 40]; % Tamaño
% Formats(5,2).callback = @(~,~,h,k)dataload(h,k);
% % 
% 
% Prompt(end+1,:) = {'Elegir FEmp:','emp',[]};
% Formats(5,3).labelloc = 'leftmiddle';
% Formats(5,3).type = 'list';
% Formats(5,3).style = 'list';
% Formats(5,3).format = 'text'; % Answer will give value shown in items, disable to get integer
% Formats(5,3).items = {'SC','No hay nada cargado'};
% Formats(5,3).limits = [1 1]; % multi-select
% Formats(5,3).size =  size_control;
% DefAns.emp = {'No hay nada cargado'};



% Prompt(end+1,:) = {'Selección de métrica:','MetCh',[]};
% Formats(5,3).labelloc = 'topcenter';
% Formats(5,3).type = 'list';
% Formats(5,3).style = 'list';
% Formats(5,3).format = 'text'; % Answer will give value shown in items, disable to get integer
% Formats(5,3).items = {'1-SSIM';'Frobenius';'Kolmogorov-Smirnov'};
% Formats(5,3).limits = [1 1]; % multi-select
% Formats(5,3).size =  size_control_short;
% DefAns.MetCh = {'1-SSIM'};





Prompt(end+1,:) = {'Frecuencia inf. de pasabanda', 'BPlb',[]};
Formats(5,5).labelloc = 'topcenter';
Formats(5,5).type = 'edit';
Formats(5,5).format = 'float';
Formats(5,5).size = 80;
Formats(5,5).limits = [0 inf] ;% non-negative decimal number
DefAns.BPlb = 0.04;


Prompt(end+1,:) = {'Frecuencia sup. de pasabanda', 'BPub',[]};
Formats(5,6).labelloc = 'topcenter';
Formats(5,6).type = 'edit';
Formats(5,6).format = 'float';
Formats(5,6).size = 80;
Formats(5,6).limits = [0 inf] ;% non-negative decimal number
DefAns.BPub = 0.07;

Prompt(end+1,:) = {'Enable bandpass filter' 'EnableFilterMode',[]};
Formats(5,7).labelloc = 'topcenter';
Formats(5,7).type = 'check';
DefAns.EnableFilterMode = true;
% 
% Prompt(end+1,:) = {['Opciones centrales al algoritmo genético'],[],[]};
% Formats(6,1).type = 'text';
% Formats(6,1).size = [-1 0];
% Formats(6,1).span = [1 1]; % item is 1 field x 4 fields

Prompt(end+1,:) = {'Sujetos', 'Suj','(# entero)'};
Formats(6,1).labelloc = 'topcenter';
Formats(6,1).type = 'edit';
Formats(6,1).format = 'integer';
Formats(6,1).limits = [1 999999999]; % 9-digits (positive #)
Formats(6,1).size = 80;
Formats(6,1).unitsloc = 'bottomleft';
DefAns.Suj = 15;

Prompt(end+1,:) = {'Forzado', 'Forz','(# entero)'};
Formats(6,2).labelloc = 'topcenter';
Formats(6,2).type = 'edit';
Formats(6,2).format = 'integer';
Formats(6,2).limits = [1 999999999]; % 9-digits (positive #)
Formats(6,2).size = 80;
Formats(6,2).unitsloc = 'bottomleft';
DefAns.Forz = 10;


Prompt(end+1,:) = {'Nodos Homotopicos', 'Nodes','(# entero)'};
Formats(6,3).labelloc = 'topcenter';
Formats(6,3).type = 'edit';
Formats(6,3).format = 'integer';
Formats(6,3).limits = [1 999999999]; % 9-digits (positive #)
Formats(6,3).size = 80;
Formats(6,3).unitsloc = 'bottomleft';
DefAns.Nodes = 45;


Prompt(end+1,:) = {'Cantidad de simulaciones', 'Repe','(# entero)'};
Formats(6,4).labelloc = 'topcenter';
Formats(6,4).type = 'edit';
Formats(6,4).format = 'integer';
Formats(6,4).limits = [1 999999999]; % 9-digits (positive #)
Formats(6,4).size = 50;
Formats(6,4).unitsloc = 'bottomleft';
DefAns.Repe = 100;




Prompt(end+1,:) = {'Enable parallel processing' 'EnableParallelMode',[]};
Formats(6,5).labelloc = 'topcenter';
Formats(6,5).type = 'check';
DefAns.EnableParallelMode = true;


Prompt(end+1,:) = {'Enable vectorized fitness function' 'EnableVectorizeMode',[]};
Formats(6,6).labelloc = 'topcenter';
Formats(6,6).type = 'check';
DefAns.EnableVectorizeMode = true;

%%
if exist('Answer0')
    
    DefAns=Answer0;
    %Necesito agregarle las listas a los items
    Formats(2,3).items = who( matfile( DefAns.TSDir ) );
    Formats(3,3).items = who( matfile( DefAns.SCDir ) );
    load(DefAns.GroupDir,'grouping')
    Formats(4,3).items = grouping.labels ;
    clear grouping
    
end

[Answer,Cancelled] = inputsdlg(Prompt,Title,Formats,DefAns,Options);

Answer0=Answer;




        
    


