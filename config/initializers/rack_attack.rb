class Rack::Attack
  blocklist('fail2ban pentesters') do |req|
    # `filter` returns truthy value if request fails, or if it's from a previously banned IP
    # so the request is blocked
    Rack::Attack::Fail2Ban.filter("pentesters-#{req.ip}", maxretry: 1, findtime: 10.minutes, bantime: 7.days) do
      # The count for the IP is incremented if the return value is truthy
      CGI.unescape(req.query_string) =~ %r{/etc/passwd} ||
      req.path.include?('/etc/passwd') ||
      req.path.include?('wp-admin') ||
      req.path.include?('wp-login') ||
      req.path.include?('currentsetting.htm') ||
      req.path.include?('command.php') ||
      req.path.include?('ru.,,\",.\"\'((') ||
      req.path.include?('en.,,\",.\"\'((') ||
      (req.path == '/' && req.post?) ||
      (req.path == '/' && req.options?)
    end
  end
end
