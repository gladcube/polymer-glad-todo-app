{find} = Polymer.GladPreludeLs

class PageDemo
  is: \page-demo
  properties:
    apps:
      value: [
        * title: "My ToDo"
      ]
  open_editor: ->
    @set \opened_editor, yes
  close_editor: ->
    @set \opened_editor, no
  open_app_editor: ->
    @open_editor!
    @set \app, {}
  delete_it: ({path}:event)->
    event.stop-propagation!
    path
    |> find ( .index?)
    |> ( .index)
    |> ~>
      @splice \apps, it, 1
  save: (event)->
    event.prevent-default!
    unless @$$ \form .validate! => return
    @push \apps, @app
    @close_editor!
|> ( .::) |> Polymer

