{CompositeDisposable} = require 'atom'

NewArticleView = require './views/new-article-view'

path = require 'path'

module.exports = MiddlemanArticleCreator =
  config:
    articleDirectory:
      type: 'string'
      default: path.join 'source', 'blog'

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
