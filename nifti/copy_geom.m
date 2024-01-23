function copy_geom(fromfname, tofname)

fromhdr = read_nifti_hdr(fromfname);

if strcmp(tofname(end - 2:end), '.gz')
  zipped = true;
  [tohdr, toimg] = read_nifti(tofname);
else
  zipped = false;
  tohdr = read_nifti_hdr(tofname);
end

todim = tohdr.dim;

fields_to_copy = {'dim', 'pixdim', 'xyzt_units', 'qform_code', 'sform_code', ...
    'quatern_b', 'quatern_c', 'quatern_d', 'qoffset_x', 'qoffset_y', 'qoffset_z', ...
    'srow_x', 'srow_y', 'srow_z', 'magic', 'originator', 'origin'};

for i = 1:numel(fields_to_copy)
    tohdr.(fields_to_copy{i}) = fromhdr.(fields_to_copy{i});
end

tohdr.dim(1) = todim(1);
tohdr.dim(5) = todim(5);

if zipped
  write_nifti(tohdr, toimg, tofname);
else
  write_nifti_hdr(tohdr, tofname);
end
