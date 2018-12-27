module Easycall
  class Client
    def initialize(username, password)
      @username, @password = username, password
    end

    def funds_text
      "Available funds: #{funds} PLN"
    end

    def funds
      agent = Mechanize.new { |a| a.log = Logger.new $stderr; a.log.level = Logger::DEBUG }
      agent.user_agent_alias = 'Mac Safari 4'
      login_page = agent.get('https://www.easycall.pl/logowanie.html')
      main_page = login_page.form_with(action: 'logowanie.html') do |f|
        f.log = @username
        f.pass = @password
        f['submit'] = ''
      end.submit

      account_page = agent.get('https://www.easycall.pl/moje_konto_podsumowanie.html')
      amount_html = account_page.search('.clb > li:nth-child(3) > p:nth-child(2) > b:nth-child(1)')
      /(\d+.\d\d) z/.match(amount_html.text) do |match|
        return match[1]
      end
    end
  end
end
