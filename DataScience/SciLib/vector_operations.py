def integration(x,w,b):
    weighted_sum = sum(x[k] * w[k] for k in xrange(0,len(x)))
    return weighted_sum + b

def magnitude(x):
    return sum(x[k]**2 for k in x)**0.5