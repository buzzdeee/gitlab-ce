# checks a response from an api call using Faraday
RSpec::Matchers.define :have_gitlab_api_status do |expected|
  match do |actual|
    expect(actual.status).to eq expected
  end

  description do
    "respond with numeric status code #{expected}"
  end

  failure_message do |actual|
    response_code = actual.status

    "expected the response to have status code #{expected.inspect}" \
    " but it was #{response_code}. The response was: #{actual.body}"
  end
end
