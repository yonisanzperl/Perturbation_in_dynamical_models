%Saca el vector de W de cada nodo segun la FC_emp de entrada
%entre .04 TO .07 Hz
function w = saca_w(tseries,nSubs, Tmax, TRsec) 
%TRABAJO INCOMPLETO, TODAVIA HAY COSAS HARDCODEADAS ACA
%IGN:este sería el comentario de ignacio

nNodes = size(tseries{1},1);
si = 1:nSubs;
ts = zeros(nNodes, Tmax, nSubs);

%IGN:aca itera la celda y deposita todo en la matriz ts(nodos, tiempo,
%sujeto)
for i = 1:nSubs
    ts(:,:,i) = tseries{si(i)}(:,1:Tmax);
end
%IGN: aca esta la hardcodeada de filtrado (0.04 0.07)
TT=Tmax;
Ts = TT*TRsec;
freq = (0:TT/2-1)/Ts;
[~, idxMinFreq] = min(abs(freq-0.04));
[~, idxMaxFreq] = min(abs(freq-0.07));
nFreqs = length(freq);

delt = Ts;                                   % sampling interval
fnq = 1/(2*TRsec);                           % Nyquist frequency
k = 2;                                      % 2nd order butterworth filter

%WIDE BANDPASS
flp = .04;                                  % lowpass frequency of filter
fhi = fnq-0.001;%.249;                      % highpass needs to be limited by Nyquist frequency, which in turn depends on TR
Wn = [flp/fnq fhi/fnq];                     % butterworth bandpass non-dimensional frequency
[bfilt_wide, afilt_wide] = butter(k,Wn);    % construct the filter

%IGN: este es el filtro que usa para sacar las frecuencias (lo otro quedo
%inutil si solo se quiere las frecuencias)
%NARROW LOW BANDPASS
flp = .04;                                  % lowpass frequency of filter
fhi = .07;                                  % highpass
Wn=[flp/fnq fhi/fnq];                       % butterworth bandpass non-dimensional frequency
[bfilt_narrow,afilt_narrow] = butter(k,Wn); % construct the filter


PowSpect_filt_narrow = zeros(nFreqs, nNodes, nSubs);
PowSpect_filt_wide = zeros(nFreqs, nNodes, nSubs);

%IGN: en este paso filtra y saca el power spectrum usando fft
for seed=1:nNodes
    
    for idxSub=1:nSubs
        signaldata = ts(:,:,idxSub);
        x=detrend(demean(signaldata(seed,:)));
        
        ts_filt_narrow =zscore(filtfilt(bfilt_narrow,afilt_narrow,x));
        pw_filt_narrow = abs(fft(ts_filt_narrow));
        PowSpect_filt_narrow(:,seed,idxSub) = pw_filt_narrow(1:floor(TT/2)).^2/(TT/2);
        
        ts_filt_wide =zscore(filtfilt(bfilt_wide,afilt_wide,x));
        pw_filt_wide = abs(fft(ts_filt_wide));
        PowSpect_filt_wide(:,seed,idxSub) = pw_filt_wide(1:floor(TT/2)).^2/(TT/2);
    end
    
end

%IGN:hace la media sobre sujetos de esos power spectrums
Power_Areas_filt_narrow_unsmoothed = mean(PowSpect_filt_narrow,3);
Power_Areas_filt_wide_unsmoothed = mean(PowSpect_filt_wide,3);
Power_Areas_filt_narrow_smoothed = zeros(nFreqs, nNodes);
Power_Areas_filt_wide_smoothed = zeros(nFreqs, nNodes);
vsig = zeros(1, nNodes);

%IGN: aca recorre los nodos y los smootea con una función custom de ellos
%de filtro gausiano.
for seed=1:nNodes
    Power_Areas_filt_narrow_smoothed(:,seed)=gaussfilt(freq,Power_Areas_filt_narrow_unsmoothed(:,seed)',0.01);
    Power_Areas_filt_wide_smoothed(:,seed)=gaussfilt(freq,Power_Areas_filt_wide_unsmoothed(:,seed)',0.01);
    %relative power in frequencies of interest (.04 - .07 Hz) with respect
    %to entire power of bandpass-filtered data (.04 - just_below_nyquist)
    %IGN:el vsig no lo usa
    vsig(seed) =...
        sum(Power_Areas_filt_wide_smoothed(idxMinFreq:idxMaxFreq,seed))/sum(Power_Areas_filt_wide_smoothed(:,seed));
end
%IGN:esto quedo tambien colgado
vmax=max(vsig); %consider computing this later where needed
vmin=min(vsig);%consider computing this later where needed

%IGN:aca saca los maximos.
%a-minimization seems to only work if we use the indices for frequency of
%maximal power from the narrowband-smoothed data
[~, idxFreqOfMaxPwr]=max(Power_Areas_filt_narrow_smoothed);
f_diff = freq(idxFreqOfMaxPwr);

%FOR EACH AREA AND TIMEPOINT COMPUTE THE INSTANTANEOUS PHASE IN THE RANGE
%OF .04 TO .07 Hz
%IGN:esto tambien es al pedo.
PhasesD = zeros(nNodes, Tmax, nSubs);
for idxSub = 1:nSubs
    signaldata=ts(:,:,idxSub);
    for seed=1:nNodes
        x = demean(detrend(signaldata(seed,:)));
        xFilt = filtfilt(bfilt_narrow,afilt_narrow,x);    % zero phase filter the data
        Xanalytic = hilbert(demean(xFilt));
        PhasesD(seed,:,idxSub) = angle(Xanalytic);
    end 
end

%f_diff  previously computed frequency with maximal power (of narrowly filtered data) by area
omega = repmat(2*pi*f_diff',1,2); %angular velocity
omega(:,1) = -omega(:,1);
w = omega;






