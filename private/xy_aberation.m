function xy_aberation(DownloadRenaming_folder, Aberation_folder, Number_of_cores)


%dir_in = uigetdir('Z:\', 'input folder');
%dir_out = uigetdir('Z:\', 'output folder');
dir_out = Aberation_folder;
dir_reg = pwd;
file_reg = 'Moving3_direct_transf.txt';
file_jim = 'aberation_ytw.ijm';
%[file_reg,dir_reg] = uigetfile('*transf.txt');Moving3_direct_transf.txt


%copyfile( DownloadRenaming_folder, Aberation_folder);




listk = dir(strcat(DownloadRenaming_folder, '/Z*'));


group_size = 100;
par_partitions = ceil(length(listk)./group_size);
hbar = parfor_progressbar(par_partitions,'Fixing aberation...');  %create the progress bar

for ii = 1:par_partitions
    
    copyfile( file_jim, [dir_out '/' 'aberation' num2str(ii) '.ijm']);
    
    fid = fopen([dir_out '/' 'aberation' num2str(ii) '.ijm'],'r');
    i = 1;
    tline = fgetl(fid);
    A{i} = tline;
    while ischar(tline)
        i = i+1;
        tline = fgetl(fid);
        A{i} = tline;
    end
    fclose(fid);
    
    % Change cell A
    ll = 1;
    start_point = group_size.*(ii-1)+1;
    end_point = group_size.*(ii);
    if end_point > length(listk)
        end_point = length(listk);
    end
    for jj = start_point:end_point
        dirIn = dir([listk(jj).folder '/' listk(jj).name '/*.tif' ]);
        subFolder = [Aberation_folder '/' listk(jj).name];
        mkdir(subFolder);
        for kk = 1:length(dirIn)
            A{ll} = ['open("' dirIn(kk).folder '/' dirIn(kk).name '");'];
            A{ll+1} = ['call("bunwarpj.bUnwarpJ_.loadElasticTransform", "' ...
                dir_reg '/' file_reg '", "' ...
                dirIn(kk).name '", "' ...
                dirIn(kk).name '");'];
            A{ll+2} = ['setMinAndMax(0, 65536);'];
            A{ll+3} = ['run("16-bit");'];
            A{ll+4} = ['makeRectangle(15, 15, 802, 802);'];
            A{ll+5} = ['run("Crop");'];
            A{ll+6} = ['saveAs("Tiff", "' subFolder '/' dirIn(kk).name '");'];
            A{ll+7} = ['close();'];
            
            ll = ll + 8;
            
            
            
            
            
            
        end
    end
    
    for i = 1:numel(A)
        A{i} = strrep(A{i}, '\' ,'/' );
    end
    
    
    
    
    
    
    % Write cell A into txt
    fid = fopen([dir_out '\' 'aberation' num2str(ii) '.ijm'],'w');
    for i = 1:numel(A)
        fprintf(fid,'%s\n', A{i});
    end
    fclose(fid);
    command{ii} = ['D:\Fiji.app\ImageJ-win64 -batch'  ' ' dir_out '\' 'aberation' num2str(ii) '.ijm'];
    clear A
    
end



parfor    (ii=1:par_partitions,Number_of_cores)
    %    [~, ~] = dos( command{ii} );
    dos( command{ii} );
    hbar.iterate(1);
end

close(hbar);
