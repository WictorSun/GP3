// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SH_PostProcess"
{
	Properties
	{
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_TextureSample2("Texture Sample 1", 2D) = "white" {}
		_Tile_U("Tile_U", Float) = 2
		_Tile_V("Tile_V", Float) = 0.25
		_Pan_V("Pan_V", Float) = 0.5
		_Pan_U("Pan_U", Float) = 0.12
		_Fraction("Fraction", Float) = -10
		_Gradient("Gradient", Float) = 1
		_Contrast("Contrast", Float) = 1
		_Switch("Switch", Float) = 0
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
			uniform float _Switch;
			uniform float _Gradient;
			uniform sampler2D _TextureSample1;
			uniform float _Tile_U;
			uniform float _Tile_V;
			uniform float _Pan_U;
			uniform float _Pan_V;
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
				float4 tex2DNode10 = tex2D( _MainTex, uv_MainTex );
				float3 desaturateInitialColor43 = tex2DNode10.rgb;
				float desaturateDot43 = dot( desaturateInitialColor43, float3( 0.299, 0.587, 0.114 ));
				float3 desaturateVar43 = lerp( desaturateInitialColor43, desaturateDot43.xxx, _Fraction );
				float2 texCoord25 = i.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float lerpResult62 = lerp( ( 1.0 - texCoord25.y ) , texCoord25.y , _Switch);
				float2 appendResult36 = (float2(_Tile_U , _Tile_V));
				float2 appendResult40 = (float2(_Pan_U , _Pan_V));
				float2 texCoord33 = i.texcoord.xy * appendResult36 + ( _Time.y * appendResult40 );
				float2 appendResult69 = (float2(( _Tile_U / 2.0 ) , ( _Tile_V / 2.0 )));
				float2 texCoord64 = i.texcoord.xy * appendResult69 + ( appendResult40 * ( _Time.y * 1.64 ) );
				float4 lerpResult26 = lerp( float4( desaturateVar43 , 0.0 ) , tex2DNode10 , saturate( ( ( ( lerpResult62 * _Gradient ) + ( tex2D( _TextureSample1, texCoord33 ).r * tex2D( _TextureSample2, texCoord64 ).r ) ) * _Contrast ) ));
				

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
Node;AmplifyShaderEditor.SamplerNode;10;-934.9329,-172.2289;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0,0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;24;-1143.715,-172.923;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DesaturateOpNode;43;-443.7264,-128.6384;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;44;-796.2762,47.43054;Inherit;False;Property;_Fraction;Fraction;6;0;Create;True;0;0;0;False;0;False;-10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;-1066,182.4114;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-1297,313.4114;Inherit;False;Property;_Gradient;Gradient;7;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;62;-1300.927,158.7679;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;25;-1819.81,146.6252;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;46;-1512.311,141.0739;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;63;-1755.398,291.1588;Inherit;False;Property;_Switch;Switch;9;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;33;-1812.368,448.3907;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;28;-911.6111,422.4204;Inherit;True;Property;_TextureSample1;Texture Sample 1;0;0;Create;True;0;0;0;False;0;False;-1;4bb2ed5cf0c9cfa4c9deb0ca14b1e966;4bb2ed5cf0c9cfa4c9deb0ca14b1e966;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;65;-911.6399,796.1392;Inherit;True;Property;_TextureSample2;Texture Sample 1;1;0;Create;True;0;0;0;False;0;False;-1;4bb2ed5cf0c9cfa4c9deb0ca14b1e966;4bb2ed5cf0c9cfa4c9deb0ca14b1e966;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;-539.5442,656.4799;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;64;-1312.865,810.4663;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;26;224.648,187.7605;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;13;436.1998,188.8147;Float;False;True;-1;2;ASEMaterialInspector;0;8;SH_PostProcess;32139be9c1eb75640a847f011acf3bcf;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;True;7;False;;False;False;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;0;;0;0;Standard;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.SimpleAddOpNode;32;-303.9548,333.9316;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;31;-5.918427,349.7993;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;-164.7079,340.8162;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-323.3528,482.855;Inherit;False;Property;_Contrast;Contrast;8;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;69;-1670.205,715.7876;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;36;-1998.553,472.4011;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-2246.071,455.999;Inherit;False;Property;_Tile_U;Tile_U;2;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-2247.071,543.999;Inherit;False;Property;_Tile_V;Tile_V;3;0;Create;True;0;0;0;False;0;False;0.25;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;40;-2224.481,814.4193;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-2443.482,873.4193;Inherit;False;Property;_Pan_V;Pan_V;4;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-2445.482,767.4193;Inherit;False;Property;_Pan_U;Pan_U;5;0;Create;True;0;0;0;False;0;False;0.12;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;38;-2256.09,932.1719;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-2012.882,792.6765;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;71;-1983.145,690.4384;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;70;-1985.66,587.7894;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;-1774.676,1003.958;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-2008.964,1003.255;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1.64;False;1;FLOAT;0
WireConnection;10;0;24;0
WireConnection;43;0;10;0
WireConnection;43;1;44;0
WireConnection;48;0;62;0
WireConnection;48;1;49;0
WireConnection;62;0;46;0
WireConnection;62;1;25;2
WireConnection;62;2;63;0
WireConnection;46;0;25;2
WireConnection;33;0;36;0
WireConnection;33;1;39;0
WireConnection;28;1;33;0
WireConnection;65;1;64;0
WireConnection;66;0;28;1
WireConnection;66;1;65;1
WireConnection;64;0;69;0
WireConnection;64;1;67;0
WireConnection;26;0;43;0
WireConnection;26;1;10;0
WireConnection;26;2;31;0
WireConnection;13;0;26;0
WireConnection;32;0;48;0
WireConnection;32;1;66;0
WireConnection;31;0;50;0
WireConnection;50;0;32;0
WireConnection;50;1;51;0
WireConnection;69;0;70;0
WireConnection;69;1;71;0
WireConnection;36;0;34;0
WireConnection;36;1;35;0
WireConnection;40;0;42;0
WireConnection;40;1;41;0
WireConnection;39;0;38;0
WireConnection;39;1;40;0
WireConnection;71;0;35;0
WireConnection;70;0;34;0
WireConnection;67;0;40;0
WireConnection;67;1;68;0
WireConnection;68;0;38;0
ASEEND*/
//CHKSM=D4DEA6C9145B2D311E89184011DDF63E04F5464B