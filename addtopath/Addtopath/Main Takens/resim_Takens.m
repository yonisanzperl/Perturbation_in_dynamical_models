function xs=resim_Takens(alpha,beta,new_G,C,nsubs,long_Total,TRsec,Gmethod,val)

nNodes=size(new_G,1);

xs=zeros(nNodes,long_Total);


    if Gmethod==1

        [xs]=simulAGTB(alpha,beta,new_G,C,nsubs,long_Total,TRsec,val);

    elseif Gmethod==2

        [xs]=simulAGTB(alpha,beta,new_G,C,nsubs,long_Total,TRsec,val);

    end %filtrado propio
    
end

