#include "camera.h"

Camera::Camera(glm::vec3 pos, glm::vec3 dir){
    this->position = pos;
    this->direction = dir;

    this->up_axis = glm::vec3(0.0f, 1.0f, 0.0f);
    this->right_axis = glm::cross(this->direction, this->up_axis);

    this->sensitivity = 0.25;

    this->tracker = glm::quat(1.0, 0.0, 0.0, 0.0);

    
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
            this->tracker = action;
            break;
        case BACKWARD:
            action = glm::angleAxis(glm::radians(-angle), this->right_axis);
            this->tracker = action;
            break;
        case LEFT:
            action = glm::angleAxis(glm::radians(angle), this->up_axis);
            this->tracker = action;
            break;
        case RIGHT:
            action = glm::angleAxis(glm::radians(-angle), this->up_axis);
            this->tracker = action;
            break;
        case UP:
            action = glm::angleAxis(glm::radians(-angle), this->direction);
            this->tracker = action;
            break;
        case DOWN:
            action = glm::angleAxis(glm::radians(-angle), this->direction);
            this->tracker = action;
            break;
        default:
            break;
    }
    this->update();
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

void Camera::update(){
    this->direction = this->hamilton(this->tracker, this->direction);
    this->up_axis = this->hamilton(this->tracker, this->up_axis);
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




