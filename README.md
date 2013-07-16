mv-power-tools
==============

Enhancements userscript for [mediavida.com](http://www.mediavida.com)


Contribute
----------
Feel free to create issues and pull requests for existing modules.

In order to write a new module you simply have to create a new `module-name.coffee` and `module-name.css` files in the modules folder and add the new module name to the `MODULES` variable in the top of the Makefile.

In the `css` file you must add all the styling required by the module (try not to add styling in the script).

The `coffee` file must follow the next structure:

```coffeescript
PT.register do ($=jQuery) ->
  # name is an identifier for the module. Set the same as the name of the file.
  name =        'module-name'
  # Human readable title/name of the module. Will show up on the settings panel.
  title =       "Super module"
  # Description of what the module does. Will show up on the settings panel.
  description = "This is a super module that does amazing things."
  # scopes is a list of functions that, if any returns true, the script will run
  # Check main.coffee for a list of already predefined functions.
  scopes =      [PT.scope.thread, PT.scope.profile]
  
  # Here go all variables / functions you are going to use

  init = () ->
    # init is only called once. Add here all initializations that only need to be executed once.
    
  _on =  () ->
    # _on runs everytime the script is activated from the settings panel. After calling _on your
    # script should be ready to run.

  _off = () ->
    # _off runs everytime the script is deactivated from the settings panel. This should revert
    # all the changes your script made and leave the page as it never run.

  new Module(name, title, description, scopes, false, init, _on, _off)
```
