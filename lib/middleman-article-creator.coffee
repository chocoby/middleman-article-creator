MiddlemanArticleCreatorView = require './middleman-article-creator-view'
NewArticleView = require './views/new-article-view'

{CompositeDisposable} = require 'atom'

module.exports = MiddlemanArticleCreator =
  middlemanArticleCreatorView: null
  modalPanel: null
  subscriptions: null

  newArticleView: null

  activate: (state) ->
    @middlemanArticleCreatorView = new MiddlemanArticleCreatorView(state.middlemanArticleCreatorViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @middlemanArticleCreatorView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    @newArticleView = new NewArticleView

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'middleman-article-creator:toggle': => @toggle()

    @subscriptions.add atom.commands.add 'atom-workspace', 'middleman-article-creator:create_article': => @createArticle()


  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @middlemanArticleCreatorView.destroy()

  serialize: ->
    middlemanArticleCreatorViewState: @middlemanArticleCreatorView.serialize()


  toggle: ->
    console.log 'MiddlemanArticleCreator was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()

  createArticle: ->
    @newArticleView.attach()
