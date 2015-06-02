{CompositeDisposable} = require 'atom'

NewArticleView = require './views/new-article-view'

module.exports = MiddlemanArticleCreator =
  subscriptions: null

  newArticleView: null

  activate: (state) ->
    @subscriptions = new CompositeDisposable

    @newArticleView = new NewArticleView

    @subscriptions.add atom.commands.add 'atom-workspace', 'middleman-article-creator:New Article': =>
      @createArticle()

  deactivate: ->
    @subscriptions.dispose()
    @newArticleView.destroy()

  createArticle: ->
    @newArticleView.attach()
