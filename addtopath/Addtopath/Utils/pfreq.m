
function [psdx,freq]=pfreq(x,Ts)

Fs = 1/Ts; 

N = length(x);  % number of samples

freq = 0:Fs/length(x):Fs/2;

%Calculo la fft
Y = fft(x);

%aislo la mitad (por alguna razon la suelta both-sided
Y = Y(1:floor(N/2)+1);
%Calculo el power
psdx = (1/(Fs*N)) * abs(Y).^2;

%hay una corrección (esta no la entiendo, debe ser por convertir a
%one-sided)
psdx(2:end-1) = 2*psdx(2:end-1);



