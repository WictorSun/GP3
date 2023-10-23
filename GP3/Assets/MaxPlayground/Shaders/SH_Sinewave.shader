// Made with Amplify Shader Editor v1.9.2.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SH_Sinewave"
{
	Properties
	{
		_WaveDirection("WaveDirection", Vector) = (0.5,0,0,0)
		_Mask("Mask", 2D) = "white" {}
		_TimeAdj("TimeAdj", Float) = 1
		_ColorRamp("ColorRamp", 2D) = "white" {}
		_ShadowColor("ShadowColor", Color) = (0.09952859,0.02055892,0.2075472,0)
		_WaveAmount("WaveAmount", Float) = 5
		_ColorMain("ColorMain", Color) = (0.6195449,0.8207547,0.4142489,0)
		_ColorVar("ColorVar", Color) = (0.4205026,0.6226415,0.2144001,0)
		_Tile("Tile", Vector) = (1,1,0,0)
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

		uniform float _TimeAdj;
		uniform float _WaveAmount;
		uniform float3 _WaveDirection;
		uniform float4 _ShadowColor;
		uniform sampler2D _Mask;
		uniform float2 _Tile;
		uniform float4 _ColorVar;
		uniform float4 _ColorMain;
		uniform sampler2D _ColorRamp;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 Sine164 = ( ( ( 1.0 - v.texcoord.xy.y ) * sin( ( ( ( ( v.texcoord.xy.y * 2.0 ) - 1.0 ) + ( _Time.y / _TimeAdj ) ) * _WaveAmount ) ) ) * _WaveDirection );
			v.vertex.xyz += Sine164;
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
			float2 uv_TexCoord212 = i.uv_texcoord * _Tile;
			float AlphaMask215 = tex2D( _Mask, uv_TexCoord212 ).r;
			float4 ShadowColor200 = saturate( ( ( 1.0 - ase_lightAtten ) * ( _ShadowColor * ( 1.0 - AlphaMask215 ) ) ) );
			float4 lerpResult187 = lerp( _ColorVar , _ColorMain , AlphaMask215);
			float4 Albedo190 = lerpResult187;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_normWorldNormal = normalize( ase_worldNormal );
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = Unity_SafeNormalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult168 = dot( ase_normWorldNormal , ase_worldlightDir );
			float Normal_LightDir174 = ( max( dotResult168 , 0.0 ) * ase_lightAtten );
			float2 temp_cast_0 = ((Normal_LightDir174*0.49 + 0.49)).xx;
			float4 Shadow204 = ( ShadowColor200 + ( Albedo190 * tex2D( _ColorRamp, temp_cast_0 ) ) );
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			UnityGI gi184 = gi;
			float3 diffNorm184 = ase_normWorldNormal;
			gi184 = UnityGI_Base( data, 1, diffNorm184 );
			float3 indirectDiffuse184 = gi184.indirect.diffuse + diffNorm184 * 0.0001;
			float4 Light_Color182 = ( Shadow204 * ( ase_lightColor * float4( ( indirectDiffuse184 + ase_lightAtten ) , 0.0 ) ) );
			c.rgb = ( Light_Color182 + (0) ).rgb;
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
Version=19201
Node;AmplifyShaderEditor.CommentaryNode;165;-4946.32,1093.146;Inherit;False;2037.673;609.104;Comment;15;164;15;9;12;11;20;4;28;27;8;26;7;22;24;25;Sine;1,1,1,1;0;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;SH_Sinewave;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.GetLocalVarNode;166;-323.0956,295.8444;Inherit;False;164;Sine;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;164;-3150.647,1246.697;Inherit;False;Sine;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-3337.397,1248.321;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;9;-4896.32,1266.231;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-4608.864,1316.012;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;11;-4416.589,1319.765;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;20;-4151.83,1335.1;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;4;-4661.137,1465.387;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-3645.685,1143.146;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;8;-3759.122,1342.53;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-4642.313,1578.95;Inherit;False;Property;_TimeAdj;TimeAdj;2;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;22;-4383.771,1467.291;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-3950.003,1340.883;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-4175.311,1482.95;Inherit;False;Property;_WaveAmount;WaveAmount;5;0;Create;True;0;0;0;False;0;False;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;167;-5680.793,-606.1997;Inherit;False;1452.284;471.9102;Comment;7;174;173;172;171;170;169;168;Normal Dir;1,1,1,1;0;0
Node;AmplifyShaderEditor.DotProductOpNode;168;-5296.799,-430.1989;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;169;-5104.798,-446.1987;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;170;-5600.792,-366.1992;Inherit;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LightAttenuation;171;-5296.799,-286.1996;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;172;-5600.792,-558.1993;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;173;-4803.536,-393.1437;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;174;-4503.544,-369.0732;Inherit;False;Normal LightDir;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;175;-3218.821,-1393.408;Inherit;False;957.8248;580.8926;Comment;5;197;190;189;188;187;Albedo;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;176;-3901.794,-680.1932;Inherit;False;1710.016;600.6762;Comment;10;210;209;208;207;206;205;204;203;202;201;Shadow;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;177;-3793.33,208.1345;Inherit;False;1195.711;451.7809;Comment;8;185;184;183;182;181;180;179;178;Light;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;178;-3065.616,321.6875;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;179;-3449.25,480.8745;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;180;-3290.47,386.6605;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LightColorNode;181;-3488.38,321.0415;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.RegisterLocalVarNode;182;-2839.614,324.6875;Inherit;False;Light Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.IndirectDiffuseLighting;184;-3722.757,446.8976;Inherit;False;Tangent;1;0;FLOAT3;0,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LightAttenuation;185;-3718.252,550.8745;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;186;-3650.824,-2417.411;Inherit;False;1486.704;713.1107;Comment;9;200;199;198;196;195;194;193;192;191;ShadowColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;201;-3577.031,-630.1932;Inherit;True;Property;_ColorRamp;ColorRamp;3;0;Create;True;0;0;0;False;0;False;4378651f2ed612e4abe5216810ad3d61;f24b20aa6f50abe42a4eaff6ff15da61;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;202;-2806.543,-415.9852;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;204;-2411.24,-408.9193;Inherit;False;Shadow;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;205;-2579.519,-418.2872;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;207;-3205.302,-392.4701;Inherit;True;Property;_TextureSample0;Texture Sample 0;7;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScaleAndOffsetNode;208;-3546.869,-352.4413;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;210;-3804.083,-312.2672;Inherit;False;Constant;_Offset;Offset;8;0;Create;True;0;0;0;False;0;False;0.49;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;187;-2738.821,-1217.409;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;188;-3170.821,-1345.409;Inherit;False;Property;_ColorMain;ColorMain;6;0;Create;True;0;0;0;False;0;False;0.6195449,0.8207547,0.4142489,0;0.6195449,0.8207547,0.4142489,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;189;-3154.82,-1169.409;Inherit;False;Property;_ColorVar;ColorVar;7;0;Create;True;0;0;0;False;0;False;0.4205026,0.6226415,0.2144001,0;0.6195449,0.8207547,0.4142489,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;190;-2514.821,-1217.409;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;191;-2818.821,-2257.411;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LightAttenuation;192;-3378.823,-2369.411;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;193;-3074.82,-2305.411;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;194;-2610.821,-2257.411;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;195;-3218.821,-2017.411;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;196;-3362.823,-1905.409;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;199;-3522.824,-2177.411;Inherit;False;Property;_ShadowColor;ShadowColor;4;0;Create;True;0;0;0;False;0;False;0.09952859,0.02055892,0.2075472,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;200;-2402.821,-2257.411;Inherit;False;ShadowColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;209;-3827.024,-461.4713;Inherit;False;174;Normal LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;211;-5486.167,186.7623;Inherit;False;1280.616;454.9784;Comment;5;219;214;213;215;212;Alpha Mask;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;212;-5151.134,236.7622;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;215;-4447.553,369.9774;Inherit;False;AlphaMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;197;-3122.82,-945.4093;Inherit;False;215;AlphaMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;198;-3570.824,-1905.409;Inherit;False;215;AlphaMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;183;-3324.984,258.1345;Inherit;False;204;Shadow;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;206;-2798.082,-543.1803;Inherit;False;200;ShadowColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;203;-3036.346,-535.2972;Inherit;False;190;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;213;-5146.158,414.7715;Inherit;True;Property;_Mask;Mask;1;0;Create;True;0;0;0;False;0;False;4bb2ed5cf0c9cfa4c9deb0ca14b1e966;c011093f005faaa4892c6f64e6b4c11b;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;214;-4794.583,345.8252;Inherit;True;Property;_FoliageV1;FoliageV1;1;0;Create;True;0;0;0;False;0;False;-1;c011093f005faaa4892c6f64e6b4c11b;c011093f005faaa4892c6f64e6b4c11b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;216;-297.8574,146.4849;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;217;-533.8078,232.5837;Inherit;False;-1;;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;218;-541.4505,102.8098;Inherit;False;182;Light Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;219;-5410.394,259.7905;Inherit;False;Property;_Tile;Tile;8;0;Create;True;0;0;0;False;0;False;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector3Node;7;-3584.408,1517.249;Inherit;False;Property;_WaveDirection;WaveDirection;0;0;Create;True;0;0;0;False;0;False;0.5,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.OneMinusNode;28;-4578.436,1147.922;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
WireConnection;0;13;216;0
WireConnection;0;11;166;0
WireConnection;164;0;15;0
WireConnection;15;0;27;0
WireConnection;15;1;7;0
WireConnection;12;0;9;2
WireConnection;11;0;12;0
WireConnection;20;0;11;0
WireConnection;20;1;22;0
WireConnection;27;0;28;0
WireConnection;27;1;8;0
WireConnection;8;0;24;0
WireConnection;22;0;4;0
WireConnection;22;1;26;0
WireConnection;24;0;20;0
WireConnection;24;1;25;0
WireConnection;168;0;172;0
WireConnection;168;1;170;0
WireConnection;169;0;168;0
WireConnection;173;0;169;0
WireConnection;173;1;171;0
WireConnection;174;0;173;0
WireConnection;178;0;183;0
WireConnection;178;1;180;0
WireConnection;179;0;184;0
WireConnection;179;1;185;0
WireConnection;180;0;181;0
WireConnection;180;1;179;0
WireConnection;182;0;178;0
WireConnection;202;0;203;0
WireConnection;202;1;207;0
WireConnection;204;0;205;0
WireConnection;205;0;206;0
WireConnection;205;1;202;0
WireConnection;207;0;201;0
WireConnection;207;1;208;0
WireConnection;208;0;209;0
WireConnection;208;1;210;0
WireConnection;208;2;210;0
WireConnection;187;0;189;0
WireConnection;187;1;188;0
WireConnection;187;2;197;0
WireConnection;190;0;187;0
WireConnection;191;0;193;0
WireConnection;191;1;195;0
WireConnection;193;0;192;0
WireConnection;194;0;191;0
WireConnection;195;0;199;0
WireConnection;195;1;196;0
WireConnection;196;0;198;0
WireConnection;200;0;194;0
WireConnection;212;0;219;0
WireConnection;215;0;214;1
WireConnection;214;0;213;0
WireConnection;214;1;212;0
WireConnection;216;0;218;0
WireConnection;216;1;217;0
WireConnection;28;0;9;2
ASEEND*/
//CHKSM=B56878478C36F3ABEEECD666F22D556D4392535F