function [] = all_in_one_hub_function(what_to_do, dir_raw,dir_temp,Channel_and_section_used_to_stitch)

warning on
%%%%%  Please chose the step you want to do %%%%
DownloadRenaming = 0;
Aberation = 0;
Averaging = 0;
Normalization = 0;
Boosting = 0;
Computational_stitching = 0;
Batch_stitching = 0;
Shrinking = 0;
Uploading = 0;

switch what_to_do
    case 'DownloadRenaming'
        DownloadRenaming = 1;
    case 'Aberation'
        Aberation = 1;
    case 'Normalize'
        Normalization  = 1;
    case 'stitching'
        Computational_stitching = 1;
        Batch_stitching = 1;
        Shrinking = 1;

end








purgeFolders = 1;

%%%%   Settings   %%%%
Number_of_cores = 8;
Case_Name = 'p10';
%Channel_and_section_used_to_stitch = [1, 600];
%ch01, section 600 is recommanded for run 2
%ch01, last non-optical section is recommanded for run 1



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%if DownloadRenaming
%dir_raw = uigetdir('Z:\', 'input folder');
%end
%dir_temp = uigetdir('D:\', 'temperary folder');
%if Uploading
%dir_up = uigetdir('Z:\', 'upload folder');
%auto_uploaded = [dir_up '\auto_uploaded'];
%end

DownloadRenaming_folder = [dir_temp '\DownloadRenaming'];
Aberation_folder = [dir_temp '\aberation'];
Averaging_folder = [dir_temp '\averaging'];
Normalized_folder = [dir_temp '\normalized'];
Computational_stitching_folder = [dir_temp '\computational_stitch'];
Batch_stitching_folder = [dir_temp '\stitched'];
Shrinking_folder = [dir_temp '\shrinked'];

if DownloadRenaming
    %mkdir(DownloadRenaming_folder);
    copyfile( dir_raw, DownloadRenaming_folder);
    fprintf('Download and renaming files\n')
    DownloadRenamingFunction( DownloadRenaming_folder);
end

if Aberation
    mkdir(Aberation_folder);
    fprintf('fix aberation\n')
    xy_aberation(DownloadRenaming_folder, Aberation_folder, Number_of_cores);
    if purgeFolders
        rmdir( DownloadRenaming_folder, 's');
    end
end

%if Averaging
%    mkdir(Averaging_folder);
%    fprintf('Averaging\n')
%    xy_averaging(Aberation_folder, Averaging_folder, Number_of_cores);
%end

if Normalization
    mkdir(Normalized_folder);
    xy_ilumination_v2(Aberation_folder, Normalized_folder, Averaging_folder,Number_of_cores);
    if purgeFolders
        rmdir( Aberation_folder, 's');
    end
end

if Computational_stitching
    mkdir(Computational_stitching_folder);
    new_compu_stitch(Normalized_folder, Computational_stitching_folder, Number_of_cores);
end

if Batch_stitching
    mkdir(Batch_stitching_folder);
    fiji_suto_waitbar(Normalized_folder, Computational_stitching_folder, Batch_stitching_folder, Number_of_cores);
    if purgeFolders
        rmdir( Normalized_folder, 's');
    end

end

if Shrinking
    mkdir(Shrinking_folder);
    shrink_image(Batch_stitching_folder, Shrinking_folder, Number_of_cores, Case_Name);
end

%if Uploading
%    mkdir(auto_uploaded);
%    autoupload(Batch_stitching_folder, Shrinking_folder,auto_uploaded);
%end
