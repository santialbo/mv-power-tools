PT.register do ($=jQuery) ->
  name =        'settings-panel'
  title =       "Ajustes"
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
        <h2>Panel de control</h2>
        <div id="pt-module-settings">
        </div>
        <a class="pt-modal-close" href="#" title="Close"></a>
      </div>
    </div>
  """)

  if PT.scopes.dark()
    settingsPanel.find('.pt-modal').addClass 'dark'

  init = () ->
    # Insert button and modal window
    settingsPanel.appendTo $('body')
    menuItems = $('#userinfo').children()
    if menuItems.length == 5
      settingsButton.insertBefore(_.last menuItems)
    else
      settingsButton.insertAfter(_.last menuItems)
    
    _.each PT.modules, (module) ->
      if module.general then return
      settingsRow = $("""
      <div class="pt-settings-row">
        <span class="pt-settings-module-name">#{module.title}:</span>
        <span class="pt-settings-module-description">#{module.description}</span>
        <div class="togglebox pull-right">
          <input type="checkbox" id="pt-settings-#{module.name}">
          <label for="pt-settings-#{module.name}"><b></b></label>
        </div>
      </div>
      """)
      $('#pt-settings-' + module.name, settingsRow)
        .prop('checked', not module.active)
        .change () ->
          if $(this).is ':checked'
            if module.canRun() then module.off()
            module.toggle()
          else
            if module.canRun() then module.on()
            module.toggle()

      settingsRow.appendTo $('#pt-module-settings')

  _on =  () ->
    settingsButton.show()

  _off = () ->
    alert "This module can't be turned off"

  new Module(name, title, description, scopes, true, init, _on, _off)
