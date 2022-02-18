function autoupload(Batch_stitching_folder, Shrinking_folder, auto_uploaded)



auto_uploaded_st = [auto_uploaded '\stitched'];
auto_uploaded_shrink = [auto_uploaded '\shrinked'];

copyfile(Batch_stitching_folder, auto_uploaded_st);
copyfile(Shrinking_folder, auto_uploaded_shrink);

