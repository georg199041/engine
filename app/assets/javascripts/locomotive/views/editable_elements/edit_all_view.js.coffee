Locomotive.Views.EditableElements ||= {}

class Locomotive.Views.EditableElements.EditAllView extends Backbone.View

  id: 'editable-elements'

  tagName: 'div'

  _editable_elements_views: []

  render: ->
    window.foo = @collection

    @blocks = @collection.blocks()

    $(@el).html(ich.editable_elements_edit(blocks: @blocks))

    @render_elements()

    @enable_nav()

    return @

  render_elements: ->
    index = 0

    _.each @blocks, (block) =>
      list = @collection.by_block block.name

      _.each list, (element) =>
        element.set(index: index)

        view_class = switch element.get('type')
          when 'EditableShortText' then Locomotive.Views.EditableElements.ShortTextView
          when 'EditableLongText' then Locomotive.Views.EditableElements.LongTextView
          when 'EditableFile' then Locomotive.Views.EditableElements.FileView

        view = new view_class(model: element)
        @$("#block-#{block.index} > fieldset > ol").append(view.render().el)

        @_editable_elements_views.push(view)

        index += 1

  enable_nav: ->
    @$('.nav a').click (event) =>
      event.stopPropagation() & event.preventDefault()

      link  = $(event.target)
      index = parseInt(link.attr('href').match(/block-(.+)/)[1])

      @$('.wrapper ul li.block').hide()
      @$("#block-#{index}").show()
      @_hide_last_separator()

      link.parent().find('.on').removeClass('on')
      link.addClass('on')

  _hide_last_separator: ->
    _.each @$('fieldset'), (fieldset) =>
      $(fieldset).find('li.last').removeClass('last')
      $(_.last($(fieldset).find('li.input:visible'))).addClass('last')