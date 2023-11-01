// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SH_PostProcess"
{
	Properties
	{
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_TextureSample2("Texture Sample 1", 2D) = "white" {}
		_Tile_U2("Tile_U", Float) = 8
		_Tile_V2("Tile_V", Float) = 0.25
		_Pan_V1("Pan_V", Float) = -0.5
		_Pan_U1("Pan_U", Float) = 0.12
		_Fraction("Fraction", Float) = 1
		_Brightness("Brightness", Float) = 2
		_Gradient("Gradient", Float) = 1
		_Contrast("Contrast", Float) = 2
		_Switch("Switch", Float) = 1
		_PerspectiveCenter("PerspectiveCenter", Vector) = (0.5,0.77,0,0)
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
				float4 tex2DNode10 = tex2D( _MainTex, uv_MainTex );
				float3 desaturateInitialColor43 = tex2DNode10.rgb;
				float desaturateDot43 = dot( desaturateInitialColor43, float3( 0.299, 0.587, 0.114 ));
				float3 desaturateVar43 = lerp( desaturateInitialColor43, desaturateDot43.xxx, _Fraction );
				float2 texCoord25 = i.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float lerpResult62 = lerp( ( 1.0 - texCoord25.y ) , texCoord25.y , _Switch);
				float2 CenteredUV15_g2 = ( i.texcoord.xy - _PerspectiveCenter );
				float2 break17_g2 = CenteredUV15_g2;
				float2 appendResult23_g2 = (float2(( length( CenteredUV15_g2 ) * _Tile_V2 * 2.0 ) , ( atan2( break17_g2.x , break17_g2.y ) * ( 1.0 / 6.28318548202515 ) * _Tile_U2 )));
				float2 break99 = appendResult23_g2;
				float temp_output_97_0 = ( _Time.y * _Pan_V1 );
				float2 appendResult89 = (float2(( break99.x + temp_output_97_0 ) , ( break99.y + ( _Time.y * _Pan_U1 ) )));
				float2 CenteredUV15_g3 = ( i.texcoord.xy - _PerspectiveCenter );
				float2 break17_g3 = CenteredUV15_g3;
				float2 appendResult23_g3 = (float2(( length( CenteredUV15_g3 ) * ( _Tile_V2 / 2.0 ) * 2.0 ) , ( atan2( break17_g3.x , break17_g3.y ) * ( 1.0 / 6.28318548202515 ) * ( _Tile_U2 / 2.0 ) )));
				float2 break109 = appendResult23_g3;
				float2 appendResult107 = (float2(( break109.x + temp_output_97_0 ) , ( break109.y + ( _Time.y * ( _Pan_U1 * -1.0 ) ) )));
				float4 lerpResult26 = lerp( float4( ( desaturateVar43 * _Brightness ) , 0.0 ) , tex2DNode10 , saturate( ( ( ( lerpResult62 * _Gradient ) + ( tex2D( _TextureSample1, appendResult89 ).r * tex2D( _TextureSample2, appendResult107 ).r ) ) * _Contrast ) ));
				

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
Node;AmplifyShaderEditor.RangedFloatNode;44;-796.2762,47.43054;Inherit;False;Property;_Fraction;Fraction;6;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;-1066,182.4114;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-1297,313.4114;Inherit;False;Property;_Gradient;Gradient;8;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;62;-1300.927,158.7679;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;25;-1819.81,146.6252;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;46;-1512.311,141.0739;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;63;-1755.398,291.1588;Inherit;False;Property;_Switch;Switch;10;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;28;-911.6111,422.4204;Inherit;True;Property;_TextureSample1;Texture Sample 1;0;0;Create;True;0;0;0;False;0;False;-1;4bb2ed5cf0c9cfa4c9deb0ca14b1e966;4bb2ed5cf0c9cfa4c9deb0ca14b1e966;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;65;-911.6399,796.1392;Inherit;True;Property;_TextureSample2;Texture Sample 1;1;0;Create;True;0;0;0;False;0;False;-1;4bb2ed5cf0c9cfa4c9deb0ca14b1e966;4bb2ed5cf0c9cfa4c9deb0ca14b1e966;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;-539.5442,656.4799;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;13;436.1998,188.8147;Float;False;True;-1;2;ASEMaterialInspector;0;8;SH_PostProcess;32139be9c1eb75640a847f011acf3bcf;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;True;7;False;;False;False;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;0;;0;0;Standard;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.SaturateNode;31;-5.918427,349.7993;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;-164.7079,340.8162;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-323.3528,482.855;Inherit;False;Property;_Contrast;Contrast;9;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;-180.4723,-127.1593;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;76;-516.8752,47.43579;Inherit;False;Property;_Brightness;Brightness;7;0;Create;True;0;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;32;-336.2174,338.2147;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;26;232.648,190.7605;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleTimeNode;96;-2169.933,711.4589;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;97;-1904.419,714.7177;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;98;-1902.893,845.9131;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;92;-1597.078,487.631;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;93;-1598.401,649.8483;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;89;-1411.951,565.014;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;78;-2154.494,476.0757;Inherit;False;Polar Coordinates;-1;;2;7dab8e02884cf104ebefaa2e788e4162;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0.5,0.5;False;3;FLOAT;1;False;4;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;99;-1882.92,476.665;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;100;-2140.999,809.7764;Inherit;False;Property;_Pan_V1;Pan_V;4;0;Create;True;0;0;0;False;0;False;-0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;101;-2137.192,908.1252;Inherit;False;Property;_Pan_U1;Pan_U;5;0;Create;True;0;0;0;False;0;False;0.12;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;95;-2608.6,781.6923;Inherit;False;Property;_Tile_V2;Tile_V;3;0;Create;True;0;0;0;False;0;False;0.25;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;94;-2606.6,875.6929;Inherit;False;Property;_Tile_U2;Tile_U;2;0;Create;True;0;0;0;False;0;False;8;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;117;-1709.716,933.2463;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;118;-1890.185,988.7505;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;105;-1424.768,912.2941;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;106;-1426.09,1074.509;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;107;-1239.641,989.6752;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;108;-1957.759,1151.225;Inherit;False;Polar Coordinates;-1;;3;7dab8e02884cf104ebefaa2e788e4162;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0.5,0.5;False;3;FLOAT;1;False;4;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;109;-1686.183,1151.815;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleDivideOpNode;114;-2130.956,1258.942;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;115;-2130.469,1149.293;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;119;-2675.706,619.5607;Inherit;False;Property;_PerspectiveCenter;PerspectiveCenter;11;0;Create;True;0;0;0;False;0;False;0.5,0.77;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
WireConnection;10;0;24;0
WireConnection;43;0;10;0
WireConnection;43;1;44;0
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
WireConnection;13;0;26;0
WireConnection;31;0;50;0
WireConnection;50;0;32;0
WireConnection;50;1;51;0
WireConnection;75;0;43;0
WireConnection;75;1;76;0
WireConnection;32;0;48;0
WireConnection;32;1;66;0
WireConnection;26;0;75;0
WireConnection;26;1;10;0
WireConnection;26;2;31;0
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
WireConnection;78;2;119;0
WireConnection;78;3;95;0
WireConnection;78;4;94;0
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
ASEEND*/
//CHKSM=9AAE347BC70F632948DF8B917524EA1CE7ED7AA8