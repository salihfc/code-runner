shader_type canvas_item;

uniform vec4 rect;
uniform float speed;
uniform vec4 in_color : hint_color;
uniform vec4 bg_color : hint_color;

const vec3 red = vec3(1.0, 0.0, 0.0);
const vec3 white = vec3(1.0, 1.0, 1.0);

void fragment()
{
	float w = rect.x;
	float h = rect.y;
	
	float mw = rect.z;
	float mh = rect.w;

	float t = mod(TIME * speed, 2.0 * (w-mw + h-mh));
	
	vec2 pos = vec2(0.0, 0.0);
	pos += min(w-mw, t) * vec2(1.0, 0.0);
	t -= (w-mw);
	
	if (t > 0.0)
		pos += min(h-mh, t) * vec2(0.0, 1.0);
	t -= (h-mh);
	
	if (t > 0.0)
		pos += min(w-mw, t) * vec2(-1.0, 0.0);
	t -= (w-mw);

	if (t > 0.0)
		pos += min(h-mh, t) * vec2(0.0, -1.0);
	
	vec4 color = bg_color;

	if (pos.x <= UV.x*w && UV.x*w <= pos.x + mw)
		if (pos.y <= UV.y*h && UV.y*h <= pos.y + mh)
			color = in_color;
	
	COLOR = color;
}