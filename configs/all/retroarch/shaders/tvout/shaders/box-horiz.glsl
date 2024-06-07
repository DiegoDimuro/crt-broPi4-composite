/*
   Box Horizontal Shader
   Automatically scales horizontal output to the maximum integer scale possible, vertical is ignored.
   Original Author: Themaister
   Modified by: Sakitoshi
   License: Public domain
*/

#if defined(VERTEX)

#if __VERSION__ >= 130
#define COMPAT_VARYING out
#define COMPAT_ATTRIBUTE in
#define COMPAT_TEXTURE texture
#else
#define COMPAT_VARYING varying
#define COMPAT_ATTRIBUTE attribute
#define COMPAT_TEXTURE texture2D
#endif

#ifdef GL_ES
#define COMPAT_PRECISION mediump
#else
#define COMPAT_PRECISION
#endif

COMPAT_ATTRIBUTE vec4 VertexCoord;
COMPAT_ATTRIBUTE vec4 COLOR;
COMPAT_ATTRIBUTE vec4 TexCoord;
COMPAT_VARYING vec4 COL0;
COMPAT_VARYING vec4 TEX0;

uniform mat4 MVPMatrix;
uniform COMPAT_PRECISION int FrameDirection;
uniform COMPAT_PRECISION int FrameCount;
uniform COMPAT_PRECISION vec2 OutputSize;
uniform COMPAT_PRECISION vec2 TextureSize;
uniform COMPAT_PRECISION vec2 InputSize;

// compatibility #defines
#define vTexCoord TEX0.xy
#define SourceSize vec4(TextureSize, 1.0 / TextureSize) //either TextureSize or InputSize
#define OutSize vec4(OutputSize, 1.0 / OutputSize)

void main()
{
   float box_scale1;
   float box_scale2;
   gl_Position = MVPMatrix * VertexCoord;

   vec2 box_scale = floor(OutputSize.xy / InputSize.xy);
   if (box_scale.x <= 0.0)
      box_scale = (OutputSize.xy / InputSize.xy) / 1.14;
   float x_scale = box_scale.x;

   float scale = (OutputSize.x / InputSize.x) / x_scale;
   //float scale = 0.0009;
   vec2 middle = vec2(0.5) * InputSize.xy / TextureSize.xy;
   vec2 diff = TexCoord.xy - middle;
   vTexCoord = vec2(middle.x + diff.x * scale, middle.y + diff.y);
}

#elif defined(FRAGMENT)

#ifdef GL_ES
#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif
#define COMPAT_PRECISION mediump
#else
#define COMPAT_PRECISION
#endif

#if __VERSION__ >= 130
#define COMPAT_VARYING in
#define COMPAT_TEXTURE texture
out COMPAT_PRECISION vec4 FragColor;
#else
#define COMPAT_VARYING varying
#define FragColor gl_FragColor
#define COMPAT_TEXTURE texture2D
#endif

uniform COMPAT_PRECISION int FrameDirection;
uniform COMPAT_PRECISION int FrameCount;
uniform COMPAT_PRECISION vec2 OutputSize;
uniform COMPAT_PRECISION vec2 TextureSize;
uniform COMPAT_PRECISION vec2 InputSize;
uniform sampler2D Texture;
COMPAT_VARYING vec4 TEX0;

// compatibility #defines
#define Source Texture
#define vTexCoord TEX0.xy

#define SourceSize vec4(TextureSize, 1.0 / TextureSize) //either TextureSize or InputSize
#define OutSize vec4(OutputSize, 1.0 / OutputSize)

void main()
{
   vec3 TexOut = COMPAT_TEXTURE(Source, vTexCoord).rgb;

   if (vTexCoord.x > 0.0) // needed to mask a repeating pattern at the top on rpi.
      TexOut = TexOut;
   else
      TexOut = vec3(0.0);

   FragColor = vec4(TexOut, 1.0);
} 
#endif
