shader_type canvas_item;

uniform sampler2D backgroundTex : repeat_enable;
uniform sampler2D firstLayerTex : repeat_enable;

const vec2 resolution = vec2(1024, 1024);
uniform float aspect_ratio = 1.0;
uniform vec2 movement_direction = vec2(0.0, 0.0);

const vec3 water_color = vec3(0.13, 0.53, 0.85);//vec3(42.0/256.0, 156.0/256.0, 244.0/255.0);

void vertex() {

}
vec2 get_wave_uv(vec2 wave_scale, float wave_speed, vec2 uv){
	return vec2(sin(TIME + (uv.x + uv.y) * wave_scale.x), cos(TIME + (uv.x + uv.y) * wave_scale.y)) * wave_speed;
}
vec2 get_flow_uv(vec2 param){
	return vec2(param.x, param.y);
}

float adjust_contrast_float(float color, float contrast){
    return mix(0.5, color, contrast);
}
float adjust_brigtness_float(float color, float min_val, float max_val){
	return mix(min_val, max_val, color);
}
float adjust_sharpness_float(float color, float limit1, float limit2){
	return smoothstep(limit1, limit2, color);
}

float get_noise_layer
(
	sampler2D noiseTex,
	vec2 uv, float scale, vec2 time, float contrast,
	float min_sharpness, float max_sharpness,
	float min_brigtness, float max_brigtness,
){
	float noise = texture(noiseTex, uv / scale + time).x;
	noise = adjust_contrast_float(noise, contrast);
	noise = adjust_sharpness_float(noise, min_sharpness, max_sharpness);
	noise = adjust_brigtness_float(noise, min_brigtness, max_brigtness);
	return noise;
}
void fragment() {
	vec2 uv = UV;
	uv.y *= aspect_ratio;

	vec2 time = get_wave_uv(vec2(0.5,0.9), 0.005, uv) + get_flow_uv(movement_direction);
	vec2 time1 = get_wave_uv(vec2(1,6), 0.006, uv) + get_flow_uv(movement_direction);
	vec2 time2 = get_wave_uv(vec2(2,1), 0.007, uv) + get_flow_uv(movement_direction);
	vec2 time3 = get_wave_uv(vec2(0.5,1.5), 0.008, uv) + get_flow_uv(movement_direction);
	vec2 time4 = get_wave_uv(vec2(0.1,0.6), 0.009, uv) + get_flow_uv(movement_direction);


	uv = round(uv * resolution) / resolution;

	float background = get_noise_layer(backgroundTex, uv, 6, time, 5, 0.2, 1, 0.7, 0.45);
	float firstLayer = 1.0 - get_noise_layer(firstLayerTex, uv, 6, time1, 3, 0.3, 1, 0.5, 0.05);
	float secondLayer = 1.0 - get_noise_layer(firstLayerTex, uv, 3, time2, 2.5, 0.5, 0.8, 0.4, 0.2);
	float thirdLayer = 1.0 - get_noise_layer(firstLayerTex, uv, 1, time3, 2, 0.7 , 0.9, 0.2, 0);

	float fourthLayer = 1.0 - get_noise_layer(firstLayerTex, uv, 0.25, time4, 2, 0.9 , 0.9, 0.1, 0);

	COLOR = vec4(water_color *  background, 1) / (firstLayer * secondLayer * thirdLayer * fourthLayer);


	//COLOR = vec4(time, 0, 1);
}
