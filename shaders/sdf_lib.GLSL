#define PI 3.14159265

//////////////////////////////////////////////////////////////////////
//	PRIMITIVES
/////////////////////////////////////////////////////////////////////
float de_sphere(vec3 p, float r){
	return length(p) - r;
}
float de_box(vec3 p, vec3 b){
  vec3 q = abs(p) - b;
  return length(max(q,0.0)) + min(max(q.x,max(q.y,q.z)),0.0);
}
float de_cross(vec3 p){
  float da = de_box(p.xyz,vec3(MAX_DIST,1.0,1.0));
  float db = de_box(p.yzx,vec3(1.0,MAX_DIST,1.0));
  float dc = de_box(p.zxy,vec3(1.0,1.0,MAX_DIST));
  return min(da,min(db,dc));
}
float de_tetrahedron(vec3 p, float r) {
	float md = max(max(-p.x - p.y - p.z, p.x + p.y - p.z),
				   max(-p.x + p.y + p.z, p.x - p.y + p.z));
	return (md - r) / sqrt(3.0);
}
/////////////////////////////////////////////////////////////////////
//	SPACE FOLDING
/////////////////////////////////////////////////////////////////////
void pFold1D(inout float x, float size){
	float half_size = 0.5 * size;
	x = mod((x + half_size), size) - half_size;
}
void pFold2D(inout vec2 p, float size){
	float half_size = 0.5 * size;
	p = mod((p + half_size), size) - half_size;
}
void pFold3D(inout vec3 p, float size){
	float half_size = 0.5 * size;
	p = mod((p + half_size), size) - half_size;
}
void pFoldMenger(inout vec3 p){
	float a = min(p.x - p.y, 0.0);
	p.x -= a;
	p.y += a;
	a = min(p.x - p.z, 0.0);
	p.x -= a;
	p.z += a;
	a = min(p.y - p.z, 0.0);
	p.y -= a;
	p.z += a;
}
void pFoldPlane(inout vec3 p, vec3 normal, float offset){
	// stuff on the side where normal points to, will be reflected on other side
	p -= 2.0 * min(0.0, dot(p, normal) - offset) * normal;
}
void pFoldAbs(inout vec3 p){
	p.x = abs(p.x);
	p.y = abs(p.y);
	p.z = abs(p.z);
}
void pRotX(inout vec3 p, float c, float s){
	p.yz = vec2(c * p.y - s * p.z, s * p.y + c * p.z);
}
void pRotX(inout vec3 p, float angle){
	angle = PI * angle / 180.0;
	pRotX(p, cos(angle), sin(angle));
}
void pRotY(inout vec3 p, float c, float s){
	p.zx = vec2(c * p.z - s * p.x, s * p.z + c * p.x);
}
void pRotY(inout vec3 p, float angle){
	angle = PI * angle / 180.0;
	pRotY(p, cos(angle), sin(angle));
}
void pRotZ(inout vec3 p, float c, float s){
	p.xy = vec2(c * p.x - s * p.y, s * p.x + c * p.y);
}
void pRotZ(inout vec3 p, float angle){
	angle = PI * angle / 180.0;
	pRotZ(p, cos(angle), sin(angle));
}
void pFoldSierpinski(inout vec3 p){
	p.xy -= min(p.x + p.y, 0.0);
	p.zx -= min(p.z + p.x, 0.0);
	p.yz -= min(p.y + p.z, 0.0);
}
void pFoldBox(inout vec3 p, vec3 r) {
	// probably wrong
	p = clamp(p, -r, r) * 2.0 - p;
}
float sphereFold(inout vec3 z, float minR, float maxR) {
	// probably wrong
	float r2 = dot(z.xyz, z.xyz);
	z *= max(maxR / max(minR, r2), 1.0);
	return max(maxR / max(minR, r2), 1.0);
}