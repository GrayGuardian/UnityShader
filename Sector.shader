// 绘制扇形

Shader "Unlit/Sector"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _Rangle ("Rangle",Range(0,360)) = 60
    }
    SubShader
    {
        Tags { "Queue" = "Transparent" "IgnoreProjector" = "true" "RenderType" = "Transparent" }

        Pass
        {
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            fixed4 _Color;
            float _Rangle;


            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float r = 0.5f;
                float2 originUv = float2(0.5,0.5);
                float2 normalUv = float2(0.5,1) - originUv;
                float2 tempUv = i.uv - originUv;

                // 数学原理：扇形中心线与圆心到扇形内任意一点组成的向量夹角cos值大于扇形弧度一半的cos值

                // if( tempUv.x * tempUv.x + tempUv.y * tempUv.y < r * r && tempUv.y/sqrt(tempUv.x*tempUv.x+tempUv.y*tempUv.y) > cos(radians(_Rangle/2)))
                // {
                    //     return _Color;
                // }
                // return (0,0,0,0);

                return step(tempUv.x * tempUv.x + tempUv.y * tempUv.y,r * r) * step(cos(radians(_Rangle/2)),tempUv.y/sqrt(tempUv.x*tempUv.x+tempUv.y*tempUv.y)) * _Color;
            }
            ENDCG
        }
    }
}
