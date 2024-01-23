function [q, s] = vox2world(i, hdr)

i = i(:);
i = i(1:3);
i = i - 1;

% qform
b = hdr.quatern_b
c = hdr.quatern_c
d = hdr.quatern_d
a = sqrt(1 - (b^2 + c^2 + d^2))

r = [a*a+b*b-c*c-d*d, 2*b*c-2*a*d, 2*b*d+2*a*c; ...
  2*b*c+2*a*d, a*a+c*c-b*b-d*d, 2*c*d-2*a*b; ...
	2*b*d-2*a*c, 2*c*d+2*a*b, a*a+d*d-c*c-b*b]

qfac = hdr.pixdim(1)
q = r * [hdr.pixdim(2) * i(1); hdr.pixdim(2) * i(2); qfac * hdr.pixdim(4) * i(3)] + ...
  [hdr.qoffset_x; hdr.qoffset_y; hdr.qoffset_z]

% sform
m = [hdr.srow_x; hdr.srow_y; hdr.srow_z; 0 0 0 1]
s = m * [i; 1]
s = s(1:3)
