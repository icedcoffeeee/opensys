struct Ray {
  vec3 position;
  vec3 direction;
};

struct PointLight {
  vec3 position;
  float strength;
  vec4 albedo;
};

struct Mat {
  vec4 albedo;
};

struct Sphere {
  vec3 center;
  float radius;
  Mat material;
};

struct Plane {
  vec3 center;
  vec2 size;
  Mat material;
};
