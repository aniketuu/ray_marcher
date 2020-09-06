#include <iostream>
#include <string>
using namespace std;

int main(){
    string a = "hey there how are ya can you see nwe; lineand tabs";
    string b = "YAa";
    string c = "ya";
    a.replace(a.find("ya"), 2, b);
    cout<<a;
}

/*./
g++ -c test.cpp
g++ test.o camera.o -lSDL2 -lGL -lGLEW
*/