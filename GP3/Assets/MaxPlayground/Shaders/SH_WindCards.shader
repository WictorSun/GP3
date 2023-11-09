// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SH_WindCards"
{
	Properties
	{
		_Color("Color", Color) = (0.7169812,0.1183695,0.1183695,0)
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_TextureSample2("Texture Sample 1", 2D) = "white" {}
		_ContrastWind("ContrastWind", Float) = 0.11
		_Tile_U2("Tile_U", Float) = 0.5
		_Tile_V2("Tile_V", Float) = 1
		_Pan_U1("Pan_U", Float) = 0.5
		_Pan_V1("Pan_V", Float) = 0.2
		_ThresholdGradient("ThresholdGradient", Float) = 1
		_ContrastGradient("ContrastGradient", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit alpha:fade keepalpha noshadow 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _Color;
		uniform float _ContrastGradient;
		uniform float _ThresholdGradient;
		uniform sampler2D _TextureSample1;
		uniform float _Tile_V2;
		uniform float _Tile_U2;
		uniform float _Pan_V1;
		uniform float _Pan_U1;
		uniform sampler2D _TextureSample2;
		uniform float _ContrastWind;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			o.Emission = _Color.rgb;
			float2 appendResult38 = (float2(_Tile_V2 , _Tile_U2));
			float temp_output_13_0 = ( _Time.y * _Pan_V1 );
			float2 appendResult17 = (float2(temp_output_13_0 , ( _Time.y * _Pan_U1 )));
			float2 uv_TexCoord10 = i.uv_texcoord * appendResult38 + appendResult17;
			float2 appendResult27 = (float2(( 1.0 - temp_output_13_0 ) , ( _Time.y * ( _Pan_U1 * 1.5 ) )));
			float2 uv_TexCoord36 = i.uv_texcoord * ( appendResult38 * float2( 2,2 ) ) + appendResult27;
			o.Alpha = ( saturate( pow( ( ( 1.0 - i.uv_texcoord.y ) * _ContrastGradient ) , _ThresholdGradient ) ) * saturate( ( ( tex2D( _TextureSample1, uv_TexCoord10 ).r * tex2D( _TextureSample2, uv_TexCoord36 ).r ) * _ContrastWind ) ) );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19202
Node;AmplifyShaderEditor.SimpleTimeNode;12;-3083.506,393.6602;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-2623.288,615.4477;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;17;-2558.225,407.115;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-2817.992,396.9191;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-2816.466,528.1147;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-2803.758,670.9517;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;27;-2417.063,595.5818;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;38;-2797.427,876.4446;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;-2580.97,872.161;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;2,2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;36;-2220.714,544.359;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-1496.375,458.8468;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;34;-1868.442,224.7873;Inherit;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;0;False;0;False;-1;4bb2ed5cf0c9cfa4c9deb0ca14b1e966;4bb2ed5cf0c9cfa4c9deb0ca14b1e966;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;35;-1868.471,598.5063;Inherit;True;Property;_TextureSample2;Texture Sample 1;2;0;Create;True;0;0;0;False;0;False;-1;4bb2ed5cf0c9cfa4c9deb0ca14b1e966;4bb2ed5cf0c9cfa4c9deb0ca14b1e966;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-1301.254,459.6953;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;10;-2352.828,357.9146;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;37;-2597.846,519.9554;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-3054.573,489.9618;Inherit;False;Property;_Pan_V1;Pan_V;15;0;Create;True;0;0;0;False;0;False;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-3048.75,590.3267;Inherit;False;Property;_Pan_U1;Pan_U;14;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-2980.543,848.0256;Inherit;False;Property;_Tile_V2;Tile_V;13;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-2978.543,942.0258;Inherit;False;Property;_Tile_U2;Tile_U;12;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;1;-1104.367,461.1701;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;41;-1968.437,-249.9978;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;43;-1713.698,-201.9301;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-1502.428,-202.3487;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;47;-1114.908,-192.2566;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;46;-1269.111,-193.4861;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;48;-824.0164,-153.0836;Inherit;False;Property;_Color;Color;0;0;Create;True;0;0;0;False;0;False;0.7169812,0.1183695,0.1183695,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-892.7635,150.9099;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-1766.466,-96.33169;Inherit;False;Property;_ContrastGradient;ContrastGradient;17;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;59;-1511.255,-84.74807;Inherit;False;Property;_ThresholdGradient;ThresholdGradient;16;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-1496.899,594.7345;Inherit;False;Property;_ContrastWind;ContrastWind;11;0;Create;True;0;0;0;False;0;False;0.11;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;60;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;SH_WindCards;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;False;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;23;0;12;0
WireConnection;23;1;24;0
WireConnection;17;0;13;0
WireConnection;17;1;14;0
WireConnection;13;0;12;0
WireConnection;13;1;19;0
WireConnection;14;0;12;0
WireConnection;14;1;20;0
WireConnection;24;0;20;0
WireConnection;27;0;37;0
WireConnection;27;1;23;0
WireConnection;38;0;21;0
WireConnection;38;1;22;0
WireConnection;40;0;38;0
WireConnection;36;0;40;0
WireConnection;36;1;27;0
WireConnection;11;0;34;1
WireConnection;11;1;35;1
WireConnection;34;1;10;0
WireConnection;35;1;36;0
WireConnection;3;0;11;0
WireConnection;3;1;4;0
WireConnection;10;0;38;0
WireConnection;10;1;17;0
WireConnection;37;0;13;0
WireConnection;1;0;3;0
WireConnection;43;0;41;2
WireConnection;44;0;43;0
WireConnection;44;1;45;0
WireConnection;47;0;46;0
WireConnection;46;0;44;0
WireConnection;46;1;59;0
WireConnection;42;0;47;0
WireConnection;42;1;1;0
WireConnection;60;2;48;0
WireConnection;60;9;42;0
ASEEND*/
//CHKSM=CBFC827AE29729D1966013BCA897F2A5C1A7D945