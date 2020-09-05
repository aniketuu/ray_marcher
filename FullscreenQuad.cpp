#include "FullscreenQuad.h"

void FullscreenQuad::genObjects(){
    glGenVertexArrays(1, &this->VAO);
    glGenBuffers(1, &this->VBO);
}

void FullscreenQuad::bindObjects(){
    glBindVertexArray(this->VAO);
    glBindBuffer(GL_ARRAY_BUFFER, this->VBO);
}

void FullscreenQuad::loadData(){
    glBufferData(GL_ARRAY_BUFFER, sizeof(this->vertices), this->vertices, GL_STATIC_DRAW);
}

void FullscreenQuad::vertexAttribs(){
    glVertexAttribPointer(0, 2, GL_FLOAT, GL_FALSE, 2 * sizeof(GLfloat), 0);
    glEnableVertexAttribArray(0);
}

FullscreenQuad::FullscreenQuad(){
    this->genObjects();
    this->bindObjects();
    this->loadData();
    this->vertexAttribs();
}

