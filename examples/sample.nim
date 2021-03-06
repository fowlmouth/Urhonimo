import urhomain, ui, stringHash, variant, component, uielement, renderer, graphicsdefs,
  resourcecache, inputevents, context, engine, xmlelement, graphics, console, debughud,
  image

import hashmap except Node

# enable auto-deref:
{.experimental.}


# Call this from main
proc createConsole*() =
  var cache = urhomain.getSubsystemResourceCache()
  let xmlFile = getResource[XMLFile](cache, "UI/DefaultStyle.xml")
  let console = getEngine().createConsole()
  console.setCommandInterpreter("MainApplication")
  console.setDefaultStyle(xmlFile)
  console.getBackground().setOpacity(0.8f32)
  # Create debug HUD.
  let debugHud = getEngine().createDebugHud()
  debugHud.setDefaultStyle(xmlFile)

# A handler the sample should either call or set up a subscribtion for
proc handleConsole*(userData: pointer; eventType: StringHash;
                      eventData: var VariantMap) {.cdecl.} =
  let key = eventData["Key"].getInt()
  if key == KEY_ESC:
    let console = getSubsystem[Console]()
    if console.isVisible():
      console.setVisible(false)
    else:
      closeUrho3D()
  elif key == KEY_F1:
    getSubsystem[Console]().toggle()
  elif key == KEY_F2:
    getSubsystem[DebugHud]().toggleAll()
  elif getSubsystemUI().getFocusElement().isNil:
    # Common rendering quality controls, only when UI has no focused element
    let renderer = getSubsystem[Renderer]()

    # Texture quality
    if key == '1'.int:
      var quality = renderer.getTextureQuality() + 1
      if quality > QUALITY_HIGH:
        quality = QUALITY_LOW
      renderer.setTextureQuality(quality)
    
    # Material quality
    elif key == '2'.int:
      var quality = renderer.getMaterialQuality() + 1
      if quality > QUALITY_HIGH:
        quality = QUALITY_LOW
      renderer.setMaterialQuality(quality)
    
    # Specular lighting
    elif key == '3'.int:
      renderer.setSpecularLighting(not renderer.getSpecularLighting())
    
    # Shadow rendering
    elif key == '4'.int:
      renderer.setDrawShadows(not renderer.getDrawShadows())
    
    # Shadow map resolution
    elif key == '5'.int:
      var shadowMapSize = renderer.getShadowMapSize() * 2
      if shadowMapSize > 2048:
        shadowMapSize = 512
      renderer.setShadowMapSize(shadowMapSize)

    # Shadow depth and filtering quality
    elif key == '6'.int:
      var quality = renderer.getShadowQuality() + 1
      if quality > SHADOWQUALITY_HIGH_24BIT:
          quality = SHADOWQUALITY_LOW_16BIT
      renderer.setShadowQuality(quality)
    
    # Occlusion culling
    elif key == '7'.int:
      var triangles = renderer.getMaxOccluderTriangles()
      if triangles > 0:
        triangles = 0
      else:
        triangles = 5000
      renderer.setMaxOccluderTriangles(triangles)
    
    # Instancing
    elif key == '8'.int:
      renderer.setDynamicInstancing(not renderer.getDynamicInstancing())
    
    # Take screenshot - not yet, takeScreenShot is a special deal...
    #elif ckey == '9':
    #  let graphics = getSubsystem[Graphics]()
    #  let screenshot = constructImage(getContext())
    #  graphics.takeScreenShot(screenshot)
      # Here we save in the Data folder with date and time appended
    #  screenshot.savePNG(getSubsystem[FileSystem]().getProgramDir() & "Data/Screenshot_" &
    #      time.getTimeStamp().replaced(':', '_').replaced('.', '_').replaced(' ', '_') & ".png")
