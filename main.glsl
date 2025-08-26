#include "./structs.glsl"

uniform vec2 u_winsize;

const int MAX = 10000;
const float STEP = 0.001;
const float TOL = 0.001;

const float PI = 3.14159265359;

PointLight light = PointLight(vec3(0., 0., 3.), 100., vec4(1.));
Sphere sphere = Sphere(vec3(0.), 0.5, Mat(vec4(1.)));
Plane plane = Plane(vec3(0., 0., -1.), vec2(1.), Mat(vec4(1.)));

vec4 traverse(Ray ray, vec4 albedo) {
  for (int i = 0; i < MAX; i++) {
    ray.position += ray.direction * STEP;

    if (distance(ray.position, sphere.center) - sphere.radius < TOL) {
      vec3 normal = normalize(ray.position - sphere.center);
      vec3 to_light = light.position - ray.position;
      ray.direction = reflect(ray.direction, normal);
      albedo = sphere.material.albedo;
      float shaded = dot(normalize(ray.direction), normalize(to_light));
      float power = light.strength / pow(length(to_light), 2.) / 4. / PI;
      return shaded * power * albedo;
    }
  }

  return albedo;
}

void main() {
  vec3 start = vec3(0., -5., 0.);
  vec2 coord = (gl_FragCoord.xy - u_winsize * vec2(0.5));
  coord /= min(u_winsize.x, u_winsize.y);

  vec3 dir = vec3(coord.x, 1., coord.y);
  Ray ray = Ray(start, dir);

  gl_FragColor = traverse(ray, vec4(0.));
}
