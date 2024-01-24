class DogService
  URL = "https://dog.ceo/api/breed/"
  
  def self.get_picture_by_breed(input)
    Faraday.get(URL+"#{input}/images/random")
  end
end