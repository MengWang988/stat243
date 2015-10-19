# Stat243 PS5
# Meng Wang, SID:21706745
# Oct 18, 2015

import numpy as np

####### Problem 1(c) ###########
vec = np.array([1e-16]*(10001))
vec[0] = 1.0
print "========== 1c ============="
print '%.20f' % np.sum(vec)

####### Problem 1(d) ###########
# use for loop, but add 1 at the beginning
d1_sum = 0.0
d1_sum = d1_sum + 1.0
for i in range(10000):
	d1_sum = d1_sum + 1e-16
print "========== 1d ============="
print "====== Add 1 first ====="
print '%.20f' % d1_sum

# use for loop, add 1 at the end
d2_sum = 0.0
for i in range(10000):
        d2_sum = d2_sum + 1e-16
d2_sum = d2_sum + 1.0
print "====== Add 1 last ====="
print '%.20f' % d2_sum



