// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Wigle"
{
	Properties
	{
		_ColorMain("ColorMain", Color) = (0.6195449,0.8207547,0.4142489,0)
		_ColorVar("ColorVar", Color) = (0.4205026,0.6226415,0.2144001,0)
		_ShadowColor("ShadowColor", Color) = (0.09952859,0.02055892,0.2075472,0)
		_ColorRamp("ColorRamp", 2D) = "white" {}
		_TimeSpeed("TimeSpeed", Float) = 1
		_WaveAmount("WaveAmount", Float) = 5
		_Mask("Mask", 2D) = "white" {}
		_WaveIntensity("WaveIntensity", Float) = 0.5
		_Tile("Tile", Vector) = (1,1,0,0)
		_AnchorsPointsStrength("AnchorsPointsStrength", Range( 0 , 1)) = 0
		_AnchorcoordL("Anchor coordL", Vector) = (0,0,0,0)
		_AnchorcoordR("Anchor coordR", Vector) = (0,0,0,0)
		[Toggle(_ALBEDO_ON)] _Albedo("Albedo", Float) = 0
		_AlbedoTexture("Albedo Texture", 2D) = "white" {}
		_AlbedoMapTint("AlbedoMapTint", Color) = (1,1,1,0)
		_TimeOfset("TimeOfset", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _ALBEDO_ON
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
			float2 uv_texcoord;
			float3 worldNormal;
			INTERNAL_DATA
			float3 worldPos;
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

		uniform float3 _AnchorcoordL;
		uniform float3 _AnchorcoordR;
		uniform float _AnchorsPointsStrength;
		uniform float _TimeSpeed;
		uniform float _TimeOfset;
		uniform float _WaveAmount;
		uniform float _WaveIntensity;
		uniform float4 _ShadowColor;
		uniform sampler2D _Mask;
		uniform float2 _Tile;
		uniform float4 _ColorVar;
		uniform float4 _ColorMain;
		uniform sampler2D _AlbedoTexture;
		uniform float4 _AlbedoTexture_ST;
		uniform float4 _AlbedoMapTint;
		uniform sampler2D _ColorRamp;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float lerpResult80 = lerp( ( ( ( 1.0 - v.texcoord.xy.y ) * v.texcoord.xy.y ) * 4.0 ) , 1.0 , _AnchorsPointsStrength);
			float Time109 = ( ( _Time.y * _TimeSpeed ) + _TimeOfset );
			float3 appendResult81 = (float3(_WaveIntensity , 0.0 , 0.0));
			float3 Sine105 = ( ( ( v.texcoord.xy.y * _AnchorcoordL ) + ( v.texcoord.xy.y * _AnchorcoordR ) ) + ( ( lerpResult80 * cos( ( ( ( ( v.texcoord.xy.y * 2.0 ) - 1.0 ) + Time109 ) * _WaveAmount ) ) ) * appendResult81 ) );
			v.vertex.xyz += Sine105;
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
			float2 uv_TexCoord121 = i.uv_texcoord * _Tile;
			float AlphaMask125 = tex2D( _Mask, uv_TexCoord121 ).r;
			float4 ShadowColor42 = saturate( ( ( 1.0 - ase_lightAtten ) * ( _ShadowColor * ( 1.0 - AlphaMask125 ) ) ) );
			float4 lerpResult53 = lerp( _ColorVar , _ColorMain , AlphaMask125);
			float2 uv_AlbedoTexture = i.uv_texcoord * _AlbedoTexture_ST.xy + _AlbedoTexture_ST.zw;
			float4 tex2DNode54 = tex2D( _AlbedoTexture, uv_AlbedoTexture );
			float4 lerpResult57 = lerp( tex2DNode54 , ( tex2DNode54 * _AlbedoMapTint ) , AlphaMask125);
			#ifdef _ALBEDO_ON
				float4 staticSwitch61 = lerpResult57;
			#else
				float4 staticSwitch61 = lerpResult53;
			#endif
			float4 Albedo60 = staticSwitch61;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_normWorldNormal = normalize( ase_worldNormal );
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = Unity_SafeNormalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult17 = dot( ase_normWorldNormal , ase_worldlightDir );
			float Normal_LightDir22 = ( max( dotResult17 , 0.0 ) * ase_lightAtten );
			float2 temp_cast_0 = ((Normal_LightDir22*0.49 + 0.49)).xx;
			float4 Shadow30 = ( ShadowColor42 + ( Albedo60 * tex2D( _ColorRamp, temp_cast_0 ) ) );
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			UnityGI gi118 = gi;
			float3 diffNorm118 = ase_normWorldNormal;
			gi118 = UnityGI_Base( data, 1, diffNorm118 );
			float3 indirectDiffuse118 = gi118.indirect.diffuse + diffNorm118 * 0.0001;
			float4 Light_Color27 = ( Shadow30 * ( ase_lightColor * float4( ( indirectDiffuse118 + ase_lightAtten ) , 0.0 ) ) );
			c.rgb = Light_Color27.rgb;
			c.a = 1;
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
Version=19202
Node;AmplifyShaderEditor.CommentaryNode;1;-2446.021,1884.466;Inherit;False;1035.204;280.7351;Comment;6;111;110;109;108;98;97;Time;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;3;-2430.835,665.7784;Inherit;False;3038.508;1031.419;Comment;24;105;102;99;96;95;93;92;90;89;88;81;80;79;77;76;75;74;73;72;69;67;65;64;63;Sine;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;4;-4900.984,-1168.514;Inherit;False;1452.284;471.9102;Comment;7;22;21;20;19;18;17;116;Normal Dir;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;5;-3172.986,-3504.514;Inherit;False;1939.463;889.946;Comment;11;61;60;59;58;57;56;55;54;53;36;35;Albedo;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;6;-3124.986,-1248.514;Inherit;False;1710.016;600.6762;Comment;10;48;47;43;34;33;32;31;30;29;28;Shadow;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;7;-3012.986,-368.5137;Inherit;False;1195.711;451.7809;Comment;8;46;27;26;25;24;23;118;119;Light;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;8;-4548.985,-2224.514;Inherit;False;1486.704;713.1107;Comment;9;52;42;41;38;37;117;126;127;128;ShadowColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.DotProductOpNode;17;-4516.985,-992.5135;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;18;-4324.984,-1008.513;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-2292.985,-240.5137;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;24;-2676.986,-80.51367;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-2516.985,-176.5137;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LightColorNode;26;-2708.986,-240.5137;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.RegisterLocalVarNode;27;-2068.985,-240.5137;Inherit;False;Light Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;30;-1636.985,-976.5135;Inherit;False;Shadow;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;33;-2772.986,-928.5135;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-3028.986,-880.5135;Inherit;False;Constant;_Offset;Offset;8;0;Create;True;0;0;0;False;0;False;0.49;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;35;-2452.986,-3456.514;Inherit;False;Property;_ColorMain;ColorMain;0;0;Create;True;0;0;0;False;0;False;0.6195449,0.8207547,0.4142489,0;0.6195449,0.8207547,0.4142489,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;36;-2436.986,-3280.514;Inherit;False;Property;_ColorVar;ColorVar;1;0;Create;True;0;0;0;False;0;False;0.4205026,0.6226415,0.2144001,0;0.6195449,0.8207547,0.4142489,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-3716.986,-2064.514;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;38;-3508.986,-2064.514;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;41;-4420.984,-1984.514;Inherit;False;Property;_ShadowColor;ShadowColor;2;0;Create;True;0;0;0;False;0;False;0.09952859,0.02055892,0.2075472,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;42;-3300.986,-2064.514;Inherit;False;ShadowColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;52;-3972.986,-2112.514;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;53;-2020.985,-3328.514;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;54;-2772.986,-3008.514;Inherit;True;Property;_Pot_Low_DefaultMaterial_Albedo;Pot_Low_DefaultMaterial_Albedo;18;0;Create;True;0;0;0;False;0;False;-1;7cc3c654cf391a74da218d6c778164be;7cc3c654cf391a74da218d6c778164be;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-2308.985,-2976.514;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0.8113208,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;56;-2692.986,-2800.514;Inherit;False;Property;_AlbedoMapTint;AlbedoMapTint;14;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;57;-2020.985,-3088.514;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;59;-3124.986,-2992.514;Inherit;True;Property;_AlbedoTexture;Albedo Texture;13;0;Create;True;0;0;0;False;0;False;f19eb64044b7dc54f9a3aea87d11a8d9;7cc3c654cf391a74da218d6c778164be;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RegisterLocalVarNode;60;-1524.986,-3216.514;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;61;-1780.985,-3216.514;Inherit;False;Property;_Albedo;Albedo;12;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;63;-1516.29,1191.389;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;-1314.462,1197.172;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;-855.1747,1015.061;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CosOpNode;67;-1119.816,1151.663;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;-494.4717,1016.136;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;72;-1479.18,722.7365;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;73;-1811.959,1085.466;Inherit;False;Property;_AnchorsPointsStrength;AnchorsPointsStrength;9;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;74;-1475.57,827.9395;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;75;-1228.121,775.9054;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;76;-2236.102,726.9094;Inherit;False;Property;_AnchorcoordL;Anchor coordL;10;0;Create;True;0;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;77;-2236.554,874.8054;Inherit;False;Property;_AnchorcoordR;Anchor coordR;11;0;Create;True;0;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;79;-175.3429,934.5845;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;80;-1490.805,947.7765;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;81;-848.7697,1300.394;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;88;-2010.088,941.7655;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;89;-1817.387,939.4084;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;90;-1655.731,939.4135;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;92;-1745.495,1192.672;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;93;-1956.322,1192.3;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;96;-1551.8,1368.161;Inherit;False;Property;_WaveAmount;WaveAmount;5;0;Create;True;0;0;0;False;0;False;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;97;-2135.221,1964.865;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;98;-2396.021,1934.465;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;99;-1800.208,1350.576;Inherit;False;109;Time;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;102;-1193.478,1400.86;Inherit;False;Property;_WaveIntensity;WaveIntensity;7;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;105;195.0674,935.7584;Inherit;False;Sine;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;108;-2377.196,2048.028;Inherit;False;Property;_TimeSpeed;TimeSpeed;4;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;110;-1850.687,1964.216;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;111;-2084.333,2076.866;Inherit;False;Property;_TimeOfset;TimeOfset;15;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;28;-2804.986,-1200.514;Inherit;True;Property;_ColorRamp;ColorRamp;3;0;Create;True;0;0;0;False;0;False;4378651f2ed612e4abe5216810ad3d61;f24b20aa6f50abe42a4eaff6ff15da61;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-2036.985,-992.5135;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;31;-1796.985,-992.5135;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;32;-2436.986,-960.5135;Inherit;True;Property;_TextureSample0;Texture Sample 0;7;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;594.3772,-888.345;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Wigle;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;109;-1622.568,1978.55;Inherit;False;Time;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;11;237.0147,-668.5135;Inherit;False;27;Light Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;46;-2548.985,-304.5137;Inherit;False;30;Shadow;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;47;-2020.985,-1104.513;Inherit;False;42;ShadowColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;48;-2260.985,-1104.513;Inherit;False;60;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;43;-3044.986,-1024.513;Inherit;False;22;Normal LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;19;-4820.984,-928.5135;Inherit;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;20;-4820.984,-1120.514;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-4124.711,-1001.645;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;22;-3890.359,-991.0101;Inherit;False;Normal LightDir;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightAttenuation;116;-4466.354,-834.2909;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.LightAttenuation;117;-4250.832,-2133.074;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.IndirectDiffuseLighting;118;-2955.359,-150.2846;Inherit;False;Tangent;1;0;FLOAT3;0,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LightAttenuation;119;-2955.359,-38.28429;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;120;-4734.29,-375.5408;Inherit;False;1290.836;447.2415;Comment;5;125;124;123;122;121;Alpha Mask;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;121;-4398.29,-327.5408;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;122;-4398.29,-151.5409;Inherit;True;Property;_Mask;Mask;6;0;Create;True;0;0;0;False;0;False;4bb2ed5cf0c9cfa4c9deb0ca14b1e966;c011093f005faaa4892c6f64e6b4c11b;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;123;-4046.292,-215.5408;Inherit;True;Property;_FoliageV1;FoliageV1;1;0;Create;True;0;0;0;False;0;False;-1;c011093f005faaa4892c6f64e6b4c11b;c011093f005faaa4892c6f64e6b4c11b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;124;-4654.291,-295.5408;Inherit;False;Property;_Tile;Tile;8;0;Create;True;0;0;0;False;0;False;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;126;-4024.627,-1859.225;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;127;-4220.69,-1724.317;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;128;-4428.691,-1724.317;Inherit;False;125;AlphaMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;125;-3688.749,-183.5408;Inherit;False;AlphaMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;58;-2420.986,-3088.514;Inherit;False;125;AlphaMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;16;251.0147,-496.5136;Inherit;False;105;Sine;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;95;-2294.801,1103.959;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
WireConnection;17;0;20;0
WireConnection;17;1;19;0
WireConnection;18;0;17;0
WireConnection;23;0;46;0
WireConnection;23;1;25;0
WireConnection;24;0;118;0
WireConnection;24;1;119;0
WireConnection;25;0;26;0
WireConnection;25;1;24;0
WireConnection;27;0;23;0
WireConnection;30;0;31;0
WireConnection;33;0;43;0
WireConnection;33;1;34;0
WireConnection;33;2;34;0
WireConnection;37;0;52;0
WireConnection;37;1;126;0
WireConnection;38;0;37;0
WireConnection;42;0;38;0
WireConnection;52;0;117;0
WireConnection;53;0;36;0
WireConnection;53;1;35;0
WireConnection;53;2;58;0
WireConnection;54;0;59;0
WireConnection;55;0;54;0
WireConnection;55;1;56;0
WireConnection;57;0;54;0
WireConnection;57;1;55;0
WireConnection;57;2;58;0
WireConnection;60;0;61;0
WireConnection;61;1;53;0
WireConnection;61;0;57;0
WireConnection;63;0;92;0
WireConnection;63;1;99;0
WireConnection;64;0;63;0
WireConnection;64;1;96;0
WireConnection;65;0;80;0
WireConnection;65;1;67;0
WireConnection;67;0;64;0
WireConnection;69;0;65;0
WireConnection;69;1;81;0
WireConnection;72;0;95;2
WireConnection;72;1;76;0
WireConnection;74;0;95;2
WireConnection;74;1;77;0
WireConnection;75;0;72;0
WireConnection;75;1;74;0
WireConnection;79;0;75;0
WireConnection;79;1;69;0
WireConnection;80;0;90;0
WireConnection;80;2;73;0
WireConnection;81;0;102;0
WireConnection;88;0;95;2
WireConnection;89;0;88;0
WireConnection;89;1;95;2
WireConnection;90;0;89;0
WireConnection;92;0;93;0
WireConnection;93;0;95;2
WireConnection;97;0;98;0
WireConnection;97;1;108;0
WireConnection;105;0;79;0
WireConnection;110;0;97;0
WireConnection;110;1;111;0
WireConnection;29;0;48;0
WireConnection;29;1;32;0
WireConnection;31;0;47;0
WireConnection;31;1;29;0
WireConnection;32;0;28;0
WireConnection;32;1;33;0
WireConnection;0;13;11;0
WireConnection;0;11;16;0
WireConnection;109;0;110;0
WireConnection;21;0;18;0
WireConnection;21;1;116;0
WireConnection;22;0;21;0
WireConnection;121;0;124;0
WireConnection;123;0;122;0
WireConnection;123;1;121;0
WireConnection;126;0;41;0
WireConnection;126;1;127;0
WireConnection;127;0;128;0
WireConnection;125;0;123;1
ASEEND*/
//CHKSM=30C2217AB195A4E472608526ABDC4DE0CA228B86