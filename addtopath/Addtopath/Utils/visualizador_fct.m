function visualizador_fct(varargin)

n_all=nargin;

    if iscell(varargin{1})

        for i=1:length(varargin{1})

            for k=1:nargin

                fc=varargin{k};
                fc=fc{i};
                
                subplot(n_all,2,2*k-1);
                imagesc(fc,[0 1]);
                
                subplot(n_all,2,2*k)
                histogram(squareform(tril(fc,-1)))

            end
            pause(1)
            drawnow
            suptitle(strcat(num2str(i) , '/' , num2str(length(varargin{1}))));
            

        end

    else 
        for i=1:size(varargin{1},3)

            for k=1:nargin

                fc=varargin{k}(:,:,i);
                
                subplot(n_all,2,2*k-1);
                imagesc(fc,[0 1]);
                
                subplot(n_all,2,2*k)
                histogram(squareform(tril(fc,-1)))


            end
            pause(1)
            drawnow
            suptitle(strcat(num2str(i) , '/' , num2str(length(varargin{1}))));
        end
    end

end
