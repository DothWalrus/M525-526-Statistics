a = [-1 2 3 12];
b = [1 -2 3 23];

a(a<0 | b<0) = 0
b(b<0 | a<=0) = 0

a_log = logical(a)