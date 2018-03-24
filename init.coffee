# Henrys init script for Atom

# Enable drag and drop for tree-view
fs = require('fs')
# Atom 1.17.0 treeView selector should be '.tree-view'
treeView = document.querySelector('ol.tree-view.full-menu.list-tree') or document.querySelector('.tree-view')

if treeView
  treeView.addEventListener 'drop', (event) ->
    if !event.dataTransfer.files or event.dataTransfer.files.length == 0
      return
    try
      path = event.dataTransfer.files[0].path
      stat = fs.statSync(path)
      if stat.isDirectory()
        atom.project.addPath path
    catch e
      console.error e
    return
  treeView.addEventListener 'dragover', (event) ->
    event.preventDefault()
    return

# Toggle focus for terminal-plus
 atom.packages.onDidActivatePackage (pack) ->
  if pack.name == 'platformio-ide-terminal'
    atom.commands.add 'atom-workspace',
      'editor:focus-main', ->
        p = atom.workspace.getActivePane()
        panels = atom.workspace.getBottomPanels()
        term = panels.find (pan) ->
          pan.item.constructor.name == 'PlatformIOTerminalView' and pan.visible
        if not term
          # Open a new terminal
          editor = atom.workspace.getActiveTextEditor()
          atom.commands.dispatch(atom.views.getView(editor), 'platformio-ide-terminal:new')
        else if term and p.focused isnt false
          term.item.focus()
        else if term and p.focused is false
          term.item.blur()  # Stops the terminal from blinking
          p.activate()
