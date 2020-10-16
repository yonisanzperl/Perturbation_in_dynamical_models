function [out] = opt_genetic(fx_opt,Cfg)
             
%shuffleado de la semilla de los numeros random
rng(Cfg.randseed);

if Cfg.ga.verbose==1   
        
        opts = optimoptions('ga','PlotFcn',{@gaplotbestf,@gaplotstopping,@gaplotbestindiv,@gaplotgenealogy},'Display','off','UseParallel', true, 'UseVectorized', false);
        
else
        
        opts = optimoptions('ga','PlotFcn',{@gaplotbestf,@gaplotstopping,@gaplotbestindiv,@gaplotgenealogy},'Display','off');
        
end

    %opts = optimoptions('ga','MutationFcn', {@mutationuniform, 0.01});
    
    opts.PopulationSize = Cfg.ga.pob;
    opts.MaxGenerations = Cfg.ga.gens;
   

    
    if Cfg.ga.parallel==1
        
        opts.UseParallel = true;
        
    else
        
        opts.UseParallel = false;
        
    end
    
    if Cfg.ga.vect==1
        
        opts.UseVectorized=true;
        
    else
        
        opts.UseVectorized = false;
        
    end
    
%opts.InitialPopulationRange = [-0.4;0.4];
%options = optimoptions('ga','MutationFcn', {@mutationuniform, rate})

%% OPTIMIZACIÓN
            
[out.solution,out.fval,out.exitflag,out.output,out.population,out.scores] = ga(fx_opt,Cfg.ga.dimx,[],[],[],[],Cfg.ga.lb,Cfg.ga.ub,[],opts);
%[out.solution,out.fval,out.exitflag,out.output,out.population,out.scores] = ga(fx_opt,Cfg.ga.dimx,[],[],[],[],[],[],[],opts);

end


