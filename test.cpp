#include "camera.h"
#include <cstdio>
using namespace std;

int main(){
    glm::vec3 cam_pos = glm::vec3(0.0f, 0.0f, 5.0f);
    glm::vec3 cam_dir = glm::vec3(0.0f, 0.0f, -1.0f);
    Camera camera(cam_pos, cam_dir);
    glm::quat q(0.71f, 0.0f, 0.71f, 0.0f);
    glm::vec3 v(0.0f, 0.0f, -1.0f);
    v = camera.hamilton(q,v);
    printf("%f %f %f\n", v.x, v.y, v.z);
    glm::quat Q(1.0f, 0.0f, 0.0f, 0.0f);
    Q = q*Q;
    printf("%f %f %f %f\n", Q.w, Q.x, Q.y, Q.z);
}

/*
g++ -c test.cpp
g++ test.o camera.o -lSDL2 -lGL -lGLEW
*/