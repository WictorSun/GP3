// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SH_PostProcess"
{
	Properties
	{
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_TextureSample2("Texture Sample 1", 2D) = "white" {}
		_Tile_U2("Tile_U", Float) = 16
		_Tile_V2("Tile_V", Float) = 0.1
		_Pan_V1("Pan_V", Float) = -0.25
		_Pan_U1("Pan_U", Float) = 0.12
		_Fraction("Fraction", Float) = 1
		_Brightness("Brightness", Float) = 2
		_Gradient("Gradient", Float) = 1
		_Contrast("Contrast", Float) = 2
		_Switch("Switch", Float) = 1
		_PerspectiveCenter("PerspectiveCenter", Vector) = (0.5,0.77,0,0)
		_Desaturate_Edge("Desaturate_Edge", Float) = 1
		_Brightness_Edge("Brightness_Edge", Float) = 0.7
		_EdgeGradient_Edge("EdgeGradient_Edge", Float) = 1
		_EdgeThreshold_Edge("EdgeThreshold_Edge", Float) = 0.45
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}

	SubShader
	{
		LOD 0

		Cull Off
		ZWrite Off
		ZTest Always
		
		Pass
		{
			CGPROGRAM

			

			#pragma vertex Vert
			#pragma fragment Frag
			#pragma target 3.0

			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"

		
			struct ASEAttributesDefault
			{
				float3 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				
			};

			struct ASEVaryingsDefault
			{
				float4 vertex : SV_POSITION;
				float2 texcoord : TEXCOORD0;
				float2 texcoordStereo : TEXCOORD1;
			#if STEREO_INSTANCING_ENABLED
				uint stereoTargetEyeIndex : SV_RenderTargetArrayIndex;
			#endif
				
			};

			uniform sampler2D _MainTex;
			uniform half4 _MainTex_TexelSize;
			uniform half4 _MainTex_ST;
			
			uniform float _Fraction;
			uniform float _Brightness;
			uniform float _Desaturate_Edge;
			uniform float _Brightness_Edge;
			uniform float _EdgeGradient_Edge;
			uniform float _EdgeThreshold_Edge;
			uniform float _Switch;
			uniform float _Gradient;
			uniform sampler2D _TextureSample1;
			uniform float2 _PerspectiveCenter;
			uniform float _Tile_V2;
			uniform float _Tile_U2;
			uniform float _Pan_V1;
			uniform float _Pan_U1;
			uniform sampler2D _TextureSample2;
			uniform float _Contrast;


			
			float2 TransformTriangleVertexToUV (float2 vertex)
			{
				float2 uv = (vertex + 1.0) * 0.5;
				return uv;
			}

			ASEVaryingsDefault Vert( ASEAttributesDefault v  )
			{
				ASEVaryingsDefault o;
				o.vertex = float4(v.vertex.xy, 0.0, 1.0);
				o.texcoord = TransformTriangleVertexToUV (v.vertex.xy);
#if UNITY_UV_STARTS_AT_TOP
				o.texcoord = o.texcoord * float2(1.0, -1.0) + float2(0.0, 1.0);
#endif
				o.texcoordStereo = TransformStereoScreenSpaceTex (o.texcoord, 1.0);

				v.texcoord = o.texcoordStereo;
				float4 ase_ppsScreenPosVertexNorm = float4(o.texcoordStereo,0,1);

				

				return o;
			}

			float4 Frag (ASEVaryingsDefault i  ) : SV_Target
			{
				float4 ase_ppsScreenPosFragNorm = float4(i.texcoordStereo,0,1);

				float2 uv_MainTex = i.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 CameraView120 = tex2D( _MainTex, uv_MainTex );
				float3 desaturateInitialColor43 = CameraView120.rgb;
				float desaturateDot43 = dot( desaturateInitialColor43, float3( 0.299, 0.587, 0.114 ));
				float3 desaturateVar43 = lerp( desaturateInitialColor43, desaturateDot43.xxx, _Fraction );
				float3 SpeedLines123 = ( desaturateVar43 * _Brightness );
				float3 desaturateInitialColor129 = CameraView120.rgb;
				float desaturateDot129 = dot( desaturateInitialColor129, float3( 0.299, 0.587, 0.114 ));
				float3 desaturateVar129 = lerp( desaturateInitialColor129, desaturateDot129.xxx, _Desaturate_Edge );
				float2 texCoord142 = i.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float4 lerpResult126 = lerp( float4( ( desaturateVar129 * _Brightness_Edge ) , 0.0 ) , CameraView120 , saturate( pow( ( ( ( ( 1.0 - texCoord142.x ) * texCoord142.x ) * 4.0 ) * _EdgeGradient_Edge ) , _EdgeThreshold_Edge ) ));
				float4 EdgeView139 = lerpResult126;
				float2 texCoord25 = i.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float lerpResult62 = lerp( ( 1.0 - texCoord25.y ) , texCoord25.y , _Switch);
				float2 CenteredUV15_g4 = ( i.texcoord.xy - _PerspectiveCenter );
				float2 break17_g4 = CenteredUV15_g4;
				float2 appendResult23_g4 = (float2(( length( CenteredUV15_g4 ) * _Tile_V2 * 2.0 ) , ( atan2( break17_g4.x , break17_g4.y ) * ( 1.0 / 6.28318548202515 ) * _Tile_U2 )));
				float2 break99 = appendResult23_g4;
				float temp_output_97_0 = ( _Time.y * _Pan_V1 );
				float2 appendResult89 = (float2(( break99.x + temp_output_97_0 ) , ( break99.y + ( _Time.y * _Pan_U1 ) )));
				float2 CenteredUV15_g3 = ( i.texcoord.xy - _PerspectiveCenter );
				float2 break17_g3 = CenteredUV15_g3;
				float2 appendResult23_g3 = (float2(( length( CenteredUV15_g3 ) * ( _Tile_V2 / 2.0 ) * 2.0 ) , ( atan2( break17_g3.x , break17_g3.y ) * ( 1.0 / 6.28318548202515 ) * ( _Tile_U2 / 2.0 ) )));
				float2 break109 = appendResult23_g3;
				float2 appendResult107 = (float2(( break109.x + temp_output_97_0 ) , ( break109.y + ( _Time.y * ( _Pan_U1 * -1.0 ) ) )));
				float SpeedLinesMask125 = saturate( ( ( ( lerpResult62 * _Gradient ) + ( tex2D( _TextureSample1, appendResult89 ).r * tex2D( _TextureSample2, appendResult107 ).r ) ) * _Contrast ) );
				float4 lerpResult26 = lerp( float4( SpeedLines123 , 0.0 ) , EdgeView139 , SpeedLinesMask125);
				

				float4 color = lerpResult26;
				
				return color;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	Fallback Off
}
/*ASEBEGIN
Version=19202
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;13;436.1998,188.8147;Float;False;True;-1;2;ASEMaterialInspector;0;8;SH_PostProcess;32139be9c1eb75640a847f011acf3bcf;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;True;7;False;;False;False;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;0;;0;0;Standard;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.RangedFloatNode;44;-2195.241,-942.8917;Inherit;False;Property;_Fraction;Fraction;6;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;-1579.436,-1117.481;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;76;-1915.839,-942.8864;Inherit;False;Property;_Brightness;Brightness;7;0;Create;True;0;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;-2428.798,353.86;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;62;-2663.725,330.2165;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;46;-2875.109,312.5226;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;28;-2274.408,593.869;Inherit;True;Property;_TextureSample1;Texture Sample 1;0;0;Create;True;0;0;0;False;0;False;-1;4bb2ed5cf0c9cfa4c9deb0ca14b1e966;4bb2ed5cf0c9cfa4c9deb0ca14b1e966;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;65;-2274.437,967.5878;Inherit;True;Property;_TextureSample2;Texture Sample 1;1;0;Create;True;0;0;0;False;0;False;-1;4bb2ed5cf0c9cfa4c9deb0ca14b1e966;4bb2ed5cf0c9cfa4c9deb0ca14b1e966;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;-1902.341,827.9285;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;-1527.505,512.2648;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-1686.15,654.3036;Inherit;False;Property;_Contrast;Contrast;9;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;32;-1699.015,509.6633;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;96;-3532.732,882.9075;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;97;-3267.218,886.1663;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;98;-3265.692,1017.362;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;92;-2959.876,659.0797;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;93;-2961.199,821.2969;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;89;-2774.749,736.4626;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;99;-3245.719,648.1136;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;100;-3503.798,981.225;Inherit;False;Property;_Pan_V1;Pan_V;4;0;Create;True;0;0;0;False;0;False;-0.25;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;101;-3499.991,1079.574;Inherit;False;Property;_Pan_U1;Pan_U;5;0;Create;True;0;0;0;False;0;False;0.12;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;95;-3971.399,953.1409;Inherit;False;Property;_Tile_V2;Tile_V;3;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;94;-3969.399,1047.141;Inherit;False;Property;_Tile_U2;Tile_U;2;0;Create;True;0;0;0;False;0;False;16;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;117;-3072.514,1104.695;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;118;-3252.984,1160.199;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;105;-2787.566,1083.743;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;106;-2788.888,1245.958;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;107;-2602.439,1161.124;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;108;-3320.558,1322.674;Inherit;False;Polar Coordinates;-1;;3;7dab8e02884cf104ebefaa2e788e4162;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0.5,0.5;False;3;FLOAT;1;False;4;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;109;-3048.981,1323.264;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleDivideOpNode;114;-3493.755,1430.391;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;115;-3493.268,1320.742;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;119;-4038.505,791.0093;Inherit;False;Property;_PerspectiveCenter;PerspectiveCenter;11;0;Create;True;0;0;0;False;0;False;0.5,0.77;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;49;-2659.798,484.86;Inherit;False;Property;_Gradient;Gradient;8;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;63;-3118.197,462.6074;Inherit;False;Property;_Switch;Switch;10;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;31;-1360.716,513.2479;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;125;-1155.221,509.2361;Inherit;False;SpeedLinesMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;26;104.4747,185.7341;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;122;-170.945,128.257;Inherit;False;123;SpeedLines;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;124;-181.8501,318.8369;Inherit;False;125;SpeedLinesMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DesaturateOpNode;43;-1842.69,-1118.961;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;78;-3517.293,647.5244;Inherit;False;Polar Coordinates;-1;;4;7dab8e02884cf104ebefaa2e788e4162;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0.5,0.5;False;3;FLOAT;1;False;4;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;126;-1575.682,-618.3356;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;121;-173.6355,213.7481;Inherit;False;139;EdgeView;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;139;-1327.301,-610.006;Inherit;False;EdgeView;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;140;-2160.308,-1152.442;Inherit;False;120;CameraView;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;123;-1381.568,-1114.964;Inherit;False;SpeedLines;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;10;-2028.236,-1672.137;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0,0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;24;-2237.019,-1672.831;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;120;-1646.593,-1652.512;Inherit;False;CameraView;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;135;-2316.124,-230.6278;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;136;-2578.925,-129.3447;Inherit;False;Property;_EdgeGradient_Edge;EdgeGradient_Edge;14;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;138;-2311.484,-107.8442;Inherit;False;Property;_EdgeThreshold_Edge;EdgeThreshold_Edge;15;0;Create;True;0;0;0;False;0;False;0.45;5.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;137;-2026.704,-230.4038;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;25;-3182.609,318.0739;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;144;-2803.979,-223.1898;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;145;-2552.979,-238.1898;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;142;-3315.092,-218.706;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;143;-3034.265,-268.6682;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DesaturateOpNode;129;-2202.255,-658.8257;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;130;-1914.647,-656.5258;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;131;-2472.822,-523.5358;Inherit;False;Property;_Desaturate_Edge;Desaturate_Edge;12;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;132;-2185.68,-520.2762;Inherit;False;Property;_Brightness_Edge;Brightness_Edge;13;0;Create;True;0;0;0;False;0;False;0.7;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;128;-2490.025,-656.4344;Inherit;False;120;CameraView;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;127;-1913.436,-461.5699;Inherit;False;120;CameraView;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;141;-1825.508,-230.3683;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
WireConnection;13;0;26;0
WireConnection;75;0;43;0
WireConnection;75;1;76;0
WireConnection;48;0;62;0
WireConnection;48;1;49;0
WireConnection;62;0;46;0
WireConnection;62;1;25;2
WireConnection;62;2;63;0
WireConnection;46;0;25;2
WireConnection;28;1;89;0
WireConnection;65;1;107;0
WireConnection;66;0;28;1
WireConnection;66;1;65;1
WireConnection;50;0;32;0
WireConnection;50;1;51;0
WireConnection;32;0;48;0
WireConnection;32;1;66;0
WireConnection;97;0;96;0
WireConnection;97;1;100;0
WireConnection;98;0;96;0
WireConnection;98;1;101;0
WireConnection;92;0;99;0
WireConnection;92;1;97;0
WireConnection;93;0;99;1
WireConnection;93;1;98;0
WireConnection;89;0;92;0
WireConnection;89;1;93;0
WireConnection;99;0;78;0
WireConnection;117;0;96;0
WireConnection;117;1;118;0
WireConnection;118;0;101;0
WireConnection;105;0;109;0
WireConnection;105;1;97;0
WireConnection;106;0;109;1
WireConnection;106;1;117;0
WireConnection;107;0;105;0
WireConnection;107;1;106;0
WireConnection;108;2;119;0
WireConnection;108;3;115;0
WireConnection;108;4;114;0
WireConnection;109;0;108;0
WireConnection;114;0;94;0
WireConnection;115;0;95;0
WireConnection;31;0;50;0
WireConnection;125;0;31;0
WireConnection;26;0;122;0
WireConnection;26;1;121;0
WireConnection;26;2;124;0
WireConnection;43;0;140;0
WireConnection;43;1;44;0
WireConnection;78;2;119;0
WireConnection;78;3;95;0
WireConnection;78;4;94;0
WireConnection;126;0;130;0
WireConnection;126;1;127;0
WireConnection;126;2;141;0
WireConnection;139;0;126;0
WireConnection;123;0;75;0
WireConnection;10;0;24;0
WireConnection;120;0;10;0
WireConnection;135;0;145;0
WireConnection;135;1;136;0
WireConnection;137;0;135;0
WireConnection;137;1;138;0
WireConnection;144;0;143;0
WireConnection;144;1;142;1
WireConnection;145;0;144;0
WireConnection;143;0;142;1
WireConnection;129;0;128;0
WireConnection;129;1;131;0
WireConnection;130;0;129;0
WireConnection;130;1;132;0
WireConnection;141;0;137;0
ASEEND*/
//CHKSM=4C3C2CC8DB56C6BFDBE7B9970D2C451D3660378A