// Made with Amplify Shader Editor v1.9.2.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SH_Master"
{
	Properties
	{
		_ColorMain("ColorMain", Color) = (0,0,0,0)
		_ColorVar("ColorVar", Color) = (0,0,0,0)
		_ShadowColor("ShadowColor", Color) = (0.1603774,0.1603774,0.1603774,0)
		_ColorMask("ColorMask", Float) = 0
		_ColorPower("ColorPower", Float) = 0
		_ColorRamp("ColorRamp", 2D) = "white" {}
		_Nomralmap("Nomral map", 2D) = "bump" {}
		_NormalStrength("NormalStrength", Float) = 1
		_Tile1("Tile", Float) = 1
		_RimColor("Rim Color", Color) = (0,0.9809995,1,0)
		_Rim_Offset("Rim_Offset", Float) = 1
		_RimPower("Rim Power", Range( 0 , 1)) = 0
		_SpecArea("Spec Area", Range( 0 , 1)) = 0.33
		_SpecOpacity("Spec Opacity", Range( 0 , 1)) = 0.5
		_SpecTransition("Spec Transition", Range( 0 , 1)) = 0
		_TotalynotSpeccolor("Totaly not Spec color", Color) = (1,0.7122642,0.7122642,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
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

		uniform float4 _ShadowColor;
		uniform sampler2D _Nomralmap;
		uniform float _Tile1;
		uniform float _ColorMask;
		uniform float _ColorPower;
		uniform float4 _ColorMain;
		uniform float4 _ColorVar;
		uniform sampler2D _ColorRamp;
		uniform float _NormalStrength;
		uniform float _Rim_Offset;
		uniform float _RimPower;
		uniform float4 _RimColor;
		uniform float _SpecArea;
		uniform float4 _TotalynotSpeccolor;
		uniform float _SpecTransition;
		uniform float _SpecOpacity;

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
			float2 temp_cast_0 = (_Tile1).xx;
			float2 uv_TexCoord69 = i.uv_texcoord * temp_cast_0;
			float3 tex2DNode71 = UnpackNormal( tex2D( _Nomralmap, uv_TexCoord69 ) );
			float TextureAlpha84 = tex2DNode71.b;
			float temp_output_192_0 = saturate( pow( ( ( 1.0 - TextureAlpha84 ) * _ColorMask ) , _ColorPower ) );
			float AlbedoAlpha213 = temp_output_192_0;
			float4 ShadowColor203 = saturate( ( ( 1.0 - ase_lightAtten ) * ( _ShadowColor * ( 1.0 - AlbedoAlpha213 ) ) ) );
			float4 lerpResult77 = lerp( _ColorMain , _ColorVar , temp_output_192_0);
			float4 Albedo86 = lerpResult77;
			float4 appendResult225 = (float4(( (tex2DNode71).xy * _NormalStrength ) , (tex2DNode71).z , 0.0));
			float4 NormalMap73 = appendResult225;
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = Unity_SafeNormalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult49 = dot( normalize( (WorldNormalVector( i , NormalMap73.xyz )) ) , ase_worldlightDir );
			float Normal_LightDir54 = ( max( dotResult49 , 0.0 ) * ase_lightAtten );
			float2 temp_cast_2 = ((Normal_LightDir54*0.5 + 0.5)).xx;
			float4 Shadow61 = ( ShadowColor203 + ( Albedo86 * tex2D( _ColorRamp, temp_cast_2 ) ) );
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			UnityGI gi100 = gi;
			float3 diffNorm100 = normalize( WorldNormalVector( i , NormalMap73.xyz ) );
			gi100 = UnityGI_Base( data, 1, diffNorm100 );
			float3 indirectDiffuse100 = gi100.indirect.diffuse + diffNorm100 * 0.0001;
			float4 Light_Color99 = ( Shadow61 * ( ase_lightColor * float4( ( indirectDiffuse100 + ase_lightAtten ) , 0.0 ) ) );
			float3 ase_worldViewDir = Unity_SafeNormalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float dotResult50 = dot( normalize( (WorldNormalVector( i , NormalMap73.xyz )) ) , ase_worldViewDir );
			float Fresnel_LightDir55 = dotResult50;
			float4 Rim114 = ( saturate( ( pow( ( 1.0 - saturate( ( _Rim_Offset + Fresnel_LightDir55 ) ) ) , _RimPower ) * ( Normal_LightDir54 * ase_lightAtten ) ) ) * ( ase_lightColor * _RimColor ) );
			float dotResult134 = dot( ( ase_worldViewDir + _WorldSpaceLightPos0.xyz ) , normalize( (WorldNormalVector( i , NormalMap73.xyz )) ) );
			float smoothstepResult137 = smoothstep( 1.1 , 1.12 , pow( dotResult134 , _SpecArea ));
			float4 lerpResult154 = lerp( _TotalynotSpeccolor , ase_lightColor , _SpecTransition);
			float4 Spec144 = ( ase_lightAtten * ( ( smoothstepResult137 * ( TextureAlpha84 * saturate( lerpResult154 ) ) ) * _SpecOpacity ) );
			c.rgb = ( ( Light_Color99 + Rim114 ) + Spec144 ).rgb;
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
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows 

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
Node;AmplifyShaderEditor.CommentaryNode;127;-3323.889,3533.607;Inherit;False;2060.51;998.4119;Comment;17;107;108;110;111;112;109;113;118;119;120;121;122;123;124;114;117;126;Rim;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;106;-3042.06,2748.309;Inherit;False;1405.516;455.7395;Comment;9;96;98;99;100;101;102;103;104;97;Light;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;88;-3085.398,674.7388;Inherit;False;1390.179;669.1792;Comment;12;86;105;78;81;80;83;77;192;193;194;195;213;Albedo;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;74;-7500.658,1641.956;Inherit;False;2026.708;534.1907;Comment;11;72;71;84;73;70;69;220;222;224;225;226;Normal Map;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;68;-3055.904,1847.476;Inherit;False;1752.588;600.1989;Comment;10;90;61;63;65;89;59;57;64;205;207;Shadow;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;67;-4768.288,1846.468;Inherit;False;1073.892;451.8376;Comment;5;75;55;50;51;52;View Dir;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;66;-5869.662,441.1867;Inherit;False;1699.939;484.432;Comment;10;170;169;162;163;47;48;54;76;49;191;Normal Dir;1,1,1,1;0;0
Node;AmplifyShaderEditor.DotProductOpNode;49;-5234.502,620.3876;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;52;-4446.866,2131.47;Inherit;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;51;-4447.866,1896.468;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;50;-4110.523,1991.547;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;55;-3936.396,1991.412;Inherit;False;Fresnel LightDir;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;64;-2680.238,2170.724;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;57;-3005.904,2084.361;Inherit;False;54;Normal LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;59;-2383.285,2138.234;Inherit;True;Property;_TextureSample0;Texture Sample 0;7;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;69;-7272.615,1691.956;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;70;-7450.658,1713.63;Inherit;False;Property;_Tile1;Tile;8;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;75;-4729.764,1925.562;Inherit;False;73;NormalMap;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;76;-5835.619,543.6898;Inherit;False;73;NormalMap;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;89;-1990.162,2125.976;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;81;-2739.618,1085.701;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;78;-2997.61,724.7388;Inherit;False;Property;_ColorMain;ColorMain;0;0;Create;True;0;0;0;False;0;False;0,0,0,0;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;105;-2995.247,893.6177;Inherit;False;Property;_ColorVar;ColorVar;1;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;96;-2363.913,2798.309;Inherit;False;61;Shadow;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;98;-2104.545,2861.862;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;99;-1878.543,2864.862;Inherit;False;Light Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;102;-2488.178,3021.049;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;103;-2992.06,2982.248;Inherit;False;73;NormalMap;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;104;-2329.399,2926.836;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LightColorNode;97;-2527.308,2861.216;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;107;-3273.889,3708.761;Inherit;False;55;Fresnel LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;108;-2968.471,3639.607;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;110;-2813.471,3635.607;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;111;-2605.5,3635.08;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;112;-2387.5,3633.08;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;109;-3195.471,3583.607;Inherit;False;Property;_Rim_Offset;Rim_Offset;10;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;113;-2713.5,3751.08;Inherit;False;Property;_RimPower;Rim Power;11;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;120;-2505.072,4228.018;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;121;-2810.469,3888.627;Inherit;False;54;Normal LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;122;-2532.575,3912.201;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;124;-2163.903,3638.404;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;114;-1505.379,3616.815;Inherit;False;Rim;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;117;-1729.77,3638.906;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;126;-1949.972,3645.373;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightAttenuation;123;-2810.575,3995.201;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;125;-388.8083,166.5121;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;151;-167.5858,286.602;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;145;-475.7711,407.9309;Inherit;False;144;Spec;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;119;-2757.072,4323.019;Inherit;False;Property;_RimColor;Rim Color;9;0;Create;True;0;0;0;False;0;False;0,0.9809995,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;62;-647.2548,127.3574;Inherit;False;99;Light Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;116;-654.3746,232.672;Inherit;False;114;Rim;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;48;-5536.017,676.0524;Inherit;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;47;-5539.149,491.1867;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;190;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;SH_Master;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;54;-4486.332,572.4518;Inherit;False;Normal LightDir;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;170;-4897.979,604.2152;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;169;-5041.979,605.2152;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMinOpNode;162;-4888.21,765.6386;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;191;-5107.733,727.1443;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;131;-3308.256,5320.829;Inherit;False;73;NormalMap;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;132;-2779.682,5094.503;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DotProductOpNode;134;-2577.682,5256.503;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;130;-3074.812,5324.162;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PowerNode;135;-2350.682,5255.503;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;137;-2132.682,5260.503;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;128;-3080.461,4971.403;Inherit;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;136;-2699.682,5398.503;Inherit;False;Property;_SpecArea;Spec Area;12;0;Create;True;0;0;0;False;0;False;0.33;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;140;-1192.514,5261.986;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;142;-872.2551,5238.465;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LightAttenuation;143;-1253.818,5145.534;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;144;-627.8176,5242.534;Inherit;False;Spec;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;141;-1516.136,5441.16;Inherit;False;Property;_SpecOpacity;Spec Opacity;13;0;Create;True;0;0;0;False;0;False;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;146;-1742.852,5264.476;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;154;-2110.041,6096.811;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;156;-1796.083,5864.633;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;157;-1918.223,6096.647;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;160;-2451.254,5994.573;Inherit;False;Property;_TotalynotSpeccolor;Totaly not Spec color;15;0;Create;True;0;0;0;False;0;False;1,0.7122642,0.7122642,0;1,0.7122642,0.7122642,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;138;-2351.682,5416.503;Inherit;False;Constant;_Min;Min;13;0;Create;True;0;0;0;False;0;False;1.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;139;-2354.682,5525.503;Inherit;False;Constant;_Max;Max;12;0;Create;True;0;0;0;False;0;False;1.12;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;153;-2352.918,6210.941;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;155;-2473.658,6374.941;Inherit;False;Property;_SpecTransition;Spec Transition;14;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;71;-6919.848,1882.044;Inherit;True;Property;_Paint_Normal_normal3;Paint_Normal_normal2;3;0;Create;True;0;0;0;False;0;False;-1;27a4d872bdeb2304ea08202862b0b96b;27a4d872bdeb2304ea08202862b0b96b;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;72;-7281.543,1884.356;Inherit;True;Property;_Nomralmap;Nomral map;6;0;Create;True;0;0;0;False;0;False;21d2d1626413cfe4db8957281f3e27d1;21d2d1626413cfe4db8957281f3e27d1;True;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;63;-2731.14,1897.476;Inherit;True;Property;_ColorRamp;ColorRamp;5;0;Create;True;0;0;0;False;0;False;91fbc20cdf5bae14e847975b917ada11;f24b20aa6f50abe42a4eaff6ff15da61;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.GetLocalVarNode;147;-2114.37,5868.442;Inherit;False;84;TextureAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;192;-2161.088,1084.011;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;193;-2345.736,1079.876;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;195;-2543.756,1079.868;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;80;-2942.208,1235.169;Inherit;False;Property;_ColorMask;ColorMask;3;0;Create;True;0;0;0;False;0;False;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;194;-2600.736,1234.876;Inherit;False;Property;_ColorPower;ColorPower;4;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.IndirectDiffuseLighting;100;-2761.683,2987.072;Inherit;False;Tangent;1;0;FLOAT3;0,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LightAttenuation;101;-2757.178,3091.049;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;118;-2736.072,4147.019;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.WorldSpaceLightPos;129;-3145.578,5163.217;Inherit;False;0;3;FLOAT4;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;90;-2263.162,1989.976;Inherit;False;86;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;197;-2543.97,-313.7194;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;61;-1554.436,2135.197;Inherit;False;Shadow;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;205;-1999.713,1980.927;Inherit;False;203;ShadowColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;207;-1750.466,2121.797;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;77;-2258.27,768.8062;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;86;-1980.755,776.6249;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;213;-1966.573,1082.347;Inherit;False;AlbedoAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;199;-3270.463,-137.3635;Inherit;False;Property;_ShadowColor;ShadowColor;2;0;Create;True;0;0;0;False;0;False;0.1603774,0.1603774,0.1603774,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;201;-2962.929,26.3819;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;214;-3321.644,133.8559;Inherit;False;213;AlbedoAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;215;-3118.745,125.7721;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;83;-3003.098,1133.521;Inherit;False;84;TextureAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightAttenuation;196;-3101.119,-416.2548;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;202;-2797.372,-355.4006;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightAttenuation;163;-5289.553,821.3375;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;206;-2335.456,-311.7067;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;203;-2126.94,-318.1596;Inherit;False;ShadowColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;65;-2936.238,2202.724;Inherit;False;Constant;_Offset;Offset;8;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;73;-5862.321,1807.174;Inherit;False;NormalMap;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;84;-6579.311,2080.834;Inherit;False;TextureAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;224;-6556.703,1821.856;Inherit;False;True;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;220;-6557.999,1944.295;Inherit;False;False;False;True;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;226;-6316.703,1815.856;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;225;-6116.703,1812.856;Inherit;False;FLOAT4;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;222;-6542.999,1729.295;Inherit;False;Property;_NormalStrength;NormalStrength;7;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
WireConnection;49;0;47;0
WireConnection;49;1;48;0
WireConnection;51;0;75;0
WireConnection;50;0;51;0
WireConnection;50;1;52;0
WireConnection;55;0;50;0
WireConnection;64;0;57;0
WireConnection;64;1;65;0
WireConnection;64;2;65;0
WireConnection;59;0;63;0
WireConnection;59;1;64;0
WireConnection;69;0;70;0
WireConnection;89;0;90;0
WireConnection;89;1;59;0
WireConnection;81;0;83;0
WireConnection;98;0;96;0
WireConnection;98;1;104;0
WireConnection;99;0;98;0
WireConnection;102;0;100;0
WireConnection;102;1;101;0
WireConnection;104;0;97;0
WireConnection;104;1;102;0
WireConnection;108;0;109;0
WireConnection;108;1;107;0
WireConnection;110;0;108;0
WireConnection;111;0;110;0
WireConnection;112;0;111;0
WireConnection;112;1;113;0
WireConnection;120;0;118;0
WireConnection;120;1;119;0
WireConnection;122;0;121;0
WireConnection;122;1;123;0
WireConnection;124;0;112;0
WireConnection;124;1;122;0
WireConnection;114;0;117;0
WireConnection;117;0;126;0
WireConnection;117;1;120;0
WireConnection;126;0;124;0
WireConnection;125;0;62;0
WireConnection;125;1;116;0
WireConnection;151;0;125;0
WireConnection;151;1;145;0
WireConnection;47;0;76;0
WireConnection;190;13;151;0
WireConnection;54;0;170;0
WireConnection;170;0;169;0
WireConnection;170;1;163;0
WireConnection;169;0;49;0
WireConnection;162;0;191;0
WireConnection;162;1;163;0
WireConnection;191;0;49;0
WireConnection;132;0;128;0
WireConnection;132;1;129;1
WireConnection;134;0;132;0
WireConnection;134;1;130;0
WireConnection;130;0;131;0
WireConnection;135;0;134;0
WireConnection;135;1;136;0
WireConnection;137;0;135;0
WireConnection;137;1;138;0
WireConnection;137;2;139;0
WireConnection;140;0;146;0
WireConnection;140;1;141;0
WireConnection;142;0;143;0
WireConnection;142;1;140;0
WireConnection;144;0;142;0
WireConnection;146;0;137;0
WireConnection;146;1;156;0
WireConnection;154;0;160;0
WireConnection;154;1;153;0
WireConnection;154;2;155;0
WireConnection;156;0;147;0
WireConnection;156;1;157;0
WireConnection;157;0;154;0
WireConnection;71;0;72;0
WireConnection;71;1;69;0
WireConnection;192;0;193;0
WireConnection;193;0;195;0
WireConnection;193;1;194;0
WireConnection;195;0;81;0
WireConnection;195;1;80;0
WireConnection;100;0;103;0
WireConnection;197;0;202;0
WireConnection;197;1;201;0
WireConnection;61;0;207;0
WireConnection;207;0;205;0
WireConnection;207;1;89;0
WireConnection;77;0;78;0
WireConnection;77;1;105;0
WireConnection;77;2;192;0
WireConnection;86;0;77;0
WireConnection;213;0;192;0
WireConnection;201;0;199;0
WireConnection;201;1;215;0
WireConnection;215;0;214;0
WireConnection;202;0;196;0
WireConnection;206;0;197;0
WireConnection;203;0;206;0
WireConnection;73;0;225;0
WireConnection;84;0;71;3
WireConnection;224;0;71;0
WireConnection;220;0;71;0
WireConnection;226;0;224;0
WireConnection;226;1;222;0
WireConnection;225;0;226;0
WireConnection;225;2;220;0
ASEEND*/
//CHKSM=3CD2D6926C9E051ACF833FBA43184900D9970CA4