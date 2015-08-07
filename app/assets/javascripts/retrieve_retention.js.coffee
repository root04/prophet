addEvents = () ->
  $('.addRetentionField').on 'click', (event) ->
    addRetentionField()

########
# callbacks
########

addRetentionField = () ->
  value = $('div.retentions input#retention_date_').last().val()
  dateValue = parseInt value, 10
  dateValue = dateValue + 1
  $('i.addRetentionField').remove()
  retentionField =  '<div class=\"retentions\">'
  retentionField += "<input type=\"number\" name=\"retention[date][]\" id=\"retention_date_\" value=#{dateValue}>"
  retentionField += '<input type=\"number\" name=\"retention[value][]\" id="retention_value_" class=\"input_retention\" step=\"0.1\" max=\"100\" min=\"0\"> % '
  retentionField += '<i class=\"fa fa-plus-square fa-2x addRetentionField\"></i>'
  retentionField += '</div>'
  $('.form-group.new_retention div.retentions').last().after retentionField
  addEvents()

$ ->
  console.log $('.form-group.new_retention div.retentions').last()
  addEvents()
