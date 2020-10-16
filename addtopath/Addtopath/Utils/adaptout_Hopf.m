function [name_out, path]=adaptout_Hopf(varargin)

if nargin==0
    [file,path] = uigetfile
    cd(path)
   
else
    ruta = varargin{1};
    d=split(ruta,'\');
    path = join(d(1:end-1),'\');
    path = strcat(path,'\');
    file = d(end);
    file = file{1};
    cd(path{1});
    
end

 load(file);

if exist('Several')
    SUBJ_max=Several.size;
else
    SUBJ_max=1;
end

for SUBJ=1:SUBJ_max

    
    if exist('FC_emp') && exist('xs')  && ~exist('FEmp')

        fprintf('Este es un output de epoca tesis probablemente\n');

        SC_best=SC;
        FEmp_best=FC_emp;
        
        out_best=out;

        [fval_best,ind_best]=min([out_best.fval]);
        FSim_best=FC_master(:,:,ind_best);
        ssimfinal_best=out_best(ind_best).ssimfinal;
        frobfinal_best=out_best(ind_best).frobfinal;
        solution_best=out_best(ind_best).solution;
        Rta_best=Rta(:,ind_best);
        RtG_best=RtG(:,ind_best);

        if exist('dt')
            fprintf('se encontró dt\n')
            dt_best=dt;
        else
            fprintf('No se encontró dt, ingresarlo\n')
            dt_best=input('Inserte dt (usualmente 0.1)\n');
        end

        if exist('TRsec')
            fprintf('se encontro la TR\n')
            TRsec_best=TRsec
        else
            fprintf('No se encontró la TR\n')
            TRsec_best=input('Inserte TRsec (usualmente 2)\n');
        end

        if exist('omega')
            fprintf('se encontró frecuencias\n');
            w_best=omega;
        else
            fprintf('No se encontró frecuencias, insertar a mano como "w_best=..."\n');
        end

        %para la posteridad parcheo todo
        TSim_best=size(xs,2);
        val_best=resamplingID(TSim_best,TRsec_best,dt_best);

        %tienen que ser 15 variables





    elseif ~iscell(FEmp)

        fprintf('Este es un output de versiones pre-sujeto individual (época review)');

        out_best=out;
        
        SC_best=SC;
        FEmp_best=FEmp;

        [fval_best,ind_best]=min([out_best(:).fval]);
        FSim_best=out_best(ind_best).FSim;
        ssimfinal_best=out_best(ind_best).fullmetric(1);
        frobfinal_best=out_best(ind_best).fullmetric(2);
        solution_best=out_best(ind_best).solution;
        Rta_best=out_best(ind_best).Rta;
        RtG_best=out_best(ind_best).RtG;
        dt_best=Hopf.dt;
        TRsec_best=Cfg.filt.TRsec;
        w_best=Hopf.w;
        TSim_best=size(out_best(ind_best).xs,2);
        val_best=resamplingID(TSim_best,TRsec_best,dt_best);





    elseif iscell(FEmp)


        fprintf('Este es un archivo de output de época multiples subjects\n')

        out_best=out(:,SUBJ);
            
        SC_best=SC_cell{SUBJ};
        FEmp_best=FEmp_cell{SUBJ};
        
        

        [fval_best,ind_best]=min([out_best(:).fval]);
        FSim_best=out_best(ind_best).FSim;
        ssimfinal_best=out_best(ind_best).fullmetric(1);
        frobfinal_best=out_best(ind_best).fullmetric(2);
        solution_best=out_best(ind_best).solution;
        Rta_best=out_best(ind_best).Rta;
        RtG_best=out_best(ind_best).RtG;
        dt_best=Hopf.dt;
        TRsec_best=Cfg.filt.TRsec;
        w_best=Hopf.w{SUBJ};
        TSim_best=size(out_best(ind_best).xs,2);
        val_best=resamplingID(TSim_best,TRsec_best,dt_best);
        
    end
    name_out = strcat('adapt_',file(1:end-3),'_sujeto',num2str(SUBJ),'.mat');
    save(strcat('adapt_',file(1:end-3),'_sujeto',num2str(SUBJ),'.mat'),'SC_best','FEmp_best','fval_best','ind_best','FSim_best','ssimfinal_best','frobfinal_best','solution_best','Rta_best','RtG_best', 'dt_best','TRsec_best','w_best','TSim_best','val_best');

end