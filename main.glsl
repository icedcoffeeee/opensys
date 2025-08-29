uniform vec2 u_winsize;

#define MAX 5
#define TOL 1e-3

struct Ray {
  vec3 position;
  vec3 direction;
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

Bulb b = Bulb(vec3(1., 0., 3.), vec4(1.), 10.);

float shade(Ray r) {
  return dot(r.direction, normalize(b.position - r.position));
}

vec4 intersect(inout Ray r, Sphere s) {
  // ray: p = p0 + d * t
  // sphere: dot(p - O, p - O) = r * r
  // dot(p0 + d * t - O, p0 + d * t - O) - r * r = 0
  // t^2 * dot(d,d) + 2 * t * dot(d, p0 - O) + dot(p0 - O, p0 - O) - r^2 = 0

  vec3 p = r.position - s.position;
  float a = dot(r.direction, r.direction);
  float b = dot(r.direction, p) * 2.;
  float c = dot(p, p) - pow(s.radius, 2.);

  float det = b * b - 4. * a * c;
  if (det <= TOL)
    return vec4(0.);

  float t = (-b + sqrt(det)) / 2. / a;
  t = min(t, (-b - sqrt(det)) / 2. / a);
  if (t <= TOL)
    return vec4(0.);

  r.position += r.direction * t;
  r.direction = reflect(r.direction, normalize(r.position - s.position));
  return s.color * shade(r);
}

vec4 intersect(inout Ray r, Plane p) {
  // ray: p = p0 + d * t
  // plane: dot(p - O, N) = 0
  // dot(p0 + d * t - O, N) = 0
  // dot(p0 - O, N) + t * dot(d, N) = 0

  float t = dot(p.position - r.position, p.normal) / dot(r.direction, p.normal);
  if (t <= TOL)
    return vec4(0.);

  r.position += r.direction * t;
  r.direction = reflect(r.direction, normalize(p.normal));
  return p.color * shade(r);
}

void main() {
  vec3 origin = vec3(0., -5., 0.);
  vec2 coord =
      (gl_FragCoord.xy - u_winsize / 2.) / min(u_winsize.x, u_winsize.y);
  vec3 dir = vec3(coord.x, 1., coord.y);
  Ray ray = Ray(origin, dir);

  Sphere sphere = Sphere(vec3(-1., 0., 0.), vec4(1.), 0.5);
  Plane plane = Plane(vec3(0.5, 0., -1.), vec4(1.), vec3(1., 0., 0.));

  vec4 col = vec4(0.);
  for (int hitN = MAX; hitN > 0; hitN--) {
    col += intersect(ray, sphere) * hitN;
    col += intersect(ray, plane) * hitN;
  }
  gl_FragColor = col / MAX;
  // gl_FragColor = vec4(shade(ray));
}
