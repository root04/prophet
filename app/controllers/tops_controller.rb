class TopsController < ApplicationController

  before_action :detect_retention
  before_action :validate_date
  before_action :validate_retention
  before_action :interpolate_date

  def show
  end

  def post
    minYRange = 0
    maxYRange = 100

    if @retention_hash
      timeScale = @retention_hash.keys.unshift("Days")
      fooNum    = @retention_hash.values.unshift("Retention(%)")
    end
    title = 'Retention'
    data = [timeScale, fooNum]
    colorSet = ["red"]

    # JSON
    gon.graphValues = {
      config: {
        titleFont: "100 18px 'Arial'",
        title: title,
        type: "line",
        minY: minYRange,
        maxY: maxYRange,
        "axisXLen": 5,
        "axisYLen": 10,
        "xScaleRotate": -90,
        width: 880,
        height: 400,
        colorSet: colorSet,
        bgGradient: {direction:"vertical",from:"#687478",to:"#222222"}
        },
      data: data
    }

    render action: :show
  end

  private

  def validate_date
    if @date && (@date.uniq.length != @date.length)
      flash[:error] = "Duplicate date"
      redirect_to root_path
    end
  end

  def validate_retention
    if !@first_view && @retention_hash[1].empty?
      flash[:error] = "At least fill in the first day."
      redirect_to root_path
    end
  end

  def detect_retention
    if params[:retention]
      @date = params[:retention][:date].map(&:to_i)
      @retention = params[:retention][:value]
      @retention_hash = Hash[@date.zip @retention]
      @retention_hash = Hash[@retention_hash.sort]
    else
      @first_view = true
    end
  end

  def interpolate_date
    unless @first_view
      max = @date.max
      @required_dates = Array(1..max.to_i)
      @interpolated_data = Hash[Array(1..max.to_i).zip []]
      if @required_dates.length != @date.length
        @required_dates.each do |required_date|
          if !@retention_hash.has_key?(required_date)
            @retention_hash[required_date] = ""
          end
        end
      end
      @retention_hash = Hash[@retention_hash.sort]
      interpolate_retention()
      format_retention()
    end
  end

  def interpolate_retention
    @retention_array = Array.new
    interpolation_wdata_hash = {}
    interpolation_wodata_hash = {}
    @retention_hash.each_pair do |day, retention|
      if retention.to_s.empty?
        interpolation_wodata_hash[day] = retention
      else
        interpolation_wdata_hash[day] = retention.to_f
      end
    end

    interpolation_wdata_hash.each_cons(2) do |data1, data2|
      @retention_array.push({'x': data1[0], 'y': data1[1]})
      if data2[0] - data1[0] > 1
        interpolate(data1[0], data1[1], data2[0], data2[1])
      end
    end

    lastkey = interpolation_wdata_hash.keys.last
    @retention_array.push({'x': lastkey, 'y': interpolation_wdata_hash[lastkey]})
    gon.retention = @retention_array
  end

  def interpolate(x1, y1, x2, y2)
    ((x1+1).to_i..(x2-1).to_i).each do |x|
      y = y1.to_f + (y2.to_f - y1.to_f) / (x2.to_f - x1.to_f) * (x.to_f - x1.to_f)
      @retention_hash[x] = y
      @interpolated_data[x] = true
      @retention_array.push({'x': x, 'y': y})
    end
  end

  def format_retention
    @retention_hash.each_pair do |day, retention|
      @retention_hash[day] = "%03.2f" % retention.to_f
    end
  end
end
