class DogsController < ApplicationController
  before_action :sanitize_breed, only: :update

  def update
    response = DogService.get_picture_by_breed(secure_params) unless @error
    respond_to do |format|
      if response
        @error = ""
        response.status == 200 ? @dog = JSON.parse(response.body)["message"] : @error = "Breed not found"
      end
      format.turbo_stream { render turbo_stream: turbo_stream.replace("dog", partial: "dog")}
    end
  end

  private

  def secure_params
    params.require(:breed)
  end

  def sanitize_breed
    @breed = params[:breed] 
    params[:breed] = sanitize(params[:breed])
  end

  def sanitize(input)
    multi = input.split().map do |i|
      if i.index( /[^[:alnum:]]/ )
        @error = "Input only normal characters please"
        return 
      end
      i.downcase
    end 
    multi.size() > 1 ? multi.reverse.join("/") : multi[0]
  end
end