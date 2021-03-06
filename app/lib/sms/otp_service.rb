class Sms::OtpService

  API_KEY = "fcecc2ecd7e0b4059ec0391926d093c5"
  USERNAME = "TarekElmasri"
  USER_SENDER = "OTP"
  MSG = "Pin Code is:"
  URL = "https://www.msegat.com/gw/sendsms.php"
  MSG_ENCODING = "UTF8"

  HEADERS = {
    'Content-Type' => 'application/json'
  }

  attr_accessor :phone_no, :otp

  def initialize(phone_no, otp)
    self.phone_no = phone_no
    self.otp= otp
  end

  
  def call
    server_response = send_otp
    response = JSON.parse(server_response.body)
    
    # if response["code"] == "1"
    #   return {token: {code: token.code}}
    # else
    #   # check sms errors
    #   #return {token: {code: token.code}}
    #   token.destroy
    #   return {errors: {message: I18n.t("sms_service_unavailable")}},status: :forbidden
    # end
  end
  
  private
  def send_otp
    response = Faraday.post(
      URL ,
      {
        apiKey: API_KEY,
        userName: USERNAME,
        numbers: self.phone_no,
        userSender: USER_SENDER,
        msgEncoding: MSG_ENCODING,
        msg: MSG + self.otp.to_s
      }.to_json,
      HEADERS
    )
  end

end
