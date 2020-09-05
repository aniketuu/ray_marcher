#pragma once

#include <string>

#include <SDL2/SDL.h>
#include <GL/glew.h>

class Display{
public:
    Display(std::string title, int width, int height);
    ~Display();
    void clearScreen(float, float, float, float);
    void swapBuffers();
private:
    SDL_Window* window;
    SDL_GLContext context; 
};