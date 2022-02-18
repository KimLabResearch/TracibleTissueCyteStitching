function shrinking_func(dir_out, Number_of_cores)

group_size = 100;

for kk = 1:3
    
    dir_out_shrink = [dir_out, '/shrink/ch', num2str(kk), '/'];
    mkdir(dir_out_shrink);
    tif_list = dir([dir_out, '/ch', num2str(kk), '/*.tif']);
    
    par_partitions = ceil(length(tif_list)./group_size);
    hbar = parfor_progressbar(par_partitions,['shrinking ch' num2str(kk)]);  %create the progress bar
    
    for ii = 1:par_partitions
        
        filename = [dir_out_shrink '/shrinking' num2str(ii) '.ijm'];
        
        % Change cell A
        ll = 1;
        start_point = group_size.*(ii-1)+1;
        end_point = group_size.*(ii);
        if end_point > length(tif_list)
            end_point = length(tif_list);
        end
        for jj = start_point:end_point
            A{ll} = ['open("' tif_list(jj).folder '/' tif_list(jj).name '");'];
            A{ll+1} = ['run("Scale...", "x=0.1 y=0.1 interpolation=Bilinear average create");'];
            A{ll+2} = ['saveAs("Tiff", "' dir_out_shrink '/p05_' tif_list(jj).name '");'];
            A{ll+3} = ['close();'];
            A{ll+4} = ['close();'];
            
            ll = ll + 5;
            
        end
        
        for i = 1:numel(A)
            A{i} = strrep(A{i}, '\' ,'/' );
        end
        fid = fopen(filename,'w');
        
        for i = 1:numel(A)
            fprintf(fid,'%s\n', A{i});
        end
        fclose(fid);
        command{ii} = ['D:\Fiji.app\ImageJ-win64 -batch'  ' ' filename];
        
    end
    
    
    
    parfor    (ii=1:par_partitions,Number_of_cores)
        [~, ~] = dos( command{ii} );
        %dos( command{ii} );
        hbar.iterate(1);
    end
    
    
    
    close(hbar);
end

