// Made with Amplify Shader Editor v1.9.2.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SH_Wind"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Mask("Mask", 2D) = "white" {}
		_Color("Color", Color) = (0.6886792,0.6886792,0.6886792,0)
		_Opacity("Opacity", Float) = 1
		_PanV("Pan V", Float) = 0
		_PanU("Pan U", Float) = 0
		_PanV_2("Pan V_2", Float) = 0
		_PanU_2("Pan U_2", Float) = 0
		_Vector0("Vector 0", Vector) = (0,0,0,0)
		_Vector1("Vector 1", Vector) = (0,0,0,0)
		_TimeMult("TimeMult", Float) = 1
		_EdgeOpacity("EdgeOpacity", Range( 4 , 10)) = 4
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		Blend SrcAlpha OneMinusSrcAlpha
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _Color;
		uniform float _Opacity;
		uniform sampler2D _Mask;
		uniform float2 _Vector1;
		uniform float _TimeMult;
		uniform float _PanU;
		uniform float _PanV;
		uniform float2 _Vector0;
		uniform float _PanU_2;
		uniform float _PanV_2;
		uniform float _EdgeOpacity;
		uniform float _Cutoff = 0.5;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			o.Emission = _Color.rgb;
			o.Alpha = _Opacity;
			float temp_output_26_0 = ( _Time.y * _TimeMult );
			float2 appendResult13 = (float2(_PanU , _PanV));
			float2 uv_TexCoord3 = i.uv_texcoord * _Vector1 + ( temp_output_26_0 * appendResult13 );
			float2 appendResult17 = (float2(_PanU_2 , _PanV_2));
			float2 uv_TexCoord15 = i.uv_texcoord * _Vector0 + ( temp_output_26_0 * appendResult17 );
			clip( ( ( tex2D( _Mask, uv_TexCoord3 ).r - tex2D( _Mask, uv_TexCoord15 ).r ) * saturate( ( ( i.uv_texcoord.x * ( 1.0 - i.uv_texcoord.x ) ) * _EdgeOpacity ) ) ) - _Cutoff );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19201
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-1133.783,72.90051;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;1;-667.395,-2.763428;Inherit;True;Property;_Paint_Normal_roughnessLinear;Paint_Normal_roughnessLinear;0;0;Create;True;0;0;0;False;0;False;-1;4bb2ed5cf0c9cfa4c9deb0ca14b1e966;4bb2ed5cf0c9cfa4c9deb0ca14b1e966;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;14;-668.7965,225.8199;Inherit;True;Property;_Paint_Normal_roughnessLinear1;Paint_Normal_roughnessLinear;0;0;Create;True;0;0;0;False;0;False;-1;4bb2ed5cf0c9cfa4c9deb0ca14b1e966;4bb2ed5cf0c9cfa4c9deb0ca14b1e966;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-957.2916,21.64479;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-1122.013,295.8859;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;13;-1326.184,183.4003;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-1536.483,244.5008;Inherit;False;Property;_PanV;Pan V;4;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-1536.783,160.0004;Inherit;False;Property;_PanU;Pan U;5;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;17;-1324.276,392.749;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-1534.875,369.3491;Inherit;False;Property;_PanU_2;Pan U_2;7;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-1534.575,453.8495;Inherit;False;Property;_PanV_2;Pan V_2;6;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;318.0396,-10.06454;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;SH_Wind;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;False;0;False;TransparentCutout;;Transparent;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;False;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.RangedFloatNode;6;118.4317,133.3451;Inherit;False;Property;_Opacity;Opacity;3;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;24;-1139.302,-62.60276;Inherit;False;Property;_Vector1;Vector 1;9;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;23;-1130.954,172.1935;Inherit;False;Property;_Vector0;Vector 0;8;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;7;-1570.716,-52.22908;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-1356.147,11.7468;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-1537.486,53.12643;Inherit;False;Property;_TimeMult;TimeMult;10;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;25;-273.4214,139.9164;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;15;-947.324,248.1615;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-30.42615,249.2476;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-776.4619,767.3916;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-581.6829,767.5584;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;29;-970.7617,872.3916;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;28;-1237.981,739.4734;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;34;-390.5588,765.8846;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-914.1446,988.853;Inherit;False;Property;_EdgeOpacity;EdgeOpacity;11;0;Create;True;0;0;0;False;0;False;4;4;4;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;5;-1136.656,-287.9932;Inherit;True;Property;_Mask;Mask;1;0;Create;True;0;0;0;False;0;False;4bb2ed5cf0c9cfa4c9deb0ca14b1e966;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.ColorNode;4;-494.2146,-285.5964;Inherit;False;Property;_Color;Color;2;0;Create;True;0;0;0;False;0;False;0.6886792,0.6886792,0.6886792,0;0.6886792,0.6886792,0.6886792,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
WireConnection;10;0;26;0
WireConnection;10;1;13;0
WireConnection;1;0;5;0
WireConnection;1;1;3;0
WireConnection;14;0;5;0
WireConnection;14;1;15;0
WireConnection;3;0;24;0
WireConnection;3;1;10;0
WireConnection;16;0;26;0
WireConnection;16;1;17;0
WireConnection;13;0;11;0
WireConnection;13;1;12;0
WireConnection;17;0;19;0
WireConnection;17;1;18;0
WireConnection;0;2;4;0
WireConnection;0;9;6;0
WireConnection;0;10;32;0
WireConnection;26;0;7;0
WireConnection;26;1;27;0
WireConnection;25;0;1;1
WireConnection;25;1;14;1
WireConnection;15;0;23;0
WireConnection;15;1;16;0
WireConnection;32;0;25;0
WireConnection;32;1;34;0
WireConnection;30;0;28;1
WireConnection;30;1;29;0
WireConnection;31;0;30;0
WireConnection;31;1;33;0
WireConnection;29;0;28;1
WireConnection;34;0;31;0
ASEEND*/
//CHKSM=DC732B568CC3A8398DB0A24CD48B056C89ED4F14