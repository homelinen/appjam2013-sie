Calendar = new Meteor.Collection("calendar")

class Event
  constructor: (options) ->

    [@date,@message] = options

if (Meteor.isClient)

  Meteor.subscribe("calendar")

  Template.calendar.event = ->
    Calendar.find({}, sort: {date: 1})


  update_message = (event) ->

    Calendar.find({date: event.currentTarget.className}, ["_id"])
    
    Meteor.call('update_message', event.currentTarget.className, event.currentTarget.value, (error, result) ->
      console.log(error + " " + result)
    )

  Template.calendar.events({
    'keydown input': (event) ->
      console.log("Pressed Enter " + event.which )
      if (event.which == 13)
        update_message(event)
    ,
    'blur input': (event) ->
      update_message(event)
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
    Calendar.find({})
  )

  Calendar.allow({
      update: (userId, doc, fieldNames, modifier) ->
        true
  })

  Meteor.methods({
    update_message: (date, message) ->
 
      date = parseInt(date)
      Calendar.update({date: date}, {date:date, message: message})
      Calendar.find({date: date})

      console.log(message)
  })

  Meteor.startup(->
    # code to run on server at startup
  )
