class MetricsController < ApplicationController
    def index
        @metrics = Metric.all
        # render json: @metrics
    end

    # get all metrics (API)
    def getMetrics
        @metrics = Metric.all
        render json: @metrics
    end
    
    #the metrics create form
    def new
        @metric = Metric.new
    end


    #Store the metric to the database
    def create
        # render plain: params[:metric].inspect
        @metric = Metric.new(metric_params)
        if(@metric.save)
            redirect_to @metric
        else
            render 'new'
        end
    end

    # This method validates the form data
    private def metric_params
        params.require(:metric).permit(:name, :value)
    end

    # show details of a specific metric
    def show
        @metric = Metric.find(params[:id])
    end

    # show the form of the metric to edit
    def edit
        @metric = Metric.find(params[:id])
    end
    
    #Store the metric to the database
    def update
        # render plain: params[:metric].inspect
        @metric = Metric.find(params[:id])
        if(@metric.update(metric_params))
            redirect_to @metric
        else
            render 'edit'
        end
    end

    # detete metric metric by id
    def destroy
        @metric = Metric.find(params[:id])
        @metric.destroy
        redirect_to metrics_path
    end

    # get averages of metrics per minute
    def timelineMinute
        metrics = Metric.all

        grouped_by_minute = metrics.group_by { |d| d[:created_at].strftime('%Y-%m-%d %H:%M') }
        # Calculate the average for each minute
        averages = {}
        grouped_by_minute.each do |minute, arry|
            arry.each do |metric|
                if averages[minute]
                    averages[minute][:count] += 1
                    averages[minute][:value] += metric.value
                else
                    averages[minute] = { count: 1, value: metric.value }
                end
            end
        end

        averages.each do |minute, data|
            averages[minute][:value] = averages[minute][:value]/data[:count]
        end

        # Format the data as an array of objects
        dataR = []
        averages.each do |minute, data|
            dataR << { minute: minute, value: data[:value] }
        end
        render json: dataR
    end

    # get the average per hour
    def timeline
        metrics = Metric.all

        # Calculate the average for each hour
        averages = {}
        metrics.each do |metric|
            hour = metric.created_at.beginning_of_hour
            if averages[hour]
                averages[hour][:count] += 1
                averages[hour][:value] += metric.value
            else
                averages[hour] = { count: 1, value: metric.value }
            end
        end

        averages.each do |hour, data|
            averages[hour][:value] = averages[hour][:value]/data[:count]
        end

        # Format the data as an array of objects
        dataR = []
        averages.each do |hour, data|
            dataR << { hour: hour, value: data[:value] }
        end
        render json: dataR
    end

    # get the average per day
    def timelineDay
        metrics = Metric.all

        # Calculate the average for each day
        averages = {}
        metrics.each do |metric|
            day = metric.created_at.beginning_of_day
            if averages[day]
                averages[day][:count] += 1
                averages[day][:value] += metric.value
            else
                averages[day] = { count: 1, value: metric.value }
            end
        end

        averages.each do |day, data|
            averages[day][:value] = averages[day][:value]/data[:count]
        end

        # Format the data as an array of objects
        dataR = []
        averages.each do |day, data|
            dataR << { day: day, value: data[:value] }
        end
        render json: dataR
    end
end
