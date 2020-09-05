#include <cstdio>

#include "display.h"
#include "FullscreenQuad.h"
#include "shader.h"
#include "camera.h"

using namespace std;

int main(){
    // display
    int display_width = 800;
    int display_height = 600;
    Display display("ray march", display_width, display_height);

    // fullscreen Quad
    FullscreenQuad fullscreen_quad;

    // shaders
    char v_path[] = "shaders/vert.GLSL";
    char f_path[] = "shaders/frag.GLSL";
    Shader shader(v_path, f_path);

    shader.compileShaders();
    shader.use();

    // camera
    glm::vec3 cam_pos = glm::vec3(0.0f, 0.0f, 5.0f);
    glm::vec3 cam_dir = glm::vec3(0.0f, 0.0f, -1.0f);
    Camera camera(cam_pos, cam_dir);

    // main loop
    bool running = true;
    SDL_Event event;
    while(running){
        // clear
        display.clearScreen(0.4, 0.3, 0.7, 1.0);

        // uniforms
        
        shader.setVec2f("display_res", (float)display_width, (float)display_height);
        shader.setVec3f("camera.position", camera.getPosition());
        shader.setVec3f("camera.direction", camera.getDirection());
        shader.setVec3f("camera.up_axis", camera.getUpAxis());
        shader.setVec3f("camera.right_axis", camera.getRightAxis());
        

        // render
        fullscreen_quad.bindObjects();
        glDrawArrays(GL_TRIANGLE_FAN, 0, 4);

        // update
        display.swapBuffers();

        // event loop
        while(SDL_PollEvent(&event)){
            if(event.type == SDL_QUIT){
                running = false;
                break;
            }

            else if(event.type == SDL_KEYDOWN){
                switch(event.key.keysym.sym){
                    case SDLK_w:
                        camera.move(FORWARD);
                        break;
                    case SDLK_s:
                        camera.move(BACKWARD);
                        break;
                    case SDLK_a:
                        camera.move(LEFT);
                        break;
                    case SDLK_d:
                        camera.move(RIGHT);
                        break;
                    case SDLK_q:
                        camera.move(UP);
                        break;
                    case SDLK_z:
                        camera.move(DOWN);
                        break;
                    case SDLK_e:
                        camera.turn(FORWARD, 5.0);
                        break;
                    case SDLK_c:
                        camera.turn(BACKWARD, 5.0);
                        break;
                    case SDLK_r:
                        camera.turn(LEFT, 5.0);
                        break;
                    case SDLK_t:
                        camera.turn(RIGHT, 5.0);
                        break;
                    case SDLK_f:
                        camera.turn(UP, 5.0);
                        break;
                    case SDLK_g:
                        camera.turn(DOWN, 5.0);
                        break;
                    case SDLK_ESCAPE:
                        running = false;
                        break;
                    default:
                        break;
                }
            }
            
            else if(event.type == SDL_MOUSEMOTION){
                SDL_SetRelativeMouseMode(SDL_TRUE);
                int xpos, ypos;
                SDL_GetRelativeMouseState(&xpos, &ypos);
                camera.mouseMotion(xpos, ypos);                
            }
            
        }
    }
    return 0;
}