
from typing import List

def unbiased_perceptron(features: List[List[int]], weights: List[int], results: List[int]) -> List[int]:
    

    def learning_function(features: List[int], weights: List[int], result: int):
        summ = sum(features[k] * weights[k] for k in range(len(features)))
        if (summ > 0 and result > 0) or (summ < 0 and result < 0):
            return True
        else:
            weights = [weights[k] + result * features[k] for k in range(len(features))]
            return weights



    if len(features[0]) != len(weights):
        print("Wrong array formats")
        return

    check_list = [False] * len(weights)

    while (1):
        i = 0
        for sets, res in zip(features, results):
            learner = learning_function(sets, weights, res)
            if learner == True:
                check_list[i] = True
            else:
                check_list[i] = False
                weights = learner
            i+=1
        res = all(item == True for item in check_list)
        if res == True:
            return weights
    
    


print(unbiased_perceptron([[1,2,4], [1,-2,3], [1,2,1]],[0,0,0],[1,-1,1]))