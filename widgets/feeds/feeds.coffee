class Dashing.Feeds extends Dashing.Widget

  @accessor 'quote', ->
    "“#{@get('current_feed')?.body}”"

  ready: ->
    @currentIndex = 0
    @commentElem = $(@node).find('.feed-container')
    @nextComment()
    @startCarousel()

  onData: (data) ->
    @currentIndex = 0

  startCarousel: ->
    setInterval(@nextComment, 8000)

  nextComment: =>
    feeds = @get('feeds')
    if feeds
      @commentElem.fadeOut =>
        @currentIndex = (@currentIndex + 1) % feeds.length
        @set 'current_feed', feeds[@currentIndex]
        @commentElem.fadeIn()
