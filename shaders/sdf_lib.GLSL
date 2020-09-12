#define saturate(x) clamp(x, 0, 1)

#define PI 3.14159265
#define TAU (2*PI)
#define PHI (sqrt(5)*0.5 + 0.5)
//////////////////////////////////////////////////////////////////////////
//  UTILS
/////////////////////////////////////////////////////////////////////////
float vmax(vec3 p){
    return max(p.x, max(p.y,p.z));
}

/////////////////////////////////////////////////////////////////////////
//  PRIMITIVES
/////////////////////////////////////////////////////////////////////////
float de_sphere(vec3 p, float r){
    return length(p) - r;
}
float de_box(vec3 p, vec3 b){
  vec3 q = abs(p) - b;
  return length(max(q,0.0)) + min(vmax(q),0.0);
}
float de_box(vec3 p, vec3 b, float r){
  vec3 q = abs(p) - b;
  return length(max(q,0.0)) + min(vmax(q),0.0) - r;
}
float de_tetrahedron(vec3 p, float r) {
	float md = max(max(-p.x - p.y - p.z, p.x + p.y - p.z),
				   max(-p.x + p.y + p.z, p.x - p.y + p.z));
	return (md - r) / sqrt(3.0);
}
float de_plane(vec3 p, vec3 n, float distanceFromOrigin) {
	return dot(p, n) + distanceFromOrigin;
}
float de_cylinder(vec3 p, float r, float height) {
	float d = length(p.xz) - r;
	d = max(d, abs(p.y) - height);
	return d;
}
float de_capsule(vec3 p, float r, float c) {
	return mix(length(p.xz) - r, length(vec3(p.x, abs(p.y) - c, p.z)) - r, step(c, abs(p.y)));
}
float fLineSegment(vec3 p, vec3 a, vec3 b) {
	vec3 ab = b - a;
	float t = saturate(dot(p - a, ab) / dot(ab, ab));
	return length((ab*t + a) - p);
}
float de_capsule(vec3 p, vec3 a, vec3 b, float r) {
	return fLineSegment(p, a, b) - r;
}
float de_torus(vec3 p, float smallRadius, float largeRadius) {
	return length(vec2(length(p.xz) - largeRadius, p.y)) - smallRadius;
}
/////////////////////////////////////////////////////////////////////////
//  SPACE FOLDING
/////////////////////////////////////////////////////////////////////////
float pFold1D(float p, float size){
  float half_size = 0.5 * size;
  return mod((p + half_size), size) - half_size;
}
vec2 pFold2D(vec2 p, float size){
  float half_size = 0.5 * size;
  return mod((p + half_size), size) - half_size;
}
vec3 pFold3D(vec3 p, float size){
  float half_size = 0.5 * size;
  return mod((p + half_size), size) - half_size;
}
void pFoldSierpinski(inout vec3 p){
	p.xy -= min(p.x + p.y, 0.0);
	p.zx -= min(p.z + p.x, 0.0);
	p.yz -= min(p.y + p.z, 0.0);
}