// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SH_Sprite"
{
	Properties
	{
		_Mask("Mask", 2D) = "white" {}
		_RowsColumns("Rows&Columns", Float) = 2
		_RowsColumns2("Rows&Columns", Float) = 2
		_Rotate("Rotate", Range( 0 , 1.5)) = 0
		[Toggle(_KEYWORD0_ON)] _Keyword0("Keyword 0", Float) = 0
		_TimeScale2("TimeScale", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _KEYWORD0_ON
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float4 vertexColor : COLOR;
			float2 uv_texcoord;
			float4 uv2_texcoord2;
		};

		uniform sampler2D _Mask;
		uniform float _Rotate;
		uniform float _RowsColumns;
		uniform float _RowsColumns2;
		uniform float _TimeScale2;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			o.Emission = i.vertexColor.rgb;
			float cos25 = cos( _Rotate );
			float sin25 = sin( _Rotate );
			float2 rotator25 = mul( i.uv_texcoord - float2( 0,0 ) , float2x2( cos25 , -sin25 , sin25 , cos25 )) + float2( 0,0 );
			float2 appendResult20 = (float2(floor( i.uv2_texcoord2.z ) , floor( ( i.uv2_texcoord2.z / _RowsColumns ) )));
			float2 appendResult7 = (float2(_RowsColumns , _RowsColumns));
			float2 ChooseFrame79 = frac( ( ( rotator25 + appendResult20 ) * ( 1.0 / appendResult7 ) ) );
			// *** BEGIN Flipbook UV Animation vars ***
			// Total tiles of Flipbook Texture
			float fbtotaltiles78 = _RowsColumns2 * _RowsColumns2;
			// Offsets for cols and rows of Flipbook Texture
			float fbcolsoffset78 = 1.0f / _RowsColumns2;
			float fbrowsoffset78 = 1.0f / _RowsColumns2;
			// Speed of animation
			float fbspeed78 = i.uv2_texcoord2.z * _TimeScale2;
			// UV Tiling (col and row offset)
			float2 fbtiling78 = float2(fbcolsoffset78, fbrowsoffset78);
			// UV Offset - calculate current tile linear index, and convert it to (X * coloffset, Y * rowoffset)
			// Calculate current tile linear index
			float fbcurrenttileindex78 = round( fmod( fbspeed78 + 0.0, fbtotaltiles78) );
			fbcurrenttileindex78 += ( fbcurrenttileindex78 < 0) ? fbtotaltiles78 : 0;
			// Obtain Offset X coordinate from current tile linear index
			float fblinearindextox78 = round ( fmod ( fbcurrenttileindex78, _RowsColumns2 ) );
			// Multiply Offset X by coloffset
			float fboffsetx78 = fblinearindextox78 * fbcolsoffset78;
			// Obtain Offset Y coordinate from current tile linear index
			float fblinearindextoy78 = round( fmod( ( fbcurrenttileindex78 - fblinearindextox78 ) / _RowsColumns2, _RowsColumns2 ) );
			// Reverse Y to get tiles from Top to Bottom
			fblinearindextoy78 = (int)(_RowsColumns2-1) - fblinearindextoy78;
			// Multiply Offset Y by rowoffset
			float fboffsety78 = fblinearindextoy78 * fbrowsoffset78;
			// UV Offset
			float2 fboffset78 = float2(fboffsetx78, fboffsety78);
			// Flipbook UV
			half2 fbuv78 = i.uv_texcoord * fbtiling78 + fboffset78;
			// *** END Flipbook UV Animation vars ***
			float2 Flipbook80 = fbuv78;
			#ifdef _KEYWORD0_ON
				float2 staticSwitch27 = Flipbook80;
			#else
				float2 staticSwitch27 = ChooseFrame79;
			#endif
			o.Alpha = ( i.vertexColor.a * tex2D( _Mask, staticSwitch27 ).r );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit alpha:fade keepalpha fullforwardshadows 

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
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 customPack2 : TEXCOORD2;
				float3 worldPos : TEXCOORD3;
				half4 color : COLOR0;
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
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.customPack2.xyzw = customInputData.uv2_texcoord2;
				o.customPack2.xyzw = v.texcoord1;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.color = v.color;
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
				surfIN.uv2_texcoord2 = IN.customPack2.xyzw;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.vertexColor = IN.color;
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
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
Node;AmplifyShaderEditor.CommentaryNode;82;-5307.962,-1750.837;Inherit;False;1827.558;1028.406;Comment;17;4;18;19;12;20;25;26;10;17;7;9;6;8;3;23;24;79;ChooseFrame;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;81;-5049.748,-295.9671;Inherit;False;1205.638;597.1618;Comment;7;80;78;86;85;74;75;76;Flipbook;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;1;-813.5487,75.06049;Inherit;True;Property;_Paint_Normal_roughnessBrushStrokes;Paint_Normal_roughnessBrushStrokes;0;0;Create;True;0;0;0;False;0;False;-1;9480a4c7fb8de454c9c101857aae40cd;9480a4c7fb8de454c9c101857aae40cd;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;21;-694.197,-116.7243;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-427.4539,81.60612;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-65.42136,-173.7755;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;SH_Sprite;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.TexturePropertyNode;2;-1305.175,178.196;Inherit;True;Property;_Mask;Mask;0;0;Create;True;0;0;0;False;0;False;9480a4c7fb8de454c9c101857aae40cd;9480a4c7fb8de454c9c101857aae40cd;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TextureCoordinatesNode;76;-4997.713,-245.9671;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;75;-4984.688,-97.61971;Inherit;False;Property;_RowsColumns2;Rows&Columns;2;0;Create;True;0;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;74;-4978.944,-15.85771;Inherit;False;Property;_TimeScale2;TimeScale;5;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-4077.496,-1046.81;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;18;-4651.587,-1135.974;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FloorOpNode;19;-4506.331,-1133.783;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;12;-4174.919,-1319.861;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;20;-4357.201,-1300.526;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RotatorNode;25;-4427.95,-1681.53;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-4747.063,-1541.495;Inherit;False;Property;_Rotate;Rotate;3;0;Create;True;0;0;0;False;0;False;0;0;0;1.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;10;-3894.053,-1046.502;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FloorOpNode;17;-4654.167,-1301.164;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;7;-4477.907,-859.4308;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;9;-4282.48,-921.9098;Inherit;False;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-4887.281,-842.4487;Inherit;False;Property;_RowsColumns;Rows&Columns;1;0;Create;True;0;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-4480.481,-958.3882;Inherit;False;Constant;_Float0;Float 0;2;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;79;-3722.404,-1046.098;Inherit;False;ChooseFrame;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StaticSwitch;27;-1280.93,-40.08991;Inherit;False;Property;_Keyword0;Keyword 0;4;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;83;-1599.491,-97.1889;Inherit;False;79;ChooseFrame;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;84;-1577.379,13.13647;Inherit;False;80;Flipbook;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-4736.543,-1701.837;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;23;-5005.688,-1245.35;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.TexCoordVertexDataNode;24;-5257.962,-1244.961;Inherit;False;1;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;85;-4729.546,79.10097;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.TexCoordVertexDataNode;86;-4981.82,79.48988;Inherit;False;1;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCFlipBookUVAnimation;78;-4422.367,-146.3772;Inherit;False;0;0;6;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RegisterLocalVarNode;80;-4112.316,-148.1648;Inherit;False;Flipbook;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
WireConnection;1;0;2;0
WireConnection;1;1;27;0
WireConnection;16;0;21;4
WireConnection;16;1;1;1
WireConnection;0;2;21;0
WireConnection;0;9;16;0
WireConnection;4;0;12;0
WireConnection;4;1;9;0
WireConnection;18;0;23;2
WireConnection;18;1;6;0
WireConnection;19;0;18;0
WireConnection;12;0;25;0
WireConnection;12;1;20;0
WireConnection;20;0;17;0
WireConnection;20;1;19;0
WireConnection;25;0;3;0
WireConnection;25;2;26;0
WireConnection;10;0;4;0
WireConnection;17;0;23;2
WireConnection;7;0;6;0
WireConnection;7;1;6;0
WireConnection;9;0;8;0
WireConnection;9;1;7;0
WireConnection;79;0;10;0
WireConnection;27;1;83;0
WireConnection;27;0;84;0
WireConnection;23;0;24;0
WireConnection;85;0;86;0
WireConnection;78;0;76;0
WireConnection;78;1;75;0
WireConnection;78;2;75;0
WireConnection;78;3;74;0
WireConnection;78;5;85;2
WireConnection;80;0;78;0
ASEEND*/
//CHKSM=3D2537F6891D6035FFE21B05F61B787FEC06302B