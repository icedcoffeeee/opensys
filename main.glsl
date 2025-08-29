uniform vec2 u_winsize;

#define MAX 10
#define TOL 1e-3

#define PI 3.14159265359

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

Bulb b = Bulb(vec3(0., 0., 1.), vec4(1.), 10.);

float shade(Ray r) {
  float cosine = dot(r.direction, normalize(b.position - r.position));
  float power = b.strength / 4 / PI / pow(distance(b.position, r.position), 2.);
  return clamp(cosine * power, 0., 1.);
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

vec4 background(Ray r) {
  // like sphere with rad R
  float R = 1000.;
  vec3 p = r.position;
  float a = dot(r.direction, r.direction);
  float b = dot(r.direction, p) * 2.;
  float c = dot(p, p) - pow(R, 2.);

  float det = b * b - 4. * a * c;
  if (det <= TOL)
    return vec4(0.);

  float t = (-b + sqrt(det)) / 2. / a;
  t = max(t, (-b - sqrt(det)) / 2. / a);

  vec3 pos = r.position + r.direction * t;
  float theta = acos(pos.x / R);
  float phi = acos(pos.z / R);

  vec4 res = vec4(0.);
  float divs = 3.;
  if (mod(theta, PI / divs) < PI / divs / 2.)
    res += vec4(1.);
  if (mod(phi, PI / divs) < PI / divs / 2.)
    res -= vec4(1.);
  return abs(0.05 * res);
}

void main() {
  vec3 origin = vec3(0., -5., 0.);
  vec2 coord =
      (gl_FragCoord.xy - u_winsize / 2.) / min(u_winsize.x, u_winsize.y);
  vec3 dir = vec3(coord.x, 1., coord.y);
  Ray ray = Ray(origin, dir);

  Sphere sphere = Sphere(vec3(0.), vec4(1., 0., 0., 1.), 0.5);
  Plane plane = Plane(vec3(1., 0., -1.), vec4(0., 0., 1., 1.),
                      normalize(vec3(-2., 0., 1.)));

  vec4 col = vec4(0.);
  for (int hitN = MAX; hitN > 0; hitN--) {
    col += intersect(ray, sphere) * hitN;
    col += intersect(ray, plane) * hitN;
  }
  gl_FragColor = col / MAX;
  gl_FragColor += background(ray);
}
