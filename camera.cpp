#include "camera.h"

Camera::Camera(glm::vec3 pos, glm::vec3 dir){
    this->position = pos;
    this->direction = dir;

    this->up_axis = glm::vec3(0.0f, 1.0f, 0.0f);
    this->right_axis = glm::cross(this->direction, this->up_axis);

    this->sensitivity = 0.015;

    this->roll = 0.0f;

    this->properties = "";
    this->loadProperties();

    // rig
    this->move_enum = NONE;
    this->rot_enum = NONE;
    this->rot_count_x = 0.0f;
    this->rot_count_y = 0.0f;
    this->rot_count_z = 0.0f;
}

void Camera::move(int enm){
    switch(enm){
        case FORWARD:
            this->position += this->direction * this->sensitivity;
            break;
        case BACKWARD:
            this->position -= this->direction * this->sensitivity;
            break;
        case RIGHT:
            this->position += this->right_axis * this->sensitivity;
            break;
        case LEFT:
            this->position -= this->right_axis * this->sensitivity;
            break;
        case UP:
            this->position += this->up_axis * this->sensitivity;
            break;
        case DOWN:
            this->position -= this->up_axis * this->sensitivity;
            break;
        default:
            break;
    }
}

void Camera::turn(int enm, float angle){
    glm::quat action;
    switch(enm){
        case FORWARD:
            action = glm::angleAxis(glm::radians(angle), this->right_axis);
            this->rot_count_x += angle;
            if(this->rot_count_x >= 90.0f){
                this->rot_count_x = 0.0f;
                this->rot_enum = NONE;
            }
            this->update(action);
            break;
        case BACKWARD:
            action = glm::angleAxis(glm::radians(-angle), this->right_axis);
            if(this->rot_count_x > 0.0f){
                this->rot_count_x = this->rot_count_x - 90.0f;
            }
            this->rot_count_x -= angle;
            if(this->rot_count_x <= -90.0f){
                this->rot_count_x = 0.0f;
                this->rot_enum = NONE;
            }
            this->update(action);
            break;
        case LEFT:
            action = glm::angleAxis(glm::radians(angle), this->up_axis);
            this->rot_count_y += angle;
            if(this->rot_count_y >= 90.0f){
                this->rot_count_y = 0.0f;
                this->rot_enum = NONE;
            }
            this->update(action);
            break;
        case RIGHT:
            action = glm::angleAxis(glm::radians(-angle), this->up_axis);
            if(this->rot_count_y > 0.0f){
                this->rot_count_y = this->rot_count_y - 90.0f;
            }
            this->rot_count_y -= angle;
            if(this->rot_count_y <= -90.0f){
                this->rot_count_y = 0.0f;
                this->rot_enum = NONE;
            }
            this->update(action);
            break;
        case UP:
            action = glm::angleAxis(glm::radians(angle), this->direction);
            this->rot_count_z += angle;
            if(this->rot_count_z >= 360.0f){
                this->rot_count_z = 0.0f;
                this->rot_enum = NONE;
            }
            this->update(action);
            break;
        case DOWN:
            action = glm::angleAxis(glm::radians(-angle), this->direction);
            if(this->rot_count_z > 0.0f){
                this->rot_count_z = this->rot_count_z - 360.0f;
            }
            this->rot_count_z -= angle;
            if(this->rot_count_z <= -360.0f){
                this->rot_count_z = 0.0f;
                this->rot_enum = NONE;
            }
            this->update(action);
            break;
        default:
            break;
    }
    
}

void Camera::mouseMotion(int x_pos, int y_pos){
    this->turn(RIGHT, (float)x_pos*this->sensitivity);
    this->turn(BACKWARD, (float)y_pos*this->sensitivity);
}

glm::vec3 Camera::hamilton(glm::quat q, glm::vec3 v){
    glm::quat p(0.0f, v.x, v.y, v.z);
    glm::quat q_inv(q.w, -q.x, -q.y, -q.z);
    p = q*p*q_inv;
    return glm::normalize(glm::vec3(p.x, p.y, p.z));
}

void Camera::update(glm::quat action){
    this->direction = this->hamilton(action, this->direction);
    this->up_axis = this->hamilton(action, this->up_axis);
    this->right_axis = glm::cross(this->direction, this->up_axis);
}

glm::vec3 Camera::getPosition(){
    return this->position;
}

glm::vec3 Camera::getDirection(){
    return this->direction;
}

glm::vec3 Camera::getUpAxis(){
    return this->up_axis;
}

glm::vec3 Camera::getRightAxis(){
    return this->right_axis;
}

// utils
void Camera::loadProperties(){
    this->properties += "const int MAX_STEPS = 200;\n";
    this->properties += "const float START = 0.001;\n";
    this->properties += "const float MAX_DIST = 100.0;\n";
    this->properties += "const float EPSILON = 0.001;\n";
    this->properties += "const float sensor_dist = 2.5;\n";
}

std::string Camera::getProperties(){
    return this->properties;
}

void Camera::printDetails(){
    //printf("%f %f %f\n", this->position.x, this->position.y, this->position.z);
    //printf("%f %f %f\n", this->direction.x, this->direction.y, this->direction.z);
    //printf("%f\n\n", this->roll);
    printf("%f %f %f\n", this->rot_count_x, this->rot_count_y, this->rot_count_z);
}

// setters
void Camera::setPosition(glm::vec3 pos){
    this->position = pos;
}

// camera movement rigs

void Camera::barellRoll(float inc){
    this->turn(UP, inc);
}


