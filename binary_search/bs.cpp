#include <bits/stdc++.h>
using namespace std;

#define INF 1000000000
#define MOD 1000000007

typedef long long ll;

typedef vector<ll> vll;

int binary_search(vector<int> &a, int key){
    int n = a.size();
    int l = 0, r=n-1,ans=-1;
    while(l<=r){
        int mid = (l+r)/2;
        if(a[mid]==key) return ans=mid;
        else if(a[mid]<key){
            l = mid+1;
        }
        else{
            r = mid-1;
        }
    }
    return ans;
}

int main(){
    int n;
    cin>>n;
    vector<int> a(n);
    cout<<"Enter the elements of the array (sorted): "<<endl;
    for(int i=0;i<n;i++){
        cin>>a[i];
    }
    int q;
    cout<<"Enter the element to be searched : "<<endl;
    cin>>q;
    int ans = binary_search(a,q);
    if(ans==-1){
        cout<<"Element not found"<<endl;
    }
    else{
        cout<<"Element found at index : "<<ans<<endl;
    }

    
    return 0;
}