Calendar = new Meteor.Collection("calendar")

chosen_event=-1

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

  chosen_event = 2
  Template.focus.event = ->
    console.log("Message: " + @message)

    console.log(Calendar.find({date: 2}))

    res = Calendar.find({date: 1}).fetch()

    console.log("Resource: ", res[0])
    result = res[0]

    if (result != undefined)
      youtube_short = result.youtube.match(/v=([a-zA-Z]*)/)[1]
      console.log("youtube short: " + youtube_short)
      result.youtube_short = youtube_short

    console.log("Result: ", result)
    result
    #{date: 1, message: "red"}

  Template.calendar.rendered = ->

    # Global assignments
    if (window.location.pathname.indexOf("edit") == -1)
      $('.event input').hide()
      console.log("Hide")
    else
      $('.event input').show()
      console.log("Show")

    $('.event').click(->
      chosen_event=parseInt($(this).children().attr("class")[0])
      console.log($(this).attr("class"))
    )

  focus_enabled=true

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
      Calendar.update({date: date}, {$set: {message: message}})
      Calendar.find({date: date})

      console.log(message)
    open_calendar: (date) ->
      Calendar.update({date: date}, {$set:{open: true}})
  })

  Meteor.startup(->
    # code to run on server at startup
  )
