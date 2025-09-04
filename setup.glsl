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
