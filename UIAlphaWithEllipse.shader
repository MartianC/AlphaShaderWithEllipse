Shader "Custom/UIAlphaWithEllipse"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color ("Tint", Color) = (1,1,1,1)
        _EllipseParams ("Ellipse Parameters", Vector) = (0,0,0,0)
        _Smooth ("Smooth", Range(0,1)) = 1
    }

    SubShader
    {
        Tags { "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" }

        Pass
        {
            Name "Default"
            //Tags { "LightMode" = "ForwardBase" }
            Blend SrcAlpha OneMinusSrcAlpha

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata_t
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color;
            float4 _EllipseParams; // x, y, width, height
            float _Smooth;

            v2f vert (appdata_t v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // Calculate the pixel position in UV coordinates
                float2 pixelPos = i.uv * _MainTex_ST.xy + _MainTex_ST.zw;

                // Extract ellipse parameters
                float2 ellipseCenter = _EllipseParams.xy;
                float2 ellipseSize = _EllipseParams.zw;

                // Calculate normalized position relative to the ellipse center
                float2 normalizedPos = (pixelPos - ellipseCenter) / ellipseSize;

                // Check if the pixel position is inside the ellipse using the ellipse equation
                float distance = normalizedPos.x * normalizedPos.x + normalizedPos.y * normalizedPos.y;

                // Outside the ellipse, calculate color with alpha
                fixed4 col = tex2D(_MainTex, i.uv) * _Color;
                if (distance > 1)
                {
                    return col;
                }                
                // Inside the ellipse, set alpha with smooth
                col.a *= saturate(1 + (1 / _Smooth) * (distance - 1));
                return col;
            }
            ENDCG
        }
    }
}
