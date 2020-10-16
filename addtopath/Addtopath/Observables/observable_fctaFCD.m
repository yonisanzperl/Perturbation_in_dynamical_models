function FCD=observable_fctaFCD(tseries_cell)


    for i=1:length(tseries_cell)

       FC=observable_FC(tseries_cell{i});
       fc_tril(i,:)=squareform(tril(FC,-1));
       
    end

FCD=corrcoef(fc_tril');

end
