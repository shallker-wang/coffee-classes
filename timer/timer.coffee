class Timer

  constructor: ->

  @getThisWeek: (time)->
    curr = new Date(time)
    thisMonday = new Date(curr.setDate(curr.getDate() - curr.getDay() + 1))
    thisSunday = new Date(curr.setDate(curr.getDate() - curr.getDay() + 7))
    begin: thisMonday, end: thisSunday

  @getFullDay: (time)->
    now = new Date(time)
    year = now.getFullYear()
    month = now.getMonth() + 1  # javascript month start from 0
    date = now.getDate()
    month = "0#{month}" if month.toString().length is 1
    date = "0#{date}" if date.toString().length is 1
    "#{year}-#{month}-#{date}"

  @getDayName: (time)->
    day = new Date(time).getDay()
    weekday = []
    weekday[0] = "Sunday"
    weekday[1] = "Monday"
    weekday[2] = "Tuesday"
    weekday[3] = "Wednesday"
    weekday[4] = "Thursday"
    weekday[5] = "Friday"
    weekday[6] = "Saturday"
    weekday[day]

module.exports = Timer