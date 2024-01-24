require 'test_helper'
require 'webmock/minitest'  # This is used to stub HTTP requests

class DogServiceTest < ActiveSupport::TestCase
  test 'successful get_picture_by_breed returns a Faraday response' do
    stub_request(:get, "https://dog.ceo/api/breed/hound/images/random")
      .to_return(status: 200, body: '{"message": "url_to_image"}', headers: {})

    response = DogService.get_picture_by_breed('hound')

    assert_instance_of Faraday::Response, response
    assert_equal 200, response.status
  end
  
  test 'unsuccessful get_picture_by_breed returns a Faraday response' do
    stub_request(:get, "https://dog.ceo/api/breed/houndd/images/random")
      .to_return(status: 402, body: '{"message": "url_to_image"}', headers: {})

    response = DogService.get_picture_by_breed('houndd')

    assert_instance_of Faraday::Response, response
    assert_equal 402, response.status
  end
end