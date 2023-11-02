// Amplify Shader Editor - Visual Shader Editing Tool
// Copyright (c) Amplify Creations, Lda <info@amplify.pt>
#if UNITY_POST_PROCESSING_STACK_V2
using System;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

[Serializable]
[PostProcess( typeof( SH_PostProcessPPSRenderer ), PostProcessEvent.AfterStack, "SH_PostProcess", true )]
public sealed class SH_PostProcessPPSSettings : PostProcessEffectSettings
{
	[Tooltip( "Texture Sample 1" )]
	public TextureParameter _TextureSample1 = new TextureParameter {  };
	[Tooltip( "Texture Sample 1" )]
	public TextureParameter _TextureSample2 = new TextureParameter {  };
	[Tooltip( "Tile_U" )]
	public FloatParameter _Tile_U2 = new FloatParameter { value = 16f };
	[Tooltip( "Tile_V" )]
	public FloatParameter _Tile_V2 = new FloatParameter { value = 0.1f };
	[Tooltip( "Pan_V" )]
	public FloatParameter _Pan_V1 = new FloatParameter { value = -0.25f };
	[Tooltip( "Pan_U" )]
	public FloatParameter _Pan_U1 = new FloatParameter { value = 0.12f };
	[Tooltip( "Fraction" )]
	public FloatParameter _Fraction = new FloatParameter { value = 1f };
	[Tooltip( "Brightness" )]
	public FloatParameter _Brightness = new FloatParameter { value = 2f };
	[Tooltip( "Gradient" )]
	public FloatParameter _Gradient = new FloatParameter { value = 1f };
	[Tooltip( "Contrast" )]
	public FloatParameter _Contrast = new FloatParameter { value = 2f };
	[Tooltip( "Switch" )]
	public FloatParameter _Switch = new FloatParameter { value = 1f };
	[Tooltip( "PerspectiveCenter" )]
	public Vector4Parameter _PerspectiveCenter = new Vector4Parameter { value = new Vector4(0.5f,0.77f,0f,0f) };
	[Tooltip( "Desaturate_Edge" )]
	public FloatParameter _Desaturate_Edge = new FloatParameter { value = 1f };
	[Tooltip( "Brightness_Edge" )]
	public FloatParameter _Brightness_Edge = new FloatParameter { value = 0.7f };
	[Tooltip( "EdgeGradient_Edge" )]
	public FloatParameter _EdgeGradient_Edge = new FloatParameter { value = 1f };
	[Tooltip( "EdgeThreshold_Edge" )]
	public FloatParameter _EdgeThreshold_Edge = new FloatParameter { value = 0.45f };
}

public sealed class SH_PostProcessPPSRenderer : PostProcessEffectRenderer<SH_PostProcessPPSSettings>
{
	public override void Render( PostProcessRenderContext context )
	{
		var sheet = context.propertySheets.Get( Shader.Find( "SH_PostProcess" ) );
		if(settings._TextureSample1.value != null) sheet.properties.SetTexture( "_TextureSample1", settings._TextureSample1 );
		if(settings._TextureSample2.value != null) sheet.properties.SetTexture( "_TextureSample2", settings._TextureSample2 );
		sheet.properties.SetFloat( "_Tile_U2", settings._Tile_U2 );
		sheet.properties.SetFloat( "_Tile_V2", settings._Tile_V2 );
		sheet.properties.SetFloat( "_Pan_V1", settings._Pan_V1 );
		sheet.properties.SetFloat( "_Pan_U1", settings._Pan_U1 );
		sheet.properties.SetFloat( "_Fraction", settings._Fraction );
		sheet.properties.SetFloat( "_Brightness", settings._Brightness );
		sheet.properties.SetFloat( "_Gradient", settings._Gradient );
		sheet.properties.SetFloat( "_Contrast", settings._Contrast );
		sheet.properties.SetFloat( "_Switch", settings._Switch );
		sheet.properties.SetVector( "_PerspectiveCenter", settings._PerspectiveCenter );
		sheet.properties.SetFloat( "_Desaturate_Edge", settings._Desaturate_Edge );
		sheet.properties.SetFloat( "_Brightness_Edge", settings._Brightness_Edge );
		sheet.properties.SetFloat( "_EdgeGradient_Edge", settings._EdgeGradient_Edge );
		sheet.properties.SetFloat( "_EdgeThreshold_Edge", settings._EdgeThreshold_Edge );
		context.command.BlitFullscreenTriangle( context.source, context.destination, sheet, 0 );
	}
}
#endif
