#include <math.h>
#include <cstdio>
#include "glm/glm.hpp"
#include "glm/gtc/quaternion.hpp"

enum {
    FORWARD,
    BACKWARD,
    LEFT,
    RIGHT,
    UP,
    DOWN
};

class Camera{
private:
    glm::vec3 position;

    glm::vec3 direction;
    glm::vec3 right_axis;
    glm::vec3 up_axis;

    glm::quat tracker;
    
    glm::vec3 plane_x;
    glm::vec3 plane_y;

    float sensitivity;
public:
    Camera(glm::vec3 pos, glm::vec3 dir);
    void move(int);
    void turn(int, float);
    void mouseMotion(int, int);
    void update();

    glm::vec3 hamilton(glm::quat q, glm::vec3 v);

    // getters
    glm::vec3 getPosition();
    glm::vec3 getDirection();
    glm::vec3 getUpAxis();
    glm::vec3 getRightAxis();
};

