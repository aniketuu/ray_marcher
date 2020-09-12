float map(vec3 p){
    float s = de_sphere(p, 0.5);
    float d = de_box(p, vec3(0.475));
    return max(s,-d);
}