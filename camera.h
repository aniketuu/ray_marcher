#include <math.h>
#include <cstdio>
#include <string>
#include "glm/glm.hpp"
#include "glm/gtc/quaternion.hpp"

#define MOVEMENT_FACTOR 1.2f

enum {
    FORWARD,
    BACKWARD,
    LEFT,
    RIGHT,
    UP,
    DOWN,
    NONE
};

class Camera{
private:
    glm::vec3 position;

    glm::vec3 direction;
    glm::vec3 right_axis;
    glm::vec3 up_axis;

    float roll;

    float sensitivity;

    std::string properties;
public:
    float movement_sensitivity;
    float rotation_sensitivity;
    Camera(glm::vec3 pos, glm::vec3 dir);
    void move(int);
    void turn(int, float);
    void mouseMotion(int, int);
    void update(glm::quat);

    glm::vec3 hamilton(glm::quat q, glm::vec3 v);


    // utils
    void printDetails();

    // getters
    glm::vec3 getPosition();
    glm::vec3 getDirection();
    glm::vec3 getUpAxis();
    glm::vec3 getRightAxis();
    std::string getProperties();
    glm::quat getTracker();

    // setters
    void setPosition(glm::vec3 pos);
    void setTracker(glm::quat tra);

    // movement rigs
    int move_enum; // movement
    int rot_enum; // rotation
    float rot_count_x;
    float rot_count_y;
    float rot_count_z;
};

