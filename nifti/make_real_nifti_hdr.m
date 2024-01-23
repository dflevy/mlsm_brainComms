function h = make_real_nifti_hdr(dim, pixdim, datatype)

% MAKE_NIFTI_HEADER  Create a new NIFTI header structure
%
% H = MAKE_NIFTI_HDR(DIM, PIXDIM, DATATYPE)


h.sizeof_hdr = 348;
h.data_type = '';
h.db_name = '';
h.extents = 0;
h.session_error = 0;
h.regular = 0;
h.dim_info = 0;

if length(dim) > 7
  error('Too many dimensions');
end
h.dim = zeros(1, 8);
h.dim(1) = length(dim);
h.dim(2:(length(dim) + 1)) = dim;

h.intent_p1 = 0;
h.intent_p2 = 0;
h.intent_p3 = 0;
h.intent_code = 0;

if ischar(datatype)
  switch datatype
    case {'DT_UNSIGNED_CHAR', 'uchar'}
      h.datatype = 2;
      h.bitpix = 8;
    case {'DT_SIGNED_SHORT', 'int16'}
      h.datatype = 4;
      h.bitpix = 16;
    case {'DT_SIGNED_INT', 'int32'}
      h.datatype = 8;
      h.bitpix = 32;
    case {'DT_FLOAT', 'float32'}
      h.datatype = 16;
      h.bitpix = 32;
    otherwise
      error('Unsupported datatype');
  end
elseif length(datatype) == 1
  h.datatype = datatype;
  switch datatype
    case 2 % DT_UNSIGNED_CHAR
      h.bitpix = 8;
    case 4 % DT_SIGNED_SHORT
      h.bitpix = 16;
    case 8 % DT_SIGNED_INT
      h.bitpix = 32;
    case 16 % DT_FLOAT
      h.bitpix = 32;
    otherwise
      error('Bitpix unknown for this datatype');
  end
elseif length(datatype) == 2
  h.datatype = datatype(1);
  h.bitpix = datatype(2);
  warning('Inserting datatype and bitpix without checking validity');
end

if length(pixdim) > 7
  error('Too many dimensions');
end
h.pixdim = zeros(1, 8);
h.pixdim(1) = -1;
h.pixdim(2:(length(pixdim) + 1)) = pixdim;

h.slice_start = 0;
h.slice_end = 0;
h.slice_code = 0;
h.xyzt_units = 0; % would be easy to set this to mm and sec
h.slice_duration = 0;
h.toffset = 0;
    
h.vox_offset = 352;
h.scl_slope = 1;
h.scl_inter = 0;
h.cal_max = 0;
h.cal_min = 0;
h.glmax = 0;
h.glmin = 0;

h.descrip = '';
h.aux_file = '';
h.intent_name = '';

h.qform_code = 1;
h.sform_code = 1;
h.quatern_b = 0;
h.quatern_c = 1;
h.quatern_d = 0;
h.qoffset_x = pixdim(1) *(dim(1) - 1) / 2;
h.qoffset_y = -pixdim(2) *(dim(2) - 1) / 2;
h.qoffset_z = -pixdim(3) * (dim(3) - 1) / 2;
h.srow_x = [-pixdim(1) 0 0 h.qoffset_x];
h.srow_y = [0 pixdim(2) 0 h.qoffset_y];
h.srow_z = [0 0 pixdim(3) h.qoffset_z];
h.magic = 'n+1 ';
h.magic(4) = 0;
