#include <bits/stdc++.h>
using namespace std;

void mengerFold(float x, float y, float z){
    float a = min(x - y, 0.0f);
    x -= a;
    y += a;
    a = min(x-z, 0.0f);
    x -= a;
    z += a;
    a = min(y - z, 0.0f);
    y -= a;
    z += a;

    printf("%f %f %f\n",x,y,z);
}


int main(){
    // input
    float x,y,z;
    scanf("%f %f %f", &x, &y, &z);
    mengerFold(x,y,z);
}

/*./
g++ -c test.cpp
g++ test.o camera.o -lSDL2 -lGL -lGLEW
*/