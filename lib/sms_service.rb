class SMS_Service

  @@api_key = "fcecc2ecd7e0b4059ec0391926d093c5"
  @@username = "TarekElmasri"
  @@userSender = "OTP"
  @@msg = "Pin Code is:"
  @@url = "https://www.msegat.com/gw/sendsms.php"
  @@msgEncoding = "UTF8"

  @@headers = {
    'Content-Type' => 'application/json'
  }


  def self.send(reciever={}) 
    response = Faraday.post(
      @@url ,
      {
        apiKey: @@api_key,
        userName: @@username,
        numbers: reciever[:phone_no],
        userSender: @@userSender,
        msgEncoding: @@msgEncoding,
        msg: @@msg + reciever[:otp].to_s
      }.to_json,
      @@headers
    )
  end

end