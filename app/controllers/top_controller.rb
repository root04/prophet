class TopController < ApplicationController

  def show
    minYRange = 0
    maxYRange = 1000

    timeScale = ['days', 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
    fooNum    = ['test', 10, 20, 30, 50, 22, 70, 180, 10, 100, 110, 20, 130, 10, 150, 0]
    title = 'Retention'
    data = [timeScale, fooNum]
    colorSet = ["red"]

    # JSON
    gon.graphValues = {
      config: {
        titleFont: "100 18px 'Arial'",
        title: title,
        type: "line",
        lineWidth: 4,
        minY: minYRange,
        maxY: maxYRange,
        width: 480,
        height: 400,
        colorSet: colorSet,
        bgGradient: {direction:"vertical",from:"#687478",to:"#222222"}
        },
      data: data
    }
  end
end
