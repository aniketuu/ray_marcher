#include "shader.h"

// getters and setters
GLuint Shader::getProgramId(){
    return this->program_id;
}

char* Shader::getPath(char type){
    if(type == 'V' || type == 'v'){
        return this->vert_path;
    }
    else if(type == 'F' || type == 'f'){
        return this->frag_path;
    }
    else{
        fprintf(stderr, "FAILURE : unknown type argument for getPath\n");
        return this->frag_path;
    }
}

void Shader::setProgramId(GLuint id){
    this->program_id = id;
}

void Shader::setPath(char type, char* path){
    if(type == 'V' || type == 'v'){
        this->vert_path = path;
    }
    else if(type == 'F' || type == 'f'){
        this->frag_path = path;
    }
    else{
        fprintf(stderr, "FAILURE : unknown type argument for setPath\n");
    }
}

// constructor and buddies
Shader::Shader(char* v_path, char* f_path){
    this->setPath('V', v_path);
    this->setPath('F', f_path);

    // load shaders
    this->loadShaders();
}

void Shader::loadShaders(){
    // 1. load glsl code from shader files
    std::ifstream vFileStream;
    std::ifstream fFileStream;
    // ensure fstream  can throw exceptions
    vFileStream.exceptions(std::ifstream::failbit | std::ifstream::badbit);
    fFileStream.exceptions(std::ifstream::failbit | std::ifstream::badbit);
    // string to hold shaders
    std::string vString;
    std::string fString;
    // try
    try{
        // open files
        vFileStream.open(Shader::getPath('V'));
        fFileStream.open(Shader::getPath('F'));
        // create string streams and read file data in it
        std::stringstream vStringStream;
        std::stringstream fStringStream;
        vStringStream << vFileStream.rdbuf();
        fStringStream << fFileStream.rdbuf();
        // close files
        vFileStream.close();
        fFileStream.close();
        // convert streams  to strings
        this->vert_source = vStringStream.str();
        this->frag_source = fStringStream.str();
    }
    catch(std::ifstream::failure& e){
        printf("ERROR::SHADER::FILE_NOT_SUCCESFULLY_READ\n");
    }
}

void Shader::compileShaders(){
    const char* vertexSource = this->vert_source.c_str();
    const char* fragmentSource = this->frag_source.c_str();

    // create and compile vertex shader
    GLuint vertexShader = glCreateShader(GL_VERTEX_SHADER);
    glShaderSource(vertexShader, 1, &vertexSource, NULL);
    glCompileShader(vertexShader);
    Shader::checkCompileErrors(vertexShader, "VERTEX_SHADER");
    // create and compile fragment shader
    GLuint fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);
    glShaderSource(fragmentShader, 1, &fragmentSource, NULL);
    glCompileShader(fragmentShader);
    Shader::checkCompileErrors(fragmentShader, "FRAGMENT_SHADER");

    // create shader program
    this->program_id = glCreateProgram();
    glAttachShader(this->program_id, vertexShader);
    glAttachShader(this->program_id, fragmentShader);
    glLinkProgram(this->program_id);
    Shader::checkCompileErrors(this->program_id, "PROGRAM");

    // free upshaders
    glDeleteShader(fragmentShader);
    glDeleteShader(vertexShader);   
}

void Shader::checkCompileErrors(GLuint shader, std::string type){

    int success;
    char infoLog[1024];
    if(type != "PROGRAM"){
        glGetShaderiv(shader, GL_COMPILE_STATUS, &success);
        if(!success){
            glGetShaderInfoLog(shader, 1024, NULL, infoLog);
            printf("ERROR::SHADER_COMPILATION_ERROR %s\n", type.c_str());
            printf("%.*s\n", 1024, infoLog);
        }
    }
    else{
        glGetProgramiv(shader, GL_LINK_STATUS, &success);
        if(!success){
            glGetProgramInfoLog(shader, 1024, NULL, infoLog);
            printf("ERROR::PROGRAM_LINKING_ERROR %s\n", type.c_str());
            printf("%.*s\n", 1024, infoLog);
        }
    }
}

void Shader::use(){
    glUseProgram(this->program_id);
}

// set uniforms
void Shader::setInt(std::string name, int n){
    this->use();
    glUniform1i(glGetUniformLocation(this->program_id, name.c_str()), n);
}

void Shader::setFloat(const std::string name, float value){
    this->use();
    glUniform1f(glGetUniformLocation(this->program_id, name.c_str()), (float)value);
}

void Shader::setMat4f(const std::string name, glm::mat4 mat){
    this->use();
    glUniformMatrix4fv(glGetUniformLocation(this->program_id, name.c_str()), 1, GL_FALSE, &mat[0][0]);
}

void Shader::setVec2f(const std::string name, glm::vec2 vec){
    glUniform2fv(glGetUniformLocation(this->program_id, name.c_str()), 1, &vec[0]);
}

void Shader::setVec3f(const std::string name, glm::vec3 vec){
    this->use();
    glUniform3fv(glGetUniformLocation(this->program_id, name.c_str()), 1, &vec[0]);
}

void Shader::setVec4f(const std::string name, glm::vec4 vec){
    this->use();
    glUniform4fv(glGetUniformLocation(this->program_id, name.c_str()), 1, &vec[0]);
}


