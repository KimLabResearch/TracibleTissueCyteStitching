


list_tif_ch2 = dir([dir_out_sub{2}, '\stitched\*\*.tif' ]);
regexp(b,'\d*','Match')





a001 = imadjust(a001);
a002 = imadjust(a002);

optimizer = registration.optimizer.OnePlusOneEvolutionary;
metric = registration.metric.MattesMutualInformation;

metric.UseAllPixels = 0;
metric.NumberOfSpatialSamples = 1000000;

tic; 
tform = imregtform(a001, a002, 'rigid', optimizer, metric);
toc
movingRegistered = imwarp(a001,tform,'OutputView',imref2d(size(a002)));
figure();imshowpair(a002, movingRegistered,'Scaling','joint');





