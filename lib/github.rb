require 'uri'
require 'net/http'

module Github
  def self.get_public_repo user
    if user.public_repo_url.present?
      url = URI(user.public_repo_url)

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Get.new(url)
      response = http.request(request)
      result = JSON.parse(response.read_body)
      return result
    end
  end
end