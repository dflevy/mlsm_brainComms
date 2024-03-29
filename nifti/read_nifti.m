function [hdr, img] = read_nifti(fname, raw, vol)

% READ_NIFTI  Read NIFTI image
%
% [HDR, IMG] = READ_NIFTI(FNAME, RAW) reads the image FNAME. You need to
% provide the filename of the .nii or .img file. If RAW is TRUE, then the
% datatype of IMG preserves the datatype of the file, and scaling is not
% applied.

if nargin < 2
    raw = false;
end

if nargin < 3
    vol = [];
end
        
[hdr, newfname] = read_nifti_hdr(fname);

switch hdr.datatype
    case 2 % DT_UNSIGNED_CHAR
        precision = 'uchar';
    case 4 % DT_SIGNED_SHORT
        precision = 'int16';
    case 8 % DT_SIGNED_INT
        precision = 'int32';
    case 16 % DT_FLOAT
        precision = 'float32';
    case 64 % DT_DOUBLE
        precision = 'double';
    case 512 % DT_UINT16
        precision = 'uint16';
    otherwise
        error('Unsupported data type; datatype = %d\n', hdr.datatype);
end

if raw % maintain datatype
    precision = ['*' precision];
end

fid = fopen(newfname, 'r', hdr.machineformat);
fseek(fid, hdr.vox_offset, 'bof');
ndims = hdr.dim(1);
if ~isempty(vol)
    fseek(fid, prod(hdr.dim(2:4)) * hdr.bitpix / 8 * (vol - 1), 'bof');
    img = fread(fid, prod(hdr.dim(2:4)), precision);
    hdr.dim(5) = 1;
else
    img = fread(fid, prod(hdr.dim(2:(ndims + 1))), precision);
end
img = reshape(img, hdr.dim(2:(ndims + 1)));

if hdr.scl_slope ~= 0 && ~raw
    img = hdr.scl_inter + hdr.scl_slope * img;
end

fclose(fid);

if ~strcmp(newfname, fname)
  delete(newfname);
end

