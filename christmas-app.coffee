Calendar = new Meteor.Collection("calendar")

class Event
  constructor: (options) ->

    [@date,@message] = options

if (Meteor.isClient)

  Meteor.subscribe("calendar")

  Template.calendar.event = ->
    Calendar.find()

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

  #Calendar.remove({})
  #Calendar.insert(new Event([day + 1,"A horse"])) for day in [0..24]

  Meteor.publish("calendar", ->
    Calendar.find().fetch())
  Meteor.startup(->
    # code to run on server at startup
  )

