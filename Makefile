a.out: main.o display.o FullscreenQuad.o shader.o camera.o
	g++ main.o display.o FullscreenQuad.o shader.o camera.o -lSDL2 -lGL -lGLEW

main.o: main.cpp
	g++ -c main.cpp

display.o: display.h display.cpp
	g++ -c display.cpp

FullscreenQuad.o: FullscreenQuad.h FullscreenQuad.cpp
	g++ -c FullscreenQuad.cpp

shader.o: shader.h shader.cpp shaders/vert.GLSL shaders/frag.GLSL shaders/settings.GLSL shaders/sdf_lib.GLSL
	g++ -c shader.cpp

camera.o: camera.h camera.cpp
	g++ -c camera.cpp

clean:
	rm a.*