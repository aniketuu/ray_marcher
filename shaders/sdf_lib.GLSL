#define PI 3.14159265358

// Sign function that doesn't return 0
float sgn(float x) {
	return (x<0)?-1:1;
}
vec2 sgn(vec2 v) {
	return vec2((v.x<0)?-1:1, (v.y<0)?-1:1);
}
float square (float x) {
	return x*x;
}
vec2 square (vec2 x) {
	return x*x;
}
vec3 square (vec3 x) {
	return x*x;
}
float lengthSqr(vec3 x) {
	return dot(x, x);
}
// Maximum/minumum elements of a vector
float vmax(vec2 v) {
	return max(v.x, v.y);
}
float vmax(vec3 v) {
	return max(max(v.x, v.y), v.z);
}
float vmax(vec4 v) {
	return max(max(v.x, v.y), max(v.z, v.w));
}
float vmin(vec2 v) {
	return min(v.x, v.y);
}
float vmin(vec3 v) {
	return min(min(v.x, v.y), v.z);
}
float vmin(vec4 v) {
	return min(min(v.x, v.y), min(v.z, v.w));
}

////////////////////////////////////////////////////////////////////////////
//	SPACE FOLDING 
////////////////////////////////////////////////////////////////////////////
float pFold(inout float p, float size){
	float half_size = 0.5*size;
	float c = floor((p + half_size)/size);
	p = mod(p+half_size,size) - half_size;
	return c;
}
vec2 pFold(inout vec2 p, float size){
	float half_size = 0.5*size;
	vec2 c = floor((p+half_size)/size);
	p = mod(p+half_size,size) - half_size;
	return c;
}
vec3 pFold(inout vec3 p, float size){
	float half_size = 0.5*size;
	vec3 c = floor((p+half_size)/size);
	p = mod(p+half_size,size) - half_size;
	return c;
}
void pFoldPlane(inout vec3 p, vec3 normal, float offset){
	p -= 2.0 * min(0.0, dot(p,normal) + offset) * normal;
}
void pFoldAbs(inout vec3 p, vec3 c){
	p = abs(p - c) + c;
}
void pFoldSierpinski(inout vec3 p){
	p.xy -= min(p.x + p.y, 0.0);
	p.xz -= min(p.x + p.z, 0.0);
	p.yz -= min(p.y + p.z, 0.0);
}
////////////////////////////////////////////////////////////////////////////
//	DISTANCE ESTIMATES
////////////////////////////////////////////////////////////////////////////
//sphere
float de_sphere(vec3 p, float r){
	return length(p) - r;
}
// plane
float de_plane(vec3 p, vec3 n, float distanceFromOrigin) {
	return dot(p, n) + distanceFromOrigin;
}
// box
float de_box(vec3 p, vec3 b) {
	vec3 d = abs(p) - b;
	return length(max(d, vec3(0))) + vmax(min(d, vec3(0)));
}
float de_boxCheap(vec3 p, vec3 b) { //cheap box
	return vmax(abs(p) - b);
}
float de_boxRound( vec3 p, vec3 b, float r ){
  vec3 q = abs(p) - b;
  return length(max(q,0.0)) + min(max(q.x,max(q.y,q.z)),0.0) - r;
}
// cylinders and capsula
float de_capsule( vec3 p, vec3 a, vec3 b, float r ){
  vec3 pa = p - a, ba = b - a;
  float h = clamp( dot(pa,ba)/dot(ba,ba), 0.0, 1.0 );
  return length( pa - ba*h ) - r;
}
float de_cylinder( vec3 p, float h, float r ){
  vec2 d = abs(vec2(length(p.xz),p.y)) - vec2(h,r);
  return min(max(d.x,d.y),0.0) + length(max(d,0.0));
}
// tertahederon and octahederon
float de_tetrahedron( vec3 p, float h){
  float m2 = h*h + 0.25;
    
  p.xz = abs(p.xz);
  p.xz = (p.z>p.x) ? p.zx : p.xz;
  p.xz -= 0.5;

  vec3 q = vec3( p.z, h*p.y - 0.5*p.x, h*p.x + 0.5*p.y);
   
  float s = max(-q.x,0.0);
  float t = clamp( (q.y-0.5*p.z)/(m2+0.25), 0.0, 1.0 );
    
  float a = m2*(q.x+s)*(q.x+s) + q.y*q.y;
  float b = m2*(q.x+0.5*t)*(q.x+0.5*t) + (q.y-m2*t)*(q.y-m2*t);
    
  float d2 = min(q.y,-q.x*m2-q.y*0.5) > 0.0 ? 0.0 : min(a,b);
    
  return sqrt( (d2+q.z*q.z)/m2 ) * sign(max(q.z,-p.y));
}
float de_octahedron( vec3 p, float s){
  p = abs(p);
  float m = p.x+p.y+p.z-s;
  vec3 q;
       if( 3.0*p.x < m ) q = p.xyz;
  else if( 3.0*p.y < m ) q = p.yzx;
  else if( 3.0*p.z < m ) q = p.zxy;
  else return m*0.57735027;
    
  float k = clamp(0.5*(q.z-q.y+s),0.0,s); 
  return length(vec3(q.x,q.y-s+k,q.z-k)); 
}
