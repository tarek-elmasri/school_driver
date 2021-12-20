class SendOtpJob < ApplicationJob
  queue_as :default

  def perform(phone_no , otp)
    Sms::OtpService.new(phone_no , otp).call
  end
end
