addRetentionGraph = () ->
  chart = undefined
  data  = undefined

  getdata = ->
    [ {
      values: gon.retention
      key: 'retention'
      color: '#ff7f0e'
      strokeWidth: 2
    } ]

  nv.addGraph ->
    chart = nv.models.lineChart().options(
      transitionDuration: 300
      useInteractiveGuideline: true)
    chart.xAxis.axisLabel('Date after start (days))').tickFormat(d3.format(',.d')).staggerLabels true
    chart.yAxis.axisLabel('Retention (%)').tickFormat (d) ->
      if d == null
        return 'N/A'
      d3.format(',.2f') d
    data = getdata()
    d3.select('#chart1').append('svg').datum(data).call chart
    nv.utils.windowResize chart.update
    chart
  return

$ ->
  addRetentionGraph()
