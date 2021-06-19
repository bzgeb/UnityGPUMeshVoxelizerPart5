Shader "Custom/Voxel"
{
    Properties
    {
        _Color ("Color", Color) = (1, 0, 0, 1)
        _CollisionColor ("Collision Color", Color) = (0, 1, 0, 1)
    }

    SubShader
    {
        Pass
        {
            Name "Draw Points"
            Tags
            {
                "RenderType" = "Opaque"
            }
            Blend SrcAlpha one

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "VoxelCommon.cginc"

            #pragma target 5.0
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float size : PSIZE;
            };

            StructuredBuffer<Voxel> _Voxels;
            float4 _Color;
            float4 _CollisionColor;

            v2f vert(uint vertex_id : SV_VertexID, uint instance_id : SV_InstanceID)
            {
                v2f o;
                float3 pos = _Voxels[instance_id].position;
                float isSolid = _Voxels[instance_id].isSolid;
                o.color = lerp(_Color, _CollisionColor, isSolid);
                o.position = UnityWorldToClipPos(float4(pos.xyz, 1.0));
                o.size = 5;
                return o;
            }

            float4 frag(v2f i) : COLOR
            {
                return i.color;
            }
            ENDCG
        }
    }
    FallBack Off
}