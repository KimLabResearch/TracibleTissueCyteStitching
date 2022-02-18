function        mergeBackward(dir_out_sub,dir_out_sub_fix)

%dir_out_sub = 'D:\test\test1';
%dir_out_sub_fix = 'D:\test\test2';


list_tif_ch2 = dir([dir_out_sub, '\stitched\ch2\*.tif' ]);
%list_tif_ch2 = dir([dir_out_sub, '\ch2\*.tif' ]);
num_list = zeros(length(list_tif_ch2),1);
for ii  =1:length(list_tif_ch2)
    temp_cell = regexp(list_tif_ch2(ii).name,'\d*','Match');
    num_list(ii) = str2double(temp_cell{1});
end
 [~,a001_serial] = min(num_list);
 
 
list_tif_ch2_fix = dir([dir_out_sub_fix, '\stitched\ch2\*.tif' ]);
%list_tif_ch2_fix = dir([dir_out_sub_fix, '\ch2\*.tif' ]);
num_list_fix = zeros(length(list_tif_ch2_fix),1);
for ii  =1:length(list_tif_ch2_fix)
    temp_cell = regexp(list_tif_ch2_fix(ii).name,'\d*','Match');
    num_list_fix(ii) = str2double(temp_cell{1});
end
 [~,a002_serial] = max(num_list_fix);
 
 
 
a001 = imread([list_tif_ch2(a001_serial).folder, '\', list_tif_ch2(a001_serial).name]);
a002 = imread([list_tif_ch2_fix(a002_serial).folder, '\', list_tif_ch2_fix(a002_serial).name]);



a001 = imadjust(a001);
a002 = imadjust(a002);

optimizer = registration.optimizer.OnePlusOneEvolutionary;
metric = registration.metric.MattesMutualInformation;

optimizer.MaximumIterations = 1000;
metric.UseAllPixels = 0;
metric.NumberOfSpatialSamples = 1000000;

tic; 
tform = imregtform(a001, a002, 'rigid', optimizer, metric);
toc
movingRegistered = imwarp(a001,tform,'OutputView',imref2d(size(a002)));
figure();imshowpair(a002, movingRegistered,'Scaling','joint');



list_tif = dir([dir_out_sub, '\stitched\*\*.tif' ]);
parfor ii = 1:length(list_tif)
    a001 = imread([list_tif(ii).folder, '\', list_tif(ii).name]);
    a001 = imwarp(a001,tform,'OutputView',imref2d(size(a002)));
    imwrite(a001, [list_tif(ii).folder, '\', list_tif(ii).name]);
end

