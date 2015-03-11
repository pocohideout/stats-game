class AmazingStatsAPI

  PER = 50

  def initialize(site, email, password)
    @site = site
    @email = email
    @password = password
  end
  
  def stats(per_page: PER, page: 1)
    response = RestClient.get(
      "#{@site}/api/v1/stats?per_page=#{PER}&page=#{page}",
      content_type: :json, accept: :json, 'X-User-Email' => @email, 'X-User-Token' => token
    )
    
    JSON.parse(response.body)
  end
  
  private
  
  def token
    @token ||= get_token
  end
  
  def get_token
    response = RestClient.post(
      "#{@site}/users/sign_in",
      {'user' => {'email' => @email, 'password' => @password}}.to_json,
      content_type: :json, accept: :json
    )

    body = JSON.parse(response.body)
    body['user']['token']
  end
end