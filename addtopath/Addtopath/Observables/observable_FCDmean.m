function FCD=observable_FCDmean(tseries_cell,twindow,tsupp,TR)

    for i=1:length(tseries_cell)

       FCD(:,:,i)=observable_FCD(tseries_cell{i},twindow,tsupp,TR);

    end

FCD=mean(FCD,3);

end