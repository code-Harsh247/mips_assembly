#include <bits/stdc++.h>
using namespace std;

#define INF 1000000000
#define MOD 1000000007

typedef long long ll;

typedef vector<ll> vll;

void bubbleSort(vector<int> &a, int n)
{
    for(int i=0;i<n;i++){
        bool swapped = false;
        for(int j=0;j<n-i-1;j++){
            if(a[j]>a[j+1]){
                swap(a[j],a[j+1]);
                swapped = true;
            }
        }
        if(!swapped) break;
    }
}

void printArr(vector<int> &a, int n){
    for(int i=0;i<n;i++){
        cout<<a[i]<<" ";
    }
    cout<<endl;
}

int main(){
    int n;
    cout<<"Enter number of elements in the array : ";
    cin>>n;
    vector<int> a(n);
    for(int i=0;i<n;i++){
        cin>>a[i];
    }
    bubbleSort(a,n);
    printArr(a,n);
    return 0;
}