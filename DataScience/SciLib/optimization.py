
def gradient_descent(point, step_size, threshold, f):
    value = f(point)
    new_point = point - step_size * gradient(point)
    new_value = f(new_point)
    if abs(new_value - value) < threshold:
        return value
    return gradient_descent(new_point, step_size, threshold, f)
