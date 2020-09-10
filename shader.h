#pragma once

#include <cstdio>
#include <cstring>
#include <string>
#include <sstream>
#include <fstream>

#include <GL/glew.h>
#include "glm/glm.hpp"

class Shader{
private:
    char* vert_path;
    char* frag_path;
    GLuint program_id;
public:
    // source of shaders
    std::string vert_source;
    std::string frag_source;
    std::string helper_source;

    // getters and setters
    GLuint getProgramId();
    char* getPath(char type);
    void setProgramId(GLuint id);
    void setPath(char type, char* path);

    // constructor and buddies
    Shader(char* v_path, char* f_path);
    void loadShaders();
    void compileShaders();
    void checkCompileErrors(GLuint id, std::string);
    void use();

    // external GLSL
    void add(std::string target, std::string source);
    void addGLSL(std::string target, std::string h_path);

    // set uniforms
    void setInt(std::string name, int n);
    void setFloat(std::string name, float f);

    void setVec2f(std::string name, float x, float y){
        this->setVec2f(name, glm::vec2(x, y));
    }
    void setVec2f(std::string name, glm::vec2 vec);
    
    void setVec3f(std::string name, float x, float y, float z){
        this->setVec3f(name, glm::vec3(x, y, z));
    }
    void setVec3f(std::string name, glm::vec3 vec);
    
    void setVec4f(std::string name, float x, float y, float z, float w){
        this->setVec4f(name, glm::vec4(x, y, z, w));
    }
    void setVec4f(std::string name, glm::vec4 vec);
    
    void setMat4f(std::string name, glm::mat4);
};