
%PRUEBA QUE FALTA : GRAFICAR LOS SMOOTHEADOS, VER QUE PAR. SMOOTHEA IGUAL
%SEGUN SAMPLEO

%PRUEBA QUE FALTA : MULTIPLICAR EL SMOOTHEADO DEL NARROW POR EL NQ Y VER
%COMO QUEDA


function w=saca_w_ign2(data,Ts)


    
    nSubs=length(data);
    nNodes=size(data{1},1);

    

    %data_nq=filtroign(tseries_unfilt,Ts,lb,fhi_nq);
    

    for i=1:nSubs


        xs_temp_filt=data{i};
        %class(xs_temp_filt)

        for j=1:nNodes

       
%         
%         [P1,freq1]=pfreq(xs_temp_filt(j,:),Ts);
%         P1_smooth=smooth(P1,'sgolay');
        
        [P1,freq1] = pwelch(xs_temp_filt(j,:),gausswin(size(xs_temp_filt,2)),size(xs_temp_filt,2)/2,size(xs_temp_filt,2),1/Ts);
        P1_smooth=smooth(P1,'sgolay');
        
        [~,i1]=max(P1);
        M_power_filt(j,i)=freq1(i1);
        
%         figure
%         plot(freq1,P1)
%         hold on
%         %plot(freq1,P1_smooth)
%         
%         plot([freq1(i1) freq1(i1)],[0 70])
        
        

        end    
    end
    
    w=2*pi*mean(M_power_filt,2);
    w=repmat(w,1,2);
    w(:,1)=-w(:,1);
  %  figure
   % plot(linspace(1,nNodes,nNodes),w(:,2)/(2*pi),'LineWidth',3)
   % hold on
    
   % for i=1:nSubs
        
    %     plot(linspace(1,nNodes,nNodes),M_power_filt(:,i))

        
    %end
    
    %drawnow
    %figure
    
end


