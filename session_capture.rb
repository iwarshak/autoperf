module SessionCapture
  def self.included(controller)
    controller.before_filter(:log_requests)
  end
  
  private 
  
  def log_requests
    return if request.headers["HTTP_USER_AGENT"] =~ /httperf/
    if request.get?
      fiveruns_request_logger(request.path)
    elsif request.post?
      fiveruns_request_logger("#{request.path} method=POST contents=#{request.env["RAW_POST_DATA"]}")
    else
      fiveruns_request_logger("#{request.path} method=#{request.method.to_s.upcase} contents=#{request.env["RAW_POST_DATA"]}")
    end
      
  end
  
  def fiveruns_request_logger(t)
    File.open("#{RAILS_ROOT}/log/requests.log", 'a') do |f|
      f.write("#{t}\n")
    end
  end
end