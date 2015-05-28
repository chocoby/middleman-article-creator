MiddlemanArticleCreatorView = require './middleman-article-creator-view'
{CompositeDisposable} = require 'atom'
path = require 'path'
touch = require 'touch'
require('date-utils');

module.exports = MiddlemanArticleCreator =
  middlemanArticleCreatorView: null
  modalPanel: null
  subscriptions: null


  activate: (state) ->
    @middlemanArticleCreatorView = new MiddlemanArticleCreatorView(state.middlemanArticleCreatorViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @middlemanArticleCreatorView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

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

  referenceDir: () ->
    homeDir = process.env.HOME or process.env.HOMEPATH or process.env.USERPROFILE
    atom.project.getPaths()[0] or homeDir

  createArticle: ->
    dt = new Date();
    formattedDate = dt.toFormat('YYYY-MM-DD');

    pathToCreate = path.join(@referenceDir(), "#{formattedDate}-hoge.md")
    console.log pathToCreate

    # TODO already exists
    touch pathToCreate

    atom.workspace.open(pathToCreate).then ->

      contents = """
      ---
      title:
      date: #{formattedDate}
      tags:
      ---


      """
      atom.workspace.getActiveTextEditor().setText(contents)
