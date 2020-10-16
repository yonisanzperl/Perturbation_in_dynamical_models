function ks2stat=metrica_KS(FSim,FEmp)


[~,~,ks2stat]=kstest2(squareform(tril(FSim,-1)),squareform(tril(FEmp,-1)));

end