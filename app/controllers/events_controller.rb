class EventsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @events = Event.all
    authorize @events
  end

  def show
    @event = Event.find(params[:id])
    authorize @event
    @markers =
    [{
      lat: @event.latitude,
      lng: @event.longitude
    }]
  end

  def new
    @event = Event.new
    authorize @event
  end

  def create
    @event = Event.new(event_params)
    @event.user = current_user
    if @event.save
      redirect_to event_path(@event)
    else
      puts @event.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end

  private

  def event_params
    params.require(:event).permit(:name, :description, :location, :date, :start_time, :end_time, photos: [])
  end

end

private

def event_params
  params.require(:event).permit(:name, :description, :date, :location, :time, :start_time, :end_time, :keywords, photos: [])
end
