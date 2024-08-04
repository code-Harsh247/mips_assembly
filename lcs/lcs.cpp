#include <bits/stdc++.h>
using namespace std;

#define INF 1000000000
#define MOD 1000000007

typedef long long ll;

typedef vector<ll> vll;

string lcs(string &s1, string &s2, int i, int j)
{
    if (i < 0 || j < 0)
        return "";
    if (s1[i] == s2[j])
        return lcs(s1, s2, i - 1, j - 1) + s1[i];
    else
    {
        string shift1 = lcs(s1, s2, i - 1, j);
        string shift2 = lcs(s1, s2, i, j - 1);
        if (shift1.size() > shift2.size())
        {
            return shift1;
        }
        else
            return shift2;
    }
}

int main()
{
    string s1, s2;
    cin >> s1 >> s2;
    int n1 = s1.size();
    int n2 = s2.size();
    vector<string>
    cout << "The longest common substring is : " << lcs(s1, s2, n1 - 1, n2 - 1) << endl;
    return 0;
}