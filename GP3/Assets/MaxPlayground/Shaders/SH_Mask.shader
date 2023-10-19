// Made with Amplify Shader Editor v1.9.2.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SH_Mask"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Mask("Mask", 2D) = "white" {}
		_ColorRamp("ColorRamp", 2D) = "white" {}
		_ShadowColor("ShadowColor", Color) = (0.09952859,0.02055892,0.2075472,0)
		_ColorMain("ColorMain", Color) = (0.6195449,0.8207547,0.4142489,0)
		_ColorVar("ColorVar", Color) = (0.4205026,0.6226415,0.2144001,0)
		_Noise("Noise", 2D) = "white" {}
		_WindTile("Wind Tile", Float) = 0.15
		_WIndScroll("WInd Scroll", Float) = 0.1
		_WindStrength("WindStrength", Float) = 0.2
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" }
		Cull Off
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
			float3 worldNormal;
			INTERNAL_DATA
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform sampler2D _Noise;
		uniform float _WIndScroll;
		uniform float _WindTile;
		uniform float _WindStrength;
		uniform sampler2D _Mask;
		uniform float4 _ShadowColor;
		uniform float4 _ColorVar;
		uniform float4 _ColorMain;
		uniform sampler2D _ColorRamp;
		uniform float _Cutoff = 0.5;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertexNormal = v.normal.xyz;
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float2 appendResult106 = (float2(ase_worldPos.x , ase_worldPos.z));
			float2 panner110 = ( ( _Time.y * _WIndScroll ) * float2( 1,1 ) + ( appendResult106 * _WindTile ));
			float3 Wind115 = ( ase_vertexNormal * ( tex2Dlod( _Noise, float4( panner110, 0, 0.0) ).r * _WindStrength ) );
			v.vertex.xyz += Wind115;
			v.vertex.w = 1;
		}

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			#ifdef UNITY_PASS_FORWARDBASE
			float ase_lightAtten = data.atten;
			if( _LightColor0.a == 0)
			ase_lightAtten = 0;
			#else
			float3 ase_lightAttenRGB = gi.light.color / ( ( _LightColor0.rgb ) + 0.000001 );
			float ase_lightAtten = max( max( ase_lightAttenRGB.r, ase_lightAttenRGB.g ), ase_lightAttenRGB.b );
			#endif
			#if defined(HANDLE_SHADOWS_BLENDING_IN_GI)
			half bakedAtten = UnitySampleBakedOcclusion(data.lightmapUV.xy, data.worldPos);
			float zDist = dot(_WorldSpaceCameraPos - data.worldPos, UNITY_MATRIX_V[2].xyz);
			float fadeDist = UnityComputeShadowFadeDistance(data.worldPos, zDist);
			ase_lightAtten = UnityMixRealtimeAndBakedShadows(data.atten, bakedAtten, UnityComputeShadowFade(fadeDist));
			#endif
			float AlphaMask54 = tex2D( _Mask, i.uv_texcoord ).r;
			float4 ShadowColor98 = saturate( ( ( 1.0 - ase_lightAtten ) * ( _ShadowColor * ( 1.0 - AlphaMask54 ) ) ) );
			float4 lerpResult74 = lerp( _ColorVar , _ColorMain , AlphaMask54);
			float4 Albedo88 = lerpResult74;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_normWorldNormal = normalize( ase_worldNormal );
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = Unity_SafeNormalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult22 = dot( ase_normWorldNormal , ase_worldlightDir );
			float Normal_LightDir26 = ( max( dotResult22 , 0.0 ) * ase_lightAtten );
			float2 temp_cast_0 = ((Normal_LightDir26*0.49 + 0.49)).xx;
			float4 Shadow19 = ( ShadowColor98 + ( Albedo88 * tex2D( _ColorRamp, temp_cast_0 ) ) );
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			UnityGI gi64 = gi;
			float3 diffNorm64 = ase_normWorldNormal;
			gi64 = UnityGI_Base( data, 1, diffNorm64 );
			float3 indirectDiffuse64 = gi64.indirect.diffuse + diffNorm64 * 0.0001;
			float4 Light_Color68 = ( Shadow19 * ( ase_lightColor * float4( ( indirectDiffuse64 + ase_lightAtten ) , 0.0 ) ) );
			c.rgb = ( Light_Color68 + (0) ).rgb;
			c.a = 1;
			clip( AlphaMask54 - _Cutoff );
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			o.Normal = float3(0,0,1);
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				UnityGI gi;
				UNITY_INITIALIZE_OUTPUT( UnityGI, gi );
				o.Alpha = LightingStandardCustomLighting( o, worldViewDir, gi ).a;
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19201
Node;AmplifyShaderEditor.CommentaryNode;124;-2583.049,-1408.25;Inherit;False;2166.21;769.7167;Comment;14;106;107;110;112;113;105;117;115;118;122;123;108;109;114;Wind;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;89;-1944.194,-4145.469;Inherit;False;957.8248;580.8926;Comment;5;71;88;87;73;74;Albedo;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;56;-4310.017,-3342.865;Inherit;False;995.5826;455.0095;Comment;4;2;3;1;54;Alpha Mask;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;10;-2278.064,-3036.499;Inherit;False;1710.016;600.6762;Comment;10;19;12;20;17;13;11;90;91;103;104;Shadow;1,1,1,1;0;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;11;-1902.399,-2713.25;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;13;-1605.445,-2745.741;Inherit;True;Property;_TextureSample0;Texture Sample 0;7;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;17;-2158.398,-2681.25;Inherit;False;Constant;_Offset;Offset;8;0;Create;True;0;0;0;False;0;False;0.49;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;20;-1953.301,-2986.499;Inherit;True;Property;_ColorRamp;ColorRamp;2;0;Create;True;0;0;0;False;0;False;4378651f2ed612e4abe5216810ad3d61;f24b20aa6f50abe42a4eaff6ff15da61;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.CommentaryNode;21;-4336.473,-4058.838;Inherit;False;1452.284;471.9102;Comment;7;25;29;24;26;28;27;22;Normal Dir;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;12;-2228.064,-2799.613;Inherit;False;26;Normal LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;59;-2267.615,-2201.634;Inherit;False;1195.711;451.7809;Comment;8;67;68;66;65;64;62;61;60;Light;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;74;-1463.303,-3969.907;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;73;-1885.175,-4095.469;Inherit;False;Property;_ColorMain;ColorMain;4;0;Create;True;0;0;0;False;0;False;0.6195449,0.8207547,0.4142489,0;0.6195449,0.8207547,0.4142489,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;87;-1875.497,-3915.088;Inherit;False;Property;_ColorVar;ColorVar;5;0;Create;True;0;0;0;False;0;False;0.4205026,0.6226415,0.2144001,0;0.6195449,0.8207547,0.4142489,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;88;-1228.37,-3967.74;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;90;-1182.813,-2772.291;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;91;-1412.616,-2891.603;Inherit;False;88;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1074.622,-3325.771;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;SH_Mask;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;True;0;False;TransparentCutout;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;-1539.901,-2088.081;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;61;-1923.535,-1928.894;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;62;-1764.755,-2023.108;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LightColorNode;66;-1962.665,-2088.727;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.RegisterLocalVarNode;68;-1313.899,-2085.081;Inherit;False;Light Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;67;-1799.269,-2151.634;Inherit;False;19;Shadow;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.IndirectDiffuseLighting;64;-2197.042,-1962.871;Inherit;False;Tangent;1;0;FLOAT3;0,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LightAttenuation;65;-2192.537,-1858.894;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;93;-2373.3,-5161.451;Inherit;False;1486.704;713.1107;Comment;9;102;101;100;99;98;97;96;95;94;ShadowColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;94;-1545.624,-5008.915;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LightAttenuation;95;-2102.775,-5111.451;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;96;-1799.026,-5050.596;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;97;-1337.11,-5006.902;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;99;-1932.544,-4759.588;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;101;-2088.362,-4660.197;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;71;-1838.332,-3698.78;Inherit;False;54;AlphaMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;100;-2291.261,-4652.114;Inherit;False;54;AlphaMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;102;-2240.08,-4923.333;Inherit;False;Property;_ShadowColor;ShadowColor;3;0;Create;True;0;0;0;False;0;False;0.09952859,0.02055892,0.2075472,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;19;-787.5104,-2765.225;Inherit;False;Shadow;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;103;-955.7893,-2774.593;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;98;-1128.594,-5013.355;Inherit;False;ShadowColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;104;-1174.352,-2899.486;Inherit;False;98;ShadowColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.DotProductOpNode;22;-3948.968,-3879.637;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-3612.445,-3895.81;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;28;-3756.445,-3894.81;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;26;-3336.858,-3895.962;Inherit;False;Normal LightDir;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;24;-4250.483,-3823.973;Inherit;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LightAttenuation;29;-3962.019,-3746.688;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;25;-4253.615,-4008.838;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-4260.017,-3292.865;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;3;-4255.041,-3114.856;Inherit;True;Property;_Mask;Mask;1;0;Create;True;0;0;0;False;0;False;c011093f005faaa4892c6f64e6b4c11b;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;1;-3903.467,-3183.802;Inherit;True;Property;_FoliageV1;FoliageV1;1;0;Create;True;0;0;0;False;0;False;-1;c011093f005faaa4892c6f64e6b4c11b;c011093f005faaa4892c6f64e6b4c11b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;54;-3556.436,-3159.65;Inherit;False;AlphaMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;58;695.3536,-3033.889;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;57;459.4032,-2947.79;Inherit;False;-1;;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;70;451.7605,-3077.564;Inherit;False;68;Light Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;55;450.9094,-3204.446;Inherit;False;54;AlphaMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;116;458.5209,-2788.754;Inherit;False;115;Wind;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;106;-2267.518,-1120.116;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;107;-2050.518,-1127.116;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;110;-1810.731,-1118.112;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;112;-2285.392,-866.5334;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;113;-2065.392,-854.5334;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;105;-2533.049,-1143.404;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;117;-894.4067,-1152.598;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;115;-658.8388,-1141.036;Inherit;False;Wind;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalVertexDataNode;118;-1146.705,-1358.25;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;122;-1130.299,-1093.733;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;123;-1396.694,-867.4667;Inherit;False;Property;_WindStrength;WindStrength;9;0;Create;True;0;0;0;False;0;False;0.2;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;108;-2271.518,-997.1159;Inherit;False;Property;_WindTile;Wind Tile;7;0;Create;True;0;0;0;False;0;False;0.15;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;109;-1552.464,-1125.361;Inherit;True;Property;_Noise;Noise;6;0;Create;True;0;0;0;False;0;False;-1;09e44a1531ca44d4299453f9f1879301;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;114;-2287.392,-751.5334;Inherit;False;Property;_WIndScroll;WInd Scroll;8;0;Create;True;0;0;0;False;0;False;0.1;1;0;0;0;1;FLOAT;0
WireConnection;11;0;12;0
WireConnection;11;1;17;0
WireConnection;11;2;17;0
WireConnection;13;0;20;0
WireConnection;13;1;11;0
WireConnection;74;0;87;0
WireConnection;74;1;73;0
WireConnection;74;2;71;0
WireConnection;88;0;74;0
WireConnection;90;0;91;0
WireConnection;90;1;13;0
WireConnection;0;10;55;0
WireConnection;0;13;58;0
WireConnection;0;11;116;0
WireConnection;60;0;67;0
WireConnection;60;1;62;0
WireConnection;61;0;64;0
WireConnection;61;1;65;0
WireConnection;62;0;66;0
WireConnection;62;1;61;0
WireConnection;68;0;60;0
WireConnection;94;0;96;0
WireConnection;94;1;99;0
WireConnection;96;0;95;0
WireConnection;97;0;94;0
WireConnection;99;0;102;0
WireConnection;99;1;101;0
WireConnection;101;0;100;0
WireConnection;19;0;103;0
WireConnection;103;0;104;0
WireConnection;103;1;90;0
WireConnection;98;0;97;0
WireConnection;22;0;25;0
WireConnection;22;1;24;0
WireConnection;27;0;28;0
WireConnection;27;1;29;0
WireConnection;28;0;22;0
WireConnection;26;0;27;0
WireConnection;1;0;3;0
WireConnection;1;1;2;0
WireConnection;54;0;1;1
WireConnection;58;0;70;0
WireConnection;58;1;57;0
WireConnection;106;0;105;1
WireConnection;106;1;105;3
WireConnection;107;0;106;0
WireConnection;107;1;108;0
WireConnection;110;0;107;0
WireConnection;110;1;113;0
WireConnection;113;0;112;0
WireConnection;113;1;114;0
WireConnection;117;0;118;0
WireConnection;117;1;122;0
WireConnection;115;0;117;0
WireConnection;122;0;109;1
WireConnection;122;1;123;0
WireConnection;109;1;110;0
ASEEND*/
//CHKSM=C2E67A1C6D51CCA3BB4145550953093E88DC1A36