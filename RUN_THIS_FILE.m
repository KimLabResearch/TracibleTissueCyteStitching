clear

total_Runs = 1;
Number_of_cores = 8;

download_rename_all = 1;
deaberation_all = 1;
average_all = 1;
normalize_all = 1;
Stitching_multi_run = 1;
Warp_all_run = 0;
Merge_into_one_folder = 0;
shrinking_all = 0;





%%% chosing input folder


if download_rename_all
    for ii = 1: total_Runs
        dir_in{ii} = uigetdir('Z:\', ['input folder #' num2str(ii)]);
    end
end

%%% chosing output folder

dir_out = uigetdir('Z:\', 'output folder ' );
for ii = 1: total_Runs
    dir_out_sub{ii} = [dir_out, '\run', num2str(ii), '\'];
end


if download_rename_all
    for ii = 1: total_Runs
        all_in_one_hub_function('DownloadRenaming',dir_in{ii}, dir_out_sub{ii}, 0);
    end
end


if deaberation_all
    for ii = 1: total_Runs
        all_in_one_hub_function('Aberation', 0, dir_out_sub{ii}, 0);
    end
end

if average_all
    
    
    xy_averaging_all(dir_out_sub,Number_of_cores);
    
end


if normalize_all
    
    
    for ii = 1: total_Runs
        all_in_one_hub_function('Normalize', 0, dir_out_sub{ii}, 0);
    end
    
end





if Stitching_multi_run
    for ii = 1: total_Runs
        all_in_one_hub_function('stitching',0, dir_out_sub{ii}, 0);
    end
end





if Warp_all_run
    
    %%% Merging
    
    for ii = 1: total_Runs
        tif_list_First_folder = dir([dir_out_sub{ii}, '\stitched\ch1\*.tif']);
        info{ii} = imfinfo([tif_list_First_folder(1).folder, '\',  tif_list_First_folder(1).name]);
        totalPixels(ii) = info{ii}.Width .* info{ii}.Height;
    end
    
    [~, jj] = max(totalPixels);
    
    if jj ~= 1
        for ii = jj-1:-1:1
            mergeForward(dir_out_sub{ii},dir_out_sub{ii+1});
        end
    end
    
    if jj ~= total_Runs
        for ii = jj+1:1:total_Runs
            mergeBackward(dir_out_sub{ii},dir_out_sub{ii-1});
        end
    end
    
end




if Merge_into_one_folder
    
    merge_all_run(dir_out_sub, dir_out);
    
    
end




if shrinking_all
    
    shrinking_func(dir_out, Number_of_cores);
    
end



