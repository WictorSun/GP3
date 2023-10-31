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
	public FloatParameter _Tile_U = new FloatParameter { value = 2f };
	[Tooltip( "Tile_V" )]
	public FloatParameter _Tile_V = new FloatParameter { value = 0.25f };
	[Tooltip( "Pan_V" )]
	public FloatParameter _Pan_V = new FloatParameter { value = 0.5f };
	[Tooltip( "Pan_U" )]
	public FloatParameter _Pan_U = new FloatParameter { value = 0.12f };
	[Tooltip( "Fraction" )]
	public FloatParameter _Fraction = new FloatParameter { value = 5f };
	[Tooltip( "Brightness" )]
	public FloatParameter _Brightness = new FloatParameter { value = 2f };
	[Tooltip( "Gradient" )]
	public FloatParameter _Gradient = new FloatParameter { value = 1f };
	[Tooltip( "Contrast" )]
	public FloatParameter _Contrast = new FloatParameter { value = 1f };
	[Tooltip( "Switch" )]
	public FloatParameter _Switch = new FloatParameter { value = 0f };
}

public sealed class SH_PostProcessPPSRenderer : PostProcessEffectRenderer<SH_PostProcessPPSSettings>
{
	public override void Render( PostProcessRenderContext context )
	{
		var sheet = context.propertySheets.Get( Shader.Find( "SH_PostProcess" ) );
		if(settings._TextureSample1.value != null) sheet.properties.SetTexture( "_TextureSample1", settings._TextureSample1 );
		if(settings._TextureSample2.value != null) sheet.properties.SetTexture( "_TextureSample2", settings._TextureSample2 );
		sheet.properties.SetFloat( "_Tile_U", settings._Tile_U );
		sheet.properties.SetFloat( "_Tile_V", settings._Tile_V );
		sheet.properties.SetFloat( "_Pan_V", settings._Pan_V );
		sheet.properties.SetFloat( "_Pan_U", settings._Pan_U );
		sheet.properties.SetFloat( "_Fraction", settings._Fraction );
		sheet.properties.SetFloat( "_Brightness", settings._Brightness );
		sheet.properties.SetFloat( "_Gradient", settings._Gradient );
		sheet.properties.SetFloat( "_Contrast", settings._Contrast );
		sheet.properties.SetFloat( "_Switch", settings._Switch );
		context.command.BlitFullscreenTriangle( context.source, context.destination, sheet, 0 );
	}
}
#endif
