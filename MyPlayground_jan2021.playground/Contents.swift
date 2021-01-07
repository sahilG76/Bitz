import UIKit

func fibonacci(n: Int) {
    //Write your code here.
    var fib = Array(repeating: 0, count: n)
    fib[0] = 0
    fib[1] = 1
    for k in 2...n {
        fib[k] = fib[k-1] + fib[k-2]
    }
    var sol = "["
    for elt in fib {
        sol += "\(elt), "
    }
    sol.remove(at: sol.index(before: sol.endIndex))
    sol += ("]")
    print(sol)
}
    
fibonacci(n: 5)
