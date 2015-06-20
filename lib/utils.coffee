uncalled = require './uncalled'
{CompositeDisposable} = require 'atom'

module.exports = Utils =
  subscriptions: null

  activate: (state) ->
    @subscriptions = new CompositeDisposable
    # Register command that toggles this view

    @subscriptions.add atom.commands.add 'atom-workspace', 'utils:clearSelect': => @clearSelect()
    @subscriptions.add atom.commands.add 'atom-workspace', 'utils:selectFunction': => @selectFunction()
    @subscriptions.add atom.commands.add 'atom-workspace', 'utils:selectClass': => @selectClass()
    @subscriptions.add atom.commands.add 'atom-workspace', 'utils:beginningConditionalSpace': => @beginningConditionalSpace()
    @subscriptions.add atom.commands.add 'atom-workspace', 'utils:endConditionalSpace': => @endConditionalSpace()
    @subscriptions.add atom.commands.add 'atom-workspace', 'utils:filePathToClipboard': => @filePathToClipboard()
    @subscriptions.add atom.workspace.observeTextEditors (editor) ->
        editor.onDidChange ->
            document.title = 'Autumntastic ' + editor.getTitle()
    @subscriptions.add atom.workspace.onDidChangeActivePaneItem (item) ->
        try
            document.title = 'Autumntastic ' + atom.workspace.getActiveTextEditor().getTitle()
        catch
            document.title = 'Autumntastic'

  deactivate: ->
    @subscriptions.dispose()

  clearSelect: ->
    editor = atom.workspace.getActiveTextEditor()
    editor.setCursorBufferPosition(editor.getCursorBufferPosition())

  selectFunction: ->
    editor = atom.workspace.getActiveTextEditor()
    signatureRow = uncalled.lineStartSearch('def')
    if signatureRow >= 0
        editor.setCursorBufferPosition([signatureRow, 0])
        editor.moveToFirstCharacterOfLine()
        editor.selectToBufferPosition(uncalled.getIndentScope(signatureRow))

  selectClass: ->
    editor = atom.workspace.getActiveTextEditor()
    signatureRow = uncalled.lineStartSearch('class')
    if signatureRow >= 0
        editor.setCursorBufferPosition([signatureRow, 0])
        editor.moveToFirstCharacterOfLine()
        editor.selectToBufferPosition(uncalled.getIndentScope(signatureRow))

  beginningConditionalSpace: ->
    editor = atom.workspace.getActiveTextEditor()
    pos = editor.getCursorBufferPosition()
    if pos.column != 0 and editor.getTextInBufferRange([pos, [pos.row, pos.column - 1]]) not in [' ', '\t']
        editor.insertText(' ')

  endConditionalSpace: ->
    editor = atom.workspace.getActiveTextEditor()
    pos = editor.getCursorBufferPosition()
    checkChar = editor.getTextInBufferRange([pos, [pos.row, pos.column + 1]])
    if checkChar not in [' ', '\t']
        editor.insertText(' ')

  filePathToClipboard: ->
    try
      atom.clipboard.write(atom.workspace.getActiveTextEditor().getPath())
    catch
      
