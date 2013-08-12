// ****************************************************************************
// *
// *  PROJECT:     Open MTA:DayZ
// *  FILE:        files/shader/water.fx
// *  PURPOSE:     Shadering water
// *
// ****************************************************************************
#define GENERATE_NORMALS
#include "mta-helper.fx"

float gWave;

sampler Sampler0 = sampler_state
{
    Texture = (gTexture0);
};

struct VSInput
{
    float3 Position : POSITION0;
	float4 Diffuse : COLOR0;
    float2 TexCoord : TEXCOORD0;
};

struct PSInput
{
	float4 Position : POSITION0;
	float4 Diffuse : COLOR0;
	float2 TexCoord : TEXCOORD0;
};

float4 PixelShaderFunction(PSInput PS) : COLOR0
{
	float4 color = tex2D(Sampler0, PS.TexCoord);
	return color * PS.Diffuse * float4(0.9f, 0.9f, 0.9f, 1.0f);
}

PSInput VertexShaderFunction(VSInput VS)
{
	PSInput PS = (PSInput)0;
	
	// Special thanks to ccw
    float3 worldPos = MTACalcWorldPosition( VS.Position );
    float camDist2D = distance( worldPos.xy, gCameraPosition.xy );

    // Fade out effect between 35 and 43 units
    float alpha = MTAUnlerp( 43, 35, camDist2D );
    alpha = clamp( alpha, 0, 1 );

	VS.Position.z = ( sin(gWave + (VS.Position.y / 4.0) ) + 
						cos(gWave + (VS.Position.x / 10.0) )
					) * 0.3f * alpha;
	
	
	PS.Position = MTACalcScreenPosition(VS.Position);
	PS.TexCoord = VS.TexCoord;
	PS.Diffuse = MTACalcGTABuildingDiffuse(VS.Diffuse);
	
	return PS;
}

technique water
{
	pass P0
	{
		PixelShader = compile ps_2_0 PixelShaderFunction();
		VertexShader = compile vs_2_0 VertexShaderFunction();
	}
}

// move this to another file
technique fail
{
	pass P0
	{
	}
}