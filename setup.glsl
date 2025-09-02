uniform vec2 u_winsize;
uniform vec3 u_pos;
uniform float u_theta;
uniform float u_phi;

#define MAX 10
#define TOL 1e-3

#define PI 3.14159265359

struct Ray {
  vec3 position;
  vec3 direction;
  vec3 normal;
  vec4 color;
  float t;
  bool c;
};

struct Sphere {
  vec3 position;
  vec4 color;

  float radius;
};

struct Plane {
  vec3 position;
  vec4 color;

  vec3 normal;
};

struct Bulb {
  vec3 position;
  vec4 color;

  float strength;
};

