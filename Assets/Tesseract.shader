Shader "Custom/Tesseract" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
	}
	SubShader {
		Tags { "Queue" = "Transparent" "RenderType"="Transparent" }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows alpha vertex:vert

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		struct Input {
            float4 my_uvw;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;

        // from https://www.shadertoy.com/view/4sfGzS
        float hash(float3 p)  // replace this by something better
        {
            p  = frac( p*0.3183099+.1 );
            p *= 17.0;
            return frac( p.x*p.y*p.z*(p.x+p.y+p.z) );
        }

        float noise( in float3 x )
        {
            float3 p = floor(x);
            float3 f = frac(x);
            f = f*f*(3.0-2.0*f);

            float l1 = lerp( hash(p+float3(0,0,0)), hash(p+float3(1,0,0)),f.x);
            float l2 = lerp( hash(p+float3(0,1,0)), hash(p+float3(1,1,0)),f.x);
            float l3 = lerp( hash(p+float3(0,0,1)), hash(p+float3(1,0,1)),f.x);
            float l4 = lerp( hash(p+float3(0,1,1)), hash(p+float3(1,1,1)),f.x);

            return lerp(lerp(l1, l2, f.y), lerp(l3, l4, f.y), f.z);
        }

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_BUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_BUFFER_END(Props)

        void vert (inout appdata_full v, out Input o) {
            UNITY_INITIALIZE_OUTPUT(Input,o);
            o.my_uvw = v.vertex;
        }

        void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
            float n = noise(float3(IN.my_uvw.x, IN.my_uvw.y, IN.my_uvw.z) * 50);
			fixed4 c = n * _Color;
			o.Albedo = c.rgb;
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
            o.Emission = c.rgb;
			o.Alpha = _Color.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
