// License: CC0 (http://creativecommons.org/publicdomain/zero/1.0/)
#extension GL_OES_standard_derivatives : enable

varying vec3 normal;
varying vec3 vertex;

void main() {
  vec3 n = normalize(normal);

  // Compute curvature
  vec3 dx = dFdx(n);
  vec3 dy = dFdy(n);
  vec3 xneg = n - dx;
  vec3 xpos = n + dx;
  vec3 yneg = n - dy;
  vec3 ypos = n + dy;
  float depth = length(vertex);
  float curvature = (cross(xneg, xpos).y - cross(yneg, ypos).x) * 4.0 / depth;

  // Compute surface properties
  float corrosion = clamp(-curvature * 3.0, 0.0, 1.0);
  float shine = clamp(curvature * 5.0, 0.0, 1.0);
  vec3 light = normalize(vec3(0.0, 1.0, 10.0));
  vec3 ambient = vec3(0.15, 0.1, 0.1);
  vec3 diffuse = mix(mix(vec3(0.3, 0.25, 0.2), vec3(0.45, 0.5, 0.5), corrosion),
    vec3(0.5, 0.4, 0.3), shine) - ambient;
  vec3 specular = mix(vec3(0.0), vec3(1.0) - ambient - diffuse, shine);
  float shininess = 128.0;

  // Compute final color
  float cosAngle = dot(n, light);
  gl_FragColor.rgb = ambient +
    diffuse * max(0.0, cosAngle) +
    specular * pow(max(0.0, cosAngle), shininess);
}