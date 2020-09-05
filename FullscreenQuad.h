#pragma once

#include <GL/glew.h>
#include "glm/glm.hpp"

class FullscreenQuad{
private:
    GLfloat vertices[12] = {
        -1.0,   -1.0,
         1.0,   -1.0,
         1.0,    1.0,
        -1.0,    1.0
    };

    GLuint VAO;
    GLuint VBO;
public:
    FullscreenQuad();
    void genObjects();
    void bindObjects();
    void loadData();
    void vertexAttribs();
};