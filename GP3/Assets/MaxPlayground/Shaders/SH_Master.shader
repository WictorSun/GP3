// Made with Amplify Shader Editor v1.9.2.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SH_Master"
{
	Properties
	{
		_ColorMain("ColorMain", Color) = (0.8396226,0.003960493,0.003960493,0)
		_ColorVar("ColorVar", Color) = (0.6132076,0.130162,0.130162,1)
		_ShadowColor("ShadowColor", Color) = (0.1603774,0.1603774,0.1603774,0)
		_ColorMask("ColorMask", Float) = 0.75
		_ColorPower("ColorPower", Float) = 0.6
		_ColorRamp("ColorRamp", 2D) = "white" {}
		_Alpha("Alpha", 2D) = "white" {}
		_Normalmap("Normal map", 2D) = "bump" {}
		_Tile("Tile", Vector) = (1,1,0,0)
		_NormalStrength("NormalStrength", Float) = 1
		_RimColor("Rim Color", Color) = (1,0.3820755,0.3820755,1)
		_Rim_Offset("Rim_Offset", Float) = 0.75
		_RimPower("Rim Power", Range( 0 , 1)) = 0.5
		_SpecArea("Spec Area", Range( 0 , 1)) = 0.16
		_SpecOpacity("Spec Opacity", Range( 0 , 1)) = 0
		_SpecTransition("Spec Transition", Range( 0 , 1)) = 0.3
		_TotalynotSpeccolor("Totaly not Spec color", Color) = (0.5764706,1,0,1)
		_BakedNormalMap("Baked Normal Map", 2D) = "bump" {}
		[Toggle(_BAKESWITCH_ON)] _BakeSwitch("Bake Switch", Float) = 0
		_AlbedoTexture("Albedo Texture", 2D) = "white" {}
		_AlbedoMapTint("AlbedoMapTint", Color) = (1,1,1,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityStandardUtils.cginc"
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _BAKESWITCH_ON
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
			float3 worldNormal;
			INTERNAL_DATA
			float2 uv_texcoord;
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

		uniform sampler2D _ColorRamp;
		uniform sampler2D _Normalmap;
		uniform float2 _Tile;
		uniform float _NormalStrength;
		uniform sampler2D _BakedNormalMap;
		uniform float4 _BakedNormalMap_ST;
		uniform float4 _ShadowColor;
		uniform sampler2D _Alpha;
		uniform float _ColorMask;
		uniform float _ColorPower;
		uniform float4 _ColorMain;
		uniform float4 _ColorVar;
		uniform sampler2D _AlbedoTexture;
		uniform float4 _AlbedoTexture_ST;
		uniform float4 _AlbedoMapTint;
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
			float2 uv_TexCoord69 = i.uv_texcoord * _Tile;
			float3 tex2DNode71 = UnpackNormal( tex2D( _Normalmap, uv_TexCoord69 ) );
			float4 appendResult225 = (float4(( (tex2DNode71).xy * _NormalStrength ) , (tex2DNode71).z , 0.0));
			float2 uv_BakedNormalMap = i.uv_texcoord * _BakedNormalMap_ST.xy + _BakedNormalMap_ST.zw;
			#ifdef _BAKESWITCH_ON
				float4 staticSwitch239 = float4( BlendNormals( appendResult225.xyz , UnpackNormal( tex2D( _BakedNormalMap, uv_BakedNormalMap ) ) ) , 0.0 );
			#else
				float4 staticSwitch239 = appendResult225;
			#endif
			float4 NormalMap73 = staticSwitch239;
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = Unity_SafeNormalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult49 = dot( normalize( (WorldNormalVector( i , NormalMap73.xyz )) ) , ase_worldlightDir );
			float Normal_LightDir54 = ( max( dotResult49 , 0.0 ) * ase_lightAtten );
			float2 temp_cast_3 = ((Normal_LightDir54*0.49 + 0.49)).xx;
			float4 tex2DNode59 = tex2D( _ColorRamp, temp_cast_3 );
			float4 ShadowMask259 = tex2DNode59;
			float TextureAlpha84 = tex2D( _Alpha, uv_TexCoord69 ).r;
			float temp_output_192_0 = saturate( pow( ( ( 1.0 - TextureAlpha84 ) * _ColorMask ) , _ColorPower ) );
			float AlbedoAlpha213 = temp_output_192_0;
			float4 ShadowColor203 = saturate( ( ( 1.0 - ( ase_lightAtten * ShadowMask259 ) ) * ( _ShadowColor * ( 1.0 - AlbedoAlpha213 ) ) ) );
			float4 lerpResult77 = lerp( _ColorMain , _ColorVar , temp_output_192_0);
			float2 uv_AlbedoTexture = i.uv_texcoord * _AlbedoTexture_ST.xy + _AlbedoTexture_ST.zw;
			float4 tex2DNode241 = tex2D( _AlbedoTexture, uv_AlbedoTexture );
			float4 lerpResult245 = lerp( tex2DNode241 , ( tex2DNode241 * _AlbedoMapTint ) , temp_output_192_0);
			#ifdef _BAKESWITCH_ON
				float4 staticSwitch248 = lerpResult245;
			#else
				float4 staticSwitch248 = lerpResult77;
			#endif
			float4 Albedo86 = staticSwitch248;
			float4 Shadow61 = ( ShadowColor203 + ( Albedo86 * tex2DNode59 ) );
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
			float Albedo_texture_Alpha251 = tex2DNode241.a;
			#ifdef _BAKESWITCH_ON
				float staticSwitch254 = saturate( ( ( TextureAlpha84 * Albedo_texture_Alpha251 ) * 5.0 ) );
			#else
				float staticSwitch254 = TextureAlpha84;
			#endif
			float4 lerpResult154 = lerp( _TotalynotSpeccolor , ase_lightColor , _SpecTransition);
			float4 Spec144 = ( ase_lightAtten * ( ( smoothstepResult137 * ( staticSwitch254 * saturate( lerpResult154 ) ) ) * _SpecOpacity ) );
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
Node;AmplifyShaderEditor.CommentaryNode;237;-7359.988,1151.544;Inherit;False;977.4063;280.5479;Comment;3;230;229;84;Alpha;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;228;-3209.276,-472.8821;Inherit;False;1486.704;713.1107;Comment;11;197;199;201;214;215;196;202;206;203;260;262;ShadowColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;227;-3905.413,4921.403;Inherit;False;3519.594;1545.392;Comment;29;254;253;147;252;160;153;157;154;155;156;129;139;138;146;141;144;143;142;140;136;128;137;135;130;134;132;131;255;256;Spec;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;127;-3323.889,3533.607;Inherit;False;2060.51;998.4119;Comment;17;107;108;110;111;112;109;113;118;119;120;121;122;123;124;114;117;126;Rim;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;106;-3042.06,2748.309;Inherit;False;1405.516;455.7395;Comment;9;96;98;99;100;101;102;103;104;97;Light;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;88;-3416.247,498.0501;Inherit;False;2003.09;1259.783;Comment;19;213;248;80;194;195;193;192;81;83;251;247;250;241;86;245;105;78;77;263;Albedo;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;74;-7500.658,1641.956;Inherit;False;2431.294;835.624;Comment;14;234;239;73;236;72;235;71;222;225;226;220;224;69;257;Normal Map;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;68;-3055.904,1847.476;Inherit;False;1752.588;600.1989;Comment;11;90;61;63;65;89;59;57;64;205;207;259;Shadow;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;67;-5858.149,-212.4699;Inherit;False;1073.892;451.8376;Comment;5;75;55;50;51;52;View Dir;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;66;-5869.662,441.1867;Inherit;False;1699.939;484.432;Comment;8;170;169;163;47;48;54;76;49;Normal Dir;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;69;-7272.615,1691.956;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;190;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;SH_Master;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.LerpOp;77;-2276.299,592.1174;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;224;-6556.703,1821.856;Inherit;False;True;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;220;-6557.999,1944.295;Inherit;False;False;False;True;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;226;-6316.703,1815.856;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;225;-6116.703,1812.856;Inherit;False;FLOAT4;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;222;-6542.999,1729.295;Inherit;False;Property;_NormalStrength;NormalStrength;9;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;78;-3015.639,548.0502;Inherit;False;Property;_ColorMain;ColorMain;0;0;Create;True;0;0;0;False;0;False;0.8396226,0.003960493,0.003960493,0;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;105;-3012.538,739.1397;Inherit;False;Property;_ColorVar;ColorVar;1;0;Create;True;0;0;0;False;0;False;0.6132076,0.130162,0.130162,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;235;-6920.104,2139.162;Inherit;True;Property;_Paint_Normal_normal4;Paint_Normal_normal2;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;72;-7281.543,1884.356;Inherit;True;Property;_Normalmap;Normal map;7;0;Create;True;0;0;0;False;0;False;c44503f9aa117654ab2ab75e404063ae;c44503f9aa117654ab2ab75e404063ae;True;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;229;-6973.493,1201.544;Inherit;True;Property;_Paint_Normal_roughness3;Paint_Normal_roughness3;16;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;73;-5341.579,1811.435;Inherit;False;NormalMap;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;245;-2269.686,780.4973;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendNormalsNode;234;-5915.533,1906.222;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;86;-1700.793,592.739;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;236;-7274.023,2147.031;Inherit;True;Property;_BakedNormalMap;Baked Normal Map;17;0;Create;True;0;0;0;False;0;False;3b97b9c75905eee4bbf0610e0dc5bcc5;3b97b9c75905eee4bbf0610e0dc5bcc5;True;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RegisterLocalVarNode;84;-6624.582,1222.596;Inherit;False;TextureAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;239;-5633.867,1814.808;Inherit;False;Property;_BakeSwitch;Bake Switch;18;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT4;0,0,0,0;False;0;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT4;0,0,0,0;False;4;FLOAT4;0,0,0,0;False;5;FLOAT4;0,0,0,0;False;6;FLOAT4;0,0,0,0;False;7;FLOAT4;0,0,0,0;False;8;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;151;-173.9555,240.7401;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;125;-430.8487,200.9085;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;62;-689.2947,161.7538;Inherit;False;99;Light Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;116;-696.4145,267.0685;Inherit;False;114;Rim;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;145;-493.6064,362.0688;Inherit;False;144;Spec;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;71;-6919.848,1882.044;Inherit;True;Property;_Paint_Normal_normal3;Paint_Normal_normal2;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;230;-7309.988,1205.092;Inherit;True;Property;_Alpha;Alpha;6;0;Create;True;0;0;0;False;0;False;66cc97fea0c6bd24180d89d64d34cf4d;66cc97fea0c6bd24180d89d64d34cf4d;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.Vector2Node;257;-7462.015,1717.177;Inherit;False;Property;_Tile;Tile;8;0;Create;True;0;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ScaleAndOffsetNode;64;-2680.238,2170.724;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;57;-3005.904,2084.361;Inherit;False;54;Normal LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;59;-2383.285,2138.234;Inherit;True;Property;_TextureSample0;Texture Sample 0;7;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;90;-2263.162,1989.976;Inherit;False;86;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;207;-1750.466,2121.797;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;65;-2936.238,2202.724;Inherit;False;Constant;_Offset;Offset;8;0;Create;True;0;0;0;False;0;False;0.49;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;205;-1998.577,1980.927;Inherit;False;203;ShadowColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;61;-1554.436,2135.197;Inherit;False;Shadow;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;63;-2731.14,1897.476;Inherit;True;Property;_ColorRamp;ColorRamp;5;0;Create;True;0;0;0;False;0;False;4378651f2ed612e4abe5216810ad3d61;f24b20aa6f50abe42a4eaff6ff15da61;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.DotProductOpNode;49;-5234.502,620.3876;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;76;-5835.619,543.6898;Inherit;False;73;NormalMap;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;48;-5536.017,676.0524;Inherit;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;47;-5539.149,491.1867;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;170;-4897.979,604.2152;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;169;-5041.979,605.2152;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightAttenuation;163;-5247.553,753.3375;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;52;-5536.727,72.5322;Inherit;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;51;-5537.727,-162.4699;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;50;-5200.384,-67.39088;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;75;-5819.625,-133.3759;Inherit;False;73;NormalMap;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;55;-5026.257,-67.52589;Inherit;False;Fresnel LightDir;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;108;-2968.471,3639.607;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;110;-2813.471,3635.607;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;111;-2605.5,3635.08;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;112;-2387.5,3633.08;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;109;-3195.471,3583.607;Inherit;False;Property;_Rim_Offset;Rim_Offset;11;0;Create;True;0;0;0;False;0;False;0.75;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;113;-2713.5,3751.08;Inherit;False;Property;_RimPower;Rim Power;12;0;Create;True;0;0;0;False;0;False;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;120;-2505.072,4228.018;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;122;-2532.575,3912.201;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;124;-2163.903,3638.404;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;117;-1729.77,3638.906;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;126;-1949.972,3645.373;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;119;-2757.072,4323.019;Inherit;False;Property;_RimColor;Rim Color;10;0;Create;True;0;0;0;False;0;False;1,0.3820755,0.3820755,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LightColorNode;118;-2736.072,4147.019;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;107;-3273.889,3708.761;Inherit;False;55;Fresnel LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightAttenuation;123;-2810.575,3995.201;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;121;-2810.469,3888.627;Inherit;False;54;Normal LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;131;-3308.256,5320.829;Inherit;False;73;NormalMap;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;132;-2779.682,5094.503;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DotProductOpNode;134;-2577.682,5256.503;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;130;-3074.812,5324.162;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PowerNode;135;-2350.682,5255.503;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;137;-2132.682,5260.503;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;128;-3080.461,4971.403;Inherit;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;136;-2699.682,5398.503;Inherit;False;Property;_SpecArea;Spec Area;13;0;Create;True;0;0;0;False;0;False;0.16;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;140;-1192.514,5261.986;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;142;-872.2551,5238.465;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LightAttenuation;143;-1253.818,5145.534;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;144;-627.8176,5242.534;Inherit;False;Spec;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;141;-1516.136,5441.16;Inherit;False;Property;_SpecOpacity;Spec Opacity;14;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;146;-1742.852,5264.476;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;138;-2351.682,5416.503;Inherit;False;Constant;_Min;Min;13;0;Create;True;0;0;0;False;0;False;1.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;139;-2354.682,5525.503;Inherit;False;Constant;_Max;Max;12;0;Create;True;0;0;0;False;0;False;1.12;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightPos;129;-3145.578,5163.217;Inherit;False;0;3;FLOAT4;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;156;-2364.94,5884.765;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;155;-3176.505,6306.695;Inherit;False;Property;_SpecTransition;Spec Transition;15;0;Create;True;0;0;0;False;0;False;0.3;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;154;-2812.888,6028.565;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;157;-2621.071,6028.401;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LightColorNode;153;-3055.765,6142.695;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.ColorNode;160;-3154.101,5926.328;Inherit;False;Property;_TotalynotSpeccolor;Totaly not Spec color;16;0;Create;True;0;0;0;False;0;False;0.5764706,1,0,1;1,0.7122642,0.7122642,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;254;-2617.304,5711.891;Inherit;False;Property;_BakeSwitch;Bake Switch;19;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;253;-3391.116,5774.327;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;147;-3702.141,5624.219;Inherit;False;84;TextureAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;252;-3719.929,5781.693;Inherit;False;251;Albedo texture Alpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;255;-2931.324,5771.818;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;256;-3166.435,5773.487;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;114;-1505.379,3616.815;Inherit;False;Rim;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;98;-2104.545,2861.862;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;102;-2488.178,3021.049;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;104;-2329.399,2926.836;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.IndirectDiffuseLighting;100;-2761.683,2987.072;Inherit;False;Tangent;1;0;FLOAT3;0,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LightAttenuation;101;-2757.178,3091.049;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;97;-2527.308,2861.216;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.RegisterLocalVarNode;99;-1878.543,2864.862;Inherit;False;Light Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;96;-2363.913,2798.309;Inherit;False;61;Shadow;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;103;-2992.06,2982.248;Inherit;False;73;NormalMap;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;197;-2381.602,-320.3467;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;206;-2173.088,-318.334;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;201;-2768.522,-71.01929;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;215;-2924.338,28.37089;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;199;-3076.056,-234.7646;Inherit;False;Property;_ShadowColor;ShadowColor;2;0;Create;True;0;0;0;False;0;False;0.1603774,0.1603774,0.1603774,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;203;-1964.572,-324.7869;Inherit;False;ShadowColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;248;-2026.161,626.1157;Inherit;False;Property;_BakeSwitch;Bake Switch;19;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;214;-3127.237,36.45469;Inherit;False;213;AlbedoAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;54;-4668.691,600.5073;Inherit;False;Normal LightDir;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;89;-1990.162,2125.976;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;259;-1983.011,2300.285;Inherit;False;ShadowMask;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LightAttenuation;196;-3095.751,-420.8821;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;260;-3094.406,-339.7492;Inherit;False;259;ShadowMask;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;262;-2800.52,-393.736;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;202;-2609.004,-357.1335;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;83;-3345.091,1550.669;Inherit;False;84;TextureAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;81;-3109.577,1514.035;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;192;-2531.047,1512.345;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;193;-2715.695,1508.21;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;195;-2913.715,1508.202;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;194;-2970.695,1663.209;Inherit;False;Property;_ColorPower;ColorPower;4;0;Create;True;0;0;0;False;0;False;0.6;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;80;-3284.201,1652.316;Inherit;False;Property;_ColorMask;ColorMask;3;0;Create;True;0;0;0;False;0;False;0.75;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;213;-2308.566,1499.495;Inherit;False;AlbedoAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;241;-3020.493,927.1417;Inherit;True;Property;_Pot_Low_DefaultMaterial_Albedo;Pot_Low_DefaultMaterial_Albedo;18;0;Create;True;0;0;0;False;0;False;-1;7cc3c654cf391a74da218d6c778164be;7cc3c654cf391a74da218d6c778164be;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;250;-3373.952,935.1012;Inherit;True;Property;_AlbedoTexture;Albedo Texture;19;0;Create;True;0;0;0;False;0;False;7cc3c654cf391a74da218d6c778164be;7cc3c654cf391a74da218d6c778164be;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;247;-2552.087,951.1683;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0.8113208,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;263;-2917.213,1132.292;Inherit;False;Property;_AlbedoMapTint;AlbedoMapTint;20;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;251;-2552.548,1082.061;Inherit;False;Albedo texture Alpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
WireConnection;69;0;257;0
WireConnection;190;13;151;0
WireConnection;77;0;78;0
WireConnection;77;1;105;0
WireConnection;77;2;192;0
WireConnection;224;0;71;0
WireConnection;220;0;71;0
WireConnection;226;0;224;0
WireConnection;226;1;222;0
WireConnection;225;0;226;0
WireConnection;225;2;220;0
WireConnection;235;0;236;0
WireConnection;229;0;230;0
WireConnection;229;1;69;0
WireConnection;73;0;239;0
WireConnection;245;0;241;0
WireConnection;245;1;247;0
WireConnection;245;2;192;0
WireConnection;234;0;225;0
WireConnection;234;1;235;0
WireConnection;86;0;248;0
WireConnection;84;0;229;1
WireConnection;239;1;225;0
WireConnection;239;0;234;0
WireConnection;151;0;125;0
WireConnection;151;1;145;0
WireConnection;125;0;62;0
WireConnection;125;1;116;0
WireConnection;71;0;72;0
WireConnection;71;1;69;0
WireConnection;64;0;57;0
WireConnection;64;1;65;0
WireConnection;64;2;65;0
WireConnection;59;0;63;0
WireConnection;59;1;64;0
WireConnection;207;0;205;0
WireConnection;207;1;89;0
WireConnection;61;0;207;0
WireConnection;49;0;47;0
WireConnection;49;1;48;0
WireConnection;47;0;76;0
WireConnection;170;0;169;0
WireConnection;170;1;163;0
WireConnection;169;0;49;0
WireConnection;51;0;75;0
WireConnection;50;0;51;0
WireConnection;50;1;52;0
WireConnection;55;0;50;0
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
WireConnection;117;0;126;0
WireConnection;117;1;120;0
WireConnection;126;0;124;0
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
WireConnection;156;0;254;0
WireConnection;156;1;157;0
WireConnection;154;0;160;0
WireConnection;154;1;153;0
WireConnection;154;2;155;0
WireConnection;157;0;154;0
WireConnection;254;1;147;0
WireConnection;254;0;255;0
WireConnection;253;0;147;0
WireConnection;253;1;252;0
WireConnection;255;0;256;0
WireConnection;256;0;253;0
WireConnection;114;0;117;0
WireConnection;98;0;96;0
WireConnection;98;1;104;0
WireConnection;102;0;100;0
WireConnection;102;1;101;0
WireConnection;104;0;97;0
WireConnection;104;1;102;0
WireConnection;100;0;103;0
WireConnection;99;0;98;0
WireConnection;197;0;202;0
WireConnection;197;1;201;0
WireConnection;206;0;197;0
WireConnection;201;0;199;0
WireConnection;201;1;215;0
WireConnection;215;0;214;0
WireConnection;203;0;206;0
WireConnection;248;1;77;0
WireConnection;248;0;245;0
WireConnection;54;0;170;0
WireConnection;89;0;90;0
WireConnection;89;1;59;0
WireConnection;259;0;59;0
WireConnection;262;0;196;0
WireConnection;262;1;260;0
WireConnection;202;0;262;0
WireConnection;81;0;83;0
WireConnection;192;0;193;0
WireConnection;193;0;195;0
WireConnection;193;1;194;0
WireConnection;195;0;81;0
WireConnection;195;1;80;0
WireConnection;213;0;192;0
WireConnection;241;0;250;0
WireConnection;247;0;241;0
WireConnection;247;1;263;0
WireConnection;251;0;241;4
ASEEND*/
//CHKSM=60FAF216215BCB4F48181D5A5CF35186A74EC4B7