function nifti_to_analyze(infname, outfname)

[hdr, img] = read_nifti(infname);
ahdr = make_nifti_hdr(hdr.datatype, hdr.dim(2:(hdr.dim(1) + 1)), hdr.pixdim(2:4));
write_nifti(ahdr, img, outfname);
