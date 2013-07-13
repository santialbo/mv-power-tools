PT.register do ($=jQuery) ->
  name =        "Ajustes"
  description = "Panel de control para activar y desactivar módulos."
  scopes =      [PT.scopes.all]

  settingsButton = $("""
    <li style="display: hidden;">
      <a class="lr" href="#pt-settings" id="pt-setting-panel-button">PT</a>
    </li>
    """)

  settingsPanel = $("""
    <div class="pt-modal-wrapper" id="pt-settings">
      <div class="pt-modal">
        <h2>Example Content Heading</h2>
        <p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam
        nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat 
        volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation 
        ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat.</p>
        <a class="pt-modal-close" href="#" title="Close">Close</a>
      </div>
    </div>
  """)
    
  init = () ->
    menuItems = $('#userinfo').children()
    if menuItems.length == 5
      settingsButton.insertBefore(_.last menuItems)
    else
      settingsButton.insertAfter(_.last menuItems)
    
    settingsPanel.appendTo $('body')

  _on =  () ->
    settingsButton.show()

  _off = () ->
    alert "This module can't be turned off"

  new Module(name, description, scopes, true, init, _on, _off)
