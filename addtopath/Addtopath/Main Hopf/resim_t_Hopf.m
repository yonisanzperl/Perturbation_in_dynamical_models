function xs=resim_t_Hopf(new_a,new_G,SC,TRsec,nNodes,long_Total,w,val,Gmethod)

    initial=0;

    for rfcd=1:size(new_a,2)
        
        fprintf(' -  %i ',rfcd);
        
        [xs_temp,initial]=simulAGint_conc(new_a(:,rfcd),new_G(:,rfcd),SC,long_Total,w,TRsec,val,initial);
        
        xs{rfcd}=xs_temp;
        
    end
    fprintf('\n');

end %filtrado propio

    