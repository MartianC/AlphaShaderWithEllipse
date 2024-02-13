using UnityEngine;
using UnityEngine.UI;

[ExecuteInEditMode]
[RequireComponent(typeof(Image))]
public class UIAlphaWithEllipse : MonoBehaviour
{
    public Rect ellipseRect;
    [Range(0,1)]
    public float smooth;
    
    private Image _image;
    private Material _material;
    private static readonly int Color1 = Shader.PropertyToID("_Color");
    private static readonly int Smooth = Shader.PropertyToID("_Smooth");
    private static readonly int EllipseParams = Shader.PropertyToID("_EllipseParams");

    private void Awake()
    {
        _image = GetComponent<Image>();
        _material = new Material(Shader.Find("Custom/UIAlphaWithEllipse"));
        _image.material = _material;
    }
    
    
    void Update()
    {
        UpdateMaterial();
    }

    private void UpdateMaterial()
    {
        var imgRect = _image.rectTransform.rect;
        var pivot = _image.rectTransform.pivot;
        var ellipse = new Vector4();
        ellipse.x = pivot.x + ellipseRect.x / imgRect.width;
        ellipse.y = pivot.y + ellipseRect.y / imgRect.height;
        ellipse.z = ellipseRect.width / imgRect.width;
        ellipse.w = ellipseRect.height / imgRect.height;
        _material.SetColor(Color1, _image.color);
        _material.SetFloat(Smooth, smooth);
        _material.SetVector(EllipseParams, ellipse);
    }
}
