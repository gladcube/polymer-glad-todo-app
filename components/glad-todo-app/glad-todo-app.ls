{reject, find, each, elem-index, map} = Polymer.GladPreludeLs

class GladTodoApp
  is: \glad-todo-app
  properties:
    title:
      notify: on
  observers: [
    "toggle_selection_on_changed(selected_items, selected_items.length)"
  ]
  toggle_selection_on_changed: (_, length)->
    | length > 0 => @toggle-attribute \selection, yes
    | _ => @toggle-attribute \selection, no
  make_them_done: ->
    @make_ @selected_items, \done
    @$$ \iron-list .clear-selection!
  make_them_undone: ->
    @make_ @selected_items, \undone
    @$$ \iron-list .clear-selection!
  delete_them: ->
    @make_ @selected_items, \deleted
    @$$ \iron-list .clear-selection!
  make_: (items, state)->
    switch state
    | \deleted => @set \todos, (@todos |> reject ( in items))
    | _ =>
      items
      |> map elem-index _, @todos
      |> each ~>
        @set "todos.#it.done", (
          switch state
          | \done => yes
          | \undone => no
        )
  find_item: (elems)->
    elems
    |> find ( .item?)
    |> ( .item)
  make_it_done: (event)->
    @make_it_ \done, event
  make_it_undone: (event)->
    @make_it_ \undone, event
  delete_it: ({path}:event)->
    @make_it_ \deleted, event
  make_it_: (state, {path}:event)->
    event.stop-propagation!
    @make_ [@find_item path], state
  edit_it: ({path}:event)->
    event.stop-propagation!
    @start_editor \edition, (@find_item path)
  start_creation: ->
    @start_editor \creation
  start_editor: (mode, item)->
    @open_editor!
    @set \todo, {}
    @set \editor_mode, mode
    if mode is \edition
      @set \index_to_edit, (@todos |> elem-index item)
      <[title]>
      |> each ~> @set "todo.#it", item.(it)
  open_editor: ->
    @set \opened_editor, yes
  close_editor: ->
    @set \opened_editor, no
  save: (event)->
    event.prevent-default!
    unless @$$ \form .validate! => return
    switch @editor_mode
    | \creation => @push \todos, @todo
    | \edition =>
      <[title]>
      |> each ~> @set "todos.#{@index_to_edit}.#it", @todo.(it)
    @end_editor!
  end_editor: ->
    <[todo editor_mode index_to_edit]>
    |> @set _, undefined
    @close_editor!
  attached: ->
    @set \todos, [
      * title: \腹筋100回
      * title: \宿題をやめる
    ]
|> ( .::) |> Polymer

