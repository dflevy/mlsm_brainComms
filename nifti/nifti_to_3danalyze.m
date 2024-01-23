function nifti_to_3danalyze(infname, outfname)

[hdr, img] = read_nifti(infname);
ahdr = make_nifti_hdr(hdr.datatype, hdr.dim(2:4), hdr.pixdim(2:4));
for i = 1:hdr.dim(5)
  write_nifti(ahdr, img(:, :, :, i), sprintf('%s%03d.img', outfname, i));
end
