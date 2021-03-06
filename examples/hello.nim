
import ui, urhomain, processutils, color, urstr, stringHash, variant, text,
  uielement

# enable auto-deref for this module:
{.experimental.}

proc onKeyDown(userData: pointer; eventType: StringHash;
               eventData: var VariantMap) {.cdecl.} =
  closeUrho3D()

proc main =
  parseArguments()

  openUrho3D(false)

  subscribeToEvent("KeyDown", onKeyDown)

  let text = cnew constructText(getContext())
  text.setText("Hello Cruel World!")
  text.setColor(color.WHITE)
  text.setFont(getFont("Fonts/BlueHighway.ttf"), 42)
  text.setHorizontalAlignment(HA_CENTER)
  text.setVerticalAlignment(VA_CENTER)

  getSubsystemUI().getRoot().addChild(text)
  let exitCode = runMainLoop()
  quit exitCode

main()
