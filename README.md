mv-power-tools
==============

Enhancements userscript for [mediavida.com](http://www.mediavida.com)

Development
-----------

**Building**

You will need grunt to build. Install it by running:
```
npm install -g grunt-cli
```

Intall dependencies by running:
```
npm install
```

To create the build simply run `grunt` from the home path of the project.
The generated `mv-power-tools.user.js` file will be located in the `dist` folder.

For quick development you can also use the `watch` task:
```
grunt watch
```
grunt will watch for changes in the source files and re-build them if necessary.

**Deployment**

There's a `deploy` task that uploads the resulting `mv-power-tools.user.js` file to Amazon S3. In order to use it you will need to have your AWS credentials in a file named `mv-power-tools` inside the `.aws` folder in your home directory.
```
$ cat ~/.aws/mv-power-tools
{
  "access_key": "your-access-key",
  "secret_key": "your-secret-key"
}
```

When running `grunt deploy` grunt will upload the file to a folder with the same name as the version specified in `package.json`. It also uploads them to a folder called `latest`.

*Remeber to up the version on package.json when you deploy a new version*

Contribute
----------
Feel free to create issues and pull requests for existing modules.

In order to write a new module you simply have to create a new `module-name.coffee` and `module-name.css` files in the modules folder and add the new module name to the `MODULES` variable in the top of the Makefile.

In the `css` file you must add all the styling required by the module (try not to add styling in the script).

Prepend all css class names and ids with `pt-module-name` in order to avoid conflicts with other modules and the main page.

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
  # Check main.coffee for a list of already predefined functions. You can also add your own functions.
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

You can also check some of the existing modules for an actual example.
