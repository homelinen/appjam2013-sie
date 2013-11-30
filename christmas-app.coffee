if (Meteor.isClient)

  class Event
    constructor: (options) ->

      console.log(options)
      [@date,@message] = options

  class Calendar

    constructor: (options) ->
      @days = (
        new Event([day + 1, "Eh?"])  for day in [0..24])


  Template.calendar.event = ->
    cal = new Calendar
    cal.days

  Template.calendar.events({
    'keydown input': (event) ->
      if (event.which == 13)
        console.log("Pressed Enter")
  })


  Template.hello.greeting = ->
    "Welcome to Christmas App."

  Template.hello.events({
    'click input' : ->
      # template data, if any, is available in 'this'
      if (typeof console != 'undefined')
        console.log("You pressed the button")
    
  })


if (Meteor.isServer)
  Meteor.startup(->
    # code to run on server at startup
  )

