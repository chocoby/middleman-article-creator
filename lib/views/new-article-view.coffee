{TextEditorView} = require 'atom-space-pen-views'
{$, View} = require 'space-pen'

path = require 'path'
touch = require 'touch'
require 'date-utils'

module.exports =
  class NewArticleView extends View
    @content: ->
      @div class: 'overlay from-top', =>
        @h4 'New Article'
        @label 'Article Title'
        @subview 'miniEditor', new TextEditorView(mini: true, placeholderText: 'great-article-title')
        @button outlet: 'createButton', class: 'btn', 'Create'

    initialize: ->
      atom.commands.add @element,
        'core:confirm': => @onConfirm(@miniEditor.getText())
        'core:cancel': => @destroy()

      @createButton.on 'click', => @onConfirm(@miniEditor.getText())

    onConfirm: (name) ->
      @destroy()
      @miniEditor.setText('')

      @createArticle(name)

    attach: ->
      @panel = atom.workspace.addModalPanel(item: this)
      @miniEditor.focus()

    destroy: ->
      @panel.destroy()
      atom.workspace.getActivePane().activate()

    articlesDir: ->
      articleDirectory = atom.config.get('middleman-article-creator.articleDirectory')

      if articleDirectory.startsWith('/')
        path.join(articleDirectory)
      else
        path.join(atom.project.getPaths()[0], articleDirectory)

    parameterizeString: (str) ->
      str.trim().toLowerCase().replace(/[^a-zA-Z0-9 -]/, "").replace(/\s/g, "-")

    createArticle: (name) ->
      dt = new Date()
      formattedDate = dt.toFormat('YYYY-MM-DD')

      pathToCreate = path.join(@articlesDir(), "#{formattedDate}-#{@parameterizeString(name)}.md")

      touch pathToCreate

      atom.workspace.open(pathToCreate).then ->
        contents = """
        ---
        title: #{name}
        date: #{formattedDate}
        tags:
        ---


        """

        atom.workspace.getActiveTextEditor().setText(contents)
