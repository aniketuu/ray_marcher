#include <cstdio>
#include <cstring>
#include <string>
#include <sstream>
#include <fstream>

void recordData(){
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