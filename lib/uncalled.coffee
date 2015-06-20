lineStartSearch = (patternString)  ->
    editor = atom.workspace.getActiveTextEditor()
    row = editor.getCursorBufferPosition().row
    startIndent = null
    reg = new RegExp('\s*' + patternString + '.+')
    while row >= 0
      text = editor.lineTextForBufferRow(row)
      if text.match(reg) and (startIndent == null or editor.indentationForBufferRow(row) < startIndent)
         return row
      if text.trim() and startIndent == null
        startIndent = editor.indentationForBufferRow(row)
      row--
    return -1

getIndentScope = (row)  ->
    editor = atom.workspace.getActiveTextEditor()
    startIndent = editor.indentationForBufferRow(row)
    lastNonEmptyRow = row
    row++
    while row < editor.getLineCount()
      if editor.lineTextForBufferRow(row).length
        if editor.indentationForBufferRow(row) <= startIndent
          break
        else
          lastNonEmptyRow = row
      row++
    return [lastNonEmptyRow, editor.lineTextForBufferRow(lastNonEmptyRow).length]


module.exports = {
  lineStartSearch
  getIndentScope
}
