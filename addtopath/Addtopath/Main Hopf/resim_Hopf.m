function xs=resim_Hopf(new_a,new_G,SC,TRsec,nNodes,long_Total,w,val,Gmethod)

xs=zeros(nNodes,long_Total);


    if Gmethod==1

        [xs,~]=simulAGint(new_a,new_G,SC,long_Total,w,TRsec,val);

    elseif Gmethod==2

        [xs,~]=simulAG(new_a,new_G,SC,long_Total,w,TRsec,val);

    end %filtrado propio
    
end

