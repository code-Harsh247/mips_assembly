#include <bits/stdc++.h>
using namespace std;

#define INF 1000000000
#define MOD 1000000007

typedef long long ll;

typedef vector<ll> vll;

int fibo(int n)
{
    if (n == 0) return 0;
    if (n == 1) return 1;
    return fibo(n-1) + fibo(n-2);
}

void print_fibo_sequence(int n)
{
    for (int i = 0; i <= n; i++) {
        cout << fibo(i) << " ";
    }
    cout << endl;
}

int main() {
    int n;
    cin >> n;
    cout << "The " << n << "th Fibonacci number is: " << fibo(n) << endl;
    cout << "Fibonacci sequence up to " << n << "th number: ";
    print_fibo_sequence(n);
    return 0;
}