#include <cstdio>

#include "display.h"
#include "FullscreenQuad.h"
#include "shader.h"
#include "camera.h"

using namespace std;

int main(){
    // display
    int display_width = 1280;
    int display_height = 720;
    Display display("ray march", display_width, display_height);

    // fullscreen Quad
    FullscreenQuad fullscreen_quad;

    // camera
    glm::vec3 cam_pos = glm::vec3(0.0f, 0.0f, 5.0f);
    glm::vec3 cam_dir = glm::vec3(0.0f, 0.0f, -1.0f);
    Camera camera(cam_pos, cam_dir);

    // shaders
    char v_path[] = "shaders/vert.GLSL";
    char f_path[] = "shaders/frag.GLSL";
    Shader shader(v_path, f_path);

    shader.add("// CAMERA_PROPERTIES", camera.getProperties());
    shader.compileShaders();
    shader.use();

    // rigs
    bool barell_roll = false;
    float count = 0.0f;
    

    // main loop
    bool running = true;
    SDL_Event event;
    while(running){
        // clear
        display.clearScreen(0.4, 0.3, 0.7, 1.0);

        // rigs
        camera.move(camera.move_enum);
        camera.turn(camera.rot_enum, 0.075);

        if(barell_roll){
            float inc = 0.25f;
            camera.barellRoll(inc);
            count += inc;
            if(count == 360.0f){
                count = 0.0f;
                barell_roll = false;
            }
        }

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
                        camera.move_enum = FORWARD;
                        break;
                    case SDLK_s:
                        camera.move_enum = BACKWARD;
                        break;
                    case SDLK_a:
                        camera.move_enum = LEFT;
                        break;
                    case SDLK_d:
                        camera.move_enum = RIGHT;
                        break;
                    case SDLK_q:
                        camera.move_enum = UP;
                        break;
                    case SDLK_z:
                        camera.move_enum = DOWN;
                        break;
                    case SDLK_x:
                        camera.move_enum = NONE;
                        break;
                    case SDLK_e:
                        camera.rot_enum = FORWARD;
                        break;
                    case SDLK_c:
                        camera.rot_enum = BACKWARD;
                        break;
                    case SDLK_r:
                        camera.rot_enum = LEFT;
                        break;
                    case SDLK_t:
                        camera.rot_enum = RIGHT;
                        break;
                    case SDLK_f:
                        camera.rot_enum = UP;
                        break;
                    case SDLK_g:
                        camera.rot_enum = DOWN;
                        break;
                    case SDLK_v:
                        camera.rot_enum = NONE;
                        break;
                    case SDLK_b:
                        camera.rot_enum = NONE;
                        camera.rot_count_x = 0.0f;
                        camera.rot_count_y = 0.0f;
                        camera.rot_count_z = 0.0f;
                        break;
                    case SDLK_ESCAPE:
                        running = false;
                        break;
                    case SDLK_u:
                        barell_roll = true;
                        break;
                    case SDLK_k:
                        camera.printDetails();
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