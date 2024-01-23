function unix_ldec(s, echo)

if nargin < 2
  echo = false;
end

if echo
  fprintf('%s\n', s);
end

ec = unix(['LD_LIBRARY_PATH=$MY_LD_LIBRARY_PATH ; ' s]);

if ec
  error('Error %d in shell command: %s', ec, s);
end
