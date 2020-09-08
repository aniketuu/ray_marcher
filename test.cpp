#include <iostream>
#include <string>
using namespace std;

#define SHADOWS_ENABLED         false

int main(){
    #if SHADOWS_ENABLED
        printf("YOOO\n");
    #endif
}

/*./
g++ -c test.cpp
g++ test.o camera.o -lSDL2 -lGL -lGLEW
*/