function unix_ec(s, echo)

if nargin < 2
  echo = false;
end

if echo
  fprintf('%s\n', s);
end

ec = unix(s);

if ec
  error('Error %d in shell command: %s', ec, s);
end
