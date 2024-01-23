function nifti_to_3dnifti(infname, outfname)

[hdr, img] = read_nifti(infname);
ahdr = hdr;
ahdr.dim(1) = 3;
ahdr.dim(5) = 0;
for i = 1:hdr.dim(5)
  write_nifti(ahdr, img(:, :, :, i), sprintf('%s%03d.nii', outfname, i));
end
