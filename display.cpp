#include "./display.h"


Display::Display( std::string title, int width, int height){
    // init sdl
    SDL_Init(SDL_INIT_EVERYTHING);

    // set sdlgl attributes
    SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 3);
    SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 3);
    SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);

    // window and context
    this->window = SDL_CreateWindow(title.c_str(),
                                    SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,
                                    width, height,
                                    SDL_WINDOW_RESIZABLE |
                                    SDL_WINDOW_OPENGL);
    this->context = SDL_GL_CreateContext(window);

    // init glew
    glewExperimental = GL_TRUE;
    glewInit();

    // enable depth buffer
    glEnable(GL_DEPTH_TEST);
}

Display::~Display(){
    SDL_GL_DeleteContext(this->context);
    SDL_DestroyWindow(this->window);
    SDL_Quit();
}

void Display::clearScreen(float r, float g, float b, float a){
    glClearColor(r, g, b, a);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
}

void Display::swapBuffers(){
    SDL_GL_SwapWindow(this->window);
}