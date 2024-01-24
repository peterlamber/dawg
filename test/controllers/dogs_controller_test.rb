# test/controllers/dogs_controller_test.rb

require 'test_helper'

class DogsControllerTest < ActionDispatch::IntegrationTest
  test 'should get update with Turbo Stream' do
    # Stubbing the DogService.get_picture_by_breed method
    breed = 'hound'
    stub_dog_service(breed, 200, '{"message": ""}')

    # Send a Turbo Stream request to the update action
    put dog_url, params: { breed: breed }, headers: { 'Accept' => 'text/vnd.turbo-stream.html, text/html' }

    # Assertions
    assert_template "dogs/_dog"
    assert_equal "", assigns(:dog)
    assert_equal '', assigns(:error)
  end

  test 'should handle error in update with Turbo Stream' do
    # Stubbing the DogService.get_picture_by_breed method with an error response
    breed = 'houndd'
    error = "Breed not found"
    stub_dog_service(breed, 404, "{'message': #{error}}")

    # Send a Turbo Stream request to the update action
    put dog_url, params: { breed: breed }, headers: { 'Accept' => 'text/vnd.turbo-stream.html, text/html' }

    # Assertions
    assert_template "dogs/_dog"
    assert_equal nil, assigns(:dog)
    assert_equal error, assigns(:error)
  end

  test 'allows whitespace and switches main breed name' do
    # Stubbing the DogService.get_picture_by_breed method with an error response
    breed = 'golden retriever'
    error = "Breed not found"
    stub_dog_service("retriever/golden", 404, "{'message': #{error}}")

    # Send a Turbo Stream request to the update action
    put dog_url, params: { breed: breed }, headers: { 'Accept' => 'text/vnd.turbo-stream.html, text/html' }

    # Assertions
    assert_template "dogs/_dog"
    assert_equal nil, assigns(:dog)
    assert_equal error, assigns(:error)
  end

  test 'lowercase input' do
    # Stubbing the DogService.get_picture_by_breed method with an error response
    breed = 'Hound'
    error = "Breed not found"
    stub_dog_service("hound", 404, "{'message': #{error}}")

    # Send a Turbo Stream request to the update action
    put dog_url, params: { breed: breed }, headers: { 'Accept' => 'text/vnd.turbo-stream.html, text/html' }

    # Assertions
    assert_template "dogs/_dog"
    assert_equal nil, assigns(:dog)
    assert_equal error, assigns(:error)
  end

  test 'should error on special character input' do
    # Stubbing the DogService.get_picture_by_breed method with an error response
    breed = 'hound!_'
    error = "Input only normal characters please"
    stub_dog_service(breed, 404, "{'message': #{error}}")

    # Send a Turbo Stream request to the update action
    put dog_url, params: { breed: breed }, headers: { 'Accept' => 'text/vnd.turbo-stream.html, text/html' }

    # Assertions
    assert_template "dogs/_dog"
    assert_equal nil, assigns(:dog)
    assert_equal error, assigns(:error)
  end

  private

  def stub_dog_service(breed, status, body)
    stub_request(:get, "https://dog.ceo/api/breed/#{breed}/images/random")
      .to_return(status: status, body: body, headers: {})
  end
end
